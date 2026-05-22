import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';

abstract class ApodRepository {
  Future<Result<ApodEntry>> getApod({String? date, bool forceRefresh = false});

  Future<Result<List<ApodEntry>>> getApodRange({
    required String startDate,
    String? endDate,
  });

  Future<bool> hasCachedApod();

  Future<void> clearCache();

  Future<Result<ApodEntry>> getApodForDate(
    DateTime date, {
    bool forceRefresh = false,
  });

  Future<Result<ApodEntry?>> getCachedApod(DateTime date);

  Future<void> cacheApodForDate(DateTime date, ApodEntry entry);

  Future<void> removeExpiredHistoricalCache();
}
