import '/backend/schema/structs/index.dart';
import '/components/course_search_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'elective_course_block_model.dart';
export 'elective_course_block_model.dart';

class ElectiveCourseBlockWidget extends StatefulWidget {
  const ElectiveCourseBlockWidget({
    super.key,
    required this.electiveCategory,
    required this.electiveData,
    required this.selectedElectiveCourse,
    required this.removeSelectedElective,
  });

  final String? electiveCategory;
  final List<ElectiveCourseStruct>? electiveData;
  final Future Function(EnrolledCourseStruct electiveCourse)?
      selectedElectiveCourse;
  final Future Function(EnrolledCourseStruct electiveCourseData)?
      removeSelectedElective;

  @override
  State<ElectiveCourseBlockWidget> createState() =>
      _ElectiveCourseBlockWidgetState();
}

class _ElectiveCourseBlockWidgetState extends State<ElectiveCourseBlockWidget> {
  late ElectiveCourseBlockModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ElectiveCourseBlockModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 45.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [FlutterFlowTheme.of(context).designToken.shadow.sm],
        borderRadius: BorderRadius.circular(
            FlutterFlowTheme.of(context).designToken.radius.sm),
      ),
      child: Builder(
        builder: (context) {
          if (_model.electiveSelected) {
            return Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  FlutterFlowTheme.of(context).designToken.spacing.xs,
                  0.0,
                  FlutterFlowTheme.of(context).designToken.spacing.sm,
                  0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        valueOrDefault<String>(
                          _model.selectedElectiveCourse?.courseName,
                          'Mathematics IV',
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 15.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'course code: ',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                            TextSpan(
                              text: valueOrDefault<String>(
                                _model.selectedElectiveCourse?.courseCode,
                                'ME1011E',
                              ),
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0,
                              ),
                            ),
                            TextSpan(
                              text: ' | credits: ',
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                            ),
                            TextSpan(
                              text: valueOrDefault<String>(
                                _model.selectedElectiveCourse?.credits
                                    .toString(),
                                '3',
                              ),
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0,
                              ),
                            ),
                            TextSpan(
                              text: ' | slot: ',
                              style: TextStyle(),
                            ),
                            TextSpan(
                              text: valueOrDefault<String>(
                                _model.selectedElectiveCourse?.slot,
                                'H',
                              ),
                              style: GoogleFonts.outfit(
                                color: FlutterFlowTheme.of(context).tertiary,
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0,
                              ),
                            )
                          ],
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .bodyMediumIsCustom,
                              ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      logFirebaseEvent(
                          'ELECTIVE_COURSE_BLOCK_Icon_ttkdio8i_ON_T');
                      logFirebaseEvent('Icon_execute_callback');
                      await widget.removeSelectedElective?.call(
                        EnrolledCourseStruct(
                          courseId: _model.selectedElectiveCourse?.courseId,
                          courseCode: _model.selectedElectiveCourse?.courseCode,
                          courseName: _model.selectedElectiveCourse?.courseName,
                          courseType:
                              _model.selectedElectiveCourse?.electiveCategory,
                          slot: _model.selectedElectiveCourse?.slot,
                          credits: _model.selectedElectiveCourse?.credits,
                          isLab: false,
                          isElective: true,
                          electiveCategory:
                              _model.selectedElectiveCourse?.courseId,
                          attendance: AttendanceStruct(
                            attended: 0,
                            missed: 0,
                            percentage: 0.0,
                          ),
                        ),
                      );
                      logFirebaseEvent('Icon_update_component_state');
                      _model.electiveSelected = false;
                      _model.selectedElectiveCourse = null;
                      safeSetState(() {});
                    },
                    child: Icon(
                      FFIcons.kxCircleCloseDelete,
                      color: FlutterFlowTheme.of(context).error,
                      size: 28.0,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  logFirebaseEvent('ELECTIVE_COURSE_BLOCK_Container_7p9lav1f');
                  logFirebaseEvent('Container_bottom_sheet');
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.viewInsetsOf(context),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.6,
                          child: CourseSearchWidget(
                            electiveData: widget.electiveData!
                                .where((e) =>
                                    e.electiveCategory ==
                                    widget.electiveCategory)
                                .toList(),
                            selectedElective: (electiveCourse) async {
                              logFirebaseEvent('_update_component_state');
                              _model.selectedElectiveCourse = electiveCourse;
                              _model.electiveSelected = true;
                              safeSetState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));

                  logFirebaseEvent('Container_execute_callback');
                  await widget.selectedElectiveCourse?.call(
                    EnrolledCourseStruct(
                      courseId: _model.selectedElectiveCourse?.courseId,
                      courseCode: _model.selectedElectiveCourse?.courseCode,
                      courseName: _model.selectedElectiveCourse?.courseName,
                      courseType:
                          _model.selectedElectiveCourse?.electiveCategory,
                      slot: _model.selectedElectiveCourse?.slot,
                      credits: _model.selectedElectiveCourse?.credits,
                      isLab: false,
                      isElective: true,
                      electiveCategory: _model.selectedElectiveCourse?.courseId,
                      attendance: AttendanceStruct(
                        attended: 0,
                        missed: 0,
                        percentage: 0.0,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding: EdgeInsets.all(
                        FlutterFlowTheme.of(context).designToken.spacing.sm),
                    child: Text(
                      'Tap to Choose Your ${valueOrDefault<String>(
                        widget.electiveCategory,
                        'OE',
                      )} Elective',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyMediumFamily,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .bodyMediumIsCustom,
                          ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
