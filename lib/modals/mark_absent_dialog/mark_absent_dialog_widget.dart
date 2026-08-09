import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'mark_absent_dialog_model.dart';
export 'mark_absent_dialog_model.dart';

class MarkAbsentDialogWidget extends StatefulWidget {
  const MarkAbsentDialogWidget({
    super.key,
    required this.classBlock,
  });

  final ScheduledClassStruct? classBlock;

  @override
  State<MarkAbsentDialogWidget> createState() => _MarkAbsentDialogWidgetState();
}

class _MarkAbsentDialogWidgetState extends State<MarkAbsentDialogWidget> {
  late MarkAbsentDialogModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarkAbsentDialogModel());

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
      width: MediaQuery.sizeOf(context).width * 0.75,
      height: 240.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Mark as Absent?',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily:
                        FlutterFlowTheme.of(context).headlineSmallFamily,
                    fontSize: 18.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts:
                        !FlutterFlowTheme.of(context).headlineSmallIsCustom,
                  ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                child: RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'You\'re about to mark yourself absent for this class.\n',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                          widget.classBlock?.courseName,
                          'Operating Systems',
                        ),
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).tertiary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      TextSpan(
                        text: '\n',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0,
                        ),
                      ),
                      TextSpan(
                        text: '${dateTimeFormat(
                          "MMMMEEEEd",
                          widget.classBlock?.scheduledStart,
                          locale: FFLocalizations.of(context).languageCode,
                        )}, ${functions.formatClassTime(widget.classBlock?.scheduledStart, FFAppState().userPreferences.preferredTimeFormat)} - ${functions.formatClassTime(widget.classBlock?.scheduledEnd, FFAppState().userPreferences.preferredTimeFormat)}',
                        style: GoogleFonts.outfit(
                          color: Color(0xFF9489F5),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      TextSpan(
                        text: '\n',
                        style: TextStyle(),
                      ),
                      TextSpan(
                        text:
                            'By default, Attendrix considers you present for this class. Mark yourself absent only if you were absent.\n',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.0,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Your attendance percentage may be updated after this change.',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).absentRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 8.0,
                        ),
                      )
                    ],
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.outfit(
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  logFirebaseEvent('MARK_ABSENT_DIALOG_MARK_AS_ABSENT_BTN_ON');
                  logFirebaseEvent('Button_custom_action');
                  _model.markAbsentfeedback = await actions.markAbsent(
                    widget.classBlock!,
                    'student',
                    'Marked By Student',
                  );
                  logFirebaseEvent('Button_show_snack_bar');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _model.markAbsentfeedback!.success
                            ? 'Attendance updated. Absence marked.'
                            : 'Failed to mark absence. Please try again.',
                        style: GoogleFonts.outfit(
                          color: FlutterFlowTheme.of(context).info,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                      ),
                      duration: Duration(milliseconds: 2000),
                      backgroundColor: _model.markAbsentfeedback!.success
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).error,
                      action: SnackBarAction(
                        label: 'Revert',
                        textColor: FlutterFlowTheme.of(context).info,
                        onPressed: () async {
                          await actions.unMarkAbsent(
                            widget.classBlock!,
                          );
                        },
                      ),
                    ),
                  );
                  logFirebaseEvent('Button_dismiss_dialog');
                  Navigator.pop(context);

                  safeSetState(() {});
                },
                text: 'Mark as Absent',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 48.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).error,
                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 3.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  logFirebaseEvent('MARK_ABSENT_DIALOG_KEEP_AS_PRESENT_BTN_O');
                  logFirebaseEvent('Button_close_dialog_drawer_etc');
                  Navigator.pop(context);
                },
                text: 'Keep as Present',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 44.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).alternate,
                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                  elevation: 0.0,
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
