// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WalkCalculationResultStruct extends BaseStruct {
  WalkCalculationResultStruct({
    int? distanceMeters,
    int? walkMinutes,
    bool? found,
  })  : _distanceMeters = distanceMeters,
        _walkMinutes = walkMinutes,
        _found = found;

  // "distanceMeters" field.
  int? _distanceMeters;
  int get distanceMeters => _distanceMeters ?? 0;
  set distanceMeters(int? val) => _distanceMeters = val;

  void incrementDistanceMeters(int amount) =>
      distanceMeters = distanceMeters + amount;

  bool hasDistanceMeters() => _distanceMeters != null;

  // "walkMinutes" field.
  int? _walkMinutes;
  int get walkMinutes => _walkMinutes ?? 0;
  set walkMinutes(int? val) => _walkMinutes = val;

  void incrementWalkMinutes(int amount) =>
      walkMinutes = walkMinutes + amount;

  bool hasWalkMinutes() => _walkMinutes != null;

  // "found" field.
  bool? _found;
  bool get found => _found ?? true;
  set found(bool? val) => _found = val;

  bool hasFound() => _found != null;

  static WalkCalculationResultStruct fromMap(Map<String, dynamic> data) =>
      WalkCalculationResultStruct(
        distanceMeters:
            castToType<int>(data['distanceMeters'] ?? data['distance_m']),
        walkMinutes:
            castToType<int>(data['walkMinutes'] ?? data['walk_minutes']),
        found: data['found'] as bool?,
      );

  static WalkCalculationResultStruct? maybeFromMap(dynamic data) => data is Map
      ? WalkCalculationResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'distanceMeters': _distanceMeters,
        'walkMinutes': _walkMinutes,
        'found': _found,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'distanceMeters': serializeParam(
          _distanceMeters,
          ParamType.int,
        ),
        'walkMinutes': serializeParam(
          _walkMinutes,
          ParamType.int,
        ),
        'found': serializeParam(
          _found,
          ParamType.bool,
        ),
      }.withoutNulls;

  static WalkCalculationResultStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      WalkCalculationResultStruct(
        distanceMeters: deserializeParam(
          data['distanceMeters'],
          ParamType.int,
          false,
        ),
        walkMinutes: deserializeParam(
          data['walkMinutes'],
          ParamType.int,
          false,
        ),
        found: deserializeParam(
          data['found'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'WalkCalculationResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WalkCalculationResultStruct &&
        distanceMeters == other.distanceMeters &&
        walkMinutes == other.walkMinutes &&
        found == other.found;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([distanceMeters, walkMinutes, found]);
}

WalkCalculationResultStruct createWalkCalculationResultStruct({
  int? distanceMeters,
  int? walkMinutes,
  bool? found,
}) =>
    WalkCalculationResultStruct(
      distanceMeters: distanceMeters,
      walkMinutes: walkMinutes,
      found: found,
    );
