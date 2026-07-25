import '/flutter_flow/flutter_flow_util.dart';
import 'quick_note_bottom_sheet_widget.dart' show QuickNoteBottomSheetWidget;
import 'package:flutter/material.dart';

class QuickNoteBottomSheetModel
    extends FlutterFlowModel<QuickNoteBottomSheetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  Color? colorPicked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
