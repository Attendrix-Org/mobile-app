import 'dart:convert';
import 'dart:io';

import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApodRepository extends Mock implements ApodRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class _TestHttpOverrides extends HttpOverrides {
  _TestHttpOverrides(this.client);
  final HttpClient client;
  @override
  HttpClient createHttpClient(SecurityContext? context) => client;
}

/// Standard image APOD entry for regression tests
const ApodEntry _imageEntry = ApodEntry(
  date: '2026-05-21',
  title: 'A Stunning Cosmic Pillar',
  explanation:
      'This entry has a perfectly ordinary explanation that renders cleanly.',
  url: 'https://apod.nasa.gov/apod/image/2605/pillar.jpg',
  hdurl: 'https://apod.nasa.gov/apod/image/2605/pillar_hd.jpg',
  mediaType: 'image',
  copyright: 'NASA/JPL',
);

/// Entry whose explanation is extremely long (> 2000 chars) to stress layout.
final ApodEntry _longExplanationEntry = ApodEntry(
  date: '2026-05-21',
  title: 'Entry With Extreme Explanation',
  explanation: 'Lorem ipsum. ' * 200, // ~2600 chars
  url: 'https://apod.nasa.gov/apod/image/2605/pillar.jpg',
  mediaType: 'image',
);

/// Entry with all optional fields absent.
const ApodEntry _minimalEntry = ApodEntry(
  date: '2026-05-21',
  title: 'Minimal Entry',
  explanation: 'Short.',
  url: 'https://apod.nasa.gov/apod/image/2605/minimal.jpg',
  mediaType: 'image',
);

