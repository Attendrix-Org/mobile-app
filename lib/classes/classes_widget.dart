import '/backend/schema/enums/enums.dart';
import '/components/class_block_general_widget.dart';
import '/components/empty_state_container_widget.dart';
import '/empty_state/empty_state_gif/empty_state_gif_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'classes_model.dart';
export 'classes_model.dart';

class ClassesWidget extends StatefulWidget {
  const ClassesWidget({super.key});

  static String routeName = 'classes';
  static String routePath = 'classes';

  @override
  State<ClassesWidget> createState() => _ClassesWidgetState();
}

class _ClassesWidgetState extends State<ClassesWidget>
    with TickerProviderStateMixin {
  late ClassesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ClassesModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'classes'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('CLASSES_PAGE_classes_ON_INIT_STATE');
      logFirebaseEvent('classes_update_page_state');
      _model.dateRange = DateRange.sevenDays;
      _model.weekendPolicy = WeekendPolicy.excludeAll;
      logFirebaseEvent('classes_custom_action');
      _model.generatedDates = await actions.generatePastDateRange(
        getCurrentTimestamp,
        _model.dateRange!,
        _model.weekendPolicy!,
      );
      logFirebaseEvent('classes_update_page_state');
      _model.generatedDatesState =
          _model.generatedDates!.toList().cast<DateTime>();
      safeSetState(() {});
      logFirebaseEvent('classes_custom_action');
      await actions.syncAppData(
        false,
        false,
        false,
        true,
        true,
        false,
        false,
        _model.generatedDatesState.toList(),
      );
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Title(
        title: 'classes',
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
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Classes',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).headlineSmallFamily,
                          fontSize: 26.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: !FlutterFlowTheme.of(context)
                              .headlineSmallIsCustom,
                        ),
                  ),
                ],
              ),
              actions: [],
              centerTitle: false,
              elevation: 0.0,
            ),
            body: SafeArea(
              top: true,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment(-1.0, 0),
                      child: FlutterFlowButtonTabBar(
                        useToggleButtonStyle: true,
                        labelStyle:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .headlineSmallFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .headlineSmallIsCustom,
                                ),
                        unselectedLabelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.outfit(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        backgroundColor: FlutterFlowTheme.of(context).accent1,
                        borderWidth: 0.0,
                        borderRadius: 0.0,
                        elevation: 0.0,
                        buttonMargin:
                            EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                        tabs: [
                          Tab(
                            text: 'All Classes',
                          ),
                          Tab(
                            text: 'Missed',
                          ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [() async {}, () async {}][i]();
                        },
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        children: [
                          KeepAliveWidgetWrapper(
                            builder: (context) => Material(
                              color: Colors.transparent,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      8.0, 6.0, 8.0, 0.0),
                                  child: SingleChildScrollView(
                                    primary: false,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -1.0, 0.0),
                                              child: Text(
                                                'Overall Classes',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmall
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmallFamily,
                                                          fontSize: 20.0,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .headlineSmallIsCustom,
                                                        ),
                                              ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                logFirebaseEvent(
                                                    'CLASSES_PAGE_Row_1klltaj8_ON_TAP');
                                                logFirebaseEvent(
                                                    'Row_show_snack_bar');
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Feature Currently Unavailable',
                                                      style: GoogleFonts.outfit(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 2000),
                                                    backgroundColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .error,
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                4.0, 0.0),
                                                    child: Text(
                                                      'View QuickNotes',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumFamily,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                4.0, 0.0),
                                                    child: Icon(
                                                      FFIcons.karrowUpRight,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      size: 18.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FlutterFlowDropDown<DateRange>(
                                              controller: _model
                                                      .dropDownValueController1 ??=
                                                  FormFieldController<
                                                      DateRange>(
                                                _model.dropDownValue1 ??=
                                                    DateRange.sevenDays,
                                              ),
                                              options: List<DateRange>.from(
                                                  DateRange.values),
                                              optionLabels:
                                                  (List<String> values) {
                                                return values
                                                    .map((e) =>
                                                        const {
                                                          'sevenDays': '7 Days',
                                                          'tenDays': '10 Days',
                                                          'thirtyDays':
                                                              '30 Days'
                                                        }[e] ??
                                                        e)
                                                    .toList();
                                              }(DateRange.values
                                                      .map((e) => e.name)
                                                      .toList()),
                                              onChanged: (val) async {
                                                safeSetState(() => _model
                                                    .dropDownValue1 = val);
                                                logFirebaseEvent(
                                                    'CLASSES_DropDown_35ys4ukh_ON_FORM_WIDGET');
                                                logFirebaseEvent(
                                                    'DropDown_update_page_state');
                                                _model.dateRange =
                                                    _model.dropDownValue1;
                                                safeSetState(() {});
                                                logFirebaseEvent(
                                                    'DropDown_custom_action');
                                                _model.generatedDatesDateRange =
                                                    await actions
                                                        .generatePastDateRange(
                                                  getCurrentTimestamp,
                                                  _model.dateRange!,
                                                  _model.weekendPolicy!,
                                                );
                                                logFirebaseEvent(
                                                    'DropDown_update_page_state');
                                                _model.generatedDatesState =
                                                    _model
                                                        .generatedDatesDateRange!
                                                        .toList()
                                                        .cast<DateTime>();
                                                logFirebaseEvent(
                                                    'DropDown_custom_action');
                                                await actions.syncAppData(
                                                  false,
                                                  false,
                                                  false,
                                                  true,
                                                  true,
                                                  false,
                                                  false,
                                                  _model.generatedDatesState
                                                      .toList(),
                                                );
                                                logFirebaseEvent(
                                                    'DropDown_rebuild_page');
                                                safeSetState(() {});

                                                safeSetState(() {});
                                              },
                                              width: 110.0,
                                              height: 26.0,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.outfit(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .info,
                                                    fontSize: 10.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                              hintText: 'Date Range',
                                              icon: Icon(
                                                FFIcons.kfilter01,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                size: 18.0,
                                              ),
                                              fillColor: Colors.black,
                                              elevation: 2.0,
                                              borderColor: Colors.transparent,
                                              borderWidth: 0.0,
                                              borderRadius: 8.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: false,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                            FlutterFlowDropDown<WeekendPolicy>(
                                              controller: _model
                                                      .dropDownValueController2 ??=
                                                  FormFieldController<
                                                      WeekendPolicy>(
                                                _model.dropDownValue2 ??=
                                                    WeekendPolicy.excludeAll,
                                              ),
                                              options: List<WeekendPolicy>.from(
                                                  WeekendPolicy.values),
                                              optionLabels:
                                                  (List<String> values) {
                                                return values
                                                    .map((e) =>
                                                        const {
                                                          'includeAll':
                                                              'Show All Days',
                                                          'excludeAll':
                                                              'Hide Weekends',
                                                          'excludeSaturdays':
                                                              'Hide Saturdays',
                                                          'excludeSundays':
                                                              'Hide Sundays'
                                                        }[e] ??
                                                        e)
                                                    .toList();
                                              }(WeekendPolicy.values
                                                      .map((e) => e.name)
                                                      .toList()),
                                              onChanged: (val) async {
                                                safeSetState(() => _model
                                                    .dropDownValue2 = val);
                                                logFirebaseEvent(
                                                    'CLASSES_DropDown_s6ujuy63_ON_FORM_WIDGET');
                                                logFirebaseEvent(
                                                    'DropDown_update_page_state');
                                                _model.weekendPolicy =
                                                    _model.dropDownValue2;
                                                logFirebaseEvent(
                                                    'DropDown_custom_action');
                                                _model.generatedDatesWeekendPolicy =
                                                    await actions
                                                        .generatePastDateRange(
                                                  getCurrentTimestamp,
                                                  _model.dateRange!,
                                                  _model.weekendPolicy!,
                                                );
                                                logFirebaseEvent(
                                                    'DropDown_update_page_state');
                                                _model.generatedDatesState = _model
                                                    .generatedDatesWeekendPolicy!
                                                    .toList()
                                                    .cast<DateTime>();
                                                logFirebaseEvent(
                                                    'DropDown_custom_action');
                                                await actions.syncAppData(
                                                  false,
                                                  false,
                                                  false,
                                                  true,
                                                  true,
                                                  false,
                                                  false,
                                                  _model.generatedDatesState
                                                      .toList(),
                                                );
                                                logFirebaseEvent(
                                                    'DropDown_rebuild_page');
                                                safeSetState(() {});

                                                safeSetState(() {});
                                              },
                                              width: 135.0,
                                              height: 25.0,
                                              textStyle: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.outfit(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .info,
                                                    fontSize: 10.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                              hintText: 'Weekend Filter',
                                              icon: Icon(
                                                Icons.filter_list,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                                size: 18.0,
                                              ),
                                              fillColor: Colors.black,
                                              elevation: 2.0,
                                              borderColor: Colors.transparent,
                                              borderWidth: 0.0,
                                              borderRadius: 6.0,
                                              margin: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 12.0, 0.0),
                                              hidesUnderline: true,
                                              isOverButton: false,
                                              isSearchable: false,
                                              isMultiSelect: false,
                                            ),
                                          ],
                                        ),
                                        Builder(
                                          builder: (context) {
                                            final generatedDatesListView =
                                                _model.generatedDatesState
                                                    .toList();

                                            return SingleChildScrollView(
                                              primary: false,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: List.generate(
                                                    generatedDatesListView
                                                        .length,
                                                    (generatedDatesListViewIndex) {
                                                  final generatedDatesListViewItem =
                                                      generatedDatesListView[
                                                          generatedDatesListViewIndex];
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        4.0,
                                                                        0.0),
                                                            child: Icon(
                                                              FFIcons
                                                                  .kdummyCircle,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                              size: 16.0,
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                AlignmentDirectional(
                                                                    -1.0, -1.0),
                                                            child: Text(
                                                              valueOrDefault<
                                                                  String>(
                                                                dateTimeFormat(
                                                                  "MMMMEEEEd",
                                                                  generatedDatesListViewItem,
                                                                  locale: FFLocalizations.of(
                                                                          context)
                                                                      .languageCode,
                                                                ),
                                                                'Sunday, July 19',
                                                              ),
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        FlutterFlowTheme.of(context)
                                                                            .bodyMediumFamily,
                                                                    fontSize:
                                                                        16.0,
                                                                    letterSpacing:
                                                                        0.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800,
                                                                    useGoogleFonts:
                                                                        !FlutterFlowTheme.of(context)
                                                                            .bodyMediumIsCustom,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    2.0,
                                                                    0.0,
                                                                    4.0),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final classesForDateListView = FFAppState()
                                                                .calendarClasses
                                                                .where((e) =>
                                                                    (dateTimeFormat(
                                                                          "d/M/y",
                                                                          e.scheduledStart,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        ) ==
                                                                        dateTimeFormat(
                                                                          "d/M/y",
                                                                          generatedDatesListViewItem,
                                                                          locale:
                                                                              FFLocalizations.of(context).languageCode,
                                                                        )) &&
                                                                    (e.scheduledStart! <= getCurrentTimestamp))
                                                                .toList()
                                                                .sortedList(keyOf: (e) => e.scheduledStart!, desc: true)
                                                                .toList();
                                                            if (classesForDateListView
                                                                .isEmpty) {
                                                              return Center(
                                                                child:
                                                                    Container(
                                                                  width: MediaQuery.sizeOf(
                                                                              context)
                                                                          .width *
                                                                      1.0,
                                                                  height: 100.0,
                                                                  child:
                                                                      EmptyStateContainerWidget(
                                                                    date:
                                                                        generatedDatesListViewItem,
                                                                    title:
                                                                        'Nothing Here!',
                                                                    message:
                                                                        'There are no upcoming classes scheduled. Check back later or sync your timetable if you recently made changes.',
                                                                  ),
                                                                ),
                                                              );
                                                            }

                                                            return Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: List.generate(
                                                                  classesForDateListView
                                                                      .length,
                                                                  (classesForDateListViewIndex) {
                                                                final classesForDateListViewItem =
                                                                    classesForDateListView[
                                                                        classesForDateListViewIndex];
                                                                return Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          2.0),
                                                                  child:
                                                                      wrapWithModel(
                                                                    model: _model
                                                                        .classBlockGeneralModels1
                                                                        .getModel(
                                                                      classesForDateListViewItem
                                                                          .classId,
                                                                      classesForDateListViewIndex,
                                                                    ),
                                                                    updateCallback: () =>
                                                                        safeSetState(
                                                                            () {}),
                                                                    child:
                                                                        ClassBlockGeneralWidget(
                                                                      key: Key(
                                                                        'Keysjj_${classesForDateListViewItem.classId}',
                                                                      ),
                                                                      classBlock:
                                                                          classesForDateListViewItem,
                                                                    ),
                                                                  ),
                                                                );
                                                              }),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                              ),
                                            );
                                          },
                                        ),
                                      ].divide(SizedBox(height: 8.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          KeepAliveWidgetWrapper(
                            builder: (context) => Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 6.0, 8.0, 0.0),
                                child: SingleChildScrollView(
                                  primary: false,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: Text(
                                          'Missed Classes (${valueOrDefault<String>(
                                            FFAppState()
                                                .missedClasses
                                                .length
                                                .toString(),
                                            '0',
                                          )})',
                                          style: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineSmallFamily,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .headlineSmallIsCustom,
                                              ),
                                        ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          final missedClassesListView =
                                              FFAppState()
                                                  .missedClasses
                                                  .toList();
                                          if (missedClassesListView.isEmpty) {
                                            return Center(
                                              child: EmptyStateGifWidget(
                                                imageUrl:
                                                    'https://cdn-icons-gif.flaticon.com/19015/19015298.gif',
                                                title: valueOrDefault<String>(
                                                  functions
                                                      .getEmptyStateMessage(
                                                          getCurrentTimestamp,
                                                          FFAppState()
                                                              .userPreferences
                                                              .preferredActionTone,
                                                          dateTimeFormat(
                                                            "d/M/y",
                                                            getCurrentTimestamp,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ))
                                                      .firstOrNull,
                                                  'No Classes Today!',
                                                ),
                                                description:
                                                    valueOrDefault<String>(
                                                  functions
                                                      .getEmptyStateMessage(
                                                          getCurrentTimestamp,
                                                          FFAppState()
                                                              .userPreferences
                                                              .preferredActionTone,
                                                          dateTimeFormat(
                                                            "d/M/y",
                                                            getCurrentTimestamp,
                                                            locale: FFLocalizations
                                                                    .of(context)
                                                                .languageCode,
                                                          ))
                                                      .lastOrNull,
                                                  'No Classes Today!',
                                                ),
                                              ),
                                            );
                                          }

                                          return Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: List.generate(
                                                missedClassesListView.length,
                                                (missedClassesListViewIndex) {
                                              final missedClassesListViewItem =
                                                  missedClassesListView[
                                                      missedClassesListViewIndex];
                                              return Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 4.0, 0.0, 0.0),
                                                child: wrapWithModel(
                                                  model: _model
                                                      .classBlockGeneralModels2
                                                      .getModel(
                                                    missedClassesListViewItem
                                                        .classId,
                                                    missedClassesListViewIndex,
                                                  ),
                                                  updateCallback: () =>
                                                      safeSetState(() {}),
                                                  child:
                                                      ClassBlockGeneralWidget(
                                                    key: Key(
                                                      'Keyydi_${missedClassesListViewItem.classId}',
                                                    ),
                                                    classBlock:
                                                        missedClassesListViewItem,
                                                  ),
                                                ),
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
