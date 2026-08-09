import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/flutter_flow/permissions_util.dart';
import '/index.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'manage_notifications_model.dart';
export 'manage_notifications_model.dart';

class ManageNotificationsWidget extends StatefulWidget {
  const ManageNotificationsWidget({super.key});

  static String routeName = 'ManageNotifications';
  static String routePath = 'manageNotifications';

  @override
  State<ManageNotificationsWidget> createState() =>
      _ManageNotificationsWidgetState();
}

class _ManageNotificationsWidgetState extends State<ManageNotificationsWidget> {
  late ManageNotificationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ManageNotificationsModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'ManageNotifications'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('MANAGE_NOTIFICATIONS_ManageNotifications');
      if (await getPermissionStatus(notificationsPermission)) {
        logFirebaseEvent('ManageNotifications_update_page_state');
        _model.userPreferences = FFAppState().userPreferences;
        safeSetState(() {});
      } else {
        logFirebaseEvent('ManageNotifications_request_permissions');
        await requestPermission(notificationsPermission);
        if (!(await getPermissionStatus(notificationsPermission))) {
          logFirebaseEvent('ManageNotifications_navigate_to');

          context.goNamed(SettingsWidget.routeName);

          logFirebaseEvent('ManageNotifications_show_snack_bar');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Enable notification permission in your device settings to manage notification preferences.',
                style: GoogleFonts.outfit(
                  color: FlutterFlowTheme.of(context).info,
                  fontWeight: FontWeight.w600,
                ),
              ),
              duration: Duration(milliseconds: 4000),
              backgroundColor: FlutterFlowTheme.of(context).error,
            ),
          );
          return;
        }
      }

      logFirebaseEvent('ManageNotifications_update_page_state');
      _model.userPreferences = FFAppState().userPreferences;
      safeSetState(() {});
    });

    _model.optInValue = _model.userPreferences!.notificationsEnabled;
    _model.enableClassNotificationsValue =
        FFAppState().userPreferences.notifClassReminder;
    _model.classRemindersValue =
        FFAppState().userPreferences.notifClassReminder;
    _model.classCancellationsValue =
        FFAppState().userPreferences.notifClassCancelled;
    _model.classRescheduleValue =
        FFAppState().userPreferences.notifClassCancelled;
    _model.enableMessNotificationsValue =
        _model.userPreferences!.notifMessReminder;
    _model.breakfastValue = _model.userPreferences!.notifBreakfastReminder;
    _model.lunchValue = _model.userPreferences!.notifLunchReminder;
    _model.eveningSnacksValue = _model.userPreferences!.notifEveningTeaReminder;
    _model.dinnerValue = _model.userPreferences!.notifDinnerReminder;
    _model.dailyMorningBriefValue = _model.userPreferences!.notifDailyBrief;
    _model.switchValue1 = _model.userPreferences!.notifAttendanceAlert;
    _model.switchValue2 = _model.userPreferences!.notifWeeklySummary;
    _model.switchValue3 = _model.userPreferences!.quietHoursEnabled;
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      logFirebaseEvent('MANAGE_NOTIFICATIONS_ManageNotifications');
      if (functions.hasPreferencesChanged(
              FFAppState().userPreferences, _model.userPreferences!) ==
          true) {
        logFirebaseEvent('ManageNotifications_custom_action');
        _model.updateFeedback = await actions.updateUserPreferences(
          _model.userPreferences,
        );
      }
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Title(
        title: 'ManageNotifications',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            appBar: AppBar(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              automaticallyImplyLeading: false,
              leading: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  FFIcons.karrowLeft,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 30.0,
                ),
                onPressed: () async {
                  logFirebaseEvent('MANAGE_NOTIFICATIONS_arrowLeft_ICN_ON_TA');
                  logFirebaseEvent('IconButton_navigate_back');
                  context.pop();
                },
              ),
              title: Text(
                'Manage Notifications',
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                      fontFamily:
                          FlutterFlowTheme.of(context).headlineMediumFamily,
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 22.0,
                      letterSpacing: 0.0,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                    ),
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 0.0),
                child: SingleChildScrollView(
                  primary: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Notifications & Reminders',
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                      ),
                      Text(
                        'Receive notifications from Attendrix about classes, attendance, meals, reminders and updates.',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enable Push Notifications     ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Receive reminders, schedule updates, and important \nannouncements.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.optInValue!,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.optInValue = newValue);
                                if (newValue) {
                                  logFirebaseEvent(
                                      'MANAGE_NOTIFICATIONS_optIn_ON_TOGGLE_ON');
                                  logFirebaseEvent('optIn_update_page_state');
                                  _model.updateUserPreferencesStruct(
                                    (e) => e..notificationsEnabled = true,
                                  );
                                  safeSetState(() {});
                                } else {
                                  logFirebaseEvent(
                                      'MANAGE_NOTIFICATIONS_optIn_ON_TOGGLE_OFF');
                                  logFirebaseEvent('optIn_update_page_state');
                                  _model.updateUserPreferencesStruct(
                                    (e) => e..notificationsEnabled = false,
                                  );
                                  safeSetState(() {});
                                }
                              },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      StyledDivider(
                        thickness: 1.5,
                        indent: 20.0,
                        endIndent: 20.0,
                        color: FlutterFlowTheme.of(context).alternate,
                        lineStyle: DividerLineStyle.dashed,
                      ),
                      Container(
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Class Reminders',
                                        style: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Never miss an important class update.',
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 10.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 6.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Enable Class Notifications  ',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w500,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      Text(
                                        'Get notified before upcoming classes start',
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodySmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 10.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodySmall
                                                      .fontStyle,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value:
                                        _model.enableClassNotificationsValue!,
                                    onChanged: _model.userPreferences!
                                            .notificationsEnabled
                                        ? null
                                        : (newValue) async {
                                            safeSetState(() => _model
                                                    .enableClassNotificationsValue =
                                                newValue);

                                            if (!newValue) {
                                              logFirebaseEvent(
                                                  'MANAGE_NOTIFICATIONS_enableClassNotifica');
                                              logFirebaseEvent(
                                                  'enableClassNotifications_update_page_sta');
                                              _model
                                                  .updateUserPreferencesStruct(
                                                (e) => e
                                                  ..notifClassReminder = false
                                                  ..notifClassCancelled = false
                                                  ..notifClassRescheduled =
                                                      false,
                                              );
                                              safeSetState(() {});
                                            }
                                          },
                                    activeThumbColor:
                                        FlutterFlowTheme.of(context).info,
                                    activeTrackColor:
                                        FlutterFlowTheme.of(context).primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Remind Me Before Class',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FlutterFlowRadioButton(
                                options: [
                                  '5 Minutes',
                                  '10 Minutes',
                                  '15 Minutes',
                                  '30 Minutes'
                                ].toList(),
                                onChanged: (val) async {
                                  safeSetState(() {});
                                  logFirebaseEvent(
                                      'MANAGE_NOTIFICATIONS_RadioButton_w9lok5z');
                                  logFirebaseEvent(
                                      'RadioButton_update_page_state');
                                  _model.updateUserPreferencesStruct(
                                    (e) => e
                                      ..notifReminderMinutes = () {
                                        if (_model.radioButtonValue1 ==
                                            '5 Minutes') {
                                          return 5;
                                        } else if (_model.radioButtonValue1 ==
                                            '10 Minutes') {
                                          return 10;
                                        } else if (_model.radioButtonValue1 ==
                                            '15 Minutes') {
                                          return 15;
                                        } else if (_model.radioButtonValue1 ==
                                            '30 Minutes') {
                                          return 30;
                                        } else {
                                          return 10;
                                        }
                                      }(),
                                  );
                                  safeSetState(() {});
                                },
                                controller: _model
                                        .radioButtonValueController1 ??=
                                    FormFieldController<String>(
                                        '${_model.userPreferences?.notifReminderMinutes.toString()} Minutes'),
                                optionHeight: 32.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                                selectedTextStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                buttonPosition: RadioButtonPosition.left,
                                direction: Axis.horizontal,
                                radioButtonColor:
                                    FlutterFlowTheme.of(context).primary,
                                inactiveRadioButtonColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                toggleable: false,
                                horizontalAlignment: WrapAlignment.start,
                                verticalAlignment: WrapCrossAlignment.start,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Class Reminders     ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Get notified when attendance drops below requirement',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.classRemindersValue!,
                              onChanged: !_model.enableClassNotificationsValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() => _model
                                          .classRemindersValue = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_classReminders_ON_T');
                                        logFirebaseEvent(
                                            'classReminders_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifClassReminder = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_classReminders_ON_T');
                                        logFirebaseEvent(
                                            'classReminders_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifClassReminder = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Class Cancellations',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Get notified when classes get cancelled',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.classCancellationsValue!,
                              onChanged: !_model.enableClassNotificationsValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() => _model
                                          .classCancellationsValue = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_classCancellations_');
                                        logFirebaseEvent(
                                            'classCancellations_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifClassCancelled = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_classCancellations_');
                                        logFirebaseEvent(
                                            'classCancellations_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifClassCancelled = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Class Rescheduled          ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Get notified when classes get rescheduled',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.classRescheduleValue!,
                              onChanged: !_model.enableClassNotificationsValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() => _model
                                          .classRescheduleValue = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_classReschedule_ON_');
                                        logFirebaseEvent(
                                            'classReschedule_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) =>
                                              e..notifClassRescheduled = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_classReschedule_ON_');
                                        logFirebaseEvent(
                                            'classReschedule_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) =>
                                              e..notifClassRescheduled = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      StyledDivider(
                        thickness: 1.5,
                        indent: 20.0,
                        endIndent: 20.0,
                        color: FlutterFlowTheme.of(context).alternate,
                        lineStyle: DividerLineStyle.dashed,
                      ),
                      Text(
                        'Mess Reminders',
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 16.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                      ),
                      Text(
                        'Get reminded before every meal.',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .fontStyle,
                            ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enable Mess Notifications',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Get notified before upcoming classes start',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.enableMessNotificationsValue!,
                              onChanged: !_model.optInValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() =>
                                          _model.enableMessNotificationsValue =
                                              newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_enableMessNotificat');
                                        logFirebaseEvent(
                                            'enableMessNotifications_update_page_stat');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e
                                            ..notifMessReminder = true
                                            ..notifBreakfastReminder = true
                                            ..notifLunchReminder = true
                                            ..notifEveningTeaReminder = true
                                            ..notifDinnerReminder = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_enableMessNotificat');
                                        logFirebaseEvent(
                                            'enableMessNotifications_update_page_stat');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e
                                            ..notifMessReminder = false
                                            ..notifBreakfastReminder = false
                                            ..notifLunchReminder = false
                                            ..notifEveningTeaReminder = false
                                            ..notifDinnerReminder = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Remind Me Before Mess',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              fontSize: 14.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: FlutterFlowRadioButton(
                                options: [
                                  '5 Minutes',
                                  '10 Minutes',
                                  '15 Minutes',
                                  '30 Minutes'
                                ].toList(),
                                onChanged: (val) async {
                                  safeSetState(() {});
                                  logFirebaseEvent(
                                      'MANAGE_NOTIFICATIONS_RadioButton_3f5hy6c');
                                  logFirebaseEvent(
                                      'RadioButton_update_page_state');
                                  _model.updateUserPreferencesStruct(
                                    (e) => e
                                      ..notifMessReminderMinutes = () {
                                        if (_model.radioButtonValue1 ==
                                            '5 Minutes') {
                                          return 5;
                                        } else if (_model.radioButtonValue1 ==
                                            '10 Minutes') {
                                          return 10;
                                        } else if (_model.radioButtonValue1 ==
                                            '15 Minutes') {
                                          return 15;
                                        } else if (_model.radioButtonValue1 ==
                                            '30 Minutes') {
                                          return 30;
                                        } else {
                                          return 10;
                                        }
                                      }(),
                                  );
                                  safeSetState(() {});
                                },
                                controller:
                                    _model.radioButtonValueController2 ??=
                                        FormFieldController<String>(null),
                                optionHeight: 32.0,
                                textStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                                selectedTextStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      letterSpacing: 0.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .bodyMediumIsCustom,
                                    ),
                                buttonPosition: RadioButtonPosition.left,
                                direction: Axis.horizontal,
                                radioButtonColor:
                                    FlutterFlowTheme.of(context).primary,
                                inactiveRadioButtonColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                toggleable: false,
                                horizontalAlignment: WrapAlignment.start,
                                verticalAlignment: WrapCrossAlignment.start,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Breakfast',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Meal previews ${valueOrDefault<String>(
                                    _model.userPreferences?.notifMessReminder
                                        .toString(),
                                    '30',
                                  )} mins before breakfast',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.breakfastValue!,
                              onChanged: !_model.enableMessNotificationsValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() =>
                                          _model.breakfastValue = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_breakfast_ON_TOGGLE');
                                        logFirebaseEvent(
                                            'breakfast_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) =>
                                              e..notifBreakfastReminder = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_breakfast_ON_TOGGLE');
                                        logFirebaseEvent(
                                            'breakfast_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) =>
                                              e..notifBreakfastReminder = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lunch',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Meal previews ${valueOrDefault<String>(
                                    _model.userPreferences?.notifMessReminder
                                        .toString(),
                                    '30',
                                  )} mins before lunch',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.lunchValue!,
                              onChanged: !_model.enableMessNotificationsValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(
                                          () => _model.lunchValue = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_lunch_ON_TOGGLE_ON');
                                        logFirebaseEvent(
                                            'lunch_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifLunchReminder = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_lunch_ON_TOGGLE_OFF');
                                        logFirebaseEvent(
                                            'lunch_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifLunchReminder = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Evening Snacks',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Meal previews ${valueOrDefault<String>(
                                    _model.userPreferences?.notifMessReminder
                                        .toString(),
                                    '30',
                                  )} mins before snacks',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.eveningSnacksValue!,
                              onChanged: !_model.enableMessNotificationsValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() => _model
                                          .eveningSnacksValue = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_eveningSnacks_ON_TO');
                                        logFirebaseEvent(
                                            'eveningSnacks_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) =>
                                              e..notifEveningTeaReminder = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_eveningSnacks_ON_TO');
                                        logFirebaseEvent(
                                            'eveningSnacks_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e
                                            ..notifEveningTeaReminder = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dinner',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Meal previews ${valueOrDefault<String>(
                                    _model.userPreferences?.notifMessReminder
                                        .toString(),
                                    '30',
                                  )} mins before dinner',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.dinnerValue!,
                              onChanged: !_model.enableMessNotificationsValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(
                                          () => _model.dinnerValue = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_Dinner_ON_TOGGLE_ON');
                                        logFirebaseEvent(
                                            'Dinner_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifDinnerReminder = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_Dinner_ON_TOGGLE_OF');
                                        logFirebaseEvent(
                                            'Dinner_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifDinnerReminder = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      StyledDivider(
                        thickness: 1.5,
                        indent: 20.0,
                        endIndent: 20.0,
                        color: FlutterFlowTheme.of(context).alternate,
                        lineStyle: DividerLineStyle.dashed,
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Academic Insights',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Receive personalized academic summaries.',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily Morning Brief   ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Receive a personalized overview of your day and key updates.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.dailyMorningBriefValue!,
                              onChanged: (newValue) async {
                                safeSetState(() =>
                                    _model.dailyMorningBriefValue = newValue);
                                if (newValue) {
                                  logFirebaseEvent(
                                      'MANAGE_NOTIFICATIONS_DailyMorningBrief_O');
                                  logFirebaseEvent(
                                      'DailyMorningBrief_update_page_state');
                                  _model.updateUserPreferencesStruct(
                                    (e) => e..notifDailyBrief = true,
                                  );
                                  safeSetState(() {});
                                } else {
                                  logFirebaseEvent(
                                      'MANAGE_NOTIFICATIONS_DailyMorningBrief_O');
                                  logFirebaseEvent(
                                      'DailyMorningBrief_update_page_state');
                                  _model.updateUserPreferencesStruct(
                                    (e) => e..notifDailyBrief = false,
                                  );
                                  safeSetState(() {});
                                }
                              },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                            Flexible(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 8.0, 4.0, 8.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'MANAGE_NOTIFICATIONS_Container_b6ygsthi_');
                                    if (_model
                                        .userPreferences!.notifDailyBrief) {
                                      logFirebaseEvent(
                                          'Container_date_time_picker');

                                      final _datePicked1Time =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            getCurrentTimestamp),
                                        builder: (context, child) {
                                          return wrapInMaterialTimePickerTheme(
                                            context,
                                            child!,
                                            headerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            headerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            headerTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .override(
                                                      fontFamily: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineLargeFamily,
                                                      fontSize: 32.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLargeIsCustom,
                                                    ),
                                            pickerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            pickerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            selectedDateTimeBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            selectedDateTimeForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            actionButtonForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            iconSize: 24.0,
                                          );
                                        },
                                      );
                                      if (_datePicked1Time != null) {
                                        safeSetState(() {
                                          _model.datePicked1 = DateTime(
                                            getCurrentTimestamp.year,
                                            getCurrentTimestamp.month,
                                            getCurrentTimestamp.day,
                                            _datePicked1Time.hour,
                                            _datePicked1Time.minute,
                                          );
                                        });
                                      } else if (_model.datePicked1 != null) {
                                        safeSetState(() {
                                          _model.datePicked1 =
                                              getCurrentTimestamp;
                                        });
                                      }
                                      if (_model.datePicked1 != null) {
                                        logFirebaseEvent(
                                            'Container_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e
                                            ..dailyBriefTime =
                                                functions.formatTimeString(
                                                    _model.datePicked1!
                                                        .toString(),
                                                    FFAppState()
                                                        .userPreferences
                                                        .preferredTimeFormat),
                                        );
                                        safeSetState(() {});
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        functions.formatTimeString(
                                            valueOrDefault<String>(
                                              _model.userPreferences
                                                  ?.dailyBriefTime,
                                              '7:00 AM',
                                            ),
                                            FFAppState()
                                                .userPreferences
                                                .preferredTimeFormat),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attendance Shortage Alerts',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Get notified when your attendance falls below \nyour minimum target.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.switchValue1!,
                              onChanged: !_model.optInValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() =>
                                          _model.switchValue1 = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_Switch_fgnyv5mq_ON_');
                                        logFirebaseEvent(
                                            'Switch_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifAttendanceAlert = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_Switch_fgnyv5mq_ON_');
                                        logFirebaseEvent(
                                            'Switch_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) =>
                                              e..notifAttendanceAlert = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weekly Attendance Recap     ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Receive a weekly summary of your attendance\nacross all enrolled courses.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.switchValue2!,
                              onChanged: !_model.optInValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() =>
                                          _model.switchValue2 = newValue);
                                      if (newValue) {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_Switch_yulpi1zy_ON_');
                                        logFirebaseEvent(
                                            'Switch_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifWeeklySummary = true,
                                        );
                                        safeSetState(() {});
                                      } else {
                                        logFirebaseEvent(
                                            'MANAGE_NOTIFICATIONS_Switch_yulpi1zy_ON_');
                                        logFirebaseEvent(
                                            'Switch_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e..notifWeeklySummary = false,
                                        );
                                        safeSetState(() {});
                                      }
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      StyledDivider(
                        thickness: 1.5,
                        indent: 20.0,
                        endIndent: 20.0,
                        color: FlutterFlowTheme.of(context).alternate,
                        lineStyle: DividerLineStyle.dashed,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quiet Hours',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            'Reduce interruptions while you\'re resting.',
                            textAlign: TextAlign.start,
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.outfit(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 10.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enable Quiet Hours  ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 14.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Silence non-essential notifications during your selected hours.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _model.switchValue3!,
                              onChanged: !_model.optInValue!
                                  ? null
                                  : (newValue) async {
                                      safeSetState(() =>
                                          _model.switchValue3 = newValue);
                                    },
                              activeThumbColor: FlutterFlowTheme.of(context).info,
                              activeTrackColor:
                                  FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                            Flexible(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 8.0, 4.0, 8.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'MANAGE_NOTIFICATIONS_Container_872o9tox_');
                                    if (_model
                                        .userPreferences!.quietHoursEnabled) {
                                      logFirebaseEvent(
                                          'Container_date_time_picker');

                                      final _datePicked2Time =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            getCurrentTimestamp),
                                        builder: (context, child) {
                                          return wrapInMaterialTimePickerTheme(
                                            context,
                                            child!,
                                            headerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            headerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            headerTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .override(
                                                      fontFamily: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineLargeFamily,
                                                      fontSize: 32.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLargeIsCustom,
                                                    ),
                                            pickerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            pickerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            selectedDateTimeBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            selectedDateTimeForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            actionButtonForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            iconSize: 24.0,
                                          );
                                        },
                                      );
                                      if (_datePicked2Time != null) {
                                        safeSetState(() {
                                          _model.datePicked2 = DateTime(
                                            getCurrentTimestamp.year,
                                            getCurrentTimestamp.month,
                                            getCurrentTimestamp.day,
                                            _datePicked2Time.hour,
                                            _datePicked2Time.minute,
                                          );
                                        });
                                      } else if (_model.datePicked2 != null) {
                                        safeSetState(() {
                                          _model.datePicked2 =
                                              getCurrentTimestamp;
                                        });
                                      }
                                      if (_model.datePicked2 != null) {
                                        logFirebaseEvent(
                                            'Container_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e
                                            ..quietHoursStart = dateTimeFormat(
                                              "HH:mm:ss",
                                              _model.datePicked2,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            ),
                                        );
                                        safeSetState(() {});
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        functions.formatTimeString(
                                            _model.userPreferences!
                                                .quietHoursStart,
                                            FFAppState()
                                                .userPreferences
                                                .preferredTimeFormat),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 8.0, 8.0, 8.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'MANAGE_NOTIFICATIONS_Container_t42wc1sc_');
                                    if (_model
                                        .userPreferences!.quietHoursEnabled) {
                                      logFirebaseEvent(
                                          'Container_date_time_picker');

                                      final _datePicked3Time =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            getCurrentTimestamp),
                                        builder: (context, child) {
                                          return wrapInMaterialTimePickerTheme(
                                            context,
                                            child!,
                                            headerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            headerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            headerTextStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .override(
                                                      fontFamily: FlutterFlowTheme
                                                              .of(context)
                                                          .headlineLargeFamily,
                                                      fontSize: 32.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      useGoogleFonts:
                                                          !FlutterFlowTheme.of(
                                                                  context)
                                                              .headlineLargeIsCustom,
                                                    ),
                                            pickerBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                            pickerForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            selectedDateTimeBackgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            selectedDateTimeForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            actionButtonForegroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            iconSize: 24.0,
                                          );
                                        },
                                      );
                                      if (_datePicked3Time != null) {
                                        safeSetState(() {
                                          _model.datePicked3 = DateTime(
                                            getCurrentTimestamp.year,
                                            getCurrentTimestamp.month,
                                            getCurrentTimestamp.day,
                                            _datePicked3Time.hour,
                                            _datePicked3Time.minute,
                                          );
                                        });
                                      } else if (_model.datePicked3 != null) {
                                        safeSetState(() {
                                          _model.datePicked3 =
                                              getCurrentTimestamp;
                                        });
                                      }
                                      if (_model.datePicked3 != null) {
                                        logFirebaseEvent(
                                            'Container_update_page_state');
                                        _model.updateUserPreferencesStruct(
                                          (e) => e
                                            ..quietHoursStart = dateTimeFormat(
                                              "HH:mm:ss",
                                              _model.datePicked3,
                                              locale:
                                                  FFLocalizations.of(context)
                                                      .languageCode,
                                            ),
                                        );
                                        safeSetState(() {});
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 80.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        functions.formatTimeString(
                                            _model
                                                .userPreferences!.quietHoursEnd,
                                            FFAppState()
                                                .userPreferences
                                                .preferredTimeFormat),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              letterSpacing: 0.0,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
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
                              Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Text(
                                  'Important schedule changes such as class cancellations may still be delivered.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodySmall
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 8.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ].addToEnd(SizedBox(height: 100.0)),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
