import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
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

  LatLng? currentUserLocationValue;

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
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
      if (widget.classBlock?.venue !=
          FFAppState().currentClassBuildingData.id) {
        logFirebaseEvent('classBlock_NextClass_backend_call');
        _model.venueBuildingId = await CampusBuildingsTable().queryRows(
          queryFn: (q) => q.eqOrNull(
            'id',
            widget.classBlock?.venue,
          ),
        );
        logFirebaseEvent('classBlock_NextClass_update_app_state');
        FFAppState().currentClassBuildingData = CampusBuildingStruct(
          id: _model.venueBuildingId?.firstOrNull?.id,
          name: _model.venueBuildingId?.firstOrNull?.name,
          category: _model.venueBuildingId?.firstOrNull?.category,
          lat: _model.venueBuildingId?.firstOrNull?.lat,
          lng: _model.venueBuildingId?.firstOrNull?.lng,
          nearestNodeId: _model.venueBuildingId?.firstOrNull?.nearestNodeId,
          snapDistM: _model.venueBuildingId?.firstOrNull?.snapDistM,
          description: _model.venueBuildingId?.firstOrNull?.description,
          createdAt: _model.venueBuildingId?.firstOrNull?.createdAt?.toString(),
        );
      }
      logFirebaseEvent('classBlock_NextClass_start_periodic_acti');
      _model.progressBarTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 20000),
        callback: (timer) async {
          currentUserLocationValue =
              await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
          logFirebaseEvent('classBlock_NextClass_custom_action');
          _model.walkRouteData = await actions.calculateWalkRoute(
            currentUserLocationValue!,
            functions.mapLatLng(FFAppState().currentClassBuildingData.lat,
                FFAppState().currentClassBuildingData.lng),
            false,
            widget.classBlock?.scheduledStart,
            FFDevEnvironmentValues().orsAPIKEY,
            FFAppState().currentClassBuildingData.id,
          );
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
        color: FlutterFlowTheme.of(context).secondaryBackground,
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
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
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
                            return 'It\'s ${_model.walkRouteDataState?.distanceMeters.toString()}m from here!';
                          } else {
                            return 'Ongoing Class:';
                          }
                        }(),
                        'Ongoing Class:',
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.outfit(
                              fontWeight: FontWeight.w800,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).tertiary,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w800,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      decoration: BoxDecoration(),
                      child: Text(
                        valueOrDefault<String>(
                          widget.classBlock?.courseName,
                          'CourseName Not Defined',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
                      child: Text(
                        '${dateTimeFormat(
                          "MMMMEEEEd",
                          widget.classBlock?.scheduledStart,
                          locale: FFLocalizations.of(context).languageCode,
                        )}, ${functions.formatClassTime(widget.classBlock?.scheduledStart, FFAppState().userPreferences.preferredTimeFormat)} - ${functions.formatClassTime(widget.classBlock?.scheduledEnd, FFAppState().userPreferences.preferredTimeFormat)}',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 11.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 2.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        height: 2.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 80.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    FFIcons.kmapShare,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 28.0,
                                  ),
                                ].divide(SizedBox(width: 4.0)),
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'View In Maps',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 8.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        lineHeight: 1.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .labelMediumIsCustom,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
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
            Builder(
              builder: (context) {
                if (widget.classBlock!.scheduledStart! > getCurrentTimestamp) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          functions.generateRelativeTime(
                              widget.classBlock?.scheduledStart, true),
                          'in 7 Hours 56 Minutes',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.w800,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w800,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 0.45,
                        height: 35.0,
                        decoration: BoxDecoration(
                          color: valueOrDefault<Color>(
                            () {
                              if (_model.walkRouteDataState!.isLate) {
                                return FlutterFlowTheme.of(context).error;
                              } else if (_model
                                  .walkRouteDataState!.isLeaveNow) {
                                return FlutterFlowTheme.of(context).success;
                              } else {
                                return FlutterFlowTheme.of(context)
                                    .primaryBackground;
                              }
                            }(),
                            FlutterFlowTheme.of(context).primaryBackground,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.34,
                              decoration: BoxDecoration(),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 4.0, 0.0),
                                  child: AutoSizeText(
                                    valueOrDefault<String>(
                                      _model.walkRouteDataState?.statusMessage,
                                      'Leave Now!',
                                    ),
                                    maxLines: 2,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          fontSize: 14.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ),
                            ),
                            Icon(
                              FFIcons.klocation,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 18.0,
                            ),
                          ].divide(SizedBox(width: 0.0)),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    height: 30.0,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                      child: LinearPercentIndicator(
                        percent: functions.getScheduleProgress(
                            widget.classBlock!.scheduledStart!,
                            widget.classBlock!.scheduledEnd!,
                            getCurrentTimestamp),
                        lineHeight: 20.0,
                        animation: true,
                        animateFromLastPercent: true,
                        progressColor: FlutterFlowTheme.of(context).tertiary,
                        backgroundColor: Color(0x9AE1CDCD),
                        center: Text(
                          valueOrDefault<String>(
                            functions.subtractDuration(
                                widget.classBlock!.scheduledEnd!,
                                getCurrentTimestamp),
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
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.65,
                      decoration: BoxDecoration(),
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
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                fontSize: 8.0,
                                letterSpacing: 0.0,
                                lineHeight: 1.38,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
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
