// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AttendanceCalculatorDataStruct extends BaseStruct {
  AttendanceCalculatorDataStruct({
    int? projectedAttended,
    int? projectedTotal,
    double? projectedAttendance,
    List<String>? attendanceInsights,
  })  : _projectedAttended = projectedAttended,
        _projectedTotal = projectedTotal,
        _projectedAttendance = projectedAttendance,
        _attendanceInsights = attendanceInsights;

  // "projectedAttended" field.
  int? _projectedAttended;
  int get projectedAttended => _projectedAttended ?? 0;
  set projectedAttended(int? val) => _projectedAttended = val;

  void incrementProjectedAttended(int amount) =>
      projectedAttended = projectedAttended + amount;

  bool hasProjectedAttended() => _projectedAttended != null;

  // "projectedTotal" field.
  int? _projectedTotal;
  int get projectedTotal => _projectedTotal ?? 0;
  set projectedTotal(int? val) => _projectedTotal = val;

  void incrementProjectedTotal(int amount) =>
      projectedTotal = projectedTotal + amount;

  bool hasProjectedTotal() => _projectedTotal != null;

  // "projectedAttendance" field.
  double? _projectedAttendance;
  double get projectedAttendance => _projectedAttendance ?? 0.0;
  set projectedAttendance(double? val) => _projectedAttendance = val;

  void incrementProjectedAttendance(double amount) =>
      projectedAttendance = projectedAttendance + amount;

  bool hasProjectedAttendance() => _projectedAttendance != null;

  // "attendanceInsights" field.
  List<String>? _attendanceInsights;
  List<String> get attendanceInsights => _attendanceInsights ?? const [];
  set attendanceInsights(List<String>? val) => _attendanceInsights = val;

  void updateAttendanceInsights(Function(List<String>) updateFn) {
    updateFn(_attendanceInsights ??= []);
  }

  bool hasAttendanceInsights() => _attendanceInsights != null;

  static AttendanceCalculatorDataStruct fromMap(Map<String, dynamic> data) =>
      AttendanceCalculatorDataStruct(
        projectedAttended: castToType<int>(data['projectedAttended']),
        projectedTotal: castToType<int>(data['projectedTotal']),
        projectedAttendance: castToType<double>(data['projectedAttendance']),
        attendanceInsights: getDataList(data['attendanceInsights']),
      );

  static AttendanceCalculatorDataStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? AttendanceCalculatorDataStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'projectedAttended': _projectedAttended,
        'projectedTotal': _projectedTotal,
        'projectedAttendance': _projectedAttendance,
        'attendanceInsights': _attendanceInsights,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'projectedAttended': serializeParam(
          _projectedAttended,
          ParamType.int,
        ),
        'projectedTotal': serializeParam(
          _projectedTotal,
          ParamType.int,
        ),
        'projectedAttendance': serializeParam(
          _projectedAttendance,
          ParamType.double,
        ),
        'attendanceInsights': serializeParam(
          _attendanceInsights,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static AttendanceCalculatorDataStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      AttendanceCalculatorDataStruct(
        projectedAttended: deserializeParam(
          data['projectedAttended'],
          ParamType.int,
          false,
        ),
        projectedTotal: deserializeParam(
          data['projectedTotal'],
          ParamType.int,
          false,
        ),
        projectedAttendance: deserializeParam(
          data['projectedAttendance'],
          ParamType.double,
          false,
        ),
        attendanceInsights: deserializeParam<String>(
          data['attendanceInsights'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'AttendanceCalculatorDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is AttendanceCalculatorDataStruct &&
        projectedAttended == other.projectedAttended &&
        projectedTotal == other.projectedTotal &&
        projectedAttendance == other.projectedAttendance &&
        listEquality.equals(attendanceInsights, other.attendanceInsights);
  }

  @override
  int get hashCode => const ListEquality().hash([
        projectedAttended,
        projectedTotal,
        projectedAttendance,
        attendanceInsights
      ]);
}

AttendanceCalculatorDataStruct createAttendanceCalculatorDataStruct({
  int? projectedAttended,
  int? projectedTotal,
  double? projectedAttendance,
}) =>
    AttendanceCalculatorDataStruct(
      projectedAttended: projectedAttended,
      projectedTotal: projectedTotal,
      projectedAttendance: projectedAttendance,
    );
