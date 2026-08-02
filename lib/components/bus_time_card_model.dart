import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'bus_time_card_widget.dart' show BusTimeCardWidget;
import 'package:flutter/material.dart';

class BusTimeCardModel extends FlutterFlowModel<BusTimeCardWidget> {
  ///  Local state fields for this component.

  List<NextBusInfoStruct> nextBusInfoState = [];
  void addToNextBusInfoState(NextBusInfoStruct item) =>
      nextBusInfoState.add(item);
  void removeFromNextBusInfoState(NextBusInfoStruct item) =>
      nextBusInfoState.remove(item);
  void removeAtIndexFromNextBusInfoState(int index) =>
      nextBusInfoState.removeAt(index);
  void insertAtIndexInNextBusInfoState(int index, NextBusInfoStruct item) =>
      nextBusInfoState.insert(index, item);
  void updateNextBusInfoStateAtIndex(
          int index, Function(NextBusInfoStruct) updateFn) =>
      nextBusInfoState[index] = updateFn(nextBusInfoState[index]);

  bool locationPermission = true;

  ///  State fields for stateful widgets in this component.

  InstantTimer? nextBusFetchTimer;
  // Stores action output result for [Custom Action - getNextBusInfo] action in busTimeCard widget.
  List<NextBusInfoStruct>? nextBusInfoData;
  // Stores action output result for [Custom Action - getNextBusInfo] action in Button widget.
  List<NextBusInfoStruct>? nextBusInfoDataRequest;
  // Stores action output result for [Custom Action - getNextBusInfo] action in Button widget.
  List<NextBusInfoStruct>? nextBusInfoDataRefresh;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nextBusFetchTimer?.cancel();
  }
}
