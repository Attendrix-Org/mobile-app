import 'dart:async';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockApodRepository extends Mock implements ApodRepository {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockApodRepository mockRepo;
  late MockSharedPreferences mockPrefs;
  final testDate = DateTime.utc(2026, 5, 21);

  const testEntry = ApodEntry(
    date: '2026-05-21',
    title: 'Glowing Cosmic Pillars',
    explanation: 'A gorgeous view of stellar columns composed of gas.',
    url: 'https://example.com/standard.jpg',
    hdurl: 'https://example.com/hd.jpg',
    mediaType: 'image',
  );

  setUp(() {
    mockRepo = MockApodRepository();
    mockPrefs = MockSharedPreferences();

    registerFallbackValue(DateTime(2026, 5, 21));

    // SharedPreferences default stubs
    when(() => mockPrefs.getStringList(any())).thenReturn(null);
    when(
      () => mockPrefs.setStringList(any(), any()),
    ).thenAnswer((_) async => true);
    when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
  });

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
        apodRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('ApodNotifier Unit Tests', () {
    test('initial state is ApodLoading and fetches from repository', () async {
      when(
        () => mockRepo.getCachedApod(any()),
      ).thenAnswer((_) async => const Success<ApodEntry?>(null));
      when(
        () => mockRepo.getApodForDate(
          any(),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Success(testEntry));

      final container = createContainer();
      final states = <ApodState>[];

      container.listen(
        apodStateProvider(testDate),
        (previous, next) => states.add(next),
        fireImmediately: true,
      );

      // Give microtasks and futures time to execute
      await Future<void>.delayed(Duration.zero);

      expect(states.first, isA<ApodLoading>());
      expect(states.last, isA<ApodSuccess>());
      final successState = states.last as ApodSuccess;
      expect(successState.entry, testEntry);
      expect(successState.isRefreshing, isFalse);
    });

    test('cache-first lookup immediately yields ApodCached', () async {
      when(
        () => mockRepo.getCachedApod(any()),
      ).thenAnswer((_) async => const Success<ApodEntry?>(testEntry));
      // For past dates, caching returns early, so getApodForDate won't be called.
      // But we still stub it just in case.
      when(
        () => mockRepo.getApodForDate(
          any(),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => const Success(testEntry));

      final container = createContainer();
      final states = <ApodState>[];

      container.listen(
        apodStateProvider(testDate),
        (previous, next) => states.add(next),
        fireImmediately: true,
      );

      await Future<void>.delayed(Duration.zero);

      expect(states, contains(isA<ApodCached>()));
      final cachedState =
          states.firstWhere((s) => s is ApodCached) as ApodCached;
      expect(cachedState.entry, testEntry);
      expect(cachedState.isRefreshing, isFalse);
    });

    test(
      'network failure after cache hit falls back to ApodOfflineFallback',
      () async {
        final today = DateTime.now().toUtc();
        final todayNormalized = DateTime.utc(
          today.year,
          today.month,
          today.day,
        );

        when(
          () => mockRepo.getCachedApod(any()),
        ).thenAnswer((_) async => const Success<ApodEntry?>(testEntry));
        // Network call fails
        when(
          () => mockRepo.getApodForDate(
            any(),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer(
          (_) async => const Failure(ApodNoConnection('No connection')),
        );

        final container = createContainer();
        final states = <ApodState>[];

        container.listen(
          apodStateProvider(todayNormalized),
          (previous, next) => states.add(next),
          fireImmediately: true,
        );

        await Future<void>.delayed(Duration.zero);

        // Verify transitions
        expect(states, contains(isA<ApodCached>()));
        expect(states.last, isA<ApodOfflineFallback>());
        final fallbackState = states.last as ApodOfflineFallback;
        expect(fallbackState.entry, testEntry);
      },
    );

    test('network failure without cache transitions to ApodError', () async {
      when(
        () => mockRepo.getCachedApod(any()),
      ).thenAnswer((_) async => const Success<ApodEntry?>(null));
      when(
        () => mockRepo.getApodForDate(
          any(),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer(
        (_) async => const Failure(ApodRateLimited('Rate limit exceeded')),
      );

      final container = createContainer();
      final states = <ApodState>[];

      container.listen(
        apodStateProvider(testDate),
        (previous, next) => states.add(next),
        fireImmediately: true,
      );

      await Future<void>.delayed(Duration.zero);

      expect(states.last, isA<ApodError>());
      final errorState = states.last as ApodError;
      expect(errorState.errorMessage, 'Rate limit exceeded');
      expect(errorState.failure, isA<ApodRateLimited>());
    });

    test(
      'force refreshing updates the isRefreshing flag to true while fetching',
      () async {
        final completer = Completer<Result<ApodEntry>>();
        when(
          () => mockRepo.getCachedApod(any()),
        ).thenAnswer((_) async => const Success<ApodEntry?>(testEntry));
        when(
          () => mockRepo.getApodForDate(any(), forceRefresh: true),
        ).thenAnswer((_) => completer.future);

        final container = createContainer()..read(apodStateProvider(testDate));
        await Future<void>.delayed(Duration.zero);

        final states = <ApodState>[];
        container.listen(
          apodStateProvider(testDate),
          (previous, next) => states.add(next),
          fireImmediately: true,
        );

        // Trigger refresh
        final notifier = container.read(apodStateProvider(testDate).notifier);
        final refreshFuture = notifier.refresh();

        // Check state while refreshing
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(states, contains(isA<ApodCached>()));
        final refreshingState = states.last as ApodCached;
        expect(refreshingState.isRefreshing, isTrue);

        // Complete the network call
        completer.complete(const Success(testEntry));
        await refreshFuture;

        expect(states.last, isA<ApodSuccess>());
        expect((states.last as ApodSuccess).isRefreshing, isFalse);
      },
    );
  });
}
