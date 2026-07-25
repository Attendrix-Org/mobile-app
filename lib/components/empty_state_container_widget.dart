import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

    return FutureBuilder<List<AcademicCalendarEventsRow>>(
      future: FFAppState().currentDayAcademicCalendar(
        uniqueQueryKey: 'CALENDAR_DAY_${dateTimeFormat(
          "d/M/y",
          getCurrentTimestamp,
          locale: FFLocalizations.of(context).languageCode,
        )}',
        requestFn: () => AcademicCalendarEventsTable().querySingleRow(
          queryFn: (q) => q.eqOrNull(
            'formatted_date',
            dateTimeFormat(
              "d/M/y",
              getCurrentTimestamp,
              locale: FFLocalizations.of(context).languageCode,
            ),
          ),
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 25.0,
              height: 25.0,
              child: SpinKitFadingCube(
                color: FlutterFlowTheme.of(context).primary,
                size: 25.0,
              ),
            ),
          );
        }
        List<AcademicCalendarEventsRow> containerAcademicCalendarEventsRowList =
            snapshot.data!;

        final containerAcademicCalendarEventsRow =
            containerAcademicCalendarEventsRowList.isNotEmpty
                ? containerAcademicCalendarEventsRowList.first
                : null;

        return Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: 180.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(16.0),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: FlutterFlowTheme.of(context).alternate,
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  FFAppConstants.icons.elementAtOrNull(valueOrDefault<int>(
                    functions.deterministicIndex(
                        dateTimeFormat(
                          "d/M/y",
                          widget.date,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        17),
                    5,
                  ))!,
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.cover,
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
      },
    );
  }
}
