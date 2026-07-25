// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CacheMetadataStruct extends BaseStruct {
  CacheMetadataStruct({
    String? appVersion,
    int? profileUpdatedAt,
    int? dashboardUpdatedAt,
    int? absencesUpdatedAt,
    int? calendarClassesUpdatedAt,
    int? busUpdatedAt,
    int? messUpdatedAt,
    DateTime? apodLastFetchedAt,
    int? generatedAt,
  })  : _appVersion = appVersion,
        _profileUpdatedAt = profileUpdatedAt,
        _dashboardUpdatedAt = dashboardUpdatedAt,
        _absencesUpdatedAt = absencesUpdatedAt,
        _calendarClassesUpdatedAt = calendarClassesUpdatedAt,
        _busUpdatedAt = busUpdatedAt,
        _messUpdatedAt = messUpdatedAt,
        _apodLastFetchedAt = apodLastFetchedAt,
        _generatedAt = generatedAt;

  // "appVersion" field.
  String? _appVersion;
  String get appVersion => _appVersion ?? '';
  set appVersion(String? val) => _appVersion = val;

  bool hasAppVersion() => _appVersion != null;

  // "profileUpdatedAt" field.
  int? _profileUpdatedAt;
  int get profileUpdatedAt => _profileUpdatedAt ?? 0;
  set profileUpdatedAt(int? val) => _profileUpdatedAt = val;

  void incrementProfileUpdatedAt(int amount) =>
      profileUpdatedAt = profileUpdatedAt + amount;

  bool hasProfileUpdatedAt() => _profileUpdatedAt != null;

  // "dashboardUpdatedAt" field.
  int? _dashboardUpdatedAt;
  int get dashboardUpdatedAt => _dashboardUpdatedAt ?? 0;
  set dashboardUpdatedAt(int? val) => _dashboardUpdatedAt = val;

  void incrementDashboardUpdatedAt(int amount) =>
      dashboardUpdatedAt = dashboardUpdatedAt + amount;

  bool hasDashboardUpdatedAt() => _dashboardUpdatedAt != null;

  // "absencesUpdatedAt" field.
  int? _absencesUpdatedAt;
  int get absencesUpdatedAt => _absencesUpdatedAt ?? 0;
  set absencesUpdatedAt(int? val) => _absencesUpdatedAt = val;

  void incrementAbsencesUpdatedAt(int amount) =>
      absencesUpdatedAt = absencesUpdatedAt + amount;

  bool hasAbsencesUpdatedAt() => _absencesUpdatedAt != null;

  // "calendarClassesUpdatedAt" field.
  int? _calendarClassesUpdatedAt;
  int get calendarClassesUpdatedAt => _calendarClassesUpdatedAt ?? 0;
  set calendarClassesUpdatedAt(int? val) => _calendarClassesUpdatedAt = val;

  void incrementCalendarClassesUpdatedAt(int amount) =>
      calendarClassesUpdatedAt = calendarClassesUpdatedAt + amount;

  bool hasCalendarClassesUpdatedAt() => _calendarClassesUpdatedAt != null;

  // "busUpdatedAt" field.
  int? _busUpdatedAt;
  int get busUpdatedAt => _busUpdatedAt ?? 0;
  set busUpdatedAt(int? val) => _busUpdatedAt = val;

  void incrementBusUpdatedAt(int amount) =>
      busUpdatedAt = busUpdatedAt + amount;

  bool hasBusUpdatedAt() => _busUpdatedAt != null;

  // "messUpdatedAt" field.
  int? _messUpdatedAt;
  int get messUpdatedAt => _messUpdatedAt ?? 0;
  set messUpdatedAt(int? val) => _messUpdatedAt = val;

  void incrementMessUpdatedAt(int amount) =>
      messUpdatedAt = messUpdatedAt + amount;

  bool hasMessUpdatedAt() => _messUpdatedAt != null;

  // "apodLastFetchedAt" field.
  DateTime? _apodLastFetchedAt;
  DateTime? get apodLastFetchedAt => _apodLastFetchedAt;
  set apodLastFetchedAt(DateTime? val) => _apodLastFetchedAt = val;

  bool hasApodLastFetchedAt() => _apodLastFetchedAt != null;

  // "generatedAt" field.
  int? _generatedAt;
  int get generatedAt => _generatedAt ?? 0;
  set generatedAt(int? val) => _generatedAt = val;

  void incrementGeneratedAt(int amount) => generatedAt = generatedAt + amount;

  bool hasGeneratedAt() => _generatedAt != null;

  static CacheMetadataStruct fromMap(Map<String, dynamic> data) =>
      CacheMetadataStruct(
        appVersion: data['appVersion'] as String?,
        profileUpdatedAt: castToType<int>(data['profileUpdatedAt']),
        dashboardUpdatedAt: castToType<int>(data['dashboardUpdatedAt']),
        absencesUpdatedAt: castToType<int>(data['absencesUpdatedAt']),
        calendarClassesUpdatedAt:
            castToType<int>(data['calendarClassesUpdatedAt']),
        busUpdatedAt: castToType<int>(data['busUpdatedAt']),
        messUpdatedAt: castToType<int>(data['messUpdatedAt']),
        apodLastFetchedAt: data['apodLastFetchedAt'] as DateTime?,
        generatedAt: castToType<int>(data['generatedAt']),
      );

  static CacheMetadataStruct? maybeFromMap(dynamic data) => data is Map
      ? CacheMetadataStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'appVersion': _appVersion,
        'profileUpdatedAt': _profileUpdatedAt,
        'dashboardUpdatedAt': _dashboardUpdatedAt,
        'absencesUpdatedAt': _absencesUpdatedAt,
        'calendarClassesUpdatedAt': _calendarClassesUpdatedAt,
        'busUpdatedAt': _busUpdatedAt,
        'messUpdatedAt': _messUpdatedAt,
        'apodLastFetchedAt': _apodLastFetchedAt,
        'generatedAt': _generatedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'appVersion': serializeParam(
          _appVersion,
          ParamType.String,
        ),
        'profileUpdatedAt': serializeParam(
          _profileUpdatedAt,
          ParamType.int,
        ),
        'dashboardUpdatedAt': serializeParam(
          _dashboardUpdatedAt,
          ParamType.int,
        ),
        'absencesUpdatedAt': serializeParam(
          _absencesUpdatedAt,
          ParamType.int,
        ),
        'calendarClassesUpdatedAt': serializeParam(
          _calendarClassesUpdatedAt,
          ParamType.int,
        ),
        'busUpdatedAt': serializeParam(
          _busUpdatedAt,
          ParamType.int,
        ),
        'messUpdatedAt': serializeParam(
          _messUpdatedAt,
          ParamType.int,
        ),
        'apodLastFetchedAt': serializeParam(
          _apodLastFetchedAt,
          ParamType.DateTime,
        ),
        'generatedAt': serializeParam(
          _generatedAt,
          ParamType.int,
        ),
      }.withoutNulls;

  static CacheMetadataStruct fromSerializableMap(Map<String, dynamic> data) =>
      CacheMetadataStruct(
        appVersion: deserializeParam(
          data['appVersion'],
          ParamType.String,
          false,
        ),
        profileUpdatedAt: deserializeParam(
          data['profileUpdatedAt'],
          ParamType.int,
          false,
        ),
        dashboardUpdatedAt: deserializeParam(
          data['dashboardUpdatedAt'],
          ParamType.int,
          false,
        ),
        absencesUpdatedAt: deserializeParam(
          data['absencesUpdatedAt'],
          ParamType.int,
          false,
        ),
        calendarClassesUpdatedAt: deserializeParam(
          data['calendarClassesUpdatedAt'],
          ParamType.int,
          false,
        ),
        busUpdatedAt: deserializeParam(
          data['busUpdatedAt'],
          ParamType.int,
          false,
        ),
        messUpdatedAt: deserializeParam(
          data['messUpdatedAt'],
          ParamType.int,
          false,
        ),
        apodLastFetchedAt: deserializeParam(
          data['apodLastFetchedAt'],
          ParamType.DateTime,
          false,
        ),
        generatedAt: deserializeParam(
          data['generatedAt'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CacheMetadataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CacheMetadataStruct &&
        appVersion == other.appVersion &&
        profileUpdatedAt == other.profileUpdatedAt &&
        dashboardUpdatedAt == other.dashboardUpdatedAt &&
        absencesUpdatedAt == other.absencesUpdatedAt &&
        calendarClassesUpdatedAt == other.calendarClassesUpdatedAt &&
        busUpdatedAt == other.busUpdatedAt &&
        messUpdatedAt == other.messUpdatedAt &&
        apodLastFetchedAt == other.apodLastFetchedAt &&
        generatedAt == other.generatedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        appVersion,
        profileUpdatedAt,
        dashboardUpdatedAt,
        absencesUpdatedAt,
        calendarClassesUpdatedAt,
        busUpdatedAt,
        messUpdatedAt,
        apodLastFetchedAt,
        generatedAt
      ]);
}

CacheMetadataStruct createCacheMetadataStruct({
  String? appVersion,
  int? profileUpdatedAt,
  int? dashboardUpdatedAt,
  int? absencesUpdatedAt,
  int? calendarClassesUpdatedAt,
  int? busUpdatedAt,
  int? messUpdatedAt,
  DateTime? apodLastFetchedAt,
  int? generatedAt,
}) =>
    CacheMetadataStruct(
      appVersion: appVersion,
      profileUpdatedAt: profileUpdatedAt,
      dashboardUpdatedAt: dashboardUpdatedAt,
      absencesUpdatedAt: absencesUpdatedAt,
      calendarClassesUpdatedAt: calendarClassesUpdatedAt,
      busUpdatedAt: busUpdatedAt,
      messUpdatedAt: messUpdatedAt,
      apodLastFetchedAt: apodLastFetchedAt,
      generatedAt: generatedAt,
    );
