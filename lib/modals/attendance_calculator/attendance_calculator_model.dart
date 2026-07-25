import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'attendance_calculator_widget.dart' show AttendanceCalculatorWidget;
import 'package:flutter/material.dart';

class AttendanceCalculatorModel
    extends FlutterFlowModel<AttendanceCalculatorWidget> {
  ///  Local state fields for this component.

  int addToAttended = 0;

  int addToSkip = 0;

  AttendanceCalculatorDataStruct? projectedAttendance;
  void updateProjectedAttendanceStruct(
      Function(AttendanceCalculatorDataStruct) updateFn) {
    updateFn(projectedAttendance ??= AttendanceCalculatorDataStruct());
  }

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - calculateProjectedAttendance] action in attendanceCalculator widget.
  AttendanceCalculatorDataStruct? initialData;
  // State field(s) for attend widget.
  int? attendValue;
  // State field(s) for skip widget.
  int? skipValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
