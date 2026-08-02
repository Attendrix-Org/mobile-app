// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NextBusInfoStruct extends BaseStruct {
  NextBusInfoStruct({
    String? routeName,
    String? nearestStop,
    DateTime? departureTime,
    int? minutesRemaining,
    bool? isSpecial,
    bool? hasAnotherBusToday,
    int? walkingDistanceMeters,
    int? walkingTimeMinutes,
    DateTime? lastUpdated,
    bool? isAvailable,
  })  : _routeName = routeName,
        _nearestStop = nearestStop,
        _departureTime = departureTime,
        _minutesRemaining = minutesRemaining,
        _isSpecial = isSpecial,
        _hasAnotherBusToday = hasAnotherBusToday,
        _walkingDistanceMeters = walkingDistanceMeters,
        _walkingTimeMinutes = walkingTimeMinutes,
        _lastUpdated = lastUpdated,
        _isAvailable = isAvailable;

  // "routeName" field.
  String? _routeName;
  String get routeName => _routeName ?? '';
  set routeName(String? val) => _routeName = val;

  bool hasRouteName() => _routeName != null;

  // "nearestStop" field.
  String? _nearestStop;
  String get nearestStop => _nearestStop ?? '';
  set nearestStop(String? val) => _nearestStop = val;

  bool hasNearestStop() => _nearestStop != null;

  // "departureTime" field.
  DateTime? _departureTime;
  DateTime? get departureTime => _departureTime;
  set departureTime(DateTime? val) => _departureTime = val;

  bool hasDepartureTime() => _departureTime != null;

  // "minutesRemaining" field.
  int? _minutesRemaining;
  int get minutesRemaining => _minutesRemaining ?? 0;
  set minutesRemaining(int? val) => _minutesRemaining = val;

  void incrementMinutesRemaining(int amount) =>
      minutesRemaining = minutesRemaining + amount;

  bool hasMinutesRemaining() => _minutesRemaining != null;

  // "isSpecial" field.
  bool? _isSpecial;
  bool get isSpecial => _isSpecial ?? false;
  set isSpecial(bool? val) => _isSpecial = val;

  bool hasIsSpecial() => _isSpecial != null;

  // "hasAnotherBusToday" field.
  bool? _hasAnotherBusToday;
  bool get hasAnotherBusToday => _hasAnotherBusToday ?? false;
  set hasAnotherBusToday(bool? val) => _hasAnotherBusToday = val;

  bool hasHasAnotherBusToday() => _hasAnotherBusToday != null;

  // "walkingDistanceMeters" field.
  int? _walkingDistanceMeters;
  int get walkingDistanceMeters => _walkingDistanceMeters ?? 0;
  set walkingDistanceMeters(int? val) => _walkingDistanceMeters = val;

  void incrementWalkingDistanceMeters(int amount) =>
      walkingDistanceMeters = walkingDistanceMeters + amount;

  bool hasWalkingDistanceMeters() => _walkingDistanceMeters != null;

  // "walkingTimeMinutes" field.
  int? _walkingTimeMinutes;
  int get walkingTimeMinutes => _walkingTimeMinutes ?? 0;
  set walkingTimeMinutes(int? val) => _walkingTimeMinutes = val;

  void incrementWalkingTimeMinutes(int amount) =>
      walkingTimeMinutes = walkingTimeMinutes + amount;

  bool hasWalkingTimeMinutes() => _walkingTimeMinutes != null;

  // "lastUpdated" field.
  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;
  set lastUpdated(DateTime? val) => _lastUpdated = val;

  bool hasLastUpdated() => _lastUpdated != null;

  // "isAvailable" field.
  bool? _isAvailable;
  bool get isAvailable => _isAvailable ?? false;
  set isAvailable(bool? val) => _isAvailable = val;

  bool hasIsAvailable() => _isAvailable != null;

  static NextBusInfoStruct fromMap(Map<String, dynamic> data) =>
      NextBusInfoStruct(
        routeName: data['routeName'] as String?,
        nearestStop: data['nearestStop'] as String?,
        departureTime: data['departureTime'] as DateTime?,
        minutesRemaining: castToType<int>(data['minutesRemaining']),
        isSpecial: data['isSpecial'] as bool?,
        hasAnotherBusToday: data['hasAnotherBusToday'] as bool?,
        walkingDistanceMeters: castToType<int>(data['walkingDistanceMeters']),
        walkingTimeMinutes: castToType<int>(data['walkingTimeMinutes']),
        lastUpdated: data['lastUpdated'] as DateTime?,
        isAvailable: data['isAvailable'] as bool?,
      );

  static NextBusInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? NextBusInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'routeName': _routeName,
        'nearestStop': _nearestStop,
        'departureTime': _departureTime,
        'minutesRemaining': _minutesRemaining,
        'isSpecial': _isSpecial,
        'hasAnotherBusToday': _hasAnotherBusToday,
        'walkingDistanceMeters': _walkingDistanceMeters,
        'walkingTimeMinutes': _walkingTimeMinutes,
        'lastUpdated': _lastUpdated,
        'isAvailable': _isAvailable,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'routeName': serializeParam(
          _routeName,
          ParamType.String,
        ),
        'nearestStop': serializeParam(
          _nearestStop,
          ParamType.String,
        ),
        'departureTime': serializeParam(
          _departureTime,
          ParamType.DateTime,
        ),
        'minutesRemaining': serializeParam(
          _minutesRemaining,
          ParamType.int,
        ),
        'isSpecial': serializeParam(
          _isSpecial,
          ParamType.bool,
        ),
        'hasAnotherBusToday': serializeParam(
          _hasAnotherBusToday,
          ParamType.bool,
        ),
        'walkingDistanceMeters': serializeParam(
          _walkingDistanceMeters,
          ParamType.int,
        ),
        'walkingTimeMinutes': serializeParam(
          _walkingTimeMinutes,
          ParamType.int,
        ),
        'lastUpdated': serializeParam(
          _lastUpdated,
          ParamType.DateTime,
        ),
        'isAvailable': serializeParam(
          _isAvailable,
          ParamType.bool,
        ),
      }.withoutNulls;

  static NextBusInfoStruct fromSerializableMap(Map<String, dynamic> data) =>
      NextBusInfoStruct(
        routeName: deserializeParam(
          data['routeName'],
          ParamType.String,
          false,
        ),
        nearestStop: deserializeParam(
          data['nearestStop'],
          ParamType.String,
          false,
        ),
        departureTime: deserializeParam(
          data['departureTime'],
          ParamType.DateTime,
          false,
        ),
        minutesRemaining: deserializeParam(
          data['minutesRemaining'],
          ParamType.int,
          false,
        ),
        isSpecial: deserializeParam(
          data['isSpecial'],
          ParamType.bool,
          false,
        ),
        hasAnotherBusToday: deserializeParam(
          data['hasAnotherBusToday'],
          ParamType.bool,
          false,
        ),
        walkingDistanceMeters: deserializeParam(
          data['walkingDistanceMeters'],
          ParamType.int,
          false,
        ),
        walkingTimeMinutes: deserializeParam(
          data['walkingTimeMinutes'],
          ParamType.int,
          false,
        ),
        lastUpdated: deserializeParam(
          data['lastUpdated'],
          ParamType.DateTime,
          false,
        ),
        isAvailable: deserializeParam(
          data['isAvailable'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'NextBusInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NextBusInfoStruct &&
        routeName == other.routeName &&
        nearestStop == other.nearestStop &&
        departureTime == other.departureTime &&
        minutesRemaining == other.minutesRemaining &&
        isSpecial == other.isSpecial &&
        hasAnotherBusToday == other.hasAnotherBusToday &&
        walkingDistanceMeters == other.walkingDistanceMeters &&
        walkingTimeMinutes == other.walkingTimeMinutes &&
        lastUpdated == other.lastUpdated &&
        isAvailable == other.isAvailable;
  }

  @override
  int get hashCode => const ListEquality().hash([
        routeName,
        nearestStop,
        departureTime,
        minutesRemaining,
        isSpecial,
        hasAnotherBusToday,
        walkingDistanceMeters,
        walkingTimeMinutes,
        lastUpdated,
        isAvailable
      ]);
}

NextBusInfoStruct createNextBusInfoStruct({
  String? routeName,
  String? nearestStop,
  DateTime? departureTime,
  int? minutesRemaining,
  bool? isSpecial,
  bool? hasAnotherBusToday,
  int? walkingDistanceMeters,
  int? walkingTimeMinutes,
  DateTime? lastUpdated,
  bool? isAvailable,
}) =>
    NextBusInfoStruct(
      routeName: routeName,
      nearestStop: nearestStop,
      departureTime: departureTime,
      minutesRemaining: minutesRemaining,
      isSpecial: isSpecial,
      hasAnotherBusToday: hasAnotherBusToday,
      walkingDistanceMeters: walkingDistanceMeters,
      walkingTimeMinutes: walkingTimeMinutes,
      lastUpdated: lastUpdated,
      isAvailable: isAvailable,
    );
