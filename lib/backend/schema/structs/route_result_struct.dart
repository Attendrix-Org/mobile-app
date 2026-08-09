// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RouteResultStruct extends BaseStruct {
  RouteResultStruct({
    String? busId,
    String? routeName,
    int? walkTimeMinutes,
    String? nearestStopName,
    String? nextBusDestination,
    int? nextBusMinutes,
    DateTime? nextBusTime,
    List<BusArrivalStruct>? availableBuses,
    DateTime? updatedAt,
    bool? hasAvailableBus,
  })  : _busId = busId,
        _routeName = routeName,
        _walkTimeMinutes = walkTimeMinutes,
        _nearestStopName = nearestStopName,
        _nextBusDestination = nextBusDestination,
        _nextBusMinutes = nextBusMinutes,
        _nextBusTime = nextBusTime,
        _availableBuses = availableBuses,
        _updatedAt = updatedAt,
        _hasAvailableBus = hasAvailableBus;

  // "busId" field.
  String? _busId;
  String get busId => _busId ?? '';
  set busId(String? val) => _busId = val;

  bool hasBusId() => _busId != null;

  // "routeName" field.
  String? _routeName;
  String get routeName => _routeName ?? '';
  set routeName(String? val) => _routeName = val;

  bool hasRouteName() => _routeName != null;

  // "walkTimeMinutes" field.
  int? _walkTimeMinutes;
  int get walkTimeMinutes => _walkTimeMinutes ?? 0;
  set walkTimeMinutes(int? val) => _walkTimeMinutes = val;

  void incrementWalkTimeMinutes(int amount) =>
      walkTimeMinutes = walkTimeMinutes + amount;

  bool hasWalkTimeMinutes() => _walkTimeMinutes != null;

  // "nearestStopName" field.
  String? _nearestStopName;
  String get nearestStopName => _nearestStopName ?? '';
  set nearestStopName(String? val) => _nearestStopName = val;

  bool hasNearestStopName() => _nearestStopName != null;

  // "nextBusDestination" field.
  String? _nextBusDestination;
  String get nextBusDestination => _nextBusDestination ?? '';
  set nextBusDestination(String? val) => _nextBusDestination = val;

  bool hasNextBusDestination() => _nextBusDestination != null;

  // "nextBusMinutes" field.
  int? _nextBusMinutes;
  int get nextBusMinutes => _nextBusMinutes ?? 0;
  set nextBusMinutes(int? val) => _nextBusMinutes = val;

  void incrementNextBusMinutes(int amount) =>
      nextBusMinutes = nextBusMinutes + amount;

  bool hasNextBusMinutes() => _nextBusMinutes != null;

  // "nextBusTime" field.
  DateTime? _nextBusTime;
  DateTime? get nextBusTime => _nextBusTime;
  set nextBusTime(DateTime? val) => _nextBusTime = val;

  bool hasNextBusTime() => _nextBusTime != null;

  // "availableBuses" field.
  List<BusArrivalStruct>? _availableBuses;
  List<BusArrivalStruct> get availableBuses => _availableBuses ?? const [];
  set availableBuses(List<BusArrivalStruct>? val) => _availableBuses = val;

  void updateAvailableBuses(Function(List<BusArrivalStruct>) updateFn) {
    updateFn(_availableBuses ??= []);
  }

  bool hasAvailableBuses() => _availableBuses != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  // "hasAvailableBus" field.
  bool? _hasAvailableBus;
  bool get hasAvailableBus => _hasAvailableBus ?? false;
  set hasAvailableBus(bool? val) => _hasAvailableBus = val;

  bool hasHasAvailableBus() => _hasAvailableBus != null;

  static RouteResultStruct fromMap(Map<String, dynamic> data) =>
      RouteResultStruct(
        busId: data['busId'] as String?,
        routeName: data['routeName'] as String?,
        walkTimeMinutes: castToType<int>(data['walkTimeMinutes']),
        nearestStopName: data['nearestStopName'] as String?,
        nextBusDestination: data['nextBusDestination'] as String?,
        nextBusMinutes: castToType<int>(data['nextBusMinutes']),
        nextBusTime: data['nextBusTime'] as DateTime?,
        availableBuses: getStructList(
          data['availableBuses'],
          BusArrivalStruct.fromMap,
        ),
        updatedAt: data['updatedAt'] as DateTime?,
        hasAvailableBus: data['hasAvailableBus'] as bool?,
      );

  static RouteResultStruct? maybeFromMap(dynamic data) => data is Map
      ? RouteResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'busId': _busId,
        'routeName': _routeName,
        'walkTimeMinutes': _walkTimeMinutes,
        'nearestStopName': _nearestStopName,
        'nextBusDestination': _nextBusDestination,
        'nextBusMinutes': _nextBusMinutes,
        'nextBusTime': _nextBusTime,
        'availableBuses': _availableBuses?.map((e) => e.toMap()).toList(),
        'updatedAt': _updatedAt,
        'hasAvailableBus': _hasAvailableBus,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'busId': serializeParam(
          _busId,
          ParamType.String,
        ),
        'routeName': serializeParam(
          _routeName,
          ParamType.String,
        ),
        'walkTimeMinutes': serializeParam(
          _walkTimeMinutes,
          ParamType.int,
        ),
        'nearestStopName': serializeParam(
          _nearestStopName,
          ParamType.String,
        ),
        'nextBusDestination': serializeParam(
          _nextBusDestination,
          ParamType.String,
        ),
        'nextBusMinutes': serializeParam(
          _nextBusMinutes,
          ParamType.int,
        ),
        'nextBusTime': serializeParam(
          _nextBusTime,
          ParamType.DateTime,
        ),
        'availableBuses': serializeParam(
          _availableBuses,
          ParamType.DataStruct,
          isList: true,
        ),
        'updatedAt': serializeParam(
          _updatedAt,
          ParamType.DateTime,
        ),
        'hasAvailableBus': serializeParam(
          _hasAvailableBus,
          ParamType.bool,
        ),
      }.withoutNulls;

  static RouteResultStruct fromSerializableMap(Map<String, dynamic> data) =>
      RouteResultStruct(
        busId: deserializeParam(
          data['busId'],
          ParamType.String,
          false,
        ),
        routeName: deserializeParam(
          data['routeName'],
          ParamType.String,
          false,
        ),
        walkTimeMinutes: deserializeParam(
          data['walkTimeMinutes'],
          ParamType.int,
          false,
        ),
        nearestStopName: deserializeParam(
          data['nearestStopName'],
          ParamType.String,
          false,
        ),
        nextBusDestination: deserializeParam(
          data['nextBusDestination'],
          ParamType.String,
          false,
        ),
        nextBusMinutes: deserializeParam(
          data['nextBusMinutes'],
          ParamType.int,
          false,
        ),
        nextBusTime: deserializeParam(
          data['nextBusTime'],
          ParamType.DateTime,
          false,
        ),
        availableBuses: deserializeStructParam<BusArrivalStruct>(
          data['availableBuses'],
          ParamType.DataStruct,
          true,
          structBuilder: BusArrivalStruct.fromSerializableMap,
        ),
        updatedAt: deserializeParam(
          data['updatedAt'],
          ParamType.DateTime,
          false,
        ),
        hasAvailableBus: deserializeParam(
          data['hasAvailableBus'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'RouteResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RouteResultStruct &&
        busId == other.busId &&
        routeName == other.routeName &&
        walkTimeMinutes == other.walkTimeMinutes &&
        nearestStopName == other.nearestStopName &&
        nextBusDestination == other.nextBusDestination &&
        nextBusMinutes == other.nextBusMinutes &&
        nextBusTime == other.nextBusTime &&
        listEquality.equals(availableBuses, other.availableBuses) &&
        updatedAt == other.updatedAt &&
        hasAvailableBus == other.hasAvailableBus;
  }

  @override
  int get hashCode => const ListEquality().hash([
        busId,
        routeName,
        walkTimeMinutes,
        nearestStopName,
        nextBusDestination,
        nextBusMinutes,
        nextBusTime,
        availableBuses,
        updatedAt,
        hasAvailableBus
      ]);
}

RouteResultStruct createRouteResultStruct({
  String? busId,
  String? routeName,
  int? walkTimeMinutes,
  String? nearestStopName,
  String? nextBusDestination,
  int? nextBusMinutes,
  DateTime? nextBusTime,
  DateTime? updatedAt,
  bool? hasAvailableBus,
}) =>
    RouteResultStruct(
      busId: busId,
      routeName: routeName,
      walkTimeMinutes: walkTimeMinutes,
      nearestStopName: nearestStopName,
      nextBusDestination: nextBusDestination,
      nextBusMinutes: nextBusMinutes,
      nextBusTime: nextBusTime,
      updatedAt: updatedAt,
      hasAvailableBus: hasAvailableBus,
    );
