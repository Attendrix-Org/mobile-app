// Integration test — must run on a real or emulated device.
// Run with: flutter test integration_test/app_test.dart
//
// This suite verifies end-to-end flows across the APOD feature:
//   1. App launch and initial render (success path)
//   2. Cache-first flow (cached startup)
//   3. Offline fallback with offline banner
//   4. Error state display when no cache
//   5. Prev/Next day navigation
//   6. HD image viewer open/close
//   7. History page navigation

import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_history_page.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/apod_action_bar.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/apod_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApodRepository extends Mock implements ApodRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

const _today = ApodEntry(
  date: '2026-05-21',
  title: 'Galaxy Collision',
  explanation: 'Two spiral galaxies are merging in a spectacular cosmic event.',
  url: 'https://apod.nasa.gov/apod/image/2605/galaxy.jpg',
  hdurl: 'https://apod.nasa.gov/apod/image/2605/galaxy_hd.jpg',
  mediaType: 'image',
  copyright: 'NASA/ESA',
);

const _yesterday = ApodEntry(
  date: '2026-05-20',
  title: 'Orion Nebula Closeup',
  explanation: 'A stunning view of the Orion Nebula in infrared.',
  url: 'https://apod.nasa.gov/apod/image/2605/orion.jpg',
  mediaType: 'image',
);

Widget _buildTestApp({
  required MockApodRepository mockRepo,
  required MockSharedPreferences mockPrefs,
}) {
  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(mockPrefs),
      apodRepositoryProvider.overrideWithValue(mockRepo),
    ],
    child: MaterialApp(
      home: const ApodDetailPage(),
      routes: {
        ApodHistoryPage.routeName: (_) => const ApodHistoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ApodDetailPage.routeName) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => const ApodDetailPage(),
          );
        }
        return null;
      },
    ),
  );
}

void main() {
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
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TEST 1: Successful APOD retrieval renders entry
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets("Integration: App launch fetches and renders today's APOD", (
    tester,
  ) async {
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Success(_today));

    await tester.pumpWidget(
      _buildTestApp(mockRepo: mockRepo, mockPrefs: mockPrefs),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Galaxy Collision'), findsOneWidget);
    expect(find.byType(ApodActionBar), findsOneWidget);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TEST 2: Cache-first startup shows cached entry before network response
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Integration: Cached entry displays before network response', (
    tester,
  ) async {
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(_today));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(seconds: 10));
      return const Success(_today);
    });

    await tester.pumpWidget(
      _buildTestApp(mockRepo: mockRepo, mockPrefs: mockPrefs),
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Galaxy Collision'), findsOneWidget);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TEST 3: Offline fallback shows cached data with offline banner
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Integration: Offline startup shows cached entry with banner', (
    tester,
  ) async {
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(_today));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Failure(ApodNoConnection()));

    await tester.pumpWidget(
      _buildTestApp(mockRepo: mockRepo, mockPrefs: mockPrefs),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Galaxy Collision'), findsOneWidget);
    expect(find.textContaining('Offline Mode'), findsOneWidget);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TEST 4: Error state shows "Lost in Space" when no cache available
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Integration: Network error with empty cache shows error state', (
    tester,
  ) async {
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Failure(ApodNoConnection()));

    await tester.pumpWidget(
      _buildTestApp(mockRepo: mockRepo, mockPrefs: mockPrefs),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Lost in Space'), findsOneWidget);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TEST 5: Prev/Next day navigation loads different entries
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Integration: Previous day navigation loads previous APOD', (
    tester,
  ) async {
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((inv) async {
      final date = inv.positionalArguments[0] as DateTime;
      if (date.day == 21) return const Success(_today);
      if (date.day == 20) return const Success(_yesterday);
      return const Failure(ApodNoConnection());
    });

    await tester.pumpWidget(
      _buildTestApp(mockRepo: mockRepo, mockPrefs: mockPrefs),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Galaxy Collision'), findsOneWidget);

    final prevBtn = find.byKey(const Key('apod_prev_day_btn'));
    expect(prevBtn, findsOneWidget);
    await tester.tap(prevBtn);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Orion Nebula Closeup'), findsOneWidget);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TEST 6: HD image viewer opens and closes correctly
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Integration: Open HD viewer via action bar and navigate back', (
    tester,
  ) async {
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Success(_today));

    await tester.pumpWidget(
      _buildTestApp(mockRepo: mockRepo, mockPrefs: mockPrefs),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.scrollUntilVisible(
      find.widgetWithText(InkWell, 'Open HD'),
      200,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.widgetWithText(InkWell, 'Open HD'));
    await tester.pumpAndSettle();

    expect(find.byType(ApodImageViewer), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(ApodImageViewer), findsNothing);
    expect(find.text('Galaxy Collision'), findsOneWidget);
  });

  // ─────────────────────────────────────────────────────────────────────────
  // TEST 7: History page navigates and renders
  // ─────────────────────────────────────────────────────────────────────────
  testWidgets('Integration: History page renders after navigation', (
    tester,
  ) async {
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Success(_today));
    when(
      () => mockRepo.getApodRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((_) async => const Success([]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          apodRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => Navigator.of(ctx).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ApodHistoryPage(),
                ),
              ),
              child: const Text('Open History'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open History'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byType(ApodHistoryPage), findsOneWidget);
  });
}