void main() {
  late MockHttpClient mockHttpClient;
  late MockHttpClientRequest mockHttpClientRequest;
  late MockHttpClientResponse mockHttpClientResponse;
  late MockHttpHeaders mockHttpHeaders;

  setUpAll(() {
    registerFallbackValue(Uri());
    registerFallbackValue(DateTime(2026));

    mockHttpClient = MockHttpClient();
    mockHttpClientRequest = MockHttpClientRequest();
    mockHttpClientResponse = MockHttpClientResponse();
    mockHttpHeaders = MockHttpHeaders();

    final transparentPng = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
    );

    when(
      () => mockHttpClient.getUrl(any()),
    ).thenAnswer((_) async => mockHttpClientRequest);
    when(() => mockHttpClientRequest.headers).thenReturn(mockHttpHeaders);
    when(
      () => mockHttpClientRequest.close(),
    ).thenAnswer((_) async => mockHttpClientResponse);
    when(() => mockHttpClientResponse.statusCode).thenReturn(200);
    when(
      () => mockHttpClientResponse.contentLength,
    ).thenReturn(transparentPng.length);
    when(
      () => mockHttpClientResponse.listen(
        any(),
        cancelOnError: any(named: 'cancelOnError'),
        onDone: any(named: 'onDone'),
        onError: any(named: 'onError'),
      ),
    ).thenAnswer((inv) {
      final onData = inv.positionalArguments[0] as void Function(List<int>);
      final onDone = inv.namedArguments[#onDone] as void Function()?;
      return Stream<List<int>>.fromIterable([
        transparentPng,
      ]).listen(onData, onDone: onDone);
    });

    HttpOverrides.global = _TestHttpOverrides(mockHttpClient);
  });

  tearDownAll(() => HttpOverrides.global = null);

  Widget buildPage({
    required ApodEntry entry,
    double textScale = 1.0,
    Size size = const Size(390, 844),
    MockApodRepository? repo,
  }) {
    final mockRepo = repo ?? MockApodRepository();
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => Success(entry));

    final mockPrefs = MockSharedPreferences();
    when(() => mockPrefs.getStringList(any())).thenReturn(null);
    when(
      () => mockPrefs.setStringList(any(), any()),
    ).thenAnswer((_) async => true);
    when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        apodRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: MaterialApp(
        home: Builder(
          builder: (ctx) => MediaQuery(
            data: MediaQuery.of(ctx).copyWith(
              textScaler: TextScaler.linear(textScale),
              size: size,
            ),
            child: ApodDetailPage(entry: entry),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 1: DTO Serialization Regressions
  // ─────────────────────────────────────────────────────────────────────────
  group('Serialization Regression Tests', () {
    test('ApodDto.fromJson round-trips through toJson without data loss', () {
      const original = ApodDto(
        date: '2026-05-21',
        title: 'Test Title',
        explanation: 'Test explanation.',
        mediaType: 'image',
        url: 'https://apod.nasa.gov/img.jpg',
        hdurl: 'https://apod.nasa.gov/img_hd.jpg',
        copyright: '© NASA',
        serviceVersion: 'v1',
        thumbnailUrl: 'https://apod.nasa.gov/thumb.jpg',
      );
      final json = original.toJson();
      final restored = ApodDto.fromJson(json);
      expect(restored, equals(original));
    });

    test('ApodDto.fromJson handles all optional fields being null', () {
      final json = <String, dynamic>{
        'date': '2026-05-21',
        'title': 'Min Title',
        'explanation': 'Min explanation.',
        'media_type': 'image',
        'url': 'https://apod.nasa.gov/img.jpg',
      };
      expect(() => ApodDto.fromJson(json), returnsNormally);
      final dto = ApodDto.fromJson(json);
      expect(dto.hdurl, isNull);
      expect(dto.copyright, isNull);
      expect(dto.serviceVersion, isNull);
      expect(dto.thumbnailUrl, isNull);
    });

    test('ApodDto.fromJson throws on missing required fields (date)', () {
      final json = <String, dynamic>{
        'title': 'No date',
        'explanation': 'x',
        'media_type': 'image',
        'url': 'https://x.com',
      };
      expect(() => ApodDto.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('ApodEntry.fromJson handles video mediaType correctly', () {
      final json = <String, dynamic>{
        'date': '2026-05-01',
        'explanation': 'A video APOD.',
        'title': 'Video Entry',
        'url': 'https://www.youtube.com/embed/abc123',
        'media_type': 'video',
      };
      final entry = ApodEntry.fromJson(json);
      expect(entry.mediaType, 'video');
      expect(entry.hdurl, isNull);
    });

    test('ApodEntry.fromJson defaults mediaType to image when missing', () {
      final json = <String, dynamic>{
        'date': '2026-05-01',
        'explanation': 'An entry.',
        'title': 'Title',
        'url': 'https://apod.nasa.gov/img.jpg',
      };
      final entry = ApodEntry.fromJson(json);
      expect(entry.mediaType, 'image');
    });

    test('ApodEntry equality and hashCode are structurally correct', () {
      const a = ApodEntry(
        date: '2026-05-21',
        explanation: 'e',
        title: 't',
        url: 'https://x.com',
        mediaType: 'image',
      );
      const b = ApodEntry(
        date: '2026-05-21',
        explanation: 'e',
        title: 't',
        url: 'https://x.com',
        mediaType: 'image',
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 2: State Transition Regression
  // ─────────────────────────────────────────────────────────────────────────
  group('Provider State Transition Regression Tests', () {
    test('ApodSuccess state carries the correct entry', () {
      const state = ApodSuccess(_imageEntry);
      expect(state.entry, equals(_imageEntry));
      expect(state.isRefreshing, isFalse);
    });

    test('ApodCached state defaults isRefreshing to false', () {
      const state = ApodCached(_imageEntry);
      expect(state.isRefreshing, isFalse);
    });

    test('ApodOfflineFallback state carries entry with isRefreshing flag', () {
      const state = ApodOfflineFallback(_imageEntry, isRefreshing: true);
      expect(state.entry, equals(_imageEntry));
      expect(state.isRefreshing, isTrue);
    });

    test('ApodError state carries message and failure type', () {
      const failure = ApodTimeout();
      final state = ApodError(failure.message, failure);
      expect(state.errorMessage, contains('timed out'));
      expect(state.failure, isA<ApodTimeout>());
    });

    test('All ApodFailure subclasses have non-empty default messages', () {
      final failures = <ApodFailure>[
        const ApodTimeout(),
        const ApodRateLimited(),
        const ApodNotFound(),
        const ApodServerError(),
        const ApodNoConnection(),
        const ApodCacheFailure(),
        const ApodUnknownFailure(),
      ];
      for (final f in failures) {
        expect(
          f.message.isNotEmpty,
          isTrue,
          reason: '${f.runtimeType} has empty message',
        );
      }
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 3: Layout Overflow Regression (Widget tests)
  // ─────────────────────────────────────────────────────────────────────────
  group('Layout Overflow Regression Tests', () {
    testWidgets('No overflow with standard entry on mobile at 1x scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _imageEntry));
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });

    testWidgets('No overflow with entry missing all optional fields', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _minimalEntry));
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });

    testWidgets('No overflow with extremely long explanation text', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _longExplanationEntry));
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });

    testWidgets('No overflow at 200% text scale factor', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _imageEntry, textScale: 2));
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });

    testWidgets('No overflow on small 320x568 screen', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildPage(entry: _imageEntry, size: const Size(320, 568)),
      );
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });

    testWidgets('No overflow on tablet 1024x768 screen', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildPage(entry: _imageEntry, size: const Size(1024, 768)),
      );
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 4: Theme Regression
  // ─────────────────────────────────────────────────────────────────────────
  group('Theme Regression Tests', () {
    testWidgets('Detail page renders in dark theme without errors', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockRepo = MockApodRepository();
      when(
        () => mockRepo.getCachedApod(any()),
      ).thenAnswer((_) async => const Success<ApodEntry?>(null));
      when(
        () => mockRepo.getApodForDate(
          any(),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Success(_imageEntry));

      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.getStringList(any())).thenReturn(null);
      when(
        () => mockPrefs.setStringList(any(), any()),
      ).thenAnswer((_) async => true);
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            apodRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData.dark(),
            home: const ApodDetailPage(entry: _imageEntry),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Detail page renders in light theme without errors', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockRepo = MockApodRepository();
      when(
        () => mockRepo.getCachedApod(any()),
      ).thenAnswer((_) async => const Success<ApodEntry?>(null));
      when(
        () => mockRepo.getApodForDate(
          any(),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Success(_imageEntry));

      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.getStringList(any())).thenReturn(null);
      when(
        () => mockPrefs.setStringList(any(), any()),
      ).thenAnswer((_) async => true);
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            apodRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            theme: ThemeData.light(),
            home: const ApodDetailPage(entry: _imageEntry),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 5: Navigation Regression
  // ─────────────────────────────────────────────────────────────────────────
  group('Navigation Regression Tests', () {
    testWidgets('Back button pops the route', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockRepo = MockApodRepository();
      when(
        () => mockRepo.getCachedApod(any()),
      ).thenAnswer((_) async => const Success<ApodEntry?>(null));
      when(
        () => mockRepo.getApodForDate(
          any(),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Success(_imageEntry));

      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.getStringList(any())).thenReturn(null);
      when(
        () => mockPrefs.setStringList(any(), any()),
      ).thenAnswer((_) async => true);
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            apodRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: const Scaffold(body: Text('Home')),
            routes: {
              ApodDetailPage.routeName: (_) =>
                  const ApodDetailPage(entry: _imageEntry),
            },
          ),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            apodRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () =>
                    Navigator.of(ctx).pushNamed(ApodDetailPage.routeName),
                child: const Text('Open'),
              ),
            ),
            routes: {
              ApodDetailPage.routeName: (_) =>
                  const ApodDetailPage(entry: _imageEntry),
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      // Use bounded pumps instead of pumpAndSettle to avoid timeout from
      // ongoing Skeletonizer shimmer / flutter_animate looping animations.
      await tester.pump(); // start navigation
      await tester.pump(
        const Duration(milliseconds: 350),
      ); // finish route transition
      await tester.pump(
        const Duration(milliseconds: 600),
      ); // settle page render
      expect(find.byType(ApodDetailPage), findsOneWidget);

      await tester.tap(find.byKey(const Key('apod_detail_back_btn')));
      await tester.pump(); // start pop
      await tester.pump(
        const Duration(milliseconds: 500),
      ); // finish pop transition
      await tester.pump(); // final frame
      expect(find.byType(ApodDetailPage), findsNothing);
    });
  });
}
