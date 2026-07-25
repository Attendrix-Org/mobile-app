import '/flutter_flow/flutter_flow_util.dart';
import 'tasks_widget.dart' show TasksWidget;
import 'package:flutter/material.dart';

class TasksModel extends FlutterFlowModel<TasksWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for MainBar widget.
  TabController? mainBarController;
  int get mainBarCurrentIndex =>
      mainBarController != null ? mainBarController!.index : 0;
  int get mainBarPreviousIndex =>
      mainBarController != null ? mainBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    mainBarController?.dispose();
  }
}
