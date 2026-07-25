import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'class_block_next_class_widget.dart' show ClassBlockNextClassWidget;
import 'package:flutter/material.dart';

class ClassBlockNextClassModel
    extends FlutterFlowModel<ClassBlockNextClassWidget> {
  ///  Local state fields for this component.

  DateTime? lastUpdatedAt;

  ///  State fields for stateful widgets in this component.

  InstantTimer? progressBarTimer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    progressBarTimer?.cancel();
  }
}
