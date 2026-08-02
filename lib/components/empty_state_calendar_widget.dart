import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'empty_state_calendar_model.dart';
export 'empty_state_calendar_model.dart';

class EmptyStateCalendarWidget extends StatefulWidget {
  const EmptyStateCalendarWidget({super.key});

  @override
  State<EmptyStateCalendarWidget> createState() =>
      _EmptyStateCalendarWidgetState();
}

class _EmptyStateCalendarWidgetState extends State<EmptyStateCalendarWidget> {
  late EmptyStateCalendarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptyStateCalendarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      height: 60.0,
      decoration: BoxDecoration(),
    );
  }
}
