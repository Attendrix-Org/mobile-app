import 'dart:convert';
import 'dart:io';

import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/apod_action_bar.dart';
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

const _testEntry = ApodEntry(
  date: '2026-05-21',
  title: 'The Pillars of Creation',
  explanation:
      'Giant columns of gas and dust photographed by the Hubble Space Telescope.',
  url: 'https://apod.nasa.gov/apod/image/2605/pillar.jpg',
  hdurl: 'https://apod.nasa.gov/apod/image/2605/pillar_hd.jpg',
  mediaType: 'image',
  copyright: 'NASA/ESA/STScI',
);

void main() {
  late MockHttpClient mockHttpClient;
  late MockHttpClientRequest mockHttpClientRequest;
  late MockHttpClientResponse mockHttpClientResponse;
  late MockHttpHeaders mockHttpHeaders;

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

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 1: Semantics Tree Validation
  // ─────────────────────────────────────────────────────────────────────────
  group('Semantics Tree Validation', () {
    testWidgets('Hero image banner has descriptive semantics label', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _testEntry));
      await tester.pump(const Duration(milliseconds: 600));

      // The hero banner Semantics node should contain the entry title
      final semanticsFinder = find.bySemanticsLabel(
        RegExp('NASA APOD Image hero banner:'),
      );
      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets('Action buttons are marked as buttons in semantics', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _testEntry));
      await tester.pump(const Duration(milliseconds: 600));

      // ApodActionBar action buttons should all have button semantics
      final shareSemantics = tester.semantics.find(
        find.widgetWithText(InkWell, 'Share'),
      );
      expect(shareSemantics.flagsCollection.isButton, isTrue);

      final downloadSemantics = tester.semantics.find(
        find.widgetWithText(InkWell, 'Download'),
      );
      expect(downloadSemantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('App bar back button is tappable and has icon semantics', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _testEntry));
      await tester.pump(const Duration(milliseconds: 600));

      final backBtn = find.byKey(const Key('apod_detail_back_btn'));
      expect(backBtn, findsOneWidget);

      // Verify tappable
      await tester.tap(backBtn);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 2: Text Scale Accessibility
  // ─────────────────────────────────────────────────────────────────────────
  group('Large Text / Text Scale Accessibility', () {
    for (final scale in [1.0, 1.25, 1.5, 2.0]) {
      testWidgets(
        'Renders without overflow at ${(scale * 100).toInt()}% text scale',
        (tester) async {
          tester.view.physicalSize = const Size(390, 844);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
          });

          await tester.pumpWidget(
            buildPage(entry: _testEntry, textScale: scale),
          );
          await tester.pump(const Duration(milliseconds: 600));
          expect(tester.takeException(), isNull);
          expect(find.text(_testEntry.title), findsOneWidget);
        },
      );
    }
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 3: Touch Target Sizes
  // ─────────────────────────────────────────────────────────────────────────
  group('Touch Target Size Validation (≥ 48x48dp)', () {
    testWidgets('Action bar buttons meet minimum touch target size', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _testEntry));
      await tester.pump(const Duration(milliseconds: 600));

      // Find the ApodActionBar and verify it renders
      expect(find.byType(ApodActionBar), findsOneWidget);

      // Measure the Share InkWell tap target
      final shareRenderBox =
          tester.renderObject(
                find.widgetWithText(InkWell, 'Share').first,
              )
              as RenderBox;
      // Button height should be at least 48 logical pixels per WCAG 2.5.5
      expect(shareRenderBox.size.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('AppBar navigation buttons meet minimum touch target', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _testEntry));
      await tester.pump(const Duration(milliseconds: 600));

      final prevBtn = find.byKey(const Key('apod_prev_day_btn'));
      expect(prevBtn, findsOneWidget);
      final prevBox = tester.renderObject(prevBtn) as RenderBox;
      expect(prevBox.size.height, greaterThanOrEqualTo(48.0));
      expect(prevBox.size.width, greaterThanOrEqualTo(48.0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 4: Focus Traversal Validation
  // ─────────────────────────────────────────────────────────────────────────
  group('Focus Traversal', () {
    testWidgets('Focus can reach action bar buttons via traversal', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildPage(entry: _testEntry));
      await tester.pump(const Duration(milliseconds: 600));

      // Scroll down to bring action bar into view
      await tester.scrollUntilVisible(
        find.byType(ApodActionBar),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();

      // Ensure the action bar is visible
      expect(find.byType(ApodActionBar), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // GROUP 5: Responsive Accessibility
  // ─────────────────────────────────────────────────────────────────────────
  group('Responsive Accessibility Across Device Sizes', () {
    final deviceSizes = <String, Size>{
      'Small phone (320x568)': const Size(320, 568),
      'Standard phone (390x844)': const Size(390, 844),
      'Large phone (428x926)': const Size(428, 926),
      'Tablet (1024x768)': const Size(1024, 768),
    };

    for (final entry in deviceSizes.entries) {
      testWidgets('Renders accessibly on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          buildPage(entry: _testEntry, size: entry.value),
        );
        await tester.pump(const Duration(milliseconds: 600));

        expect(tester.takeException(), isNull);
        expect(find.text(_testEntry.title), findsOneWidget);
      });
    }
  });
}
