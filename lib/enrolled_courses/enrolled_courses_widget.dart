import '/backend/schema/structs/index.dart';
import '/components/core_course_block_widget.dart';
import '/components/elective_course_block_widget.dart';
import '/components/lab_selection_block_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'enrolled_courses_model.dart';
export 'enrolled_courses_model.dart';

class EnrolledCoursesWidget extends StatefulWidget {
  const EnrolledCoursesWidget({super.key});

  static String routeName = 'enrolledCourses';
  static String routePath = 'enrolledCourses';

  @override
  State<EnrolledCoursesWidget> createState() => _EnrolledCoursesWidgetState();
}

class _EnrolledCoursesWidgetState extends State<EnrolledCoursesWidget> {
  late EnrolledCoursesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EnrolledCoursesModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'enrolledCourses'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('ENROLLED_COURSES_enrolledCourses_ON_INIT');
      logFirebaseEvent('enrolledCourses_custom_action');
      _model.userLabCourses = await actions.getLabCourses(
        FFAppState().userProfile.batchId,
      );
      logFirebaseEvent('enrolledCourses_custom_action');
      _model.userElectiveRequirement =
          await actions.getElectiveRequirementsList(
        FFAppState().userProfile.batchId,
        FFAppState().userProfile.currentSemester,
      );
      logFirebaseEvent('enrolledCourses_custom_action');
      _model.electiveCoursesCatalogQuery = await actions.getElectiveCourses(
        FFAppState().userProfile.batchId,
      );
      logFirebaseEvent('enrolledCourses_update_page_state');
      _model.labCourseCatelog =
          _model.userLabCourses!.toList().cast<EnrolledCourseStruct>();
      _model.userElectiveRequirementList =
          _model.userElectiveRequirement!.toList().cast<String>();
      _model.electiveCourseCatelog = _model.electiveCoursesCatalogQuery!
          .toList()
          .cast<ElectiveCourseStruct>();
      _model.selectedLabCourses = FFAppState()
          .userProfile
          .enrolledCourses
          .where((e) => !e.isElective && e.isLab)
          .toList()
          .toList()
          .cast<EnrolledCourseStruct>();
      _model.selectedElectiveCourses = FFAppState()
          .userProfile
          .enrolledCourses
          .where((e) => e.isElective && !e.isLab)
          .toList()
          .toList()
          .cast<EnrolledCourseStruct>();
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
    context.watch<FFAppState>();

