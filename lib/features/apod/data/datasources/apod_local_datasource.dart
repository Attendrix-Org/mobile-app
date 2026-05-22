import 'dart:convert';
import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:attendrix_app/features/apod/data/dto/media_metadata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApodLocalDatasource {
  ApodLocalDatasource(
    this._sharedPreferences, {
    this.maxHistoricalEntries = 50,
  });

  final SharedPreferences _sharedPreferences;
  final int maxHistoricalEntries;

  static const _kApodResponse = 'apod_latest_response';
  static const _kApodCachedAt = 'apod_cached_at';
  static const _kApodMediaMetadata = 'apod_media_metadata';

  static const _kApodLruList = 'apod_cache_dates_lru';
  static const _kApodCacheEntryPrefix = 'apod_cache_entry_';
  static const _kApodCacheTimestampPrefix = 'apod_cache_timestamp_';

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  ApodDto? getCachedApod() {
    try {
      final jsonStr = _sharedPreferences.getString(_kApodResponse);
      if (jsonStr == null) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ApodDto.fromJson(map);
    } on Object catch (_) {
      return null;
    }
  }

  Future<void> cacheApod(ApodDto dto) async {
    final jsonStr = jsonEncode(dto.toJson());
    await _sharedPreferences.setString(_kApodResponse, jsonStr);
    await _sharedPreferences.setString(
      _kApodCachedAt,
      DateTime.now().toUtc().toIso8601String(),
    );
  }

  DateTime? getCachedTimestamp() {
    try {
      final isoStr = _sharedPreferences.getString(_kApodCachedAt);
      if (isoStr == null) return null;
      return DateTime.parse(isoStr);
    } on Object catch (_) {
      return null;
    }
  }

  bool isCacheStale() {
    final cached = getCachedApod();
    if (cached == null) return true;

    final today = DateTime.now().toUtc();
    final todayStr =
        '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    return cached.date != todayStr;
  }

  MediaMetadata? getCachedMediaMetadata() {
    try {
      final jsonStr = _sharedPreferences.getString(_kApodMediaMetadata);
      if (jsonStr == null) return null;
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return MediaMetadata.fromJson(map);
    } on Object catch (_) {
      return null;
    }
  }

  Future<void> cacheMediaMetadata(MediaMetadata metadata) async {
    final jsonStr = jsonEncode(metadata.toJson());
    await _sharedPreferences.setString(_kApodMediaMetadata, jsonStr);
  }

  Future<ApodDto?> getCachedApodForDate(DateTime date) async {
    try {
      final dateStr = _formatDate(date);
      final jsonStr = _sharedPreferences.getString(
        _kApodCacheEntryPrefix + dateStr,
      );
      if (jsonStr == null) return null;

      // Update LRU access order
      await _updateLru(dateStr);

      // Update access timestamp
      await _sharedPreferences.setString(
        _kApodCacheTimestampPrefix + dateStr,
        DateTime.now().toUtc().toIso8601String(),
      );

      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ApodDto.fromJson(map);
    } on Object catch (_) {
      return null;
    }
  }

  Future<void> cacheApodForDate(DateTime date, ApodDto dto) async {
    final dateStr = _formatDate(date);
    final jsonStr = jsonEncode(dto.toJson());
    await _sharedPreferences.setString(
      _kApodCacheEntryPrefix + dateStr,
      jsonStr,
    );
    await _sharedPreferences.setString(
      _kApodCacheTimestampPrefix + dateStr,
      DateTime.now().toUtc().toIso8601String(),
    );
    await _updateLru(dateStr);
    await removeExpiredHistoricalCache();
  }

  Future<void> _updateLru(String dateStr) async {
    final list = (_sharedPreferences.getStringList(_kApodLruList) ?? <String>[])
      ..remove(dateStr)
      ..add(dateStr);
    await _sharedPreferences.setStringList(_kApodLruList, list);
  }

  Future<void> removeExpiredHistoricalCache() async {
    final list = _sharedPreferences.getStringList(_kApodLruList) ?? <String>[];
    if (list.length > maxHistoricalEntries) {
      final excessCount = list.length - maxHistoricalEntries;
      final toEvict = list.sublist(0, excessCount);
      final remaining = list.sublist(excessCount);

      for (final dateStr in toEvict) {
        await _sharedPreferences.remove(_kApodCacheEntryPrefix + dateStr);
        await _sharedPreferences.remove(_kApodCacheTimestampPrefix + dateStr);
      }
      await _sharedPreferences.setStringList(_kApodLruList, remaining);
    }
  }

  List<String> getCachedDates() {
    return _sharedPreferences.getStringList(_kApodLruList) ?? <String>[];
  }

  Future<void> clearCache() async {
    final list = getCachedDates();
    for (final dateStr in list) {
      await _sharedPreferences.remove(_kApodCacheEntryPrefix + dateStr);
      await _sharedPreferences.remove(_kApodCacheTimestampPrefix + dateStr);
    }
    await _sharedPreferences.remove(_kApodLruList);
    await _sharedPreferences.remove(_kApodResponse);
    await _sharedPreferences.remove(_kApodCachedAt);
    await _sharedPreferences.remove(_kApodMediaMetadata);
  }
}
