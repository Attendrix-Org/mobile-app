// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RollNumberDetailsStruct extends BaseStruct {
  RollNumberDetailsStruct({
    String? departmentId,
    int? semesterNumber,
  })  : _departmentId = departmentId,
        _semesterNumber = semesterNumber;

  // "departmentId" field.
  String? _departmentId;
  String get departmentId => _departmentId ?? '';
  set departmentId(String? val) => _departmentId = val;

  bool hasDepartmentId() => _departmentId != null;

  // "semesterNumber" field.
  int? _semesterNumber;
  int get semesterNumber => _semesterNumber ?? 0;
  set semesterNumber(int? val) => _semesterNumber = val;

  void incrementSemesterNumber(int amount) =>
      semesterNumber = semesterNumber + amount;

  bool hasSemesterNumber() => _semesterNumber != null;

  static RollNumberDetailsStruct fromMap(Map<String, dynamic> data) =>
      RollNumberDetailsStruct(
        departmentId: data['departmentId'] as String?,
        semesterNumber: castToType<int>(data['semesterNumber']),
      );

  static RollNumberDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? RollNumberDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'departmentId': _departmentId,
        'semesterNumber': _semesterNumber,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'departmentId': serializeParam(
          _departmentId,
          ParamType.String,
        ),
        'semesterNumber': serializeParam(
          _semesterNumber,
          ParamType.int,
        ),
      }.withoutNulls;

  static RollNumberDetailsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      RollNumberDetailsStruct(
        departmentId: deserializeParam(
          data['departmentId'],
          ParamType.String,
          false,
        ),
        semesterNumber: deserializeParam(
          data['semesterNumber'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'RollNumberDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RollNumberDetailsStruct &&
        departmentId == other.departmentId &&
        semesterNumber == other.semesterNumber;
  }

  @override
  int get hashCode => const ListEquality().hash([departmentId, semesterNumber]);
}

RollNumberDetailsStruct createRollNumberDetailsStruct({
  String? departmentId,
  int? semesterNumber,
}) =>
    RollNumberDetailsStruct(
      departmentId: departmentId,
      semesterNumber: semesterNumber,
    );
