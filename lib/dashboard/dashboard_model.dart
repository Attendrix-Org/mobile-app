import '/backend/schema/structs/index.dart';
import '/components/at_a_glance_widget.dart';
import '/components/class_block_today_widget.dart';
import '/components/class_block_upcoming_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dashboard_widget.dart' show DashboardWidget;
import 'package:flutter/material.dart';

class DashboardModel extends FlutterFlowModel<DashboardWidget> {
  ///  Local state fields for this page.

  List<DateTime> generatedDates = [];
  void addToGeneratedDates(DateTime item) => generatedDates.add(item);
  void removeFromGeneratedDates(DateTime item) => generatedDates.remove(item);
  void removeAtIndexFromGeneratedDates(int index) =>
      generatedDates.removeAt(index);
  void insertAtIndexInGeneratedDates(int index, DateTime item) =>
      generatedDates.insert(index, item);
  void updateGeneratedDatesAtIndex(int index, Function(DateTime) updateFn) =>
      generatedDates[index] = updateFn(generatedDates[index]);

  bool dashboardLoaded = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - loadAppBootstrapStatus] action in dashboard widget.
  AppBootstrapStruct? appBootstrapData;
  // Stores action output result for [Custom Action - generateGreeting] action in dashboard widget.
  String? generatedGreetingMessage;
  // Model for atAGlance component.
  late AtAGlanceModel atAGlanceModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Models for classBlock_today dynamic component.
  late FlutterFlowDynamicModels<ClassBlockTodayModel> classBlockTodayModels;
  // Models for classBlock_upcoming dynamic component.
  late FlutterFlowDynamicModels<ClassBlockUpcomingModel>
      classBlockUpcomingModels;

  @override
  void initState(BuildContext context) {
    atAGlanceModel = createModel(context, () => AtAGlanceModel());
    classBlockTodayModels =
        FlutterFlowDynamicModels(() => ClassBlockTodayModel());
    classBlockUpcomingModels =
        FlutterFlowDynamicModels(() => ClassBlockUpcomingModel());
  }

  @override
  void dispose() {
    atAGlanceModel.dispose();
    tabBarController?.dispose();
    classBlockTodayModels.dispose();
    classBlockUpcomingModels.dispose();
  }
}
