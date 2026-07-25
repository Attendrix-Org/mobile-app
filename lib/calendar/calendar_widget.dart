import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/components/class_block_calender_widget.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_model.dart';
export 'calendar_model.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  static String routeName = 'calendar';
  static String routePath = 'calendar';

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late CalendarModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalendarModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'calendar'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('CALENDAR_PAGE_calendar_ON_INIT_STATE');
      logFirebaseEvent('calendar_custom_action');
      _model.generatedDates = await actions.generateDateRange(
        getCurrentTimestamp,
        DateRange.sevenDays,
        WeekendPolicy.excludeAll,
      );
      logFirebaseEvent('calendar_custom_action');
      _model.selectedDateClassesQuery = await actions.executeScheduleQuery(
        ScheduleViewType.calendarDay,
        getCurrentTimestamp,
        getCurrentTimestamp,
        getCurrentTimestamp,
        10,
      );
      logFirebaseEvent('calendar_custom_action');
      _model.generatedTimeline = await actions.generateTimeline(
        getCurrentTimestamp,
        _model.selectedDateClasses
            .map((e) => e.scheduledStart)
            .withoutNulls
            .toList()
            .toList(),
        _model.selectedDateClasses
            .map((e) => e.scheduledEnd)
            .withoutNulls
            .toList()
            .toList(),
      );
      logFirebaseEvent('calendar_update_page_state');
      _model.selectedDate = dateTimeFormat(
        "d/M/y",
        getCurrentTimestamp,
        locale: FFLocalizations.of(context).languageCode,
      );
      _model.dateRange = _model.generatedTimeline!.toList().cast<DateTime>();
      _model.selectedDateClasses = _model.selectedDateClassesQuery!
          .toList()
          .cast<ScheduledClassStruct>();
      _model.displayDatesRange =
          _model.generatedDates!.toList().cast<DateTime>();
      safeSetState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Title(
        title: 'calendar',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: SafeArea(
              top: true,
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                FFIcons.kcalendarMonth,
                                color: Colors.black,
                                size: 26.0,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    4.0, 0.0, 0.0, 0.0),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: valueOrDefault<String>(
                                          dateTimeFormat(
                                            "MMMM",
                                            getCurrentTimestamp,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          'July',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w800,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: Color(0xFF58617B),
                                              fontSize: 24.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                      TextSpan(
                                        text: ' ',
                                        style: TextStyle(),
                                      ),
                                      TextSpan(
                                        text: valueOrDefault<String>(
                                          dateTimeFormat(
                                            "yyy",
                                            getCurrentTimestamp,
                                            locale: FFLocalizations.of(context)
                                                .languageCode,
                                          ),
                                          '2026',
                                        ),
                                        style: GoogleFonts.outfit(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      )
                                    ],
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FontWeight.w800,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w800,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 4.0),
                        child: Builder(
                          builder: (context) {
                            final dateRangeRowView = _model.displayDatesRange
                                .toList()
                                .take(30)
                                .toList();
                            if (dateRangeRowView.isEmpty) {
                              return Center(
                                child: CachedNetworkImage(
                                  fadeInDuration: Duration(milliseconds: 0),
                                  fadeOutDuration: Duration(milliseconds: 0),
                                  imageUrl:
                                      'https://cdn-icons-gif.flaticon.com/19021/19021483.gif',
                                  width: 50.0,
                                  height: 50.0,
                                ),
                              );
                            }

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(dateRangeRowView.length,
                                    (dateRangeRowViewIndex) {
                                  final dateRangeRowViewItem =
                                      dateRangeRowView[dateRangeRowViewIndex];
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 4.0, 2.0),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        logFirebaseEvent(
                                            'CALENDAR_PAGE_Container_9kzwpaii_ON_TAP');
                                        logFirebaseEvent(
                                            'Container_custom_action');
                                        _model.selectedDateQuery =
                                            await actions.executeScheduleQuery(
                                          ScheduleViewType.calendarDay,
                                          dateRangeRowViewItem,
                                          dateRangeRowViewItem,
                                          dateRangeRowViewItem,
                                          10,
                                        );
                                        logFirebaseEvent(
                                            'Container_custom_action');
                                        _model.newSelectedDateTimeline =
                                            await actions.generateTimeline(
                                          dateRangeRowViewItem,
                                          _model.selectedDateQuery!
                                              .map((e) => e.scheduledStart)
                                              .withoutNulls
                                              .toList(),
                                          _model.selectedDateQuery!
                                              .map((e) => e.scheduledEnd)
                                              .withoutNulls
                                              .toList(),
                                        );
                                        logFirebaseEvent(
                                            'Container_update_page_state');
                                        _model.selectedDate = dateTimeFormat(
                                          "d/M/y",
                                          dateRangeRowViewItem,
                                          locale: FFLocalizations.of(context)
                                              .languageCode,
                                        );
                                        _model.selectedDateClasses = _model
                                            .selectedDateQuery!
                                            .toList()
                                            .cast<ScheduledClassStruct>();
                                        _model.dateRange = _model
                                            .newSelectedDateTimeline!
                                            .toList()
                                            .cast<DateTime>();
                                        safeSetState(() {});

                                        safeSetState(() {});
                                      },
                                      child: Material(
                                        color: Colors.transparent,
                                        elevation: 0.5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        child: Container(
                                          width: 50.0,
                                          height: 90.0,
                                          decoration: BoxDecoration(
                                            color: _model.selectedDate ==
                                                    dateTimeFormat(
                                                      "d/M/y",
                                                      dateRangeRowViewItem,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    )
                                                ? FlutterFlowTheme.of(context)
                                                    .primary
                                                : FlutterFlowTheme.of(context)
                                                    .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            border: Border.all(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .alternate,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 10.0, 0.0, 10.0),
                                                child: Text(
                                                  valueOrDefault<String>(
                                                    dateTimeFormat(
                                                      "EE",
                                                      dateRangeRowViewItem,
                                                      locale:
                                                          FFLocalizations.of(
                                                                  context)
                                                              .languageCode,
                                                    ),
                                                    'Mon',
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Container(
                                                  width: 28.0,
                                                  height: 28.0,
                                                  decoration: BoxDecoration(
                                                    color: _model
                                                                .selectedDate ==
                                                            dateTimeFormat(
                                                              "d/M/y",
                                                              dateRangeRowViewItem,
                                                              locale: FFLocalizations
                                                                      .of(context)
                                                                  .languageCode,
                                                            )
                                                        ? FlutterFlowTheme.of(
                                                                context)
                                                            .info
                                                        : FlutterFlowTheme.of(
                                                                context)
                                                            .primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Text(
                                                      valueOrDefault<String>(
                                                        dateTimeFormat(
                                                          "dd",
                                                          dateRangeRowViewItem,
                                                          locale:
                                                              FFLocalizations.of(
                                                                      context)
                                                                  .languageCode,
                                                        ),
                                                        '02',
                                                      ),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font:
                                                                    GoogleFonts
                                                                        .outfit(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: _model
                                                                            .selectedDate ==
                                                                        dateTimeFormat(
                                                                          "d/M/y",
                                                                          dateRangeRowViewItem,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        )
                                                                    ? Colors
                                                                        .black
                                                                    : FlutterFlowTheme.of(
                                                                            context)
                                                                        .info,
                                                                fontSize: 16.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
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
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 4.0, 12.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlutterFlowDropDown<WeekendPolicy>(
                            controller: _model.weekendPolicyValueController ??=
                                FormFieldController<WeekendPolicy>(
                              _model.weekendPolicyValue ??=
                                  _model.weekendFilter,
                            ),
                            options:
                                List<WeekendPolicy>.from(WeekendPolicy.values),
                            optionLabels: (List<String> values) {
                              return values
                                  .map((e) =>
                                      const {
                                        'includeAll': 'Show All Days',
                                        'excludeAll': 'Hide Weekends',
                                        'excludeSaturdays': 'Hide Saturdays',
                                        'excludeSundays': 'Hide Sundays'
                                      }[e] ??
                                      e)
                                  .toList();
                            }(WeekendPolicy.values.map((e) => e.name).toList()),
                            onChanged: (val) async {
                              safeSetState(
                                  () => _model.weekendPolicyValue = val);
                              logFirebaseEvent(
                                  'CALENDAR_weekendPolicy_ON_FORM_WIDGET_SE');
                              logFirebaseEvent('weekendPolicy_custom_action');
                              _model.updatedDateRangeViaWeekendPolicy =
                                  await actions.generateDateRange(
                                getCurrentTimestamp,
                                _model.displayRange!,
                                _model.weekendPolicyValue!,
                              );
                              logFirebaseEvent(
                                  'weekendPolicy_update_page_state');
                              _model.displayRange = _model.displayRangeValue;
                              _model.displayDatesRange = _model
                                  .updatedDateRangeViaWeekendPolicy!
                                  .toList()
                                  .cast<DateTime>();
                              safeSetState(() {});

                              safeSetState(() {});
                            },
                            width: 150.0,
                            height: 25.0,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).info,
                                  fontSize: 8.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            hintText: 'Weekend Filter',
                            icon: Icon(
                              Icons.filter_list,
                              color: FlutterFlowTheme.of(context).info,
                              size: 18.0,
                            ),
                            fillColor: Colors.black,
                            elevation: 2.0,
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            borderRadius: 6.0,
                            margin: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 12.0, 0.0),
                            hidesUnderline: true,
                            isOverButton: false,
                            isSearchable: false,
                            isMultiSelect: false,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 0.0, 0.0, 0.0),
                            child: FlutterFlowDropDown<DateRange>(
                              controller: _model.displayRangeValueController ??=
                                  FormFieldController<DateRange>(
                                _model.displayRangeValue ??=
                                    _model.displayRange,
                              ),
                              options: List<DateRange>.from(DateRange.values),
                              optionLabels: (List<String> values) {
                                return values
                                    .map((e) =>
                                        const {
                                          'sevenDays': '7 Days',
                                          'tenDays': '10 Days',
                                          'thirtyDays': '30 Days'
                                        }[e] ??
                                        e)
                                    .toList();
                              }(DateRange.values.map((e) => e.name).toList()),
                              onChanged: (val) async {
                                safeSetState(
                                    () => _model.displayRangeValue = val);
                                logFirebaseEvent(
                                    'CALENDAR_displayRange_ON_FORM_WIDGET_SEL');
                                logFirebaseEvent('displayRange_custom_action');
                                _model.updatedDateRangeViaDisplayRange =
                                    await actions.generateDateRange(
                                  getCurrentTimestamp,
                                  _model.displayRangeValue!,
                                  _model.weekendFilter!,
                                );
                                logFirebaseEvent(
                                    'displayRange_update_page_state');
                                _model.displayRange = _model.displayRangeValue;
                                _model.displayDatesRange = _model
                                    .updatedDateRangeViaDisplayRange!
                                    .toList()
                                    .cast<DateTime>();
                                safeSetState(() {});

                                safeSetState(() {});
                              },
                              width: 100.0,
                              height: 25.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: 8.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                              hintText: 'Display Range',
                              icon: Icon(
                                FFIcons.kfilter01,
                                color: FlutterFlowTheme.of(context).info,
                                size: 14.0,
                              ),
                              fillColor: Colors.black,
                              elevation: 2.0,
                              borderColor: Colors.transparent,
                              borderWidth: 0.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 12.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: false,
                              isSearchable: false,
                              isMultiSelect: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      primary: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                12.0, 0.0, 0.0, 0.0),
                            child: Builder(
                              builder: (context) {
                                final selectedDateClassesListView =
                                    _model.dateRange.toList();
                                if (selectedDateClassesListView.isEmpty) {
                                  return Center(
                                    child: CachedNetworkImage(
                                      fadeInDuration: Duration(milliseconds: 0),
                                      fadeOutDuration:
                                          Duration(milliseconds: 0),
                                      imageUrl:
                                          'https://cdn-icons-gif.flaticon.com/19021/19021483.gif',
                                      width: 50.0,
                                      height: 50.0,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: selectedDateClassesListView.length,
                                  itemBuilder: (context,
                                      selectedDateClassesListViewIndex) {
                                    final selectedDateClassesListViewItem =
                                        selectedDateClassesListView[
                                            selectedDateClassesListViewIndex];
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              if (selectedDateClassesListViewItem
                                                      .secondsSinceEpoch >
                                                  selectedDateClassesListViewItem
                                                      .secondsSinceEpoch)
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/images/Check_icon.png',
                                                    width: 20.0,
                                                    height: 20.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              if (selectedDateClassesListViewItem
                                                      .secondsSinceEpoch <
                                                  selectedDateClassesListViewItem
                                                      .secondsSinceEpoch)
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/images/UI_Dot_Icon_(1).png',
                                                    width: 18.0,
                                                    height: 18.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              if ((int startTime, int endTime,
                                                      int currentTime) {
                                                return currentTime >=
                                                        startTime &&
                                                    currentTime <= endTime;
                                              }(
                                                  selectedDateClassesListViewItem
                                                      .secondsSinceEpoch,
                                                  selectedDateClassesListViewItem
                                                      .secondsSinceEpoch,
                                                  selectedDateClassesListViewItem
                                                      .secondsSinceEpoch))
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.asset(
                                                    'assets/images/UI_Dot_Icon.png',
                                                    width: 18.0,
                                                    height: 18.0,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        4.0, 0.0, 0.0, 0.0),
                                                child: Text(
                                                  dateTimeFormat(
                                                    "jm",
                                                    selectedDateClassesListViewItem,
                                                    locale: FFLocalizations.of(
                                                            context)
                                                        .languageCode,
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 4.0),
                                          child: Builder(
                                            builder: (context) {
                                              final individualClassBlockView =
                                                  _model.selectedDateClasses
                                                      .where((e) =>
                                                          e.scheduledStart ==
                                                          selectedDateClassesListViewItem)
                                                      .toList()
                                                      .take(1)
                                                      .toList();
                                              if (individualClassBlockView
                                                  .isEmpty) {
                                                return Center(
                                                  child: Image.asset(
                                                    'assets/images/Empty_Icon.png',
                                                    width: 60.0,
                                                    height: 60.0,
                                                  ),
                                                );
                                              }

                                              return ListView.builder(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    individualClassBlockView
                                                        .length,
                                                itemBuilder: (context,
                                                    individualClassBlockViewIndex) {
                                                  final individualClassBlockViewItem =
                                                      individualClassBlockView[
                                                          individualClassBlockViewIndex];
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                12.0, 0.0),
                                                    child: wrapWithModel(
                                                      model: _model
                                                          .classBlockCalenderModels
                                                          .getModel(
                                                        _model
                                                            .selectedDateClasses
                                                            .where((e) =>
                                                                e.scheduledStart ==
                                                                selectedDateClassesListViewItem)
                                                            .toList()
                                                            .firstOrNull!
                                                            .classId,
                                                        individualClassBlockViewIndex,
                                                      ),
                                                      updateCallback: () =>
                                                          safeSetState(() {}),
                                                      child:
                                                          ClassBlockCalenderWidget(
                                                        key: Key(
                                                          'Keyqzs_${_model.selectedDateClasses.where((e) => e.scheduledStart == selectedDateClassesListViewItem).toList().firstOrNull!.classId}',
                                                        ),
                                                        classRow: _model
                                                            .selectedDateClasses
                                                            .where((e) =>
                                                                e.scheduledStart ==
                                                                selectedDateClassesListViewItem)
                                                            .toList()
                                                            .firstOrNull!,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ].addToStart(SizedBox(height: 30.0)),
                ),
              ),
            ),
          ),
        ));
  }
}
