import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'lab_selection_block_widget.dart' show LabSelectionBlockWidget;
import 'package:flutter/material.dart';

class LabSelectionBlockModel extends FlutterFlowModel<LabSelectionBlockWidget> {
  ///  Local state fields for this component.

  bool labSelected = false;

  EnrolledCourseStruct? selectedLabCourse;
  void updateSelectedLabCourseStruct(Function(EnrolledCourseStruct) updateFn) {
    updateFn(selectedLabCourse ??= EnrolledCourseStruct());
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
