import 'dart:convert';
import 'package:attendrix_app/features/apod/data/datasources/apod_local_datasource.dart';
import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late ApodLocalDatasource datasource;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    // Use a small maxHistoricalEntries limit (e.g. 3) to test eviction easily
    datasource = ApodLocalDatasource(mockPrefs, maxHistoricalEntries: 3);
  });

  group('ApodLocalDatasource LRU Eviction & Date Caching Tests', () {
    const dto1 = ApodDto(
      date: '2026-05-19',
      title: 'Entry 1',
      explanation:
          'These pillars of gas and dust are being sculpted from within.',
      mediaType: 'image',
      url:
          'https://apod.nasa.gov/apod/image/2410/PillarsOfCreation_Webb_960.jpg',
    );
    const dto2 = ApodDto(
      date: '2026-05-20',
      title: 'Entry 2',
      explanation:
          'These pillars of gas and dust are being sculpted from within.',
      mediaType: 'image',
      url:
          'https://apod.nasa.gov/apod/image/2410/PillarsOfCreation_Webb_960.jpg',
    );
    const dto3 = ApodDto(
      date: '2026-05-21',
      title: 'Entry 3',
      explanation:
          'These pillars of gas and dust are being sculpted from within.',
      mediaType: 'image',
      url:
          'https://apod.nasa.gov/apod/image/2410/PillarsOfCreation_Webb_960.jpg',
    );
    const dto4 = ApodDto(
      date: '2026-05-22',
      title: 'Entry 4',
      explanation:
          'These pillars of gas and dust are being sculpted from within.',
      mediaType: 'image',
      url:
          'https://apod.nasa.gov/apod/image/2410/PillarsOfCreation_Webb_960.jpg',
    );

    test(
      'getCachedApodForDate should return DTO and update LRU order/timestamps',
      () async {
        final date = DateTime(2026, 5, 20);
        const dateStr = '2026-05-20';

        when(
          () => mockPrefs.getString('apod_cache_entry_$dateStr'),
        ).thenReturn(jsonEncode(dto2.toJson()));
        when(
          () => mockPrefs.getStringList('apod_cache_dates_lru'),
        ).thenReturn(['2026-05-19', '2026-05-20']);
        when(
          () => mockPrefs.setStringList(any(), any()),
        ).thenAnswer((_) async => true);
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);

        final result = await datasource.getCachedApodForDate(date);

        expect(result, equals(dto2));
        // Verify LRU date list updated to put 2026-05-20 at the end (most recent)
        verify(
          () => mockPrefs.setStringList('apod_cache_dates_lru', [
            '2026-05-19',
            '2026-05-20',
          ]),
        ).called(1);
        verify(
          () => mockPrefs.setString(
            any(that: startsWith('apod_cache_timestamp_')),
            any(),
          ),
        ).called(1);
      },
    );

    test(
      'cacheApodForDate should add entry, update LRU list, and evict oldest if limit exceeded',
      () async {
        // 1. Mock first 3 cache entries added successfully
        var lruList = <String>[];

        when(
          () => mockPrefs.getStringList('apod_cache_dates_lru'),
        ).thenAnswer((_) => lruList);
        when(
          () => mockPrefs.setStringList('apod_cache_dates_lru', any()),
        ).thenAnswer((invocation) async {
          lruList = invocation.positionalArguments[1] as List<String>;
          return true;
        });
        when(
          () => mockPrefs.setString(any(), any()),
        ).thenAnswer((_) async => true);
        when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

        // Cache date 1
        await datasource.cacheApodForDate(DateTime(2026, 5, 19), dto1);
        expect(lruList, equals(['2026-05-19']));

        // Cache date 2
        await datasource.cacheApodForDate(DateTime(2026, 5, 20), dto2);
        expect(lruList, equals(['2026-05-19', '2026-05-20']));

        // Cache date 3
        await datasource.cacheApodForDate(DateTime(2026, 5, 21), dto3);
        expect(lruList, equals(['2026-05-19', '2026-05-20', '2026-05-21']));

        // Cache date 4 - should trigger eviction of 2026-05-19 because limit is 3
        await datasource.cacheApodForDate(DateTime(2026, 5, 22), dto4);
        expect(lruList, equals(['2026-05-20', '2026-05-21', '2026-05-22']));

        // Verify oldest entry was removed from SharedPreferences
        verify(() => mockPrefs.remove('apod_cache_entry_2026-05-19')).called(1);
        verify(
          () => mockPrefs.remove('apod_cache_timestamp_2026-05-19'),
        ).called(1);

        // Ensure other entries were NOT removed
        verifyNever(() => mockPrefs.remove('apod_cache_entry_2026-05-20'));
        verifyNever(() => mockPrefs.remove('apod_cache_entry_2026-05-21'));
        verifyNever(() => mockPrefs.remove('apod_cache_entry_2026-05-22'));
      },
    );

    test('getCachedDates should return list from SharedPreferences', () {
      when(
        () => mockPrefs.getStringList('apod_cache_dates_lru'),
      ).thenReturn(['2026-05-20', '2026-05-21']);

      final dates = datasource.getCachedDates();

      expect(dates, equals(['2026-05-20', '2026-05-21']));
    });

    test(
      'clearCache should remove all cache entries and helper keys',
      () async {
        when(
          () => mockPrefs.getStringList('apod_cache_dates_lru'),
        ).thenReturn(['2026-05-20', '2026-05-21']);
        when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

        await datasource.clearCache();

        verify(() => mockPrefs.remove('apod_cache_entry_2026-05-20')).called(1);
        verify(
          () => mockPrefs.remove('apod_cache_timestamp_2026-05-20'),
        ).called(1);
        verify(() => mockPrefs.remove('apod_cache_entry_2026-05-21')).called(1);
        verify(
          () => mockPrefs.remove('apod_cache_timestamp_2026-05-21'),
        ).called(1);
        verify(() => mockPrefs.remove('apod_cache_dates_lru')).called(1);
        verify(() => mockPrefs.remove('apod_latest_response')).called(1);
        verify(() => mockPrefs.remove('apod_cached_at')).called(1);
        verify(() => mockPrefs.remove('apod_media_metadata')).called(1);
      },
    );
  });
}
