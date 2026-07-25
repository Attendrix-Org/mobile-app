// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AttendanceStruct extends BaseStruct {
  AttendanceStruct({
    int? attended,
    int? missed,
    double? percentage,
    int? required,
  })  : _attended = attended,
        _missed = missed,
        _percentage = percentage,
        _required = required;

  // "attended" field.
  int? _attended;
  int get attended => _attended ?? 0;
  set attended(int? val) => _attended = val;

  void incrementAttended(int amount) => attended = attended + amount;

  bool hasAttended() => _attended != null;

  // "missed" field.
  int? _missed;
  int get missed => _missed ?? 0;
  set missed(int? val) => _missed = val;

  void incrementMissed(int amount) => missed = missed + amount;

  bool hasMissed() => _missed != null;

  // "percentage" field.
  double? _percentage;
  double get percentage => _percentage ?? 0.0;
  set percentage(double? val) => _percentage = val;

  void incrementPercentage(double amount) => percentage = percentage + amount;

  bool hasPercentage() => _percentage != null;

  // "required" field.
  int? _required;
  int get required => _required ?? 80;
  set required(int? val) => _required = val;

  void incrementRequired(int amount) => required = required + amount;

  bool hasRequired() => _required != null;

  static AttendanceStruct fromMap(Map<String, dynamic> data) =>
      AttendanceStruct(
        attended: castToType<int>(data['attended']),
        missed: castToType<int>(data['missed']),
        percentage: castToType<double>(data['percentage']),
        required: castToType<int>(data['required']),
      );

  static AttendanceStruct? maybeFromMap(dynamic data) => data is Map
      ? AttendanceStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'attended': _attended,
        'missed': _missed,
        'percentage': _percentage,
        'required': _required,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'attended': serializeParam(
          _attended,
          ParamType.int,
        ),
        'missed': serializeParam(
          _missed,
          ParamType.int,
        ),
        'percentage': serializeParam(
          _percentage,
          ParamType.double,
        ),
        'required': serializeParam(
          _required,
          ParamType.int,
        ),
      }.withoutNulls;

  static AttendanceStruct fromSerializableMap(Map<String, dynamic> data) =>
      AttendanceStruct(
        attended: deserializeParam(
          data['attended'],
          ParamType.int,
          false,
        ),
        missed: deserializeParam(
          data['missed'],
          ParamType.int,
          false,
        ),
        percentage: deserializeParam(
          data['percentage'],
          ParamType.double,
          false,
        ),
        required: deserializeParam(
          data['required'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'AttendanceStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AttendanceStruct &&
        attended == other.attended &&
        missed == other.missed &&
        percentage == other.percentage &&
        required == other.required;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([attended, missed, percentage, required]);
}

AttendanceStruct createAttendanceStruct({
  int? attended,
  int? missed,
  double? percentage,
  int? required,
}) =>
    AttendanceStruct(
      attended: attended,
      missed: missed,
      percentage: percentage,
      required: required,
    );
