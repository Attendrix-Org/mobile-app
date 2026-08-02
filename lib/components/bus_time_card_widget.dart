import '/backend/schema/structs/index.dart';
import '/bottom_sheets/how_attendrix_shows_bus_timings/how_attendrix_shows_bus_timings_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/permissions_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bus_time_card_model.dart';
export 'bus_time_card_model.dart';

/// Design a premium, modern dashboard widget for **Attendrix** called
/// **Campus Transit**.
///
/// The design should follow Apple's Human Interface Guidelines and modern
/// productivity apps like Linear, Notion Calendar, and Things. The card
/// should feel calm, intelligent, and glanceable rather than data-heavy.
///
/// This is **not** a live bus tracker.
///
/// The app **does NOT know**:
/// - Live bus locations
/// - Bus ETAs
/// - User destination
/// - User's next class
/// - Which bus the user intends to board
///
/// The app **ONLY knows**:
/// - User's current GPS location
/// - Locations of all bus stops
/// - Static bus timetable
/// - Current time
///
/// The purpose of this card is to answer one question:
///
/// **"Should I walk to the nearest bus stop and wait, or is it not worth
/// it?"**
///
/// The recommendation should always be the most visually dominant element.
///
/// ---
///
/// ## Card Structure
///
/// ### Header
///
/// - Bus icon
/// - Title: Campus Transit
/// - Chevron on the right that opens the complete Bus Timings page
///
/// ---
///
/// ## Primary Section
///
/// Large section showing:
///
/// Next Bus
///
/// Example
///
/// Bus 2
///
/// Large countdown
///
/// 7 min
///
/// Small caption
///
/// from Main Gate
///
/// This is the **next scheduled bus departing from the nearest bus stop**,
/// not a live arrival estimate.
///
/// ---
///
/// ## Nearest Stop
///
/// Display:
///
/// 📍 Main Gate
///
/// 140 m away
///
/// ≈2 min walk
///
/// This section should feel secondary but still immediately visible.
///
/// ---
///
/// ## Recommendation
///
/// This is the most important part of the card.
///
/// Large colored badge.
///
/// Possible states:
///
/// 🟢 Worth Waiting
///
/// Walking to the stop takes 2 minutes.
/// The next bus departs in 7 minutes.
///
/// or
///
/// 🚶 Skip This Bus
///
/// Walking takes 6 minutes.
/// The next bus departs in 3 minutes.
///
/// You'll probably miss this departure.
///
/// or
///
/// ⚠ Hurry
///
/// The bus departs in 4 minutes.
/// Walk quickly to reach the stop.
///
/// The recommendation should explain **why** it was chosen.
///
/// ---
///
/// ## Quick Stats
///
/// Display two compact metrics.
///
/// Walking Time
///
/// 2 min
///
/// Next Departure
///
/// 7 min
///
/// Optionally display
///
/// Total Time Until Boarding
///
/// 9 min
///
/// This equals
///
/// Walking Time + Time Until Bus Departure
///
/// ---
///
/// ## Bottom Action
///
/// Large button
///
/// View Bus Timings
///
/// This opens the dedicated transit page.
///
/// ---
///
/// ## Visual Style
///
/// - Premium
/// - Minimal
/// - Spacious
/// - Rounded corners (20–24px)
/// - Soft elevation
/// - Subtle gradients
/// - Excellent typography hierarchy
/// - High contrast for important information
/// - No tables
/// - No dense timetable
///
/// The countdown should be visually larger than every other value.
///
/// ---
///
/// ## States
///
/// Design all of these.
///
/// ### 1. Worth Waiting
///
/// Green recommendation.
///
/// Bus departs soon enough that walking to the stop is worthwhile.
///
/// ---
///
/// ### 2. Hurry
///
/// Orange recommendation.
///
/// The user can probably catch the bus if they walk immediately.
///
/// ---
///
/// ### 3. Skip This Bus
///
/// Walking to the stop would likely take longer than the remaining time
/// before departure.
///
/// Recommend waiting for the next departure or simply walking to the
/// destination.
///
/// ---
///
/// ### 4. No More Buses Today
///
/// Friendly empty state.
///
/// Display
///
/// "No more scheduled buses today."
///
/// Button
///
/// View Tomorrow's Timetable
///
/// ---
///
/// ## Important Design Rules
///
/// Do NOT display:
///
/// - Destination
/// - Route ETA
/// - Arrival at destination
/// - Live bus location
/// - Bus tracking map
/// - Next class
/// - Classroom
/// - Academic information
///
/// Those cannot be accurately determined.
///
/// The card should only communicate verified information derived from the
/// static timetable and the user's location.
///
/// The overall feeling should be that of an intelligent campus assistant
/// helping the user decide whether catching the next bus is worthwhile,
/// rather than simply displaying bus schedules.
class BusTimeCardWidget extends StatefulWidget {
  const BusTimeCardWidget({super.key});

  @override
  State<BusTimeCardWidget> createState() => _BusTimeCardWidgetState();
}

