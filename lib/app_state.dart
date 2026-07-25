import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/schema/structs/index.dart';
import 'backend/supabase/supabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_userProfile') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_userProfile') ?? '{}';
          _userProfile =
              UserProfileStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_userPreferences') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_userPreferences') ?? '{}';
          _userPreferences = UserPreferencesStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_cacheMetaData') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_cacheMetaData') ?? '{}';
          _cacheMetaData = CacheMetadataStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _dashboardClasses =
          (await secureStorage.getStringList('ff_dashboardClasses'))
                  ?.map((x) {
                    try {
                      return ScheduledClassStruct.fromSerializableMap(
                          jsonDecode(x));
                    } catch (e) {
                      print("Can't decode persisted data type. Error: $e.");
                      return null;
                    }
                  })
                  .withoutNulls
                  .toList() ??
              _dashboardClasses;
    });
    await _safeInitAsync(() async {
      _missedClasses = (await secureStorage.getStringList('ff_missedClasses'))
              ?.map((x) {
                try {
                  return ScheduledClassStruct.fromSerializableMap(
                      jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _missedClasses;
    });
    await _safeInitAsync(() async {
      _calendarClasses =
          (await secureStorage.getStringList('ff_calendarClasses'))
                  ?.map((x) {
                    try {
                      return ScheduledClassStruct.fromSerializableMap(
                          jsonDecode(x));
                    } catch (e) {
                      print("Can't decode persisted data type. Error: $e.");
                      return null;
                    }
                  })
                  .withoutNulls
                  .toList() ??
              _calendarClasses;
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_apodData') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_apodData') ?? '{}';
          _apodData =
              ApodStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _BusRoutes = (await secureStorage.getStringList('ff_BusRoutes'))
              ?.map((x) {
                try {
                  return BusRouteStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _BusRoutes;
    });
    await _safeInitAsync(() async {
      _Messes = (await secureStorage.getStringList('ff_Messes'))
              ?.map((x) {
                try {
                  return MessStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _Messes;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  UserProfileStruct _userProfile = UserProfileStruct();
  UserProfileStruct get userProfile => _userProfile;
  set userProfile(UserProfileStruct value) {
    _userProfile = value;
    secureStorage.setString('ff_userProfile', value.serialize());
  }

  void deleteUserProfile() {
    secureStorage.delete(key: 'ff_userProfile');
  }

  void updateUserProfileStruct(Function(UserProfileStruct) updateFn) {
    updateFn(_userProfile);
    secureStorage.setString('ff_userProfile', _userProfile.serialize());
  }

  UserPreferencesStruct _userPreferences =
      UserPreferencesStruct.fromSerializableMap(jsonDecode(
          '{\"enableAPOD\":\"true\",\"preferredTimeFormat\":\"twelveHour\"}'));
  UserPreferencesStruct get userPreferences => _userPreferences;
  set userPreferences(UserPreferencesStruct value) {
    _userPreferences = value;
    secureStorage.setString('ff_userPreferences', value.serialize());
  }

  void deleteUserPreferences() {
    secureStorage.delete(key: 'ff_userPreferences');
  }

  void updateUserPreferencesStruct(Function(UserPreferencesStruct) updateFn) {
    updateFn(_userPreferences);
    secureStorage.setString('ff_userPreferences', _userPreferences.serialize());
  }

  String _userGreetingMessage = '';
  String get userGreetingMessage => _userGreetingMessage;
  set userGreetingMessage(String value) {
    _userGreetingMessage = value;
  }

  CacheMetadataStruct _cacheMetaData = CacheMetadataStruct.fromSerializableMap(
      jsonDecode(
          '{\"todayLastFetched\":\"l1783103400000\",\"currentLastFetched\":\"l1783103400000\",\"upcomingLastFetched\":\"l1783103400000\",\"todayDate\":\"4/7/2026\",\"upcomingLimit\":\"10\",\"selectedDateLastFetched\":\"l1783103400000\",\"selectedDate\":\"4/7/2026\",\"rangeLastFetched\":\"l1783103400000\"}'));
  CacheMetadataStruct get cacheMetaData => _cacheMetaData;
  set cacheMetaData(CacheMetadataStruct value) {
    _cacheMetaData = value;
    secureStorage.setString('ff_cacheMetaData', value.serialize());
  }

  void deleteCacheMetaData() {
    secureStorage.delete(key: 'ff_cacheMetaData');
  }

  void updateCacheMetaDataStruct(Function(CacheMetadataStruct) updateFn) {
    updateFn(_cacheMetaData);
    secureStorage.setString('ff_cacheMetaData', _cacheMetaData.serialize());
  }

  List<ScheduledClassStruct> _dashboardClasses = [];
  List<ScheduledClassStruct> get dashboardClasses => _dashboardClasses;
  set dashboardClasses(List<ScheduledClassStruct> value) {
    _dashboardClasses = value;
    secureStorage.setStringList(
        'ff_dashboardClasses', value.map((x) => x.serialize()).toList());
  }

  void deleteDashboardClasses() {
    secureStorage.delete(key: 'ff_dashboardClasses');
  }

  void addToDashboardClasses(ScheduledClassStruct value) {
    dashboardClasses.add(value);
    secureStorage.setStringList('ff_dashboardClasses',
        _dashboardClasses.map((x) => x.serialize()).toList());
  }

  void removeFromDashboardClasses(ScheduledClassStruct value) {
    dashboardClasses.remove(value);
    secureStorage.setStringList('ff_dashboardClasses',
        _dashboardClasses.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromDashboardClasses(int index) {
    dashboardClasses.removeAt(index);
    secureStorage.setStringList('ff_dashboardClasses',
        _dashboardClasses.map((x) => x.serialize()).toList());
  }

  void updateDashboardClassesAtIndex(
    int index,
    ScheduledClassStruct Function(ScheduledClassStruct) updateFn,
  ) {
    dashboardClasses[index] = updateFn(_dashboardClasses[index]);
    secureStorage.setStringList('ff_dashboardClasses',
        _dashboardClasses.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInDashboardClasses(int index, ScheduledClassStruct value) {
    dashboardClasses.insert(index, value);
    secureStorage.setStringList('ff_dashboardClasses',
        _dashboardClasses.map((x) => x.serialize()).toList());
  }

  List<ScheduledClassStruct> _missedClasses = [];
  List<ScheduledClassStruct> get missedClasses => _missedClasses;
  set missedClasses(List<ScheduledClassStruct> value) {
    _missedClasses = value;
    secureStorage.setStringList(
        'ff_missedClasses', value.map((x) => x.serialize()).toList());
  }

  void deleteMissedClasses() {
    secureStorage.delete(key: 'ff_missedClasses');
  }

  void addToMissedClasses(ScheduledClassStruct value) {
    missedClasses.add(value);
    secureStorage.setStringList(
        'ff_missedClasses', _missedClasses.map((x) => x.serialize()).toList());
  }

  void removeFromMissedClasses(ScheduledClassStruct value) {
    missedClasses.remove(value);
    secureStorage.setStringList(
        'ff_missedClasses', _missedClasses.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromMissedClasses(int index) {
    missedClasses.removeAt(index);
    secureStorage.setStringList(
        'ff_missedClasses', _missedClasses.map((x) => x.serialize()).toList());
  }

  void updateMissedClassesAtIndex(
    int index,
    ScheduledClassStruct Function(ScheduledClassStruct) updateFn,
  ) {
    missedClasses[index] = updateFn(_missedClasses[index]);
    secureStorage.setStringList(
        'ff_missedClasses', _missedClasses.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInMissedClasses(int index, ScheduledClassStruct value) {
    missedClasses.insert(index, value);
    secureStorage.setStringList(
        'ff_missedClasses', _missedClasses.map((x) => x.serialize()).toList());
  }

  List<ScheduledClassStruct> _calendarClasses = [];
  List<ScheduledClassStruct> get calendarClasses => _calendarClasses;
  set calendarClasses(List<ScheduledClassStruct> value) {
    _calendarClasses = value;
    secureStorage.setStringList(
        'ff_calendarClasses', value.map((x) => x.serialize()).toList());
  }

  void deleteCalendarClasses() {
    secureStorage.delete(key: 'ff_calendarClasses');
  }

  void addToCalendarClasses(ScheduledClassStruct value) {
    calendarClasses.add(value);
    secureStorage.setStringList('ff_calendarClasses',
        _calendarClasses.map((x) => x.serialize()).toList());
  }

  void removeFromCalendarClasses(ScheduledClassStruct value) {
    calendarClasses.remove(value);
    secureStorage.setStringList('ff_calendarClasses',
        _calendarClasses.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromCalendarClasses(int index) {
    calendarClasses.removeAt(index);
    secureStorage.setStringList('ff_calendarClasses',
        _calendarClasses.map((x) => x.serialize()).toList());
  }

  void updateCalendarClassesAtIndex(
    int index,
    ScheduledClassStruct Function(ScheduledClassStruct) updateFn,
  ) {
    calendarClasses[index] = updateFn(_calendarClasses[index]);
    secureStorage.setStringList('ff_calendarClasses',
        _calendarClasses.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInCalendarClasses(int index, ScheduledClassStruct value) {
    calendarClasses.insert(index, value);
    secureStorage.setStringList('ff_calendarClasses',
        _calendarClasses.map((x) => x.serialize()).toList());
  }

  ApodStruct _apodData = ApodStruct();
  ApodStruct get apodData => _apodData;
  set apodData(ApodStruct value) {
    _apodData = value;
    secureStorage.setString('ff_apodData', value.serialize());
  }

  void deleteApodData() {
    secureStorage.delete(key: 'ff_apodData');
  }

  void updateApodDataStruct(Function(ApodStruct) updateFn) {
    updateFn(_apodData);
    secureStorage.setString('ff_apodData', _apodData.serialize());
  }

  List<BusRouteStruct> _BusRoutes = [];
  List<BusRouteStruct> get BusRoutes => _BusRoutes;
  set BusRoutes(List<BusRouteStruct> value) {
    _BusRoutes = value;
    secureStorage.setStringList(
        'ff_BusRoutes', value.map((x) => x.serialize()).toList());
  }

  void deleteBusRoutes() {
    secureStorage.delete(key: 'ff_BusRoutes');
  }

  void addToBusRoutes(BusRouteStruct value) {
    BusRoutes.add(value);
    secureStorage.setStringList(
        'ff_BusRoutes', _BusRoutes.map((x) => x.serialize()).toList());
  }

  void removeFromBusRoutes(BusRouteStruct value) {
    BusRoutes.remove(value);
    secureStorage.setStringList(
        'ff_BusRoutes', _BusRoutes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromBusRoutes(int index) {
    BusRoutes.removeAt(index);
    secureStorage.setStringList(
        'ff_BusRoutes', _BusRoutes.map((x) => x.serialize()).toList());
  }

  void updateBusRoutesAtIndex(
    int index,
    BusRouteStruct Function(BusRouteStruct) updateFn,
  ) {
    BusRoutes[index] = updateFn(_BusRoutes[index]);
    secureStorage.setStringList(
        'ff_BusRoutes', _BusRoutes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInBusRoutes(int index, BusRouteStruct value) {
    BusRoutes.insert(index, value);
    secureStorage.setStringList(
        'ff_BusRoutes', _BusRoutes.map((x) => x.serialize()).toList());
  }

  List<MessStruct> _Messes = [];
  List<MessStruct> get Messes => _Messes;
  set Messes(List<MessStruct> value) {
    _Messes = value;
    secureStorage.setStringList(
        'ff_Messes', value.map((x) => x.serialize()).toList());
  }

  void deleteMesses() {
    secureStorage.delete(key: 'ff_Messes');
  }

  void addToMesses(MessStruct value) {
    Messes.add(value);
    secureStorage.setStringList(
        'ff_Messes', _Messes.map((x) => x.serialize()).toList());
  }

  void removeFromMesses(MessStruct value) {
    Messes.remove(value);
    secureStorage.setStringList(
        'ff_Messes', _Messes.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromMesses(int index) {
    Messes.removeAt(index);
    secureStorage.setStringList(
        'ff_Messes', _Messes.map((x) => x.serialize()).toList());
  }

  void updateMessesAtIndex(
    int index,
    MessStruct Function(MessStruct) updateFn,
  ) {
    Messes[index] = updateFn(_Messes[index]);
    secureStorage.setStringList(
        'ff_Messes', _Messes.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInMesses(int index, MessStruct value) {
    Messes.insert(index, value);
    secureStorage.setStringList(
        'ff_Messes', _Messes.map((x) => x.serialize()).toList());
  }

  final _courseCatalogManager = FutureRequestManager<List<CourseSyllabiRow>>();
  Future<List<CourseSyllabiRow>> courseCatalog({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<CourseSyllabiRow>> Function() requestFn,
  }) =>
      _courseCatalogManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearCourseCatalogCache() => _courseCatalogManager.clear();
  void clearCourseCatalogCacheKey(String? uniqueKey) =>
      _courseCatalogManager.clearRequest(uniqueKey);

  final _currentDayAcademicCalendarManager =
      FutureRequestManager<List<AcademicCalendarEventsRow>>();
  Future<List<AcademicCalendarEventsRow>> currentDayAcademicCalendar({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<AcademicCalendarEventsRow>> Function() requestFn,
  }) =>
      _currentDayAcademicCalendarManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearCurrentDayAcademicCalendarCache() =>
      _currentDayAcademicCalendarManager.clear();
  void clearCurrentDayAcademicCalendarCacheKey(String? uniqueKey) =>
      _currentDayAcademicCalendarManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
