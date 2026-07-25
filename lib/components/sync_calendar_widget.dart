import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'sync_calendar_model.dart';
export 'sync_calendar_model.dart';

/// 📦 Create a modern, minimalistic custom dialog named SyncToCalendarDialog
/// for syncing the user's timetable calendar to their preferred device.
///
/// 🎯 Purpose:
/// Allow users to quickly subscribe to the public calendar, with two distinct
/// button actions:
/// – One for iOS users using the web version
/// – One for Android/Desktop users using Google Calendar
///
/// 🖼️ Design Guidelines:
/// Use a glassmorphic container with soft blur and drop shadow.
///
/// Rounded corners (radius: 24), padding: 24, and width: responsive
/// (maxWidth: 400px).
///
/// Background: semi-transparent white (rgba(255,255,255,0.85)).
///
/// Theme: light mode, clean edges, responsive layout.
///
/// 🧩 Layout:
/// 🔹 Title Text:
/// Text: Sync Calendar
///
/// Style: titleLarge from app theme
///
/// Alignment: Centered
///
/// 🔹 Subtitle / Context:
/// Text:
///
/// “Choose your device to sync your timetable with your calendar app. You'll
/// be asked to confirm on the next screen.”
///
/// Style: bodyMedium, muted grey (Colors.grey.shade600)
///
/// Alignment: Centered
///
/// Padding: top 12, bottom 20
///
/// 🔹 Two Buttons (Side by Side on Desktop, Stacked on Mobile):
/// ✅ Button 1 (iOS / Apple Calendar):
///
/// Text: 📱 iPhone / iPad
///
/// Action: Launch URL →
///
/// ruby
/// Copy
/// Edit
/// webcal://calendar.google.com/calendar/ical/8f6471671fa0ed8943250538ceedf97e5a8ce18b1ef09256738731bb37f57904@group.calendar.google.com/public/basic.ics
/// Style: Primary, full-width on mobile, 45% width on desktop/tablet
///
/// Tooltip: “Opens the Apple Calendar app to confirm subscription.”
///
/// ✅ Button 2 (Google Calendar / Android):
///
/// Text: 📆 Google Calendar
///
/// Action: Launch URL →
///
/// ruby
/// Copy
/// Edit
/// https://calendar.google.com/calendar/u/0/r?cid=8f6471671fa0ed8943250538ceedf97e5a8ce18b1ef09256738731bb37f57904@group.calendar.google.com
/// Style: Secondary or tonal button, same layout specs
///
/// 📝 Footer Text (Contextual Help):
/// Text:
///
/// “Need help or want to understand how syncing works?”
///
/// Below that, add:
///
/// 👉 [Read the Docs]
///
/// Make “Read the Docs” a clickable text button with:
///
/// Bold font (labelLarge)
///
/// Color: primary theme color
///
/// Action: Open URL → link to your calendar docs/help page
///
/// 🧠 Behavior:
/// Dismiss dialog by tapping outside or pressing “X” icon at top-right
/// (optional).
///
/// Responsive layout:
///
/// On mobile → buttons stack vertically
///
/// On desktop → buttons shown side by side with spacing (gap: 12px)
class SyncCalendarWidget extends StatefulWidget {
  const SyncCalendarWidget({
    super.key,
    this.calendarID,
  });

  final String? calendarID;

  @override
  State<SyncCalendarWidget> createState() => _SyncCalendarWidgetState();
}

class _SyncCalendarWidgetState extends State<SyncCalendarWidget> {
  late SyncCalendarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SyncCalendarModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 32.0,
            color: Color(0x33000000),
            offset: Offset(
              0.0,
              8.0,
            ),
            spreadRadius: 0.0,
          )
        ],
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(),
                ),
                Text(
                  'Sync with Google Calendar',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).titleLargeFamily,
                        fontSize: 24.0,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).titleLargeIsCustom,
                      ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Automatically sync your classes, labs, exams, and academic events with Google Calendar. You\'ll securely review and approve the connection through Google on the next screen.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                      ),
                ),
              ].divide(SizedBox(height: 12.0)),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FFButtonWidget(
                  onPressed: () async {
                    logFirebaseEvent(
                        'SYNC_CALENDAR_CONTINUE_WITH_GOOGLE_BTN_O');
                    logFirebaseEvent('Button_custom_action');
                    await actions.connectGoogleCalendar();
                  },
                  text: 'Continue with Google',
                  icon: Icon(
                    FFIcons.kgoogle,
                    size: 24.0,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconColor: FlutterFlowTheme.of(context).info,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          color: FlutterFlowTheme.of(context).info,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    logFirebaseEvent('SYNC_CALENDAR_COMP_DISMISS_BTN_ON_TAP');
                    logFirebaseEvent('Button_dismiss_dialog');
                    Navigator.pop(context);
                  },
                  text: 'Dismiss',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleSmallFamily,
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                              !FlutterFlowTheme.of(context).titleSmallIsCustom,
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ].divide(SizedBox(height: 6.0)),
            ),
          ].divide(SizedBox(height: 16.0)),
        ),
      ),
    );
  }
}
