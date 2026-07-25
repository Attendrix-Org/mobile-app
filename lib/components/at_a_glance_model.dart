import '/components/bus_time_card_widget.dart';
import '/components/class_block_next_class_widget.dart';
import '/components/mess_menu_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'at_a_glance_widget.dart' show AtAGlanceWidget;
import 'package:flutter/material.dart';

class AtAGlanceModel extends FlutterFlowModel<AtAGlanceWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for CardsView widget.
  PageController? cardsViewController;

  int get cardsViewCurrentIndex => cardsViewController != null &&
          cardsViewController!.hasClients &&
          cardsViewController!.page != null
      ? cardsViewController!.page!.round()
      : 0;
  // Model for classBlock_NextClass component.
  late ClassBlockNextClassModel classBlockNextClassModel;
  // Model for MessMenuCard component.
  late MessMenuCardModel messMenuCardModel;
  // Model for busTimeCard component.
  late BusTimeCardModel busTimeCardModel;

  @override
  void initState(BuildContext context) {
    classBlockNextClassModel =
        createModel(context, () => ClassBlockNextClassModel());
    messMenuCardModel = createModel(context, () => MessMenuCardModel());
    busTimeCardModel = createModel(context, () => BusTimeCardModel());
  }

  @override
  void dispose() {
    classBlockNextClassModel.dispose();
    messMenuCardModel.dispose();
    busTimeCardModel.dispose();
  }
}
