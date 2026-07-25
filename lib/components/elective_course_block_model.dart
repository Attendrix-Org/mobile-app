import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'elective_course_block_widget.dart' show ElectiveCourseBlockWidget;
import 'package:flutter/material.dart';

class ElectiveCourseBlockModel
    extends FlutterFlowModel<ElectiveCourseBlockWidget> {
  ///  Local state fields for this component.

  bool electiveSelected = false;

  ElectiveCourseStruct? selectedElectiveCourse;
  void updateSelectedElectiveCourseStruct(
      Function(ElectiveCourseStruct) updateFn) {
    updateFn(selectedElectiveCourse ??= ElectiveCourseStruct());
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
