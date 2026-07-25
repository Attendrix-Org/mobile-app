import '/flutter_flow/flutter_flow_util.dart';
import 'challenges_widget.dart' show ChallengesWidget;
import 'package:flutter/material.dart';

class ChallengesModel extends FlutterFlowModel<ChallengesWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
