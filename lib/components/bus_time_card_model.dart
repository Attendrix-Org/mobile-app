import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'bus_time_card_widget.dart' show BusTimeCardWidget;
import 'package:flutter/material.dart';

class BusTimeCardModel extends FlutterFlowModel<BusTimeCardWidget> {
  ///  Local state fields for this component.

  NextBusInfoStruct? nextBusInfoState;
  void updateNextBusInfoStateStruct(Function(NextBusInfoStruct) updateFn) {
    updateFn(nextBusInfoState ??= NextBusInfoStruct());
  }

  bool locationPermission = true;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - getNextBusInfo] action in busTimeCard widget.
  NextBusInfoStruct? nextBusInfoDataPrimary;
  InstantTimer? nextBusFetchTimer;
  // Stores action output result for [Custom Action - getNextBusInfo] action in busTimeCard widget.
  NextBusInfoStruct? nextBusInfoData;
  // Stores action output result for [Custom Action - getNextBusInfo] action in Button widget.
  NextBusInfoStruct? nextBusInfoDataCopy;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nextBusFetchTimer?.cancel();
  }
}
