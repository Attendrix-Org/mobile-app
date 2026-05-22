// ignore_for_file: avoid_redundant_argument_values // Mocktail stubs/matchers require explicit nulls to distinguish mock setups

import 'package:attendrix_app/features/apod/data/datasources/apod_local_datasource.dart';
import 'package:attendrix_app/features/apod/data/datasources/apod_remote_datasource.dart';
import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:attendrix_app/features/apod/data/dto/media_metadata.dart';
import 'package:attendrix_app/features/apod/data/repositories/apod_repository_impl.dart';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../fixtures/apod_fixtures.dart';

class MockApodRemoteDatasource extends Mock implements ApodRemoteDatasource {}
class MockApodLocalDatasource extends Mock implements ApodLocalDatasource {}
class FakeMediaMetadata extends Fake implements MediaMetadata {}
class FakeApodDto extends Fake implements ApodDto {}

void main() {
  late MockApodRemoteDatasource mockRemote;
  late MockApodLocalDatasource mockLocal;
  late ApodRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeMediaMetadata());
    registerFallbackValue(FakeApodDto());
  });

  setUp(() {
    mockRemote = MockApodRemoteDatasource();
    mockLocal = MockApodLocalDatasource();
    repository = ApodRepositoryImpl(
      remoteDatasource: mockRemote,
      localDatasource: mockLocal,
    );
  });

  group('ApodRepositoryImpl Tests', () {
    final imageDto = ApodDto.fromJson(ApodFixtures.imageResponse);
    final videoDto = ApodDto.fromJson(ApodFixtures.videoResponse);

    test('getApod should return cached entry when cache is not stale and forceRefresh is false', () async {
      when(() => mockLocal.getCachedApod()).thenReturn(imageDto);
      when(() => mockLocal.isCacheStale()).thenReturn(false);

      final result = await repository.getApod();

      expect(result, isA<Success<ApodEntry>>());
      expect((result as Success<ApodEntry>).data.date, imageDto.date);
      verifyNever(() => mockRemote.fetchApod(date: any(named: 'date')));
      verifyNever(() => mockRemote.fetchApod(date: null));
    });

    test('getApod should fetch from remote when cache is stale', () async {
      when(() => mockLocal.getCachedApod()).thenReturn(imageDto);
      when(() => mockLocal.isCacheStale()).thenReturn(true);
      when(() => mockRemote.fetchApod(date: any(named: 'date'))).thenAnswer((_) async => imageDto);
      when(() => mockRemote.fetchApod(date: null)).thenAnswer((_) async => imageDto);
      when(() => mockLocal.cacheApod(any())).thenAnswer((_) async => {});
      when(() => mockLocal.cacheMediaMetadata(any())).thenAnswer((_) async => {});

      final result = await repository.getApod();

      expect(result, isA<Success<ApodEntry>>());
      expect((result as Success<ApodEntry>).data.date, imageDto.date);
      verify(() => mockRemote.fetchApod(date: null)).called(1);
      verify(() => mockLocal.cacheApod(imageDto)).called(1);
    });

    test('getApod should parse and cache video metadata when remote returns video DTO', () async {
      when(() => mockLocal.getCachedApod()).thenReturn(null);
      when(() => mockLocal.isCacheStale()).thenReturn(true);
      when(() => mockRemote.fetchApod(date: any(named: 'date'))).thenAnswer((_) async => videoDto);
      when(() => mockRemote.fetchApod(date: null)).thenAnswer((_) async => videoDto);
      when(() => mockLocal.cacheApod(any())).thenAnswer((_) async => {});
      when(() => mockLocal.cacheMediaMetadata(any())).thenAnswer((_) async => {});

      final result = await repository.getApod();

      expect(result, isA<Success<ApodEntry>>());
      verify(() => mockLocal.cacheMediaMetadata(
        any(that: predicate((meta) => meta is MediaMetadata && meta.mediaType == 'video' && meta.videoProvider == 'youtube')),
      )).called(1);
    });

    test('getApod should fetch from remote when forceRefresh is true', () async {
      when(() => mockLocal.getCachedApod()).thenReturn(imageDto);
      when(() => mockLocal.isCacheStale()).thenReturn(false);
      when(() => mockRemote.fetchApod(date: any(named: 'date'))).thenAnswer((_) async => imageDto);
      when(() => mockRemote.fetchApod(date: null)).thenAnswer((_) async => imageDto);
      when(() => mockLocal.cacheApod(any())).thenAnswer((_) async => {});
      when(() => mockLocal.cacheMediaMetadata(any())).thenAnswer((_) async => {});

      final result = await repository.getApod(forceRefresh: true);

      expect(result, isA<Success<ApodEntry>>());
      verify(() => mockRemote.fetchApod(date: null)).called(1);
    });

    test('getApod should fallback to cached entry on remote failure', () async {
      when(() => mockLocal.getCachedApod()).thenReturn(imageDto);
      when(() => mockLocal.isCacheStale()).thenReturn(true);
      when(() => mockRemote.fetchApod(date: any(named: 'date'))).thenThrow(const ApodTimeout());
      when(() => mockRemote.fetchApod(date: null)).thenThrow(const ApodTimeout());

      final result = await repository.getApod();

      expect(result, isA<Success<ApodEntry>>());
      expect((result as Success<ApodEntry>).data.date, imageDto.date);
    });

    test('getApod should return Failure on remote failure when cache is empty', () async {
      when(() => mockLocal.getCachedApod()).thenReturn(null);
      when(() => mockLocal.isCacheStale()).thenReturn(true);
      when(() => mockRemote.fetchApod(date: any(named: 'date'))).thenThrow(const ApodTimeout());
      when(() => mockRemote.fetchApod(date: null)).thenThrow(const ApodTimeout());

      final result = await repository.getApod();

      expect(result, isA<Failure<ApodEntry>>());
      expect((result as Failure<ApodEntry>).failure, isA<ApodTimeout>());
    });

    test('getApodRange should fetch from remote and map entries', () async {
      when(() => mockRemote.fetchApodRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      )).thenAnswer((_) async => [imageDto, videoDto]);
      when(() => mockRemote.fetchApodRange(
        startDate: any(named: 'startDate'),
        endDate: null,
      )).thenAnswer((_) async => [imageDto, videoDto]);

      final result = await repository.getApodRange(startDate: '2024-10-20');

      expect(result, isA<Success<List<ApodEntry>>>());
      final list = (result as Success<List<ApodEntry>>).data;
      expect(list, hasLength(2));
      expect(list[0].mediaType, 'image');
      expect(list[1].mediaType, 'video');
    });

    test('getApodRange should return Failure on remote error', () async {
      when(() => mockRemote.fetchApodRange(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      )).thenThrow(const ApodRateLimited());
      when(() => mockRemote.fetchApodRange(
        startDate: any(named: 'startDate'),
        endDate: null,
      )).thenThrow(const ApodRateLimited());

      final result = await repository.getApodRange(startDate: '2024-10-20');

      expect(result, isA<Failure<List<ApodEntry>>>());
      expect((result as Failure<List<ApodEntry>>).failure, isA<ApodRateLimited>());
    });

    test('hasCachedApod and clearCache should delegate to local datasource', () async {
      when(() => mockLocal.getCachedApod()).thenReturn(imageDto);
      final hasCached = await repository.hasCachedApod();
      expect(hasCached, isTrue);

      when(() => mockLocal.clearCache()).thenAnswer((_) async => {});
      await repository.clearCache();
      verify(() => mockLocal.clearCache()).called(1);
    });
  });
}
