import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'empty_state_container_model.dart';
export 'empty_state_container_model.dart';

/// An Empty State Container with a text Saying The Reason
class EmptyStateContainerWidget extends StatefulWidget {
  const EmptyStateContainerWidget({
    super.key,
    String? title,
    String? message,
    required this.date,
  })  : this.title = title ?? '',
        this.message = message ?? '';

  final String title;
  final String message;
  final DateTime? date;

  @override
  State<EmptyStateContainerWidget> createState() =>
      _EmptyStateContainerWidgetState();
}

class _EmptyStateContainerWidgetState extends State<EmptyStateContainerWidget> {
  late EmptyStateContainerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptyStateContainerModel());

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
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            valueOrDefault<String>(
              functions
                  .getEmptyStateMessage(
                      widget.date,
                      FFAppState().userPreferences.preferredActionTone,
                      dateTimeFormat(
                        "d/M/y",
                        widget.date,
                        locale: FFLocalizations.of(context).languageCode,
                      ))
                  .firstOrNull,
              'Nothing Here!',
            ),
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  lineHeight: 1.27,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).titleLargeIsCustom,
                ),
          ),
          Text(
            valueOrDefault<String>(
              functions
                  .getEmptyStateMessage(
                      widget.date,
                      FFAppState().userPreferences.preferredActionTone,
                      dateTimeFormat(
                        "d/M/y",
                        widget.date,
                        locale: FFLocalizations.of(context).languageCode,
                      ))
                  .lastOrNull,
              'No classes were scheduled for this day. It may have been a holiday, a timetable update, or simply a class-free day.',
            ),
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  lineHeight: 1.47,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
        ].divide(SizedBox(height: 4.0)),
      ),
    );
  }
}
