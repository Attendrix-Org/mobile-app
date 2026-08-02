import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'class_block_next_class_widget.dart' show ClassBlockNextClassWidget;
import 'package:flutter/material.dart';

class ClassBlockNextClassModel
    extends FlutterFlowModel<ClassBlockNextClassWidget> {
  ///  Local state fields for this component.

  DateTime? lastUpdatedAt;

  RouteResultStruct? walkRouteDataState;
  void updateWalkRouteDataStateStruct(Function(RouteResultStruct) updateFn) {
    updateFn(walkRouteDataState ??= RouteResultStruct());
  }

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in classBlock_NextClass widget.
  List<CampusBuildingsRow>? venueBuildingId;
  InstantTimer? progressBarTimer;
  // Stores action output result for [Custom Action - calculateWalkRoute] action in classBlock_NextClass widget.
  RouteResultStruct? walkRouteData;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    progressBarTimer?.cancel();
  }
}