    return Title(
        title: 'enrolledCourses',
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
                  logFirebaseEvent('ENROLLED_COURSES_arrowLeft_ICN_ON_TAP');
                  logFirebaseEvent('IconButton_navigate_back');
                  context.pop();
                },
              ),
              title: Text(
                'Enrolled Courses',
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
              child: SingleChildScrollView(
                primary: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                          0.0,
                          0.0),
                      child: Text(
                        'Your courses for this semester:',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .headlineMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: !FlutterFlowTheme.of(context)
                                  .headlineMediumIsCustom,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(18.0, 2.0, 0.0, 4.0),
                      child: Text(
                        'Core Courses:',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                          0.0,
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                          0.0),
                      child: Builder(
                        builder: (context) {
                          final coreCoursesListView = functions
                              .mapCoreCourses(FFAppState()
                                  .userProfile
                                  .enrolledCourses
                                  .where((e) => !e.isElective && !e.isLab)
                                  .toList())
                              .toList();
                          if (coreCoursesListView.isEmpty) {
                            return Center(
                              child: Image.asset(
                                'assets/images/Empty_Icon.png',
                                width: 100.0,
                                height: 200.0,
                              ),
                            );
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(coreCoursesListView.length,
                                (coreCoursesListViewIndex) {
                              final coreCoursesListViewItem =
                                  coreCoursesListView[coreCoursesListViewIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    0.0,
                                    0.0,
                                    FlutterFlowTheme.of(context)
                                        .designToken
                                        .spacing
                                        .xs),
                                child: wrapWithModel(
                                  model: _model.coreCourseBlockModels.getModel(
                                    coreCoursesListViewItem.courseId,
                                    coreCoursesListViewIndex,
                                  ),
                                  updateCallback: () => safeSetState(() {}),
                                  child: CoreCourseBlockWidget(
                                    key: Key(
                                      'Key3cb_${coreCoursesListViewItem.courseId}',
                                    ),
                                    coreCourseData: coreCoursesListViewItem,
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                    StyledDivider(
                      thickness: 2.0,
                      indent: 10.0,
                      endIndent: 10.0,
                      color: FlutterFlowTheme.of(context).alternate,
                      lineStyle: DividerLineStyle.dashed,
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(18.0, 2.0, 0.0, 4.0),
                      child: Text(
                        'Lab Courses:',
                        style:
                            FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelMediumIsCustom,
                                ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                          0.0,
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                          0.0),
                      child: Builder(
                        builder: (context) {
                          final labCoursesListView = _model.labCourseCatelog
                              .unique((e) => e.courseCode)
                              .toList();
                          if (labCoursesListView.isEmpty) {
                            return Center(
                              child: Image.asset(
                                'assets/images/Empty_Icon.png',
                                width: 100.0,
                                height: 200.0,
                              ),
                            );
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(labCoursesListView.length,
                                (labCoursesListViewIndex) {
                              final labCoursesListViewItem =
                                  labCoursesListView[labCoursesListViewIndex];
                              return Builder(
                                builder: (context) => Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 4.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      logFirebaseEvent(
                                          'ENROLLED_COURSES_Container_v3iqhvut_ON_T');
                                      logFirebaseEvent(
                                          'labSelection_block_alert_dialog');
                                      await showDialog(
                                        context: context,
                                        builder: (dialogContext) {
                                          return Dialog(
                                            elevation: 0,
                                            insetPadding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            alignment: AlignmentDirectional(
                                                    0.0, 0.0)
                                                .resolve(
                                                    Directionality.of(context)),
                                            child: GestureDetector(
                                              onTap: () {
                                                FocusScope.of(dialogContext)
                                                    .unfocus();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              child: LabSelectionBlockWidget(
                                                courseBlocks:
                                                    _model.labCourseCatelog,
                                                requiredlabCourseCode:
                                                    labCoursesListViewItem
                                                        .courseCode,
                                                addSelectedLabCourse:
                                                    (selectedLabCourse) async {
                                                  logFirebaseEvent(
                                                      '_update_page_state');
                                                  _model
                                                      .addToSelectedLabCourses(
                                                          selectedLabCourse);
                                                },
                                                removeSelectedLabCourse:
                                                    (selectedLabCourseToRemove) async {
                                                  logFirebaseEvent(
                                                      '_update_page_state');
                                                  _model.removeFromSelectedLabCourses(
                                                      selectedLabCourseToRemove);
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: wrapWithModel(
                                      model: _model.labSelectionBlockModels
                                          .getModel(
                                        labCoursesListViewItem.courseCode,
                                        labCoursesListViewIndex,
                                      ),
                                      updateCallback: () => safeSetState(() {}),
                                      child: LabSelectionBlockWidget(
                                        key: Key(
                                          'Keyv3i_${labCoursesListViewItem.courseCode}',
                                        ),
                                        requiredlabCourseCode:
                                            labCoursesListViewItem.courseCode,
                                        courseBlocks: _model.labCourseCatelog,
                                        addSelectedLabCourse:
                                            (selectedLabCourse) async {
                                          logFirebaseEvent(
                                              'ENROLLED_COURSES_Container_v3iqhvut_CALL');
                                          logFirebaseEvent(
                                              'labSelection_block_update_page_state');
                                          _model.addToSelectedLabCourses(
                                              selectedLabCourse);
                                        },
                                        removeSelectedLabCourse:
                                            (selectedLabCourseToRemove) async {
                                          logFirebaseEvent(
                                              'ENROLLED_COURSES_Container_v3iqhvut_CALL');
                                          logFirebaseEvent(
                                              'labSelection_block_update_page_state');
                                          _model.removeFromSelectedLabCourses(
                                              selectedLabCourseToRemove);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                    StyledDivider(
                      thickness: 2.0,
                      indent: 10.0,
                      endIndent: 10.0,
                      color: FlutterFlowTheme.of(context).alternate,
                      lineStyle: DividerLineStyle.dashed,
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(18.0, 2.0, 0.0, 4.0),
                        child: Text(
                          'Elective Courses:',
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                fontSize: 16.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .labelMediumIsCustom,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                          0.0,
                          FlutterFlowTheme.of(context).designToken.spacing.md,
                          0.0),
                      child: Builder(
                        builder: (context) {
                          final requiredElectivesListView =
                              _model.userElectiveRequirementList.toList();
                          if (requiredElectivesListView.isEmpty) {
                            return Center(
                              child: Image.asset(
                                'assets/images/Empty_Icon.png',
                                width: 100.0,
                                height: 200.0,
                              ),
                            );
                          }

                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            children:
                                List.generate(requiredElectivesListView.length,
                                    (requiredElectivesListViewIndex) {
                              final requiredElectivesListViewItem =
                                  requiredElectivesListView[
                                      requiredElectivesListViewIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    0.0,
                                    0.0,
                                    FlutterFlowTheme.of(context)
                                        .designToken
                                        .spacing
                                        .xs),
                                child: wrapWithModel(
                                  model:
                                      _model.electiveCourseBlockModels.getModel(
                                    requiredElectivesListViewIndex.toString(),
                                    requiredElectivesListViewIndex,
                                  ),
                                  updateCallback: () => safeSetState(() {}),
                                  child: ElectiveCourseBlockWidget(
                                    key: Key(
                                      'Keyqgd_${requiredElectivesListViewIndex.toString()}',
                                    ),
                                    electiveCategory:
                                        requiredElectivesListViewItem,
                                    electiveData: _model.electiveCourseCatelog,
                                    selectedElectiveCourse:
                                        (electiveCourse) async {
                                      logFirebaseEvent(
                                          'ENROLLED_COURSES_Container_qgdapkve_CALL');
                                      logFirebaseEvent(
                                          'electiveCourse_block_update_page_state');
                                      _model.addToSelectedElectiveCourses(
                                          electiveCourse);
                                    },
                                    removeSelectedElective:
                                        (electiveCourseData) async {
                                      logFirebaseEvent(
                                          'ENROLLED_COURSES_Container_qgdapkve_CALL');
                                      logFirebaseEvent(
                                          'electiveCourse_block_update_page_state');
                                      _model.removeFromSelectedElectiveCourses(
                                          electiveCourseData);
                                    },
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 20.0, 16.0, 20.0),
                      child: FFButtonWidget(
                        onPressed: ((_model.selectedLabCourses.length !=
                                    _model.labCourseCatelog
                                        .unique((e) => e.courseCode)
                                        .length) &&
                                (_model.selectedElectiveCourses.length !=
                                    _model.userElectiveRequirementList.length))
                            ? null
                            : () async {
                                logFirebaseEvent(
                                    'ENROLLED_COURSES_UPDATE_COURSES_BTN_ON_T');
                                logFirebaseEvent('Button_custom_action');
                                _model.combinedCourses =
                                    await actions.combineEnrolledCourses(
                                  FFAppState()
                                      .userProfile
                                      .enrolledCourses
                                      .where((e) =>
                                          (e.isElective == false) &&
                                          (e.isLab == false))
                                      .toList(),
                                  _model.selectedElectiveCourses.toList(),
                                  _model.selectedLabCourses.toList(),
                                );
                                logFirebaseEvent('Button_custom_action');
                                _model.courseEnrollmentComplete =
                                    await actions.completeCourseEnrollment(
                                  _model.combinedCourses!.toList(),
                                );
                                if (_model.courseEnrollmentComplete!.success) {
                                  logFirebaseEvent('Button_update_app_state');
                                  FFAppState().updateUserProfileStruct(
                                    (e) => e
                                      ..enrolledCourses =
                                          _model.combinedCourses!.toList(),
                                  );
                                }
                                logFirebaseEvent('Button_show_snack_bar');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _model.courseEnrollmentComplete!.message,
                                      style: GoogleFonts.outfit(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    duration: Duration(milliseconds: 4000),
                                    backgroundColor: _model
                                            .courseEnrollmentComplete!.success
                                        ? FlutterFlowTheme.of(context).success
                                        : FlutterFlowTheme.of(context).error,
                                  ),
                                );

                                safeSetState(() {});
                              },
                        text: 'Update Courses',
                        icon: Icon(
                          FFIcons.kfileEdit,
                          size: 24.0,
                        ),
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 45.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).info,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(12.0),
                          disabledColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          disabledTextColor:
                              FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                    ),
                  ].addToEnd(SizedBox(height: 40.0)),
                ),
              ),
            ),
          ),
        ));
  }
}
