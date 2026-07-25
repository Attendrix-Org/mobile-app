import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'class_block_next_class_model.dart';
export 'class_block_next_class_model.dart';

class ClassBlockNextClassWidget extends StatefulWidget {
  const ClassBlockNextClassWidget({
    super.key,
    required this.classBlock,
  });

  final ScheduledClassStruct? classBlock;

  @override
  State<ClassBlockNextClassWidget> createState() =>
      _ClassBlockNextClassWidgetState();
}

class _ClassBlockNextClassWidgetState extends State<ClassBlockNextClassWidget> {
  late ClassBlockNextClassModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClassBlockNextClassModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('CLASS_BLOCK_NEXT_CLASS_classBlock_NextCl');
      logFirebaseEvent('classBlock_NextClass_start_periodic_acti');
      _model.progressBarTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 2000),
        callback: (timer) async {
          logFirebaseEvent('classBlock_NextClass_update_component_st');
          _model.lastUpdatedAt = getCurrentTimestamp;
          safeSetState(() {});
        },
        startImmediately: true,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On component dispose action.
    () async {
      logFirebaseEvent('CLASS_BLOCK_NEXT_CLASS_classBlock_NextCl');
      logFirebaseEvent('classBlock_NextClass_stop_periodic_actio');
      _model.progressBarTimer?.cancel();
    }();

    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      height: 138.0,
      decoration: BoxDecoration(
        color: Color(0xEBF2F1FF),
        boxShadow: [
          BoxShadow(
            blurRadius: 3.0,
            color: Color(0x33000000),
            offset: Offset(
              0.0,
              1.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              valueOrDefault<String>(
                () {
                  if (widget.classBlock!.scheduledStart! >
                      getCurrentTimestamp) {
                    return 'Next Up:';
                  } else if ((widget.classBlock!.scheduledStart! <
                          getCurrentTimestamp) &&
                      (widget.classBlock!.scheduledEnd! >
                          getCurrentTimestamp) &&
                      (widget.classBlock?.venue != null &&
                          widget.classBlock?.venue != '')) {
                    return 'Currently happening in ${valueOrDefault<String>(
                      widget.classBlock?.venue,
                      'ELHC ',
                    )}';
                  } else {
                    return 'Ongoing Class:';
                  }
                }(),
                'Ongoing Class:',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).tertiary,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w800,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
            Text(
              valueOrDefault<String>(
                widget.classBlock?.courseName,
                'CourseName Not Defined',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
              child: Text(
                '${dateTimeFormat(
                  "MMMMEEEEd",
                  widget.classBlock?.scheduledStart,
                  locale: FFLocalizations.of(context).languageCode,
                )}, ${functions.formatClassTime(widget.classBlock?.scheduledStart, FFAppState().userPreferences.preferredTimeFormat)} - ${functions.formatClassTime(widget.classBlock?.scheduledEnd, FFAppState().userPreferences.preferredTimeFormat)}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 11.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
            Divider(
              thickness: 1.0,
              indent: 4.0,
              endIndent: 4.0,
              color: Color(0xC5606A85),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  widget.classBlock!.scheduledStart! > getCurrentTimestamp
                      ? 'Class Starts in:'
                      : 'Class Progress: ',
                  'Class Starts in:',
                ),
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 11.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
            Builder(
              builder: (context) {
                if (widget.classBlock!.scheduledStart! > getCurrentTimestamp) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                4.0, 0.0, 0.0, 0.0),
                            child: Text(
                              functions.generateRelativeTime(
                                  widget.classBlock?.scheduledStart, true),
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 20.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w800,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        FFIcons.kclockCountdownBold,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 26.0,
                      ),
                    ],
                  );
                } else {
                  return Container(
                    height: 30.0,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: LinearPercentIndicator(
                        percent: functions.getScheduleProgress(
                            widget.classBlock!.scheduledStart!,
                            widget.classBlock!.scheduledEnd!,
                            getCurrentTimestamp),
                        lineHeight: 24.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).tertiary,
                        backgroundColor: Color(0x9AE1CDCD),
                        center: Text(
                          valueOrDefault<String>(
                            (double progress) {
                              return '${(progress * 100).toStringAsFixed(1)}%';
                            }(functions.getScheduleProgress(
                                widget.classBlock!.scheduledStart!,
                                widget.classBlock!.scheduledEnd!,
                                getCurrentTimestamp)),
                            '~%',
                          ),
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .headlineSmallFamily,
                                fontSize: 12.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .headlineSmallIsCustom,
                              ),
                        ),
                        barRadius: Radius.circular(18.0),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  );
                }
              },
            ),
            Align(
              alignment: AlignmentDirectional(1.0, -1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.65,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                        child: RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Automatically updates every 2 minutes.',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 8.0,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.38,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                              )
                            ],
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 8.0,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.38,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'updated ${dateTimeFormat(
                        "relative",
                        _model.lastUpdatedAt,
                        locale: FFLocalizations.of(context).languageCode,
                      )}',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelMediumFamily,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 8.0,
                            letterSpacing: 0.0,
                            lineHeight: 1.38,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelMediumIsCustom,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