class _BusTimeCardWidgetState extends State<BusTimeCardWidget> {
  late BusTimeCardModel _model;

  LatLng? currentUserLocationValue;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BusTimeCardModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('BUS_TIME_CARD_busTimeCard_ON_INIT_STATE');
      currentUserLocationValue =
          await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
      logFirebaseEvent('busTimeCard_start_periodic_action');
      _model.nextBusFetchTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 30000),
        callback: (timer) async {
          currentUserLocationValue =
              await getCurrentUserLocation(defaultLocation: LatLng(0.0, 0.0));
          if (await getPermissionStatus(locationPermission)) {
            logFirebaseEvent('busTimeCard_custom_action');
            _model.nextBusInfoData = await actions.getNextBusInfo(
              FFAppState().BusRoutes.toList(),
              currentUserLocationValue,
            );
            logFirebaseEvent('busTimeCard_update_component_state');
            _model.nextBusInfoState =
                _model.nextBusInfoData!.toList().cast<NextBusInfoStruct>();
            _model.locationPermission = true;
            safeSetState(() {});
          } else {
            logFirebaseEvent('busTimeCard_update_component_state');
            _model.locationPermission = false;
            safeSetState(() {});
          }
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
      logFirebaseEvent('BUS_TIME_CARD_busTimeCard_ON_DISPOSE');
      logFirebaseEvent('busTimeCard_stop_periodic_action');
      _model.nextBusFetchTimer?.cancel();
    }();

    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Builder(
      builder: (context) {
        if (_model.nextBusInfoState.isNotEmpty) {
          return Container(
            height: 150.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(20.0),
              shape: BoxShape.rectangle,
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
                width: 1.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 4.0, 0.0, 0.0),
                                child: Text(
                                  'Next Bus',
                                  style: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .labelMediumFamily,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        fontSize: 10.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                        lineHeight: 1.0,
                                        useGoogleFonts:
                                            !FlutterFlowTheme.of(context)
                                                .labelMediumIsCustom,
                                      ),
                                ),
                              ),
                              Text(
                                valueOrDefault<String>(
                                  _model
                                      .nextBusInfoState.firstOrNull?.routeName,
                                  'MBH → East Campus (Bus 2)',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      lineHeight: 1.0,
                                      useGoogleFonts:
                                          !FlutterFlowTheme.of(context)
                                              .labelMediumIsCustom,
                                    ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(16.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8.0, 2.0, 8.0, 2.0),
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, -1.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                6.0, 0.0),
                                                    child: Text(
                                                      'Walk Time',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .tertiary,
                                                            fontSize: 10.0,
                                                            letterSpacing: 0.0,
                                                            lineHeight: 1.38,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 4.0, 0.0),
                                                  child: Text(
                                                    valueOrDefault<String>(
                                                      _model
                                                          .nextBusInfoState
                                                          .firstOrNull
                                                          ?.walkingTimeMinutes
                                                          .toString(),
                                                      '10',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineLargeFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          lineHeight: 1.2,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineLargeIsCustom,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 2.0),
                                                  child: Text(
                                                    'mins',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.35,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ].divide(SizedBox(height: 4.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 0.0, 0.0, 0.0),
                                    child: Container(
                                      height: 25.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 2.0, 8.0, 2.0),
                                        child: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FFIcons.klocation,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primary,
                                                    size: 16.0,
                                                  ),
                                                  Text(
                                                    valueOrDefault<String>(
                                                      _model
                                                          .nextBusInfoState
                                                          .firstOrNull
                                                          ?.nearestStop,
                                                      'Center Circle',
                                                    ),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 14.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          lineHeight: 1.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 4.0)),
                                              ),
                                            ].divide(SizedBox(height: 4.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 0.0, 0.0),
                      child: Text(
                        'Available Buses',
                        style: FlutterFlowTheme.of(context)
                            .labelMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .labelMediumFamily,
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              lineHeight: 1.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .labelMediumIsCustom,
                            ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Container(
                        height: 70.0,
                        child: Builder(
                          builder: (context) {
                            final nextBusInfo = _model.nextBusInfoState
                                .toList()
                                .take(5)
                                .toList();

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: nextBusInfo.length,
                              itemBuilder: (context, nextBusInfoIndex) {
                                final nextBusInfoItem =
                                    nextBusInfo[nextBusInfoIndex];
                                return Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      2.0, 0.0, 2.0, 2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius: BorderRadius.circular(12.0),
                                      shape: BoxShape.rectangle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 4.0),
                                              child: Text(
                                                valueOrDefault<String>(
                                                  nextBusInfoItem.routeName,
                                                  'MBH II -> Architecture',
                                                ),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .titleMedium
                                                    .override(
                                                      font: GoogleFonts.outfit(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .titleMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleMedium
                                                              .fontStyle,
                                                      lineHeight: 1.35,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .alternate,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        8.0, 3.0, 8.0, 3.0),
                                                child: Container(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    2.0),
                                                        child: Text(
                                                          'in ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                                lineHeight:
                                                                    1.35,
                                                              ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    4.0,
                                                                    0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            nextBusInfoItem
                                                                .minutesRemaining
                                                                .toString(),
                                                            '10',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLargeFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                lineHeight: 1.2,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLargeIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    2.0),
                                                        child: Text(
                                                          'mins at ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .titleMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .titleMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 14.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                                lineHeight:
                                                                    1.35,
                                                              ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    4.0,
                                                                    0.0),
                                                        child: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            nextBusInfoItem
                                                                .departureTime
                                                                ?.toString(),
                                                            '4:00 PM',
                                                          ),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .headlineLarge
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineLargeFamily,
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                lineHeight: 1.2,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .headlineLargeIsCustom,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1.0, -1.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.65,
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 0.0, 0.0, 0.0),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Based on the official Bus timings. ',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMediumFamily,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 8.0,
                                              letterSpacing: 0.0,
                                              lineHeight: 1.38,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelMediumIsCustom,
                                            ),
                                      ),
                                      TextSpan(
                                        text: 'Tap to learn more.',
                                        style: GoogleFonts.outfit(
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 8.0,
                                        ),
                                        mouseCursor: SystemMouseCursors.click,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            logFirebaseEvent(
                                                'BUS_TIME_CARD_RichTextSpan_etm9hvz3_ON_T');
                                            logFirebaseEvent(
                                                'RichTextSpan_bottom_sheet');
                                            await showModalBottomSheet(
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              enableDrag: false,
                                              context: context,
                                              builder: (context) {
                                                return Padding(
                                                  padding:
                                                      MediaQuery.viewInsetsOf(
                                                          context),
                                                  child:
                                                      HowAttendrixShowsBusTimingsWidget(),
                                                );
                                              },
                                            ).then(
                                                (value) => safeSetState(() {}));
                                          },
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
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
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'updated ${dateTimeFormat(
                                "relative",
                                _model
                                    .nextBusInfoState.firstOrNull?.lastUpdated,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              )}',
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (_model.locationPermission) {
          return Container(
            width: double.infinity,
            height: 150.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_off_outlined,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 32.0,
                ),
                Text(
                  'Find Buses Near You',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w900,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        lineHeight: 1.47,
                      ),
                ),
                Text(
                  'Enable location to see nearby scheduled buses.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        lineHeight: 1.47,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      logFirebaseEvent(
                          'BUS_TIME_CARD_ENABLE_LOCATION_BTN_ON_TAP');
                      currentUserLocationValue = await getCurrentUserLocation(
                          defaultLocation: LatLng(0.0, 0.0));
                      logFirebaseEvent('Button_request_permissions');
                      await requestPermission(locationPermission);
                      if (await getPermissionStatus(locationPermission)) {
                        logFirebaseEvent('Button_custom_action');
                        _model.nextBusInfoDataRequest =
                            await actions.getNextBusInfo(
                          FFAppState().BusRoutes.toList(),
                          currentUserLocationValue,
                        );
                        logFirebaseEvent('Button_update_component_state');
                        _model.nextBusInfoState = _model.nextBusInfoDataRequest!
                            .toList()
                            .cast<NextBusInfoStruct>();
                        _model.locationPermission = true;
                        safeSetState(() {});
                      } else {
                        logFirebaseEvent('Button_update_component_state');
                        _model.locationPermission = false;
                        safeSetState(() {});
                      }

                      safeSetState(() {});
                    },
                    text: 'Enable Location',
                    icon: Icon(
                      FFIcons.klocationPlus,
                      size: 15.0,
                    ),
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 34.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleSmallFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleSmallIsCustom,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            height: 150.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  FFIcons.kbusOff,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  size: 48.0,
                ),
                Text(
                  'No More Scheduled Buses',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FontWeight.w900,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w900,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        lineHeight: 1.47,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      logFirebaseEvent('BUS_TIME_CARD_REFRESH_DATA_BTN_ON_TAP');
                      currentUserLocationValue = await getCurrentUserLocation(
                          defaultLocation: LatLng(0.0, 0.0));
                      logFirebaseEvent('Button_custom_action');
                      _model.nextBusInfoDataRefresh =
                          await actions.getNextBusInfo(
                        FFAppState().BusRoutes.toList(),
                        currentUserLocationValue,
                      );
                      logFirebaseEvent('Button_update_component_state');
                      _model.nextBusInfoState = _model.nextBusInfoDataRefresh!
                          .toList()
                          .cast<NextBusInfoStruct>();
                      safeSetState(() {});

                      safeSetState(() {});
                    },
                    text: 'Refresh Data',
                    icon: Icon(
                      FFIcons.krefresh,
                      size: 18.0,
                    ),
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.4,
                      height: 34.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                            fontFamily:
                                FlutterFlowTheme.of(context).titleSmallFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: !FlutterFlowTheme.of(context)
                                .titleSmallIsCustom,
                          ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
