import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'edit_existing_class_widget.dart' show EditExistingClassWidget;
import 'package:flutter/material.dart';

class EditExistingClassModel extends FlutterFlowModel<EditExistingClassWidget> {
  ///  Local state fields for this component.

  DateTime? startTime;

  DateTime? endTime;

  DateTime? classDate;

  ///  State fields for stateful widgets in this component.

  DateTime? datePicked1;
  DateTime? datePicked2;
  DateTime? datePicked3;
  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
  bool? checkboxValue2;
  // Stores action output result for [Custom Action - rescheduleClass] action in Button widget.
  FeedbackStruct? rescheduleFeedback;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
