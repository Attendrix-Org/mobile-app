import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'class_widget_model.dart';
export 'class_widget_model.dart';

class ClassWidgetWidget extends StatefulWidget {
  const ClassWidgetWidget({
    super.key,
    required this.classesRecords,
  });

  final List<ScheduledClassStruct>? classesRecords;

  @override
  State<ClassWidgetWidget> createState() => _ClassWidgetWidgetState();
}

class _ClassWidgetWidgetState extends State<ClassWidgetWidget> {
  late ClassWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClassWidgetModel());

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
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              valueOrDefault<String>(
                () {
                  if (widget.classesRecords!
                          .sortedList(
                              keyOf: (e) => e.scheduledStart!, desc: false)
                          .firstOrNull!
                          .scheduledStart! >
                      getCurrentTimestamp) {
                    return 'Next Up:';
                  } else if ((widget.classesRecords!
                              .sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull!
                              .scheduledStart! <
                          getCurrentTimestamp) &&
                      (widget.classesRecords!
                              .sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull!
                              .scheduledEnd! >
                          getCurrentTimestamp) &&
                      (valueOrDefault<String>(
                                widget.classesRecords
                                    ?.sortedList(
                                        keyOf: (e) => e.scheduledStart!,
                                        desc: false)
                                    .firstOrNull
                                    ?.venue,
                                'CourseName Not Defined',
                              ) !=
                              '')) {
                    return 'Currently happening in ${valueOrDefault<String>(
                      widget.classesRecords
                          ?.sortedList(
                              keyOf: (e) => e.scheduledStart!, desc: false)
                          .firstOrNull
                          ?.venue,
                      'CourseName Not Defined',
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
                widget.classesRecords
                    ?.sortedList(keyOf: (e) => e.scheduledStart!, desc: false)
                    .firstOrNull
                    ?.courseName,
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
                FFAppState().userPreferences.preferredTimeFormat ==
                        TimeFormat.twelveHour
                    ? '${valueOrDefault<String>(
                        dateTimeFormat(
                          "MMMEd",
                          widget.classesRecords
                              ?.sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull
                              ?.scheduledStart,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        'CourseName Not Defined',
                      )}, ${valueOrDefault<String>(
                        dateTimeFormat(
                          "jm",
                          widget.classesRecords
                              ?.sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull
                              ?.scheduledStart,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        'CourseName Not Defined',
                      )} - ${valueOrDefault<String>(
                        dateTimeFormat(
                          "jm",
                          widget.classesRecords
                              ?.sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull
                              ?.scheduledEnd,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        'CourseName Not Defined',
                      )}'
                    : '${valueOrDefault<String>(
                        dateTimeFormat(
                          "MMMEd",
                          widget.classesRecords
                              ?.sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull
                              ?.scheduledStart,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        'CourseName Not Defined',
                      )}, ${valueOrDefault<String>(
                        dateTimeFormat(
                          "Hm",
                          widget.classesRecords
                              ?.sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull
                              ?.scheduledStart,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        'CourseName Not Defined',
                      )} - ${valueOrDefault<String>(
                        dateTimeFormat(
                          "Hm",
                          widget.classesRecords
                              ?.sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull
                              ?.scheduledEnd,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        'CourseName Not Defined',
                      )} Hours',
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
                  widget.classesRecords!
                              .sortedList(
                                  keyOf: (e) => e.scheduledStart!, desc: false)
                              .firstOrNull!
                              .scheduledStart! >
                          getCurrentTimestamp
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
                if (widget.classesRecords!
                        .sortedList(
                            keyOf: (e) => e.scheduledStart!, desc: false)
                        .firstOrNull!
                        .scheduledStart! >
                    getCurrentTimestamp) {
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
                              'Hello World',
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
                            widget.classesRecords!
                                .sortedList(
                                    keyOf: (e) => e.scheduledStart!,
                                    desc: false)
                                .firstOrNull!
                                .scheduledStart!,
                            widget.classesRecords!
                                .sortedList(
                                    keyOf: (e) => e.scheduledStart!,
                                    desc: false)
                                .firstOrNull!
                                .scheduledEnd!,
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
                                widget.classesRecords!
                                    .sortedList(
                                        keyOf: (e) => e.scheduledStart!,
                                        desc: false)
                                    .firstOrNull!
                                    .scheduledStart!,
                                widget.classesRecords!
                                    .sortedList(
                                        keyOf: (e) => e.scheduledStart!,
                                        desc: false)
                                    .firstOrNull!
                                    .scheduledEnd!,
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
                            EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 0.0, 0.0),
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You have ${widget.classesRecords?.length.toString()} classes today!',
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
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final todayClassesWidgetView = widget.classesRecords!
                            .where(
                                (e) => e.scheduledStart! > getCurrentTimestamp)
                            .toList()
                            .take(3)
                            .toList();

                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: todayClassesWidgetView.length,
                          itemBuilder: (context, todayClassesWidgetViewIndex) {
                            final todayClassesWidgetViewItem =
                                todayClassesWidgetView[
                                    todayClassesWidgetViewIndex];
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 2.0),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: double.infinity,
                                height: 45.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  boxShadow: [
                                    FlutterFlowTheme.of(context)
                                        .designToken
                                        .shadow
                                        .sm
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      FlutterFlowTheme.of(context)
                                          .designToken
                                          .radius
                                          .sm),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 0.0, 0.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        valueOrDefault<String>(
                                          todayClassesWidgetViewItem.courseName,
                                          'Course Name Not Defined',
                                        ),
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 15.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 2.0),
                                        child: Text(
                                          FFAppState()
                                                      .userPreferences
                                                      .preferredTimeFormat ==
                                                  TimeFormat.twelveHour
                                              ? '${dateTimeFormat(
                                                  "MMMEd",
                                                  todayClassesWidgetViewItem
                                                      .scheduledStart,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                )}, ${dateTimeFormat(
                                                  "jm",
                                                  todayClassesWidgetViewItem
                                                      .scheduledStart,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                )} - ${dateTimeFormat(
                                                  "jm",
                                                  todayClassesWidgetViewItem
                                                      .scheduledEnd,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                )}'
                                              : '${dateTimeFormat(
                                                  "MMMEd",
                                                  todayClassesWidgetViewItem
                                                      .scheduledStart,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                )}, ${dateTimeFormat(
                                                  "Hm",
                                                  todayClassesWidgetViewItem
                                                      .scheduledStart,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                )} - ${dateTimeFormat(
                                                  "Hm",
                                                  todayClassesWidgetViewItem
                                                      .scheduledEnd,
                                                  locale: FFLocalizations.of(
                                                          context)
                                                      .languageCode,
                                                )} Hours',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                                fontSize: 11.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
