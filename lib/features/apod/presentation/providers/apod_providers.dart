import 'dart:async';
import 'package:attendrix_app/features/apod/data/datasources/apod_local_datasource.dart';
import 'package:attendrix_app/features/apod/data/datasources/apod_remote_datasource.dart';
import 'package:attendrix_app/features/apod/data/repositories/apod_repository_impl.dart';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/failures/apod_failure.dart';
import 'package:attendrix_app/features/apod/domain/repositories/apod_repository.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for SharedPreferences. Must be overridden in the root ProviderScope.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

/// Provider for Dio HTTP client.
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

/// Provider for remote data source.
final apodRemoteDatasourceProvider = Provider<ApodRemoteDatasource>((ref) {
  final dio = ref.watch(dioProvider);
  final apiKey = dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';
  return ApodRemoteDatasource(dio, apiKey: apiKey);
});

/// Provider for local data source.
final apodLocalDatasourceProvider = Provider<ApodLocalDatasource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ApodLocalDatasource(prefs);
});

/// Provider for APOD repository.
final apodRepositoryProvider = Provider<ApodRepository>((ref) {
  final remote = ref.watch(apodRemoteDatasourceProvider);
  final local = ref.watch(apodLocalDatasourceProvider);
  return ApodRepositoryImpl(remoteDatasource: remote, localDatasource: local);
});

/// Notifier for persistent recent search queries.
class RecentSearchesNotifier extends Notifier<List<String>> {
  static const _key = 'apod_recent_searches';

  @override
  List<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getStringList(_key) ?? const <String>[];
  }

  Future<void> addSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final list = List<String>.from(state)
      ..remove(trimmed)
      ..insert(0, trimmed);

    if (list.length > 10) {
      list.removeLast();
    }

    state = list;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setStringList(_key, list);
  }

  Future<void> clearSearches() async {
    state = const <String>[];
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_key);
  }
}

final recentSearchesProvider = NotifierProvider<RecentSearchesNotifier, List<String>>(RecentSearchesNotifier.new);

/// Notifier for tracking viewed dates.
class ViewedDatesNotifier extends Notifier<List<String>> {
  static const _key = 'apod_viewed_dates';

  @override
  List<String> build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getStringList(_key) ?? const <String>[];
  }

  Future<void> addViewedDate(String dateStr) async {
    final list = List<String>.from(state);
    if (!list.contains(dateStr)) {
      list.add(dateStr);
      state = list;
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setStringList(_key, list);
    }
  }

  Future<void> clearViewedDates() async {
    state = const <String>[];
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_key);
  }
}

final viewedDatesProvider = NotifierProvider<ViewedDatesNotifier, List<String>>(ViewedDatesNotifier.new);

class HistoryViewModeNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  @override
  set state(bool value) => super.state = value;
}

/// Tracks if user is viewing in Grid (true) or List (false) mode.
final historyViewModeProvider = NotifierProvider<HistoryViewModeNotifier, bool>(HistoryViewModeNotifier.new);

class CalendarSelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  @override
  set state(DateTime value) => super.state = value;
}

/// Tracks the selected date in the Calendar Explorer.
final calendarSelectedDateProvider = NotifierProvider<CalendarSelectedDateNotifier, DateTime>(CalendarSelectedDateNotifier.new);

/// Simple class to represent a Month and a Year.
@immutable
class MonthYear {
  const MonthYear(this.month, this.year);
  final int month;
  final int year;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthYear && other.month == month && other.year == year;

  @override
  int get hashCode => Object.hash(month, year);
}

class CalendarMonthYearNotifier extends Notifier<MonthYear> {
  @override
  MonthYear build() {
    final now = DateTime.now();
    return MonthYear(now.month, now.year);
  }

  @override
  set state(MonthYear value) => super.state = value;
}

/// Tracks the month and year currently displayed in the calendar explorer.
final calendarMonthYearProvider = NotifierProvider<CalendarMonthYearNotifier, MonthYear>(CalendarMonthYearNotifier.new);

/// Exposes the list of cached dates currently available in local storage.
final cachedDatesProvider = Provider<List<String>>((ref) {
  // Watch local datasource changes by reloading when caching happens
  final local = ref.watch(apodLocalDatasourceProvider);
  return local.getCachedDates();
});

