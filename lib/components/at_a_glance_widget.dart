import '/components/bus_time_card_widget.dart';
import '/components/class_block_next_class_widget.dart';
import '/components/mess_menu_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'at_a_glance_model.dart';
export 'at_a_glance_model.dart';

class AtAGlanceWidget extends StatefulWidget {
  const AtAGlanceWidget({super.key});

  @override
  State<AtAGlanceWidget> createState() => _AtAGlanceWidgetState();
}

class _AtAGlanceWidgetState extends State<AtAGlanceWidget> {
  late AtAGlanceModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AtAGlanceModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: double.infinity,
        height: 150.0,
        child: PageView(
          controller: _model.cardsViewController ??=
              PageController(initialPage: 0),
          scrollDirection: Axis.horizontal,
          children: [
            wrapWithModel(
              model: _model.classBlockNextClassModel,
              updateCallback: () => safeSetState(() {}),
              updateOnChange: true,
              child: ClassBlockNextClassWidget(
                classBlock: FFAppState()
                    .dashboardClasses
                    .where((e) => e.scheduledEnd! > getCurrentTimestamp)
                    .toList()
                    .firstOrNull!,
              ),
            ),
            wrapWithModel(
              model: _model.messMenuCardModel,
              updateCallback: () => safeSetState(() {}),
              child: MessMenuCardWidget(),
            ),
            wrapWithModel(
              model: _model.busTimeCardModel,
              updateCallback: () => safeSetState(() {}),
              child: BusTimeCardWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
