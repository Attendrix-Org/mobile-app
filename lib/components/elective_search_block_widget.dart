import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'elective_search_block_model.dart';
export 'elective_search_block_model.dart';

class ElectiveSearchBlockWidget extends StatefulWidget {
  const ElectiveSearchBlockWidget({
    super.key,
    required this.electiveCourse,
  });

  final ElectiveCourseStruct? electiveCourse;

  @override
  State<ElectiveSearchBlockWidget> createState() =>
      _ElectiveSearchBlockWidgetState();
}

class _ElectiveSearchBlockWidgetState extends State<ElectiveSearchBlockWidget> {
  late ElectiveSearchBlockModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ElectiveSearchBlockModel());

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
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              valueOrDefault<String>(
                widget.electiveCourse?.courseName,
                'Mathematics IV',
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
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'course code: ',
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
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                  TextSpan(
                    text: valueOrDefault<String>(
                      widget.electiveCourse?.courseCode,
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
                      widget.electiveCourse?.credits.toString(),
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
                      widget.electiveCourse?.slot,
                      'H',
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
          ],
        ),
      ),
    );
  }
}
