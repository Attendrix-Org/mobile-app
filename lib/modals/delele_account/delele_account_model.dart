import '/flutter_flow/flutter_flow_util.dart';
import 'delele_account_widget.dart' show DeleleAccountWidget;
import 'package:flutter/material.dart';

class DeleleAccountModel extends FlutterFlowModel<DeleleAccountWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;
  // State field(s) for password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Custom Action - deleteUserAccount] action in Button widget.
  bool? userDeletion;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