/// Loads all ApodEntry objects corresponding to the viewed dates.
final historyEntriesProvider = FutureProvider<List<ApodEntry>>((ref) async {
  final dates = ref.watch(viewedDatesProvider);
  final repository = ref.watch(apodRepositoryProvider);
  final list = <ApodEntry>[];
  
  for (final dateStr in dates) {
    final parsedDate = DateTime.tryParse(dateStr);
    if (parsedDate != null) {
      final result = await repository.getApodForDate(parsedDate);
      if (result is Success<ApodEntry>) {
        list.add(result.data);
      }
    }
  }
  
  // Sort by date descending (most recent first)
  list.sort((a, b) => b.date.compareTo(a.date));
  return list;
});

sealed class ApodState {
  const ApodState();
}

class ApodLoading extends ApodState {
  const ApodLoading();
}

class ApodSuccess extends ApodState {
  const ApodSuccess(this.entry, {this.isRefreshing = false});

  final ApodEntry entry;
  final bool isRefreshing;
}

class ApodCached extends ApodState {
  const ApodCached(this.entry, {this.isRefreshing = false});

  final ApodEntry entry;
  final bool isRefreshing;
}

class ApodOfflineFallback extends ApodState {
  const ApodOfflineFallback(this.entry, {this.isRefreshing = false});

  final ApodEntry entry;
  final bool isRefreshing;
}

class ApodError extends ApodState {
  const ApodError(this.errorMessage, this.failure);

  final String errorMessage;
  final ApodFailure failure;
}

class ApodNotifier extends Notifier<ApodState> {
  ApodNotifier(this._date);

  final DateTime _date;
  bool _isDisposed = false;

  @override
  ApodState build() {
    ref.onDispose(() => _isDisposed = true);
    // Normalize date to midnight UTC to ensure consistency of family keys
    final normalizedDate = DateTime.utc(_date.year, _date.month, _date.day);
    unawaited(Future.microtask(() => fetch(normalizedDate)));
    return const ApodLoading();
  }

  Future<void> fetch(DateTime normalizedDate, {bool forceRefresh = false}) async {
    final repo = ref.read(apodRepositoryProvider);

    // 1. Cache-first lookup
    final cachedResult = await repo.getCachedApod(normalizedDate);
    ApodEntry? cachedEntry;
    if (cachedResult is Success<ApodEntry?>) {
      cachedEntry = cachedResult.data;
    }

    // Emit Cached state immediately if cachedEntry exists and we aren't forcing a refresh
    if (cachedEntry != null && !forceRefresh) {
      state = ApodCached(cachedEntry);
      
      // Check if cache is stale or if we need to refresh.
      final today = DateTime.now().toUtc();
      final isToday = normalizedDate.year == today.year &&
          normalizedDate.month == today.month &&
          normalizedDate.day == today.day;
      
      if (!isToday) {
        // For past dates, the APOD is static. No need to execute a network request.
        return;
      }
    }

    // Update state to show refreshing if we already have data
    final previousState = state;
    if (previousState is ApodSuccess) {
      state = ApodSuccess(previousState.entry, isRefreshing: true);
    } else if (previousState is ApodCached) {
      state = ApodCached(previousState.entry, isRefreshing: true);
    } else if (previousState is ApodOfflineFallback) {
      state = ApodOfflineFallback(previousState.entry, isRefreshing: true);
    } else if (state is! ApodCached) {
      state = const ApodLoading();
    }

    final result = await repo.getApodForDate(normalizedDate, forceRefresh: forceRefresh);

    // Check if notifier has been disposed before updating state
    if (_isDisposed) return;

    switch (result) {
      case Success(:final data):
        state = ApodSuccess(data);
        unawaited(ref.read(viewedDatesProvider.notifier).addViewedDate(data.date));
        // Refresh the cached dates list
        ref.invalidate(cachedDatesProvider);
      case Failure(:final failure):
        if (cachedEntry != null) {
          state = ApodOfflineFallback(cachedEntry);
        } else {
          state = ApodError(failure.message, failure);
        }
    }
  }

  Future<void> refresh() async {
    final normalizedDate = DateTime.utc(_date.year, _date.month, _date.day);
    await fetch(normalizedDate, forceRefresh: true);
  }
}

// ignore: specify_nonobvious_property_types, NotifierProviderFamily is not publicly exported by Riverpod
final apodStateProvider =
    NotifierProvider.family<ApodNotifier, ApodState, DateTime>(
  ApodNotifier.new,
);
