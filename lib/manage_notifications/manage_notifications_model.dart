import '/components/manage_course_notification_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'manage_notifications_widget.dart' show ManageNotificationsWidget;
import 'package:flutter/material.dart';

class ManageNotificationsModel
    extends FlutterFlowModel<ManageNotificationsWidget> {
  ///  Local state fields for this page.

  bool hideCourses = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for optIn widget.
  bool? optInValue;
  // Models for manageCourseNotification dynamic component.
  late FlutterFlowDynamicModels<ManageCourseNotificationModel>
      manageCourseNotificationModels;
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;
  // State field(s) for Switch widget.
  bool? switchValue3;

  @override
  void initState(BuildContext context) {
    manageCourseNotificationModels =
        FlutterFlowDynamicModels(() => ManageCourseNotificationModel());
  }

  @override
  void dispose() {
    manageCourseNotificationModels.dispose();
  }
}
