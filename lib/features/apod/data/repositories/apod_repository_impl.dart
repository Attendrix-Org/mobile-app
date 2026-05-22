import 'dart:async';
import 'package:attendrix_app/features/apod/data/datasources/apod_local_datasource.dart';
import 'package:attendrix_app/features/apod/data/datasources/apod_remote_datasource.dart';
import 'package:attendrix_app/features/apod/data/dto/media_metadata.dart';
import 'package:attendrix_app/features/apod/data/mappers/apod_mapper.dart';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/utils/media_parser.dart';

class ApodRepositoryImpl implements ApodRepository {
  ApodRepositoryImpl({
    required ApodRemoteDatasource remoteDatasource,
    required ApodLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  final ApodRemoteDatasource _remoteDatasource;
  final ApodLocalDatasource _localDatasource;

  @override
  Future<Result<ApodEntry>> getApod({
    String? date,
    bool forceRefresh = false,
  }) async {
    final cached = _localDatasource.getCachedApod();
    final cacheIsValid = cached != null && !_localDatasource.isCacheStale();
    final dateMatches = date == null || (cached != null && cached.date == date);

    if (!forceRefresh && cacheIsValid && dateMatches) {
      return Success(ApodMapper.fromDto(cached));
    }

    try {
      final dto = await _remoteDatasource.fetchApod(date: date);

      // Cache if we are fetching today's (or if date matches today's or is null)
      final today = DateTime.now().toUtc();
      final todayStr = '${today.year}-'
          '${today.month.toString().padLeft(2, '0')}-'
          '${today.day.toString().padLeft(2, '0')}';

      if (date == null || date == todayStr) {
        await _localDatasource.cacheApod(dto);

        if (dto.mediaType == 'video') {
          final parsed = MediaParser.parseVideoUrl(dto.url);
          await _localDatasource.cacheMediaMetadata(
            MediaMetadata(
              mediaType: dto.mediaType,
              videoProvider: parsed?.provider.name,
              videoId: parsed?.videoId,
              thumbnailUrl: parsed?.thumbnailUrl,
            ),
          );
        } else {
          await _localDatasource.cacheMediaMetadata(
            MediaMetadata(mediaType: dto.mediaType),
          );
        }
      }

      return Success(ApodMapper.fromDto(dto));
    } on ApodFailure catch (f) {
      // Offline fallback: try to serve cached entry if date matches or is null
      if (cached != null && (date == null || cached.date == date)) {
        return Success(ApodMapper.fromDto(cached));
      }
      return Failure(f);
    } on Object catch (e) {
      if (cached != null && (date == null || cached.date == date)) {
        return Success(ApodMapper.fromDto(cached));
      }
      return Failure(ApodUnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ApodEntry>>> getApodRange({
    required String startDate,
    String? endDate,
  }) async {
    try {
      final list = await _remoteDatasource.fetchApodRange(
        startDate: startDate,
        endDate: endDate,
      );
      final entries = list.map(ApodMapper.fromDto).toList();
      return Success(entries);
    } on ApodFailure catch (f) {
      return Failure(f);
    } on Object catch (e) {
      return Failure(ApodUnknownFailure(e.toString()));
    }
  }

  @override
  Future<bool> hasCachedApod() async {
    return _localDatasource.getCachedApod() != null;
  }

  @override
  Future<void> clearCache() async {
    await _sharedClearCache();
  }

  Future<void> _sharedClearCache() async {
    await _localDatasource.clearCache();
  }

  @override
  Future<Result<ApodEntry>> getApodForDate(
    DateTime date, {
    bool forceRefresh = false,
  }) async {
    final cached = await _localDatasource.getCachedApodForDate(date);

    if (!forceRefresh && cached != null) {
      return Success(ApodMapper.fromDto(cached));
    }

    final dateStr = '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    try {
      final dto = await _remoteDatasource.fetchApod(date: dateStr);
      await _localDatasource.cacheApodForDate(date, dto);
      return Success(ApodMapper.fromDto(dto));
    } on ApodFailure catch (f) {
      if (cached != null) {
        return Success(ApodMapper.fromDto(cached));
      }
      return Failure(f);
    } on Object catch (e) {
      if (cached != null) {
        return Success(ApodMapper.fromDto(cached));
      }
      return Failure(ApodUnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<ApodEntry?>> getCachedApod(DateTime date) async {
    try {
      final cached = await _localDatasource.getCachedApodForDate(date);
      if (cached == null) {
        return const Success(null);
      }
      return Success(ApodMapper.fromDto(cached));
    } on Object catch (e) {
      return Failure(ApodUnknownFailure(e.toString()));
    }
  }

  @override
  Future<void> cacheApodForDate(DateTime date, ApodEntry entry) async {
    final dto = ApodMapper.toDto(entry);
    await _localDatasource.cacheApodForDate(date, dto);
  }

  @override
  Future<void> removeExpiredHistoricalCache() async {
    await _localDatasource.removeExpiredHistoricalCache();
  }
}
