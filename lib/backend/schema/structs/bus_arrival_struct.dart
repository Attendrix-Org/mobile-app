// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BusArrivalStruct extends BaseStruct {
  BusArrivalStruct({
    String? busId,
    String? destination,
    int? arrivalMinutes,
    DateTime? arrivalTime,
    bool? isNext,
    bool? isAvailable,
  })  : _busId = busId,
        _destination = destination,
        _arrivalMinutes = arrivalMinutes,
        _arrivalTime = arrivalTime,
        _isNext = isNext,
        _isAvailable = isAvailable;

  // "busId" field.
  String? _busId;
  String get busId => _busId ?? '';
  set busId(String? val) => _busId = val;

  bool hasBusId() => _busId != null;

  // "destination" field.
  String? _destination;
  String get destination => _destination ?? '';
  set destination(String? val) => _destination = val;

  bool hasDestination() => _destination != null;

  // "arrivalMinutes" field.
  int? _arrivalMinutes;
  int get arrivalMinutes => _arrivalMinutes ?? 0;
  set arrivalMinutes(int? val) => _arrivalMinutes = val;

  void incrementArrivalMinutes(int amount) =>
      arrivalMinutes = arrivalMinutes + amount;

  bool hasArrivalMinutes() => _arrivalMinutes != null;

  // "arrivalTime" field.
  DateTime? _arrivalTime;
  DateTime? get arrivalTime => _arrivalTime;
  set arrivalTime(DateTime? val) => _arrivalTime = val;

  bool hasArrivalTime() => _arrivalTime != null;

  // "isNext" field.
  bool? _isNext;
  bool get isNext => _isNext ?? false;
  set isNext(bool? val) => _isNext = val;

  bool hasIsNext() => _isNext != null;

  // "isAvailable" field.
  bool? _isAvailable;
  bool get isAvailable => _isAvailable ?? false;
  set isAvailable(bool? val) => _isAvailable = val;

  bool hasIsAvailable() => _isAvailable != null;

  static BusArrivalStruct fromMap(Map<String, dynamic> data) =>
      BusArrivalStruct(
        busId: data['busId'] as String?,
        destination: data['destination'] as String?,
        arrivalMinutes: castToType<int>(data['arrivalMinutes']),
        arrivalTime: data['arrivalTime'] as DateTime?,
        isNext: data['isNext'] as bool?,
        isAvailable: data['isAvailable'] as bool?,
      );

  static BusArrivalStruct? maybeFromMap(dynamic data) => data is Map
      ? BusArrivalStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'busId': _busId,
        'destination': _destination,
        'arrivalMinutes': _arrivalMinutes,
        'arrivalTime': _arrivalTime,
        'isNext': _isNext,
        'isAvailable': _isAvailable,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'busId': serializeParam(
          _busId,
          ParamType.String,
        ),
        'destination': serializeParam(
          _destination,
          ParamType.String,
        ),
        'arrivalMinutes': serializeParam(
          _arrivalMinutes,
          ParamType.int,
        ),
        'arrivalTime': serializeParam(
          _arrivalTime,
          ParamType.DateTime,
        ),
        'isNext': serializeParam(
          _isNext,
          ParamType.bool,
        ),
        'isAvailable': serializeParam(
          _isAvailable,
          ParamType.bool,
        ),
      }.withoutNulls;

  static BusArrivalStruct fromSerializableMap(Map<String, dynamic> data) =>
      BusArrivalStruct(
        busId: deserializeParam(
          data['busId'],
          ParamType.String,
          false,
        ),
        destination: deserializeParam(
          data['destination'],
          ParamType.String,
          false,
        ),
        arrivalMinutes: deserializeParam(
          data['arrivalMinutes'],
          ParamType.int,
          false,
        ),
        arrivalTime: deserializeParam(
          data['arrivalTime'],
          ParamType.DateTime,
          false,
        ),
        isNext: deserializeParam(
          data['isNext'],
          ParamType.bool,
          false,
        ),
        isAvailable: deserializeParam(
          data['isAvailable'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'BusArrivalStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BusArrivalStruct &&
        busId == other.busId &&
        destination == other.destination &&
        arrivalMinutes == other.arrivalMinutes &&
        arrivalTime == other.arrivalTime &&
        isNext == other.isNext &&
        isAvailable == other.isAvailable;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [busId, destination, arrivalMinutes, arrivalTime, isNext, isAvailable]);
}

BusArrivalStruct createBusArrivalStruct({
  String? busId,
  String? destination,
  int? arrivalMinutes,
  DateTime? arrivalTime,
  bool? isNext,
  bool? isAvailable,
}) =>
    BusArrivalStruct(
      busId: busId,
      destination: destination,
      arrivalMinutes: arrivalMinutes,
      arrivalTime: arrivalTime,
      isNext: isNext,
      isAvailable: isAvailable,
    );
