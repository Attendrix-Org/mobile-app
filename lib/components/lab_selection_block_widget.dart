import '/backend/schema/structs/index.dart';
import '/components/lab_search_block_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lab_selection_block_model.dart';
export 'lab_selection_block_model.dart';

class LabSelectionBlockWidget extends StatefulWidget {
  const LabSelectionBlockWidget({
    super.key,
    required this.courseBlocks,
    required this.requiredlabCourseCode,
    required this.addSelectedLabCourse,
    required this.removeSelectedLabCourse,
  });

  final List<EnrolledCourseStruct>? courseBlocks;
  final String? requiredlabCourseCode;
  final Future Function(EnrolledCourseStruct selectedLabCourse)?
      addSelectedLabCourse;
  final Future Function(EnrolledCourseStruct selectedLabCourseToRemove)?
      removeSelectedLabCourse;

  @override
  State<LabSelectionBlockWidget> createState() =>
      _LabSelectionBlockWidgetState();
}

class _LabSelectionBlockWidgetState extends State<LabSelectionBlockWidget> {
  late LabSelectionBlockModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LabSelectionBlockModel());

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
          if (_model.labSelected) {
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
                          _model.selectedLabCourse?.courseName,
                          'CourseName Not Defined',
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
                                _model.selectedLabCourse?.courseCode,
                                'ME1001E',
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
                                _model.selectedLabCourse?.credits.toString(),
                                '2',
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
                                _model.selectedLabCourse?.slot,
                                'R1',
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
                          'LAB_SELECTION_BLOCK_Icon_7mjdpt03_ON_TAP');
                      logFirebaseEvent('Icon_execute_callback');
                      await widget.removeSelectedLabCourse?.call(
                        _model.selectedLabCourse!,
                      );
                      logFirebaseEvent('Icon_update_component_state');
                      _model.labSelected = false;
                      _model.selectedLabCourse = null;
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
              child: Builder(
                builder: (context) => InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    logFirebaseEvent(
                        'LAB_SELECTION_BLOCK_Container_71bimphu_O');
                    logFirebaseEvent('Container_alert_dialog');
                    await showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return Dialog(
                          elevation: 0,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          alignment: AlignmentDirectional(0.0, 0.0)
                              .resolve(Directionality.of(context)),
                          child: LabSearchBlockWidget(
                            labCourseSearchItems: widget.courseBlocks!
                                .where((e) =>
                                    e.courseCode ==
                                    widget.requiredlabCourseCode)
                                .toList(),
                            returnSelectedLabCourse:
                                (selectedCourseBlock) async {
                              logFirebaseEvent('_update_component_state');
                              _model.selectedLabCourse = selectedCourseBlock;
                              _model.labSelected = true;
                              safeSetState(() {});
                            },
                          ),
                        );
                      },
                    );

                    logFirebaseEvent('Container_execute_callback');
                    await widget.addSelectedLabCourse?.call(
                      _model.selectedLabCourse!,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.all(
                          FlutterFlowTheme.of(context).designToken.spacing.sm),
                      child: Text(
                        'Choose your slot for ${widget.courseBlocks?.where((e) => e.courseCode == widget.requiredlabCourseCode).toList().firstOrNull?.courseName}',
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
              ),
            );
          }
        },
      ),
    );
  }
}
