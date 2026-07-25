import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lab_course_block_model.dart';
export 'lab_course_block_model.dart';

class LabCourseBlockWidget extends StatefulWidget {
  const LabCourseBlockWidget({
    super.key,
    required this.labCourse,
    required this.selectedLabCourse,
  });

  final LabCourseSlotStruct? labCourse;
  final Future Function(EnrolledCourseStruct selectedLabCourse,
      EnrolledCourseStruct? previouslySelectedCourse)? selectedLabCourse;

  @override
  State<LabCourseBlockWidget> createState() => _LabCourseBlockWidgetState();
}

class _LabCourseBlockWidgetState extends State<LabCourseBlockWidget> {
  late LabCourseBlockModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LabCourseBlockModel());

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
      height: 120.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [FlutterFlowTheme.of(context).designToken.shadow.sm],
        borderRadius: BorderRadius.circular(
            FlutterFlowTheme.of(context).designToken.radius.sm),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.0,
                FlutterFlowTheme.of(context).designToken.spacing.xs, 0.0, 0.0),
            child: Text(
              valueOrDefault<String>(
                widget.labCourse?.courseName,
                'Strength Of Materials Lab',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 15.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
            child: RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'course code: ',
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: valueOrDefault<String>(
                      widget.labCourse?.courseCode,
                      'ME1001E',
                    ),
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).tertiary,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: '  | credits:  ',
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                  ),
                  TextSpan(
                    text: valueOrDefault<String>(
                      widget.labCourse?.credits.toString(),
                      '3',
                    ),
                    style: GoogleFonts.outfit(
                      color: FlutterFlowTheme.of(context).tertiary,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.0,
                    ),
                  )
                ],
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                    ),
              ),
            ),
          ),
          if (widget.labCourse?.hasSubBatches == true)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Choose your sub batch for the ',
                      style: GoogleFonts.outfit(
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                    TextSpan(
                      text: 'Lab Course',
                      style: FlutterFlowTheme.of(context).labelSmall.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).labelSmallFamily,
                            color: FlutterFlowTheme.of(context).tertiary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w900,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .labelSmallIsCustom,
                          ),
                    )
                  ],
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                FlutterFlowTheme.of(context).designToken.spacing.xs,
                FlutterFlowTheme.of(context).designToken.spacing.xs,
                FlutterFlowTheme.of(context).designToken.spacing.xs,
                FlutterFlowTheme.of(context).designToken.spacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Builder(
                  builder: (context) {
                    if (widget.labCourse?.hasSubBatches ?? false) {
                      return Visibility(
                        visible: widget.labCourse?.hasSubBatches == true,
                        child: FlutterFlowChoiceChips(
                          options:
                              ((List<int> weekDays, List<String> startTime) {
                            return List.generate(
                              weekDays.length,
                              (i) => '${startTime[i]} - ${const [
                                'Monday',
                                'Tuesday',
                                'Wednesday',
                                'Thursday',
                                'Friday',
                                'Saturday',
                                'Sunday'
                              ][weekDays[i] - 1]}',
                            );
                          }(
                                      widget.labCourse!.subBatches
                                          .map((e) => e.dayOfWeek)
                                          .toList(),
                                      widget.labCourse!.subBatches
                                          .map((e) => e.startTime)
                                          .toList()))
                                  .map((label) => ChipData(label))
                                  .toList(),
                          onChanged: (val) async {
                            safeSetState(() =>
                                _model.choiceChipsValue = val?.firstOrNull);
                            logFirebaseEvent(
                                'LAB_COURSE_BLOCK_ChoiceChips_dqrq5coj_ON');
                            logFirebaseEvent(
                                'ChoiceChips_update_component_state');
                            _model.selectedSubBatch = widget
                                .labCourse?.subBatches
                                .where((e) =>
                                    e.subBatch == _model.choiceChipsValue)
                                .toList()
                                .firstOrNull;
                            logFirebaseEvent('ChoiceChips_execute_callback');
                            await widget.selectedLabCourse?.call(
                              EnrolledCourseStruct(
                                courseId: widget.labCourse?.courseId,
                                courseCode: widget.labCourse?.courseCode,
                                courseName: widget.labCourse?.courseName,
                                courseType: 'LAB',
                                slot: widget.labCourse?.slot,
                                credits: widget.labCourse?.credits,
                                isLab: true,
                                isElective: false,
                                labSubBatch: _model.selectedSubBatch,
                                attendance: AttendanceStruct(
                                  attended: 0,
                                  missed: 0,
                                  percentage: 0.0,
                                ),
                              ),
                              _model.selectedCourse,
                            );
                            logFirebaseEvent(
                                'ChoiceChips_update_component_state');
                            _model.selectedCourse = EnrolledCourseStruct(
                              courseId: widget.labCourse?.courseId,
                              courseCode: widget.labCourse?.courseCode,
                              courseName: widget.labCourse?.courseName,
                              courseType: 'LAB',
                              slot: widget.labCourse?.slot,
                              credits: widget.labCourse?.credits,
                              isLab: true,
                              isElective: false,
                              labSubBatch: _model.selectedSubBatch,
                              attendance: AttendanceStruct(
                                attended: 0,
                                missed: 0,
                                percentage: 0.0,
                              ),
                            );
                            safeSetState(() {});
                          },
                          selectedChipStyle: ChipStyle(
                            backgroundColor:
                                FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            iconColor: FlutterFlowTheme.of(context).info,
                            iconSize: 16.0,
                            elevation: 0.0,
                            borderWidth: 0.0,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .bodyMediumIsCustom,
                                ),
                            iconColor:
                                FlutterFlowTheme.of(context).secondaryText,
                            iconSize: 16.0,
                            elevation: 0.0,
                            borderColor: FlutterFlowTheme.of(context).alternate,
                            borderWidth: 2.0,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          chipSpacing: 8.0,
                          rowSpacing: 8.0,
                          multiselect: false,
                          alignment: WrapAlignment.start,
                          controller: _model.choiceChipsValueController ??=
                              FormFieldController<List<String>>(
                            [],
                          ),
                          wrapped: true,
                        ),
                      );
                    } else {
                      return Container(
                        width: 1.0,
                        height: 1.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
