// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BusTimingStruct extends BaseStruct {
  BusTimingStruct({
    String? timingId,
    String? departureTime,
    bool? isSpecial,
    int? sortOrder,
  })  : _timingId = timingId,
        _departureTime = departureTime,
        _isSpecial = isSpecial,
        _sortOrder = sortOrder;

  // "timingId" field.
  String? _timingId;
  String get timingId => _timingId ?? '';
  set timingId(String? val) => _timingId = val;

  bool hasTimingId() => _timingId != null;

  // "departureTime" field.
  String? _departureTime;
  String get departureTime => _departureTime ?? '';
  set departureTime(String? val) => _departureTime = val;

  bool hasDepartureTime() => _departureTime != null;

  // "isSpecial" field.
  bool? _isSpecial;
  bool get isSpecial => _isSpecial ?? false;
  set isSpecial(bool? val) => _isSpecial = val;

  bool hasIsSpecial() => _isSpecial != null;

  // "sortOrder" field.
  int? _sortOrder;
  int get sortOrder => _sortOrder ?? 0;
  set sortOrder(int? val) => _sortOrder = val;

  void incrementSortOrder(int amount) => sortOrder = sortOrder + amount;

  bool hasSortOrder() => _sortOrder != null;

  static BusTimingStruct fromMap(Map<String, dynamic> data) => BusTimingStruct(
        timingId: data['timingId'] as String?,
        departureTime: data['departureTime'] as String?,
        isSpecial: data['isSpecial'] as bool?,
        sortOrder: castToType<int>(data['sortOrder']),
      );

  static BusTimingStruct? maybeFromMap(dynamic data) => data is Map
      ? BusTimingStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'timingId': _timingId,
        'departureTime': _departureTime,
        'isSpecial': _isSpecial,
        'sortOrder': _sortOrder,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'timingId': serializeParam(
          _timingId,
          ParamType.String,
        ),
        'departureTime': serializeParam(
          _departureTime,
          ParamType.String,
        ),
        'isSpecial': serializeParam(
          _isSpecial,
          ParamType.bool,
        ),
        'sortOrder': serializeParam(
          _sortOrder,
          ParamType.int,
        ),
      }.withoutNulls;

  static BusTimingStruct fromSerializableMap(Map<String, dynamic> data) =>
      BusTimingStruct(
        timingId: deserializeParam(
          data['timingId'],
          ParamType.String,
          false,
        ),
        departureTime: deserializeParam(
          data['departureTime'],
          ParamType.String,
          false,
        ),
        isSpecial: deserializeParam(
          data['isSpecial'],
          ParamType.bool,
          false,
        ),
        sortOrder: deserializeParam(
          data['sortOrder'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'BusTimingStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BusTimingStruct &&
        timingId == other.timingId &&
        departureTime == other.departureTime &&
        isSpecial == other.isSpecial &&
        sortOrder == other.sortOrder;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([timingId, departureTime, isSpecial, sortOrder]);
}

BusTimingStruct createBusTimingStruct({
  String? timingId,
  String? departureTime,
  bool? isSpecial,
  int? sortOrder,
}) =>
    BusTimingStruct(
      timingId: timingId,
      departureTime: departureTime,
      isSpecial: isSpecial,
      sortOrder: sortOrder,
    );
