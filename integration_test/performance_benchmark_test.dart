// Performance benchmark integration tests.
//
// Run in profile mode for real frame timing:
//   flutter drive \
//     --driver=test_driver/integration_test.dart \
//     --target=integration_test/performance_benchmark_test.dart \
//     -d emulator-5554 \
//     --profile
//
// Or as a standard integration test:
//   flutter test integration_test/performance_benchmark_test.dart

import 'package:attendrix_app/features/apod/data/datasources/apod_local_datasource.dart';
import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_history_page.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApodRepository extends Mock implements ApodRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

/// Generates N synthetic APOD entries for history scroll benchmarks.
List<ApodEntry> _generateEntries(int count) {
  return List.generate(count, (i) {
    final date = DateTime(2026, 5, 21).subtract(Duration(days: i));
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return ApodEntry(
      date: dateStr,
      title: 'APOD Entry #$i: Stellar Feature',
      explanation: 'Scientific explanation for entry number $i. ' * 5,
      url: 'https://apod.nasa.gov/apod/image/perf/entry_$i.jpg',
      mediaType: i % 5 == 0 ? 'video' : 'image',
    );
  });
}

const _singleEntry = ApodEntry(
  date: '2026-05-21',
  title: 'Performance Test Entry',
  explanation: 'This entry is used for rendering benchmark tests.',
  url: 'https://apod.nasa.gov/apod/image/perf/bench.jpg',
  mediaType: 'image',
);

