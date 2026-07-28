import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'manage_course_notification_model.dart';
export 'manage_course_notification_model.dart';

class ManageCourseNotificationWidget extends StatefulWidget {
  const ManageCourseNotificationWidget({
    super.key,
    this.parameter1,
  });

  final String? parameter1;

  @override
  State<ManageCourseNotificationWidget> createState() =>
      _ManageCourseNotificationWidgetState();
}

class _ManageCourseNotificationWidgetState
    extends State<ManageCourseNotificationWidget> {
  late ManageCourseNotificationModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageCourseNotificationModel());

    _model.switchValue = false;
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
      child: AnimatedContainer(
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Text(
                widget.parameter1!,
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
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
              child: Switch(
                value: _model.switchValue!,
                onChanged: (newValue) async {
                  safeSetState(() => _model.switchValue = newValue);
                  if (newValue) {
                    logFirebaseEvent(
                        'MANAGE_COURSE_NOTIFICATION_Switch_xcpn3j');
                    logFirebaseEvent('Switch_custom_action');
                    await actions.optInPushNotifications();
                  } else {
                    logFirebaseEvent(
                        'MANAGE_COURSE_NOTIFICATION_Switch_xcpn3j');
                    logFirebaseEvent('Switch_custom_action');
                    await actions.optOutPushNotifications();
                  }
                },
                activeThumbColor: FlutterFlowTheme.of(context).info,
                activeTrackColor: FlutterFlowTheme.of(context).primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
