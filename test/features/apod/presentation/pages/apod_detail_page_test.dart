import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/apod_action_bar.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/apod_image_viewer.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mocks for HTTP overrides
class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class MockApodRepository extends Mock implements ApodRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class TestHttpOverrides extends HttpOverrides {
  TestHttpOverrides(this.client);
  final HttpClient client;

  @override
  HttpClient createHttpClient(SecurityContext? context) => client;
}

void main() {
  late MockHttpClient mockHttpClient;
  late MockHttpClientRequest mockHttpClientRequest;
  late MockHttpClientResponse mockHttpClientResponse;
  late MockHttpHeaders mockHttpHeaders;

  const testEntry = ApodEntry(
    date: '2026-05-21',
    title: 'Glowing Cosmic Pillars',
    explanation:
        'A gorgeous view of stellar columns composed of gas and dust clouds spanning across light years.',
    url: 'https://example.com/standard.jpg',
    hdurl: 'https://example.com/hd.jpg',
    mediaType: 'image',
    copyright: 'Stellar Observatory Partner',
    resolution: '4K UHD',
    creditTitle: 'James Webb Space Telescope',
    creditDescription: 'The Webb telescope is a premier space observatory.',
  );

  setUpAll(() {
    mockHttpClient = MockHttpClient();
    mockHttpClientRequest = MockHttpClientRequest();
    mockHttpClientResponse = MockHttpClientResponse();
    mockHttpHeaders = MockHttpHeaders();

    // 1x1 transparent PNG bytes
    final transparentPng = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
    );

    registerFallbackValue(Uri());

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
    ).thenAnswer((invocation) {
      final onData =
          invocation.positionalArguments[0] as void Function(List<int>);
      final onDone = invocation.namedArguments[#onDone] as void Function()?;
      return Stream<List<int>>.fromIterable([
        transparentPng,
      ]).listen(onData, onDone: onDone);
    });

    HttpOverrides.global = TestHttpOverrides(mockHttpClient);
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  Widget buildTestWidget({
    ApodEntry? entry,
    bool isLoading = false,
    String? errorMessage,
    VoidCallback? onRetry,
    double textScaleFactor = 1.0,
    Size size = const Size(375, 812), // Mobile by default
    ApodRepository? repository,
  }) {
    final mockRepo = repository ?? MockApodRepository();
    registerFallbackValue(DateTime(2026, 5, 21));
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    if (repository == null) {
      when(
        () => mockRepo.getApodForDate(
          any(),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Success(testEntry));
    }

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
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(textScaleFactor),
                size: size,
              ),
              child: ApodDetailPage(
                entry: entry,
                isLoading: isLoading,
                errorMessage: errorMessage,
                onRetry: onRetry,
              ),
            );
          },
        ),
      ),
    );
  }

  group('ApodDetailPage Widget Rendering Tests', () {
    testWidgets('Renders detail page with loaded data successfully', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(entry: testEntry));
      await tester.pump(const Duration(milliseconds: 600));

      // Check header titles and date
      expect(
        find.text('GLOWING COSMIC PILLARS'),
        findsNothing,
      ); // Checks matching case-sensitivity
      expect(find.text('Glowing Cosmic Pillars'), findsOneWidget);
      expect(find.text('2026-05-21'), findsWidgets); // Badges and titles

      // Check copyright, resolution, and explanation
      expect(find.text('Stellar Observatory Partner'), findsOneWidget);
      expect(find.text('4K UHD'), findsOneWidget);
      expect(find.byType(ExpandableText), findsOneWidget);
      expect(find.text(testEntry.explanation), findsOneWidget);

      // Check actions bar
      expect(find.byType(ApodActionBar), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
      expect(find.text('Open HD'), findsOneWidget);

      // Check attribution card
      expect(find.text('PARTNER CREDIT'), findsOneWidget);
      expect(find.text('James Webb Space Telescope'), findsOneWidget);
      expect(
        find.text('The Webb telescope is a premier space observatory.'),
        findsOneWidget,
      );
    });

    testWidgets('Renders page in loading state (Skeletonizer active)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(isLoading: true));
      await tester.pump(
        const Duration(milliseconds: 600),
      ); // Pump to allow timers/microtasks to resolve

      // Skeletonizer should wrap contents
      expect(find.byKey(const Key('apod_skeletonizer')), findsWidgets);

      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('Renders page in error state with retry button', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      var retryClicked = false;

      await tester.pumpWidget(
        buildTestWidget(
          errorMessage: 'Server handshake failed. Timeout after 15000ms.',
          onRetry: () => retryClicked = true,
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Check "Lost in Space" UI elements
      expect(find.text('Lost in Space'), findsOneWidget);
      expect(
        find.text('Server handshake failed. Timeout after 15000ms.'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.satellite_alt_rounded), findsOneWidget);
      expect(find.byIcon(Icons.signal_wifi_off_rounded), findsOneWidget);
      expect(find.text('SYSTEM DIAGNOSTICS'), findsOneWidget);
      expect(find.textContaining('Gateway Timeout (504)'), findsOneWidget);

      // Find and tap retry button
      final retryBtn = find.byKey(const Key('apod_error_retry_btn'));
      expect(retryBtn, findsOneWidget);
      await tester.ensureVisible(retryBtn);
      await tester.tap(retryBtn);
      await tester.pump(const Duration(milliseconds: 500));

      expect(retryClicked, isTrue);
    });
  });

  group('A11y and Dynamic Text Scaling Tests', () {
    testWidgets(
      'Checks semantic labels and descriptions for standard widgets',
      (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(buildTestWidget(entry: testEntry));
        await tester.pump(const Duration(milliseconds: 600));

        // Verify buttons have button semantics
        final shareButtonSemantics = tester.semantics.find(
          find.widgetWithText(InkWell, 'Share'),
        );
        expect(shareButtonSemantics.flagsCollection.isButton, isTrue);

        final openHdButtonSemantics = tester.semantics.find(
          find.widgetWithText(InkWell, 'Open HD'),
        );
        expect(openHdButtonSemantics.flagsCollection.isButton, isTrue);
      },
    );

    testWidgets(
      'Handles double scale text factors without crash or exceptions',
      (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        // High text scale factor (2.0)
        await tester.pumpWidget(
          buildTestWidget(
            entry: testEntry,
            textScaleFactor: 2,
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        // Verification that no exception has occurred
        expect(tester.takeException(), isNull);
        expect(find.text('Glowing Cosmic Pillars'), findsOneWidget);
      },
    );
  });

  group('Responsive Layout Layout Tests', () {
    testWidgets('Loads mobile layout when screen width <= 720', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Small screen size (mobile)
      await tester.pumpWidget(
        buildTestWidget(
          entry: testEntry,
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      // Mobile layout uses single scroll, which has image banner edge-to-edge
      // (Aspect ratio height ~45% of height, which is ~365)
      final heroBannerFinder = find.bySemanticsLabel(
        RegExp('NASA APOD Image hero banner'),
      );
      expect(heroBannerFinder, findsOneWidget);

      // Mobile columns: metadata is vertically stacked overall
      // Verify list view scrollable container exists
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('Loads tablet split layout when screen width > 720', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Large screen size (tablet)
      await tester.pumpWidget(
        buildTestWidget(
          entry: testEntry,
          size: const Size(1024, 768),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      // Tablet layout uses a Row split.
      expect(find.byType(Row), findsWidgets);

      // Verification of layout contents
      expect(find.text('Glowing Cosmic Pillars'), findsOneWidget);
      expect(find.byType(ApodActionBar), findsOneWidget);
    });
  });

  group('Interactive Actions and Expansion Tests', () {
    testWidgets(
      'Toggles accordion sections for copyright and metadata details',
      (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(buildTestWidget(entry: testEntry));
        await tester.pump(const Duration(milliseconds: 600));

        // Initially closed copyright details accordion
        expect(
          find.textContaining(
            '© All rights reserved to Stellar Observatory Partner',
          ),
          findsNothing,
        );

        // Tap to expand copyright accordion
        final copyrightAccordion = find.byKey(const Key('copyright_accordion'));
        await tester.ensureVisible(copyrightAccordion);
        await tester.tap(copyrightAccordion);
        await tester.pump(const Duration(milliseconds: 600));

        // Now copyright text is visible
        expect(
          find.textContaining(
            '© All rights reserved to Stellar Observatory Partner',
          ),
          findsOneWidget,
        );

        // Tap to close copyright accordion
        await tester.tap(copyrightAccordion);
        await tester.pump(const Duration(milliseconds: 600));

        expect(
          find.textContaining(
            '© All rights reserved to Stellar Observatory Partner',
          ),
          findsNothing,
        );
      },
    );

    testWidgets('Opens full screen image viewer on banner or Open HD tap', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(entry: testEntry));
      await tester.pump(const Duration(milliseconds: 600));

      // Tap Open HD action button
      final openHdBtn = find.widgetWithText(InkWell, 'Open HD');
      await tester.ensureVisible(openHdBtn);
      await tester.tap(openHdBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verifies ApodImageViewer page is opened
      expect(find.byType(ApodImageViewer), findsOneWidget);
      expect(find.text('Interactive HD Viewer'), findsOneWidget);
      expect(find.text(testEntry.title), findsOneWidget);

      // Tap back button in viewer
      final backBtn = find.byIcon(Icons.arrow_back);
      await tester.tap(backBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verifies ApodImageViewer popped
      expect(find.byType(ApodImageViewer), findsNothing);
    });
  });

  group('Previous/Next Navigation and Dynamic Loading Tests', () {
    testWidgets(
      'Loads dynamically when only date is passed via route arguments',
      (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final mockRepo = MockApodRepository();
        registerFallbackValue(DateTime(2026, 5, 21));
        when(
          () => mockRepo.getCachedApod(any()),
        ).thenAnswer((_) async => const Success<ApodEntry?>(null));
        final completer = Completer<Result<ApodEntry>>();
        when(
          () => mockRepo.getApodForDate(
            DateTime.utc(2026, 5, 20),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer((_) => completer.future);

        final mockPrefs = MockSharedPreferences();
        when(() => mockPrefs.getStringList(any())).thenReturn(null);
        when(
          () => mockPrefs.setStringList(any(), any()),
        ).thenAnswer((_) async => true);
        when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

        // Pump materials with a routing setup that passes date argument
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(mockPrefs),
              apodRepositoryProvider.overrideWithValue(mockRepo),
            ],
            child: MaterialApp(
              routes: {
                ApodDetailPage.routeName: (context) => const ApodDetailPage(),
              },
              home: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    ApodDetailPage.routeName,
                    arguments: '2026-05-20',
                  ),
                  child: const Text('Go'),
                ),
              ),
            ),
          ),
        );

        // Tap Go to navigate
        await tester.tap(find.text('Go'));
        await tester.pump(); // Start navigation
        await tester.pump(
          const Duration(milliseconds: 350),
        ); // Finish navigation transition
        await tester
            .pump(); // Build detail page didChangeDependencies and trigger fetch

        // Verify skeleton is showing first
        expect(find.byKey(const Key('apod_skeletonizer')), findsOneWidget);

        // Complete the future
        completer.complete(
          const Success(
            ApodEntry(
              date: '2026-05-20',
              title: 'Dynamic Loaded Entry',
              explanation: 'This was loaded dynamically by date.',
              url: 'https://example.com/standard.jpg',
              mediaType: 'image',
            ),
          ),
        );

        await tester.pump(); // Allow Future to complete and trigger rebuild
        await tester.pump(
          const Duration(milliseconds: 350),
        ); // Finish AnimatedSwitcher transition
        await tester.pump(); // Final build

        // Verify loaded entry content is displayed
        expect(find.text('Dynamic Loaded Entry'), findsOneWidget);
        expect(find.text('2026-05-20'), findsWidgets);
      },
    );

    testWidgets(
      'Prev and Next buttons update date and load entries dynamically',
      (tester) async {
        tester.view.physicalSize = const Size(375, 812);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final mockRepo = MockApodRepository();

        // Stub for 2026-05-21 (initial)
        final initialEntry = testEntry.copyWith(
          date: '2026-05-21',
          title: 'Initial 21st',
        );
        // Stub for 2026-05-20 (previous)
        final prevEntry = testEntry.copyWith(
          date: '2026-05-20',
          title: 'Previous 20th',
        );
        // Stub for 2026-05-22 (next)
        final nextEntry = testEntry.copyWith(
          date: '2026-05-22',
          title: 'Next 22nd',
        );

        registerFallbackValue(DateTime(2026, 5, 21));
        when(
          () => mockRepo.getApodForDate(
            any(),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer((invocation) async {
          final date = invocation.positionalArguments[0] as DateTime;
          if (date.year == 2026 && date.month == 5 && date.day == 21) {
            return Success(initialEntry);
          } else if (date.year == 2026 && date.month == 5 && date.day == 20) {
            return Success(prevEntry);
          } else if (date.year == 2026 && date.month == 5 && date.day == 22) {
            return Success(nextEntry);
          }
          return const Failure(ApodUnknownFailure('Date not stubbed'));
        });

        await tester.pumpWidget(
          buildTestWidget(
            entry: initialEntry,
            repository: mockRepo,
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        expect(find.text('Initial 21st'), findsOneWidget);

        // Verify buttons exist
        final prevBtn = find.byKey(const Key('apod_prev_day_btn'));
        final nextBtn = find.byKey(const Key('apod_next_day_btn'));
        expect(prevBtn, findsOneWidget);
        expect(nextBtn, findsOneWidget);

        // Tap prev day button
        await tester.tap(prevBtn);
        await tester.pump(); // Starts loading state
        await tester.pump(const Duration(milliseconds: 50)); // Resolves Future
        await tester.pump(
          const Duration(milliseconds: 350),
        ); // Finish AnimatedSwitcher transition
        await tester.pump(); // Build the new page with new entry

        expect(find.text('Previous 20th'), findsOneWidget);

        // Tap next day button (should load 2026-05-21)
        await tester.tap(nextBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump(const Duration(milliseconds: 350));
        await tester.pump();

        expect(find.text('Initial 21st'), findsOneWidget);

        // Tap next day button again (should load 2026-05-22)
        await tester.tap(nextBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pump(const Duration(milliseconds: 350));
        await tester.pump();

        expect(find.text('Next 22nd'), findsOneWidget);
      },
    );
  });
}
