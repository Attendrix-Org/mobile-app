// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BusRouteStruct extends BaseStruct {
  BusRouteStruct({
    String? busId,
    String? routeName,
    String? stopsSummary,
    bool? isActive,
    List<BusTimingStruct>? timings,
  })  : _busId = busId,
        _routeName = routeName,
        _stopsSummary = stopsSummary,
        _isActive = isActive,
        _timings = timings;

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

  // "stopsSummary" field.
  String? _stopsSummary;
  String get stopsSummary => _stopsSummary ?? '';
  set stopsSummary(String? val) => _stopsSummary = val;

  bool hasStopsSummary() => _stopsSummary != null;

  // "isActive" field.
  bool? _isActive;
  bool get isActive => _isActive ?? false;
  set isActive(bool? val) => _isActive = val;

  bool hasIsActive() => _isActive != null;

  // "timings" field.
  List<BusTimingStruct>? _timings;
  List<BusTimingStruct> get timings => _timings ?? const [];
  set timings(List<BusTimingStruct>? val) => _timings = val;

  void updateTimings(Function(List<BusTimingStruct>) updateFn) {
    updateFn(_timings ??= []);
  }

  bool hasTimings() => _timings != null;

  static BusRouteStruct fromMap(Map<String, dynamic> data) => BusRouteStruct(
        busId: data['busId'] as String?,
        routeName: data['routeName'] as String?,
        stopsSummary: data['stopsSummary'] as String?,
        isActive: data['isActive'] as bool?,
        timings: getStructList(
          data['timings'],
          BusTimingStruct.fromMap,
        ),
      );

  static BusRouteStruct? maybeFromMap(dynamic data) =>
      data is Map ? BusRouteStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'busId': _busId,
        'routeName': _routeName,
        'stopsSummary': _stopsSummary,
        'isActive': _isActive,
        'timings': _timings?.map((e) => e.toMap()).toList(),
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
        'stopsSummary': serializeParam(
          _stopsSummary,
          ParamType.String,
        ),
        'isActive': serializeParam(
          _isActive,
          ParamType.bool,
        ),
        'timings': serializeParam(
          _timings,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static BusRouteStruct fromSerializableMap(Map<String, dynamic> data) =>
      BusRouteStruct(
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
        stopsSummary: deserializeParam(
          data['stopsSummary'],
          ParamType.String,
          false,
        ),
        isActive: deserializeParam(
          data['isActive'],
          ParamType.bool,
          false,
        ),
        timings: deserializeStructParam<BusTimingStruct>(
          data['timings'],
          ParamType.DataStruct,
          true,
          structBuilder: BusTimingStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'BusRouteStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is BusRouteStruct &&
        busId == other.busId &&
        routeName == other.routeName &&
        stopsSummary == other.stopsSummary &&
        isActive == other.isActive &&
        listEquality.equals(timings, other.timings);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([busId, routeName, stopsSummary, isActive, timings]);
}

BusRouteStruct createBusRouteStruct({
  String? busId,
  String? routeName,
  String? stopsSummary,
  bool? isActive,
}) =>
    BusRouteStruct(
      busId: busId,
      routeName: routeName,
      stopsSummary: stopsSummary,
      isActive: isActive,
    );