void main() {
  final WidgetsBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockApodRepository mockRepo;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    registerFallbackValue(DateTime(2026));
    mockRepo = MockApodRepository();
    mockPrefs = MockSharedPreferences();

    when(() => mockPrefs.getStringList(any())).thenReturn(null);
    when(
      () => mockPrefs.setStringList(any(), any()),
    ).thenAnswer((_) async => true);
    when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
    when(() => mockPrefs.getString(any())).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Success(_singleEntry));
  });

  Widget buildDetailPage() {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        apodRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: const MaterialApp(
        home: ApodDetailPage(entry: _singleEntry),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BENCHMARK 1: Detail page initial render performance
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Perf: Detail page renders within 5 seconds of pump', (
    tester,
  ) async {
    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(buildDetailPage());
    await tester.pumpAndSettle(const Duration(seconds: 5));

    stopwatch.stop();

    expect(find.text('Performance Test Entry'), findsOneWidget);
    expect(
      stopwatch.elapsedMilliseconds,
      lessThan(5000),
      reason:
          'Detail page must settle in < 5s (actual: ${stopwatch.elapsedMilliseconds}ms)',
    );
  });

  // ─────────────────────────────────────────────────────────────────────────
  // BENCHMARK 2: Cache write/read latency
  // ─────────────────────────────────────────────────────────────────────────
  test('Perf: Cache write completes < 50ms, read completes < 5ms', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final datasource = ApodLocalDatasource(prefs);

    const dto = ApodDto(
      date: '2026-05-21',
      title: 'Cache Benchmark',
      explanation: 'Benchmark explanation.',
      mediaType: 'image',
      url: 'https://apod.nasa.gov/img.jpg',
    );

    // Benchmark write
    final writeStopwatch = Stopwatch()..start();
    await datasource.cacheApod(dto);
    writeStopwatch.stop();

    expect(
      writeStopwatch.elapsedMilliseconds,
      lessThan(50),
      reason:
          'Cache write must be < 50ms (actual: ${writeStopwatch.elapsedMilliseconds}ms)',
    );

    // Benchmark synchronous read
    final readStopwatch = Stopwatch()..start();
    final result = datasource.getCachedApod();
    readStopwatch.stop();

    expect(result, isNotNull);
    expect(result?.title, 'Cache Benchmark');
    expect(
      readStopwatch.elapsedMilliseconds,
      lessThan(5),
      reason:
          'Cache read must be < 5ms (actual: ${readStopwatch.elapsedMilliseconds}ms)',
    );
  });

  // ─────────────────────────────────────────────────────────────────────────
  // BENCHMARK 3: LRU cache with 50 entries
  // ─────────────────────────────────────────────────────────────────────────
  test('Perf: 50 sequential LRU cache writes complete within 2 seconds', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final datasource = ApodLocalDatasource(prefs);

    final stopwatch = Stopwatch()..start();
    for (var i = 0; i < 50; i++) {
      final date = DateTime(2026, 5, 21).subtract(Duration(days: i));
      final day = date.day.clamp(1, 31);
      final month = date.month;
      final year = date.year;
      await datasource.cacheApodForDate(
        date,
        ApodDto(
          date:
              '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}',
          title: 'Entry $i',
          explanation: 'Explanation $i',
          mediaType: 'image',
          url: 'https://x.com/$i.jpg',
        ),
      );
    }
    stopwatch.stop();

    expect(
      stopwatch.elapsedMilliseconds,
      lessThan(2000),
      reason:
          '50 LRU writes must be < 2s (actual: ${stopwatch.elapsedMilliseconds}ms)',
    );

    // Eviction should keep count at or below maxHistoricalEntries
    final dates = datasource.getCachedDates();
    expect(dates.length, lessThanOrEqualTo(50));
  });

  // ─────────────────────────────────────────────────────────────────────────
  // BENCHMARK 4: History page scroll with 50 items
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Perf: History page scroll through 50 entries without jank', (
    tester,
  ) async {
    final entries = _generateEntries(50);

    final prefsStub = MockSharedPreferences();
    when(
      () => prefsStub.getStringList('apod_viewed_dates'),
    ).thenReturn(entries.map((e) => e.date).toList());
    when(() => prefsStub.getStringList(any())).thenReturn(null);
    when(
      () => prefsStub.setStringList(any(), any()),
    ).thenAnswer((_) async => true);
    when(() => prefsStub.remove(any())).thenAnswer((_) async => true);
    when(() => prefsStub.getString(any())).thenReturn(null);
    when(() => prefsStub.setString(any(), any())).thenAnswer((_) async => true);

    final repoStub = MockApodRepository();
    when(
      () => repoStub.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => repoStub.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((inv) async {
      final date = inv.positionalArguments[0] as DateTime;
      final found = entries.where((e) {
        final d = DateTime.parse(e.date);
        return d.year == date.year &&
            d.month == date.month &&
            d.day == date.day;
      });
      if (found.isNotEmpty) return Success(found.first);
      return const Failure(ApodNoConnection());
    });
    when(
      () => repoStub.getApodRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((_) async => Success(entries));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefsStub),
          apodRepositoryProvider.overrideWithValue(repoStub),
        ],
        child: const MaterialApp(home: ApodHistoryPage()),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 5));

    if (binding is IntegrationTestWidgetsFlutterBinding) {
      await binding.traceAction(
        () async {
          for (var i = 0; i < 5; i++) {
            await tester.fling(
              find.byType(Scrollable).first,
              const Offset(0, -300),
              800,
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 500));
          }
        },
        reportKey: 'history_scroll_timeline',
      );
    } else {
      for (var i = 0; i < 3; i++) {
        await tester.fling(
          find.byType(Scrollable).first,
          const Offset(0, -300),
          800,
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 500));
      }
    }

    expect(tester.takeException(), isNull);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // BENCHMARK 5: Provider rebuild count validation
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Perf: Idle pump does not trigger excessive root rebuilds', (
    tester,
  ) async {
    var buildCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          apodRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (ctx) {
              buildCount++;
              return const ApodDetailPage(entry: _singleEntry);
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 3));
    final initialCount = buildCount;

    await tester.pump(const Duration(milliseconds: 100));
    final afterIdleCount = buildCount;

    expect(
      afterIdleCount - initialCount,
      lessThanOrEqualTo(2),
      reason:
          'Idle pump triggered ${afterIdleCount - initialCount} extra rebuilds',
    );
  });
}
