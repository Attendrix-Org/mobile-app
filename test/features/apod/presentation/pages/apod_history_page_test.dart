import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_history_page.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/calendar_explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late MockSharedPreferences mockPrefs;
  late MockApodRepository mockRepo;

  const testEntry1 = ApodEntry(
    date: '2026-05-21',
    title: 'Glowing Cosmic Pillars',
    explanation: 'A gorgeous view of stellar columns composed of gas.',
    url: 'https://example.com/standard1.jpg',
    hdurl: 'https://example.com/hd1.jpg',
    mediaType: 'image',
  );

  const testEntry2 = ApodEntry(
    date: '2026-05-20',
    title: 'Supernova Remnant',
    explanation: 'A beautiful remnant of a collapsed massive star.',
    url: 'https://example.com/standard2.jpg',
    hdurl: 'https://example.com/hd2.jpg',
    mediaType: 'image',
  );

  setUpAll(() {
    mockHttpClient = MockHttpClient();
    mockHttpClientRequest = MockHttpClientRequest();
    mockHttpClientResponse = MockHttpClientResponse();
    mockHttpHeaders = MockHttpHeaders();

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

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockRepo = MockApodRepository();

    // Default mock preferences stubs
    when(
      () => mockPrefs.getStringList('apod_recent_searches'),
    ).thenReturn(null);
    when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn(null);
    when(
      () => mockPrefs.setStringList(any(), any()),
    ).thenAnswer((_) async => true);
    when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

    registerFallbackValue(DateTime(2026, 5, 21));
    when(
      () => mockRepo.getCachedApod(any()),
    ).thenAnswer((_) async => const Success<ApodEntry?>(null));
    when(
      () => mockRepo.getApodForDate(
        any(),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Success(testEntry1));
  });

  Widget buildTestWidget({
    required Widget child,
    List<dynamic> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        apodRepositoryProvider.overrideWithValue(mockRepo),
        ...overrides,
      ].cast(),
      child: MaterialApp(
        routes: {
          ApodDetailPage.routeName: (context) => const ApodDetailPage(),
          ApodHistoryPage.routeName: (context) => const ApodHistoryPage(),
        },
        home: child,
      ),
    );
  }

  group('ApodHistoryPage Widget Tests', () {
    testWidgets('renders empty state when there is no history', (tester) async {
      when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn([]);

      await tester.pumpWidget(buildTestWidget(child: const ApodHistoryPage()));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('No APODs viewed yet'), findsOneWidget);
      expect(find.byKey(const Key('explore_today_btn')), findsOneWidget);

      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets(
      'explore today button navigates to detail page with null arguments',
      (tester) async {
        when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn([]);

        await tester.pumpWidget(
          buildTestWidget(child: const ApodHistoryPage()),
        );
        await tester.pump(const Duration(milliseconds: 500));

        await tester.tap(find.byKey(const Key('explore_today_btn')));
        await tester.pump();
        await tester.pump(
          const Duration(milliseconds: 100),
        ); // Resolve today fetch
        await tester.pump(
          const Duration(milliseconds: 350),
        ); // Navigation transition
        await tester.pump(
          const Duration(milliseconds: 600),
        ); // Image load & animations on Detail Page
        await tester.pump();

        expect(find.byType(ApodDetailPage), findsOneWidget);
      },
    );

    testWidgets('toggles history list and grid view mode', (tester) async {
      when(
        () => mockPrefs.getStringList('apod_viewed_dates'),
      ).thenReturn(['2026-05-21', '2026-05-20']);
      when(
        () => mockRepo.getApodForDate(
          DateTime(2026, 5, 21),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Success(testEntry1));
      when(
        () => mockRepo.getApodForDate(
          DateTime(2026, 5, 20),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Success(testEntry2));

      await tester.pumpWidget(buildTestWidget(child: const ApodHistoryPage()));
      await tester.pump(); // Start fetching
      await tester.pump(const Duration(milliseconds: 100)); // Resolve futures
      await tester.pump(
        const Duration(milliseconds: 350),
      ); // Resolve animations
      await tester.pump();

      // Verify grid view is visible by default
      expect(find.byKey(const Key('history_grid_view')), findsOneWidget);
      expect(find.byKey(const Key('history_list_view')), findsNothing);

      // Tap list toggle button
      await tester.tap(find.byKey(const Key('history_list_toggle')));
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();

      // Verify list view is visible
      expect(find.byKey(const Key('history_list_view')), findsOneWidget);
      expect(find.byKey(const Key('history_grid_view')), findsNothing);

      // Tap grid toggle button
      await tester.tap(find.byKey(const Key('history_grid_toggle')));
      await tester.pump(const Duration(seconds: 5));
      await tester.pump();

      // Verify grid view is visible again
      expect(find.byKey(const Key('history_grid_view')), findsOneWidget);

      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('displays validation error for invalid search formats', (
      tester,
    ) async {
      when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn([]);

      await tester.pumpWidget(buildTestWidget(child: const ApodHistoryPage()));
      await tester.pump(const Duration(milliseconds: 500));

      final inputFinder = find.byKey(const Key('history_search_input'));

      // Test format validation
      await tester.enterText(inputFinder, '2026-05');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Format must be YYYY-MM-DD'), findsOneWidget);

      // Test start date boundary
      await tester.enterText(inputFinder, '1995-06-15');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('APOD started on June 16, 1995'), findsOneWidget);

      // Test future date validation
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowStr =
          '${tomorrow.year}-'
          '${tomorrow.month.toString().padLeft(2, '0')}-'
          '${tomorrow.day.toString().padLeft(2, '0')}';
      await tester.enterText(inputFinder, tomorrowStr);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Date cannot be in the future'), findsOneWidget);
    });

    testWidgets(
      'triggers successful search, adds to viewed/recent, and navigates to Detail Page',
      (tester) async {
        when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn([]);
        when(
          () => mockRepo.getCachedApod(any()),
        ).thenAnswer((_) async => const Success<ApodEntry?>(testEntry2));
        when(
          () => mockRepo.getApodForDate(
            DateTime(2026, 5, 20),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer((_) async => const Success(testEntry2));

        await tester.pumpWidget(
          buildTestWidget(child: const ApodHistoryPage()),
        );
        await tester.pump(const Duration(milliseconds: 500));

        final inputFinder = find.byKey(const Key('history_search_input'));
        await tester.enterText(inputFinder, '2026-05-20');
        await tester.testTextInput.receiveAction(TextInputAction.done);

        // Pump search execution state
        await tester.pump(); // Starts loading overlay
        expect(find.byType(CircularProgressIndicator), findsWidgets);

        await tester.pump(const Duration(milliseconds: 100)); // Resolves Future
        await tester.pump(
          const Duration(milliseconds: 350),
        ); // Navigator transition
        await tester.pump(
          const Duration(milliseconds: 600),
        ); // Resolve image loads & animations on Detail Page
        await tester.pump();

        // Verify repository call (called twice: once for search, once when viewedDatesProvider updates historyEntriesProvider)
        verify(() => mockRepo.getApodForDate(DateTime(2026, 5, 20))).called(2);

        // Verify SharedPreferences updates
        verify(
          () => mockPrefs.setStringList('apod_viewed_dates', ['2026-05-20']),
        ).called(1);
        verify(
          () => mockPrefs.setStringList('apod_recent_searches', ['2026-05-20']),
        ).called(1);

        // Verify Detail Page has loaded and displays standard contents
        expect(find.byType(ApodDetailPage), findsOneWidget);
        expect(find.text('Supernova Remnant'), findsOneWidget);
      },
    );

    testWidgets(
      'renders recent searches and handles chip interaction and clearing',
      (tester) async {
        when(
          () => mockPrefs.getStringList('apod_recent_searches'),
        ).thenReturn(['2026-05-20', '2026-05-21']);
        when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn([]);
        when(
          () => mockRepo.getApodForDate(
            any(),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer((_) async => const Success(testEntry1));

        await tester.pumpWidget(
          buildTestWidget(child: const ApodHistoryPage()),
        );
        await tester.pump(const Duration(milliseconds: 500));

        // Verify chips render
        expect(find.text('2026-05-20'), findsOneWidget);
        expect(find.text('2026-05-21'), findsOneWidget);

        // Tap a recent search chip
        await tester.tap(
          find.byKey(const Key('recent_search_chip_2026-05-20')),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100)); // Future resolves
        await tester.pump(
          const Duration(milliseconds: 350),
        ); // Detail page transition
        await tester.pump(
          const Duration(milliseconds: 600),
        ); // Image load & animations on Detail Page
        await tester.pump();

        expect(find.byType(ApodDetailPage), findsOneWidget);

        // Pop back to history page
        final backBtn = find.byKey(const Key('apod_detail_back_btn'));
        await tester.tap(backBtn);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 350)); // Pop transition
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump();

        // Tap clear all recent searches
        await tester.tap(find.text('Clear All'));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();

        // Verify chips are removed
        expect(
          find.byKey(const Key('recent_search_chip_2026-05-20')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('recent_search_chip_2026-05-21')),
          findsNothing,
        );
        verify(() => mockPrefs.remove('apod_recent_searches')).called(1);
      },
    );

    testWidgets('renders error state and retries on button tap', (
      tester,
    ) async {
      when(
        () => mockPrefs.getStringList('apod_viewed_dates'),
      ).thenReturn(['2026-05-21']);

      var shouldFail = true;

      await tester.pumpWidget(
        buildTestWidget(
          overrides: [
            historyEntriesProvider.overrideWith((ref) async {
              if (shouldFail) {
                throw const ApodUnknownFailure('Network Outage');
              }
              return [testEntry1];
            }),
          ],
          child: const ApodHistoryPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error state renders
      expect(find.text('Archive Sync Error'), findsOneWidget);
      expect(find.text('Network Outage'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry Sync'), findsOneWidget);

      // Set state to succeed
      shouldFail = false;

      // Tap retry sync
      await tester.tap(find.widgetWithText(ElevatedButton, 'Retry Sync'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100)); // Resolve futures
      await tester.pump(
        const Duration(milliseconds: 350),
      ); // Settle transitions
      await tester.pump();

      // Verify history grid is now displayed
      expect(find.byKey(const Key('history_grid_view')), findsOneWidget);
      expect(find.text('Archive Sync Error'), findsNothing);
    });
  });

  group('CalendarExplorer and Panel Integration Tests', () {
    testWidgets(
      'toggles calendar view and triggers search on valid date selection',
      (tester) async {
        when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn([]);
        when(
          () => mockRepo.getApodForDate(
            any(),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer(
          (_) async => Success(testEntry1.copyWith(date: '2026-05-18')),
        );

        await tester.pumpWidget(
          buildTestWidget(child: const ApodHistoryPage()),
        );
        await tester.pump(const Duration(milliseconds: 500));

        // Assert CalendarExplorer is not visible
        expect(find.byType(CalendarExplorer), findsNothing);

        // Toggle calendar panel open
        await tester.tap(find.byKey(const Key('calendar_toggle_btn')));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();

        // Assert CalendarExplorer is visible
        expect(find.byType(CalendarExplorer), findsOneWidget);

        // Test calendar navigation
        final prevMonthBtn = find.byKey(const Key('calendar_prev_month'));
        await tester.tap(prevMonthBtn);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();

        // Tap a day cell
        final day15 = find.widgetWithText(InkWell, '15');
        expect(day15, findsAtLeastNWidgets(1));
        await tester.tap(day15.first);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100)); // Future resolves
        await tester.pump(
          const Duration(milliseconds: 350),
        ); // Detail page transition
        await tester.pump(
          const Duration(milliseconds: 600),
        ); // Detail page loaded resources
        await tester.pump();

        // Assert it navigated
        expect(find.byType(ApodDetailPage), findsOneWidget);
      },
    );

    testWidgets(
      'calendar explorer disables dates before start date (June 16, 1995)',
      (tester) async {
        when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn([]);

        await tester.pumpWidget(
          buildTestWidget(child: const ApodHistoryPage()),
        );
        await tester.pump(const Duration(milliseconds: 500));

        // Toggle calendar panel open
        await tester.tap(find.byKey(const Key('calendar_toggle_btn')));
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();

        // Set month/year to May 1995
        final container = ProviderScope.containerOf(
          tester.element(find.byType(ApodHistoryPage)),
        );
        container.read(calendarMonthYearProvider.notifier).state =
            const MonthYear(5, 1995);
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump();

        // Try to tap day 15 (which is in May 1995, hence before June 16, 1995)
        final day15 = find.widgetWithText(InkWell, '15').first;
        final inkWell = tester.widget<InkWell>(day15);

        // Assert that the InkWell's onTap is null (meaning it is disabled)
        expect(inkWell.onTap, isNull);
      },
    );

    testWidgets('calendar explorer disables future dates', (tester) async {
      when(() => mockPrefs.getStringList('apod_viewed_dates')).thenReturn([]);

      await tester.pumpWidget(buildTestWidget(child: const ApodHistoryPage()));
      await tester.pump(const Duration(milliseconds: 500));

      // Toggle calendar panel open
      await tester.tap(find.byKey(const Key('calendar_toggle_btn')));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // Set month/year to next year (future)
      final now = DateTime.now();
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ApodHistoryPage)),
      );
      container.read(calendarMonthYearProvider.notifier).state = MonthYear(
        now.month,
        now.year + 1,
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      // Any day in the future should be disabled
      final day15 = find.widgetWithText(InkWell, '15').first;
      final inkWell = tester.widget<InkWell>(day15);

      expect(inkWell.onTap, isNull);
    });
  });
}
