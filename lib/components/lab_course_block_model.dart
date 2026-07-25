import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'lab_course_block_widget.dart' show LabCourseBlockWidget;
import 'package:flutter/material.dart';

class LabCourseBlockModel extends FlutterFlowModel<LabCourseBlockWidget> {
  ///  Local state fields for this component.

  LabSubBatchStruct? selectedSubBatch;
  void updateSelectedSubBatchStruct(Function(LabSubBatchStruct) updateFn) {
    updateFn(selectedSubBatch ??= LabSubBatchStruct());
  }

  EnrolledCourseStruct? selectedCourse;
  void updateSelectedCourseStruct(Function(EnrolledCourseStruct) updateFn) {
    updateFn(selectedCourse ??= EnrolledCourseStruct());
  }

  ///  State fields for stateful widgets in this component.

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
