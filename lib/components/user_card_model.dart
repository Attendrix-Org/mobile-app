import '/flutter_flow/flutter_flow_util.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'user_card_widget.dart' show UserCardWidget;
import 'package:flutter/material.dart';

class UserCardModel extends FlutterFlowModel<UserCardWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for FlippableCard widget.
  final flippableCardController = FlipCardController();
  bool flippableCardIsFront = true;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
