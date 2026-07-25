import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'mess_menu_card_widget.dart' show MessMenuCardWidget;
import 'package:flutter/material.dart';

class MessMenuCardModel extends FlutterFlowModel<MessMenuCardWidget> {
  ///  Local state fields for this component.

  String? selectedMess;

  int? selectedDay = 1;

  ///  State fields for stateful widgets in this component.

  // State field(s) for messDropdownEmptyState widget.
  String? messDropdownEmptyStateValue;
  FormFieldController<String>? messDropdownEmptyStateValueController;
  // State field(s) for messDropdown widget.
  String? messDropdownValue1;
  FormFieldController<String>? messDropdownValueController1;
  // State field(s) for messDropdown widget.
  int? messDropdownValue2;
  FormFieldController<int>? messDropdownValueController2;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
