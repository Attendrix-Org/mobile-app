import 'dart:convert';
import 'package:attendrix_app/features/apod/data/datasources/apod_local_datasource.dart';
import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:attendrix_app/features/apod/data/dto/media_metadata.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../fixtures/apod_fixtures.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late ApodLocalDatasource datasource;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    datasource = ApodLocalDatasource(mockPrefs);
  });

  group('ApodLocalDatasource Tests', () {
    final imageDto = ApodDto.fromJson(ApodFixtures.imageResponse);

    test('getCachedApod should return null when cache is empty', () {
      when(() => mockPrefs.getString(any())).thenReturn(null);

      final cached = datasource.getCachedApod();

      expect(cached, isNull);
      verify(() => mockPrefs.getString('apod_latest_response')).called(1);
    });

    test('getCachedApod should return ApodDto when cache contains valid data', () {
      when(() => mockPrefs.getString('apod_latest_response'))
          .thenReturn(jsonEncode(ApodFixtures.imageResponse));

      final cached = datasource.getCachedApod();

      expect(cached, equals(imageDto));
    });

    test('getCachedApod should return null when cache data is corrupted', () {
      when(() => mockPrefs.getString('apod_latest_response'))
          .thenReturn('corrupted { json');

      final cached = datasource.getCachedApod();

      expect(cached, isNull);
    });

    test('cacheApod should save DTO and timestamp', () async {
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) => Future.value(true));

      await datasource.cacheApod(imageDto);

      verify(() => mockPrefs.setString('apod_latest_response', any())).called(1);
      verify(() => mockPrefs.setString('apod_cached_at', any())).called(1);
    });

    test('getCachedTimestamp should return parsed DateTime or null', () {
      final nowStr = DateTime.now().toUtc().toIso8601String();
      when(() => mockPrefs.getString('apod_cached_at')).thenReturn(nowStr);

      final timestamp = datasource.getCachedTimestamp();
      expect(timestamp, isNotNull);
      expect(timestamp!.toIso8601String(), equals(nowStr));

      when(() => mockPrefs.getString('apod_cached_at')).thenReturn(null);
      expect(datasource.getCachedTimestamp(), isNull);

      when(() => mockPrefs.getString('apod_cached_at')).thenReturn('bad date');
      expect(datasource.getCachedTimestamp(), isNull);
    });

    test('isCacheStale should return true when cache is empty', () {
      when(() => mockPrefs.getString('apod_latest_response')).thenReturn(null);

      expect(datasource.isCacheStale(), isTrue);
    });

    test('isCacheStale should return false when cache is for today (UTC)', () {
      final today = DateTime.now().toUtc();
      final todayStr = '${today.year}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';
      
      final todayResponse = Map<String, dynamic>.from(ApodFixtures.imageResponse)
        ..['date'] = todayStr;

      when(() => mockPrefs.getString('apod_latest_response'))
          .thenReturn(jsonEncode(todayResponse));

      expect(datasource.isCacheStale(), isFalse);
    });

    test('isCacheStale should return true when cache is for a different day', () {
      final yesterday = DateTime.now().toUtc().subtract(const Duration(days: 1));
      final yesterdayStr = '${yesterday.year}-'
          '${yesterday.month.toString().padLeft(2, '0')}-'
          '${yesterday.day.toString().padLeft(2, '0')}';

      final yesterdayResponse = Map<String, dynamic>.from(ApodFixtures.imageResponse)
        ..['date'] = yesterdayStr;

      when(() => mockPrefs.getString('apod_latest_response'))
          .thenReturn(jsonEncode(yesterdayResponse));

      expect(datasource.isCacheStale(), isTrue);
    });

    test('clearCache should remove all keys', () async {
      when(() => mockPrefs.remove(any())).thenAnswer((_) => Future.value(true));

      await datasource.clearCache();

      verify(() => mockPrefs.remove('apod_latest_response')).called(1);
      verify(() => mockPrefs.remove('apod_cached_at')).called(1);
      verify(() => mockPrefs.remove('apod_media_metadata')).called(1);
    });

    test('cacheMediaMetadata and getCachedMediaMetadata tests', () async {
      const meta = MediaMetadata(
        mediaType: 'video',
        videoProvider: 'youtube',
        videoId: 'P3GkZe3nRQ0',
        thumbnailUrl: 'https://img.youtube.com/vi/P3GkZe3nRQ0/0.jpg',
      );

      when(() => mockPrefs.setString('apod_media_metadata', any()))
          .thenAnswer((_) => Future.value(true));

      await datasource.cacheMediaMetadata(meta);
      verify(() => mockPrefs.setString('apod_media_metadata', any())).called(1);

      when(() => mockPrefs.getString('apod_media_metadata'))
          .thenReturn(jsonEncode(meta.toJson()));
      final cachedMeta = datasource.getCachedMediaMetadata();
      expect(cachedMeta, equals(meta));

      when(() => mockPrefs.getString('apod_media_metadata')).thenReturn(null);
      expect(datasource.getCachedMediaMetadata(), isNull);
    });
  });
}
