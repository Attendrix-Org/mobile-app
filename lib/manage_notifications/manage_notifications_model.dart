import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'manage_notifications_widget.dart' show ManageNotificationsWidget;
import 'package:flutter/material.dart';

class ManageNotificationsModel
    extends FlutterFlowModel<ManageNotificationsWidget> {
  ///  Local state fields for this page.

  UserPreferencesStruct? userPreferences;
  void updateUserPreferencesStruct(Function(UserPreferencesStruct) updateFn) {
    updateFn(userPreferences ??= UserPreferencesStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - updateUserPreferences] action in ManageNotifications widget.
  bool? updateFeedback;
  // State field(s) for optIn widget.
  bool? optInValue;
  // State field(s) for enableClassNotifications widget.
  bool? enableClassNotificationsValue;
  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController1;
  // State field(s) for classReminders widget.
  bool? classRemindersValue;
  // State field(s) for classCancellations widget.
  bool? classCancellationsValue;
  // State field(s) for classReschedule widget.
  bool? classRescheduleValue;
  // State field(s) for enableMessNotifications widget.
  bool? enableMessNotificationsValue;
  // State field(s) for RadioButton widget.
  FormFieldController<String>? radioButtonValueController2;
  // State field(s) for breakfast widget.
  bool? breakfastValue;
  // State field(s) for lunch widget.
  bool? lunchValue;
  // State field(s) for eveningSnacks widget.
  bool? eveningSnacksValue;
  // State field(s) for Dinner widget.
  bool? dinnerValue;
  // State field(s) for DailyMorningBrief widget.
  bool? dailyMorningBriefValue;
  DateTime? datePicked1;
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;
  // State field(s) for Switch widget.
  bool? switchValue3;
  DateTime? datePicked2;
  DateTime? datePicked3;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Additional helper methods.
  String? get radioButtonValue1 => radioButtonValueController1?.value;
  String? get radioButtonValue2 => radioButtonValueController2?.value;
}
