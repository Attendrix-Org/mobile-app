import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/bottom_sheets/why_do_we_need_your_info/why_do_we_need_your_info_widget.dart';
import '/components/core_course_block_widget.dart';
import '/components/elective_course_block_widget.dart';
import '/components/lab_selection_block_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:styled_divider/styled_divider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'onboarding_model.dart';
export 'onboarding_model.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  static String routeName = 'onboarding';
  static String routePath = 'onboarding';

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget>
    with TickerProviderStateMixin {
  late OnboardingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'onboarding'});
    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      logFirebaseEvent('ONBOARDING_PAGE_onboarding_ON_INIT_STATE');
      if (!_model.dataLoaded || !(_model.semesterData.isNotEmpty)) {
        logFirebaseEvent('onboarding_backend_call');
        _model.semesterQueryData = await SemestersTable().queryRows(
          queryFn: (q) => q,
        );
        logFirebaseEvent('onboarding_backend_call');
        _model.batchDataQuery = await BatchesTable().queryRows(
          queryFn: (q) => q.eqOrNull(
            'semester_id',
            _model.semesterQueryData?.firstOrNull?.semesterId,
          ),
        );
        logFirebaseEvent('onboarding_update_page_state');
        _model.semesterData =
            _model.semesterQueryData!.toList().cast<SemestersRow>();
        _model.dataLoaded = true;
        _model.batchData = _model.batchDataQuery!.toList().cast<BatchesRow>();
        safeSetState(() {});
      }
    });

    _model.fullNameTextController ??= TextEditingController();
    _model.fullNameFocusNode ??= FocusNode();

    _model.rollNumberTextController ??= TextEditingController();
    _model.rollNumberFocusNode ??= FocusNode();
    _model.rollNumberFocusNode!.addListener(
      () async {
        logFirebaseEvent('ONBOARDING_rollNumber_ON_FOCUS_CHANGE');
        logFirebaseEvent('rollNumber_custom_action');
        _model.parsedRollNumberDetailsCopy = await actions.parseRollNumber(
          _model.rollNumberTextController.text,
        );
        logFirebaseEvent('rollNumber_set_form_field');
        _model.semesterValueController?.value =
            _model.parsedRollNumberDetailsCopy!.semesterNumber;
        _model.semesterValue =
            _model.parsedRollNumberDetailsCopy!.semesterNumber;
        logFirebaseEvent('rollNumber_set_form_field');
        _model.branchValueController?.value =
            _model.parsedRollNumberDetailsCopy!.departmentId;
        _model.branchValue = _model.parsedRollNumberDetailsCopy!.departmentId;
        logFirebaseEvent('rollNumber_backend_call');
        _model.batchQueryDataCopy = await BatchesTable().queryRows(
          queryFn: (q) => q.eqOrNull(
            'semester_number',
            valueOrDefault<int>(
              _model.parsedRollNumberDetailsCopy?.semesterNumber,
              5,
            ),
          ),
        );
        logFirebaseEvent('rollNumber_update_page_state');
        _model.rollNumber = _model.rollNumberTextController.text;
        _model.branch = _model.parsedRollNumberDetailsCopy?.departmentId;
        _model.semester = _model.semesterQueryData
            ?.where((e) =>
                e.semesterNumber ==
                _model.parsedRollNumberDetailsCopy?.semesterNumber)
            .toList()
            .firstOrNull
            ?.semesterNumber;
        _model.batchData =
            _model.batchQueryDataCopy!.toList().cast<BatchesRow>();
        safeSetState(() {});

        safeSetState(() {});
      },
    );
    _model.userBioTextController ??= TextEditingController();
    _model.userBioFocusNode ??= FocusNode();
    _model.userBioFocusNode!.addListener(() => safeSetState(() {}));
    _model.usernameTextController ??= TextEditingController();
    _model.usernameFocusNode ??= FocusNode();

    animationsMap.addAll({
      'textOnPageLoadAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'textOnPageLoadAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 400.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 400.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'textOnPageLoadAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 800.0.ms,
            duration: 500.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'richTextOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1200.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 1200.0.ms,
            duration: 600.0.ms,
            begin: Offset(0.0, 100.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

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
        title: 'onboarding',
        color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: PopScope(
            canPop: false,
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              body: SafeArea(
                top: true,
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _model.onboardingPagesController ??=
                              PageController(initialPage: 0),
                          onPageChanged: (_) => safeSetState(() {}),
                          scrollDirection: Axis.horizontal,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Let\'s Set Up Your Academic Profile',
                                          style: FlutterFlowTheme.of(context)
                                              .headlineMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMediumFamily,
                                                fontSize: 22.0,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .headlineMediumIsCustom,
                                              ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 12.0),
                                          child: RichText(
                                            textScaler: MediaQuery.of(context)
                                                .textScaler,
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Tell us a few details about your academic profile so we can personalize your timetable, courses, and campus experience. Why do we ask for this information? ',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            fontSize: 10.0,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                ),
                                                TextSpan(
                                                  text: 'Tap to Learn More. ',
                                                  style: GoogleFonts.outfit(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                  mouseCursor:
                                                      SystemMouseCursors.click,
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () async {
                                                          logFirebaseEvent(
                                                              'ONBOARDING_RichTextSpan_jfbwqc73_ON_TAP');
                                                          logFirebaseEvent(
                                                              'RichTextSpan_bottom_sheet');
                                                          await showModalBottomSheet(
                                                            isScrollControlled:
                                                                true,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            isDismissible:
                                                                false,
                                                            enableDrag: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                  FocusManager
                                                                      .instance
                                                                      .primaryFocus
                                                                      ?.unfocus();
                                                                },
                                                                child: Padding(
                                                                  padding: MediaQuery
                                                                      .viewInsetsOf(
                                                                          context),
                                                                  child:
                                                                      WhyDoWeNeedYourInfoWidget(),
                                                                ),
                                                              );
                                                            },
                                                          ).then((value) =>
                                                              safeSetState(
                                                                  () {}));
                                                        },
                                                ),
                                                TextSpan(
                                                  text:
                                                      'Can\'t find your branch or batch? ',
                                                  style: TextStyle(),
                                                ),
                                                TextSpan(
                                                  text: 'Request here',
                                                  style: GoogleFonts.outfit(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .tertiary,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                )
                                              ],
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMedium
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelMediumFamily,
                                                        fontSize: 10.0,
                                                        letterSpacing: 0.0,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .labelMediumIsCustom,
                                                      ),
                                            ),
                                          ),
                                        ),
                                        Form(
                                          key: _model.formKey1,
                                          autovalidateMode:
                                              AutovalidateMode.always,
                                          child: SingleChildScrollView(
                                            primary: false,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'What should we call you?',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 8.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller: _model
                                                          .fullNameTextController,
                                                      focusNode: _model
                                                          .fullNameFocusNode,
                                                      onChanged: (_) =>
                                                          EasyDebounce.debounce(
                                                        '_model.fullNameTextController',
                                                        Duration(
                                                            milliseconds: 2000),
                                                        () async {
                                                          logFirebaseEvent(
                                                              'ONBOARDING_fullName_ON_TEXTFIELD_CHANGE');
                                                          logFirebaseEvent(
                                                              'fullName_update_page_state');
                                                          _model.fullName = _model
                                                              .fullNameTextController
                                                              .text;
                                                          safeSetState(() {});
                                                        },
                                                      ),
                                                      autofocus: true,
                                                      autofillHints: [
                                                        AutofillHints.name
                                                      ],
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: false,
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLargeIsCustom,
                                                                ),
                                                        hintText: 'Your Name',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBackground,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            font: GoogleFonts
                                                                .outfit(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                      validator: _model
                                                          .fullNameTextControllerValidator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'What\'s your institute roll number?',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 8.0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    child: TextFormField(
                                                      controller: _model
                                                          .rollNumberTextController,
                                                      focusNode: _model
                                                          .rollNumberFocusNode,
                                                      onFieldSubmitted:
                                                          (_) async {
                                                        logFirebaseEvent(
                                                            'ONBOARDING_rollNumber_ON_TEXTFIELD_SUBMI');
                                                        logFirebaseEvent(
                                                            'rollNumber_custom_action');
                                                        _model.parsedRollNumberDetails =
                                                            await actions
                                                                .parseRollNumber(
                                                          _model
                                                              .rollNumberTextController
                                                              .text,
                                                        );
                                                        logFirebaseEvent(
                                                            'rollNumber_set_form_field');
                                                        _model.semesterValueController
                                                                ?.value =
                                                            _model
                                                                .parsedRollNumberDetails!
                                                                .semesterNumber;
                                                        _model.semesterValue =
                                                            _model
                                                                .parsedRollNumberDetails!
                                                                .semesterNumber;
                                                        logFirebaseEvent(
                                                            'rollNumber_set_form_field');
                                                        _model.branchValueController
                                                                ?.value =
                                                            _model
                                                                .parsedRollNumberDetails!
                                                                .departmentId;
                                                        _model.branchValue = _model
                                                            .parsedRollNumberDetails!
                                                            .departmentId;
                                                        logFirebaseEvent(
                                                            'rollNumber_backend_call');
                                                        _model.batchQueryData =
                                                            await BatchesTable()
                                                                .queryRows(
                                                          queryFn: (q) =>
                                                              q.eqOrNull(
                                                            'semester_number',
                                                            valueOrDefault<int>(
                                                              _model
                                                                  .parsedRollNumberDetails
                                                                  ?.semesterNumber,
                                                              5,
                                                            ),
                                                          ),
                                                        );
                                                        logFirebaseEvent(
                                                            'rollNumber_update_page_state');
                                                        _model.rollNumber = _model
                                                            .rollNumberTextController
                                                            .text;
                                                        _model.branch = _model
                                                            .parsedRollNumberDetails
                                                            ?.departmentId;
                                                        _model.semester = _model
                                                            .semesterQueryData
                                                            ?.where((e) =>
                                                                e.semesterNumber ==
                                                                _model
                                                                    .parsedRollNumberDetails
                                                                    ?.semesterNumber)
                                                            .toList()
                                                            .firstOrNull
                                                            ?.semesterNumber;
                                                        _model.batchData = _model
                                                            .batchQueryData!
                                                            .toList()
                                                            .cast<BatchesRow>();
                                                        safeSetState(() {});

                                                        safeSetState(() {});
                                                      },
                                                      autofocus: true,
                                                      autofillHints: [
                                                        AutofillHints.name
                                                      ],
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      obscureText: false,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: false,
                                                        labelStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .labelLarge
                                                                .override(
                                                                  fontFamily: FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  useGoogleFonts:
                                                                      !FlutterFlowTheme.of(
                                                                              context)
                                                                          .labelLargeIsCustom,
                                                                ),
                                                        hintText:
                                                            'Institute Roll Number',
                                                        hintStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .outfit(
                                                                    fontWeight: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontWeight,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyLarge
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontWeight,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                                ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .alternate,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primary,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        focusedErrorBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .error,
                                                            width: 2.0,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        filled: true,
                                                        fillColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryBackground,
                                                      ),
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyLarge
                                                          .override(
                                                            font: GoogleFonts
                                                                .outfit(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                      validator: _model
                                                          .rollNumberTextControllerValidator
                                                          .asValidator(context),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'What’s your current semester?',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                ),
                                                FlutterFlowDropDown<int>(
                                                  controller: _model
                                                          .semesterValueController ??=
                                                      FormFieldController<int>(
                                                          null),
                                                  options: List<int>.from(_model
                                                      .semesterData
                                                      .map((e) =>
                                                          e.semesterNumber)
                                                      .withoutNulls
                                                      .toList()),
                                                  optionLabels: _model
                                                      .semesterData
                                                      .map(
                                                          (e) => e.semesterName)
                                                      .toList(),
                                                  onChanged: (val) async {
                                                    safeSetState(() => _model
                                                        .semesterValue = val);
                                                    logFirebaseEvent(
                                                        'ONBOARDING_semester_ON_FORM_WIDGET_SELEC');
                                                    logFirebaseEvent(
                                                        'semester_update_page_state');
                                                    _model.semester =
                                                        _model.semesterValue;
                                                    logFirebaseEvent(
                                                        'semester_backend_call');
                                                    _model.batchQueryDataViaSemester =
                                                        await BatchesTable()
                                                            .queryRows(
                                                      queryFn: (q) =>
                                                          q.eqOrNull(
                                                        'semester_number',
                                                        _model.semester,
                                                      ),
                                                    );
                                                    logFirebaseEvent(
                                                        'semester_update_page_state');
                                                    _model.batchData = _model
                                                        .batchQueryDataViaSemester!
                                                        .toList()
                                                        .cast<BatchesRow>();
                                                    safeSetState(() {});

                                                    safeSetState(() {});
                                                  },
                                                  width: double.infinity,
                                                  height: 50.0,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .headlineSmall
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmallFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmallIsCustom,
                                                      ),
                                                  hintText: 'Semester',
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  elevation: 2.0,
                                                  borderColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  borderWidth: 2.0,
                                                  borderRadius: 12.0,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  hidesUnderline: true,
                                                  isOverButton: false,
                                                  isSearchable: false,
                                                  isMultiSelect: false,
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 4.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Which branch do you belong to?',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                                FlutterFlowDropDown<String>(
                                                  controller: _model
                                                          .branchValueController ??=
                                                      FormFieldController<
                                                          String>(null),
                                                  options: List<String>.from(
                                                      _model.batchData
                                                          .map((e) =>
                                                              e.departmentId)
                                                          .toList()
                                                          .unique((e) => e)),
                                                  optionLabels: _model.batchData
                                                      .map((e) =>
                                                          e.departmentName)
                                                      .toList()
                                                      .unique((e) => e),
                                                  onChanged: (val) async {
                                                    safeSetState(() => _model
                                                        .branchValue = val);
                                                    logFirebaseEvent(
                                                        'ONBOARDING_branch_ON_FORM_WIDGET_SELECTE');
                                                    logFirebaseEvent(
                                                        'branch_update_page_state');
                                                    _model.branch =
                                                        _model.branchValue;
                                                  },
                                                  width: double.infinity,
                                                  height: 50.0,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .headlineSmall
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmallFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmallIsCustom,
                                                      ),
                                                  hintText: 'Branch',
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  elevation: 2.0,
                                                  borderColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  borderWidth: 2.0,
                                                  borderRadius: 12.0,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  hidesUnderline: true,
                                                  disabled: !(_model
                                                      .batchData.isNotEmpty),
                                                  isOverButton: false,
                                                  isSearchable: false,
                                                  isMultiSelect: false,
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 4.0, 0.0, 0.0),
                                                  child: Text(
                                                    'Which batch do you belong to?',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .labelMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelMediumFamily,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                                FlutterFlowDropDown<String>(
                                                  controller: _model
                                                          .batchValueController ??=
                                                      FormFieldController<
                                                          String>(null),
                                                  options: _model.batchData
                                                      .where((e) =>
                                                          e.departmentId ==
                                                          _model.branch)
                                                      .toList()
                                                      .map((e) => e.batchId)
                                                      .toList(),
                                                  onChanged: (val) async {
                                                    safeSetState(() => _model
                                                        .batchValue = val);
                                                    logFirebaseEvent(
                                                        'ONBOARDING_batch_ON_FORM_WIDGET_SELECTED');
                                                    logFirebaseEvent(
                                                        'batch_update_page_state');
                                                    _model.batch =
                                                        _model.batchValue;
                                                    safeSetState(() {});
                                                  },
                                                  width: double.infinity,
                                                  height: 50.0,
                                                  textStyle: FlutterFlowTheme
                                                          .of(context)
                                                      .headlineSmall
                                                      .override(
                                                        fontFamily:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .headlineSmallFamily,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        fontSize: 16.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        useGoogleFonts:
                                                            !FlutterFlowTheme
                                                                    .of(context)
                                                                .headlineSmallIsCustom,
                                                      ),
                                                  hintText: 'Batch',
                                                  icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                    size: 24.0,
                                                  ),
                                                  fillColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primaryBackground,
                                                  elevation: 2.0,
                                                  borderColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .alternate,
                                                  borderWidth: 2.0,
                                                  borderRadius: 12.0,
                                                  margin: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          12.0, 0.0, 12.0, 0.0),
                                                  hidesUnderline: true,
                                                  disabled:
                                                      _model.branch == null ||
                                                          _model.branch == '',
                                                  isOverButton: false,
                                                  isSearchable: false,
                                                  isMultiSelect: false,
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 4.0, 0.0, 0.0),
                                                  child: RichText(
                                                    textScaler:
                                                        MediaQuery.of(context)
                                                            .textScaler,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Tell us about yourself ',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .labelMedium
                                                              .override(
                                                                fontFamily: FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                                letterSpacing:
                                                                    0.0,
                                                                useGoogleFonts:
                                                                    !FlutterFlowTheme.of(
                                                                            context)
                                                                        .labelMediumIsCustom,
                                                              ),
                                                        ),
                                                        TextSpan(
                                                          text: '(Optional):',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xB3606A85),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12.0,
                                                          ),
                                                        )
                                                      ],
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .labelMedium
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumFamily,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .labelMediumIsCustom,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                TextFormField(
                                                  controller: _model
                                                      .userBioTextController,
                                                  focusNode:
                                                      _model.userBioFocusNode,
                                                  onFieldSubmitted: (_) async {
                                                    logFirebaseEvent(
                                                        'ONBOARDING_userBio_ON_TEXTFIELD_SUBMIT');
                                                    logFirebaseEvent(
                                                        'userBio_update_page_state');
                                                    _model.userBio = _model
                                                        .userBioTextController
                                                        .text;
                                                    safeSetState(() {});
                                                  },
                                                  autofocus: true,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelLarge
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeFamily,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelLargeIsCustom,
                                                            ),
                                                    alignLabelWithHint: false,
                                                    hintText:
                                                        'Introduce yourself in a few words.',
                                                    hintStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumFamily,
                                                              fontSize: 16.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .labelMediumIsCustom,
                                                            ),
                                                    errorStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumFamily,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .error,
                                                              fontSize: 12.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              useGoogleFonts:
                                                                  !FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMediumIsCustom,
                                                            ),
                                                    counterStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .override(
                                                              font: GoogleFonts
                                                                  .outfit(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                              ),
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyLarge
                                                                      .fontStyle,
                                                            ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .alternate,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .primaryBackground,
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                16.0,
                                                                16.0,
                                                                16.0,
                                                                16.0),
                                                  ),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyLarge
                                                      .override(
                                                        font:
                                                            GoogleFonts.outfit(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                        fontSize: 14.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyLarge
                                                                .fontStyle,
                                                      ),
                                                  maxLines: 5,
                                                  minLines: 3,
                                                  maxLength: 200,
                                                  maxLengthEnforcement:
                                                      MaxLengthEnforcement
                                                          .enforced,
                                                  cursorColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  validator: _model
                                                      .userBioTextControllerValidator
                                                      .asValidator(context),
                                                  inputFormatters: [
                                                    if (!isAndroid && !isiOS)
                                                      TextInputFormatter
                                                          .withFunction(
                                                              (oldValue,
                                                                  newValue) {
                                                        return TextEditingValue(
                                                          selection: newValue
                                                              .selection,
                                                          text: newValue.text
                                                              .toCapitalization(
                                                                  TextCapitalization
                                                                      .words),
                                                        );
                                                      }),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 20.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 6.0),
                                              child: Theme(
                                                data: ThemeData(
                                                  checkboxTheme:
                                                      CheckboxThemeData(
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                    ),
                                                  ),
                                                  unselectedWidgetColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .secondaryText,
                                                ),
                                                child: Checkbox(
                                                  value: _model
                                                      .checkboxValue1 ??= false,
                                                  onChanged: (newValue) async {
                                                    safeSetState(() =>
                                                        _model.checkboxValue1 =
                                                            newValue!);
                                                    if (newValue!) {
                                                      logFirebaseEvent(
                                                          'ONBOARDING_Checkbox_1q2cejmq_ON_TOGGLE_O');
                                                      logFirebaseEvent(
                                                          'Checkbox_update_page_state');
                                                      _model.acceptedTermsAndConditions =
                                                          true;
                                                      safeSetState(() {});
                                                    } else {
                                                      logFirebaseEvent(
                                                          'ONBOARDING_Checkbox_1q2cejmq_ON_TOGGLE_O');
                                                      logFirebaseEvent(
                                                          'Checkbox_update_page_state');
                                                      _model.acceptedTermsAndConditions =
                                                          false;
                                                      safeSetState(() {});
                                                    }
                                                  },
                                                  side: (FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText !=
                                                          null)
                                                      ? BorderSide(
                                                          width: 2,
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                        )
                                                      : null,
                                                  activeColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .primary,
                                                  checkColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .info,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.832,
                                              decoration: BoxDecoration(),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'I confirm that I have read and agree to the ',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 11.0,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'Terms of Service',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' and',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' Privacy Policy ',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' of Attendrix Inc.',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 13.0,
                                                        ),
                                                      )
                                                    ],
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 6.0),
                                            child: Theme(
                                              data: ThemeData(
                                                checkboxTheme:
                                                    CheckboxThemeData(
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                  ),
                                                ),
                                                unselectedWidgetColor:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                              child: Checkbox(
                                                value: _model.checkboxValue2 ??=
                                                    false,
                                                onChanged: (newValue) async {
                                                  safeSetState(() =>
                                                      _model.checkboxValue2 =
                                                          newValue!);
                                                  if (newValue!) {
                                                    logFirebaseEvent(
                                                        'ONBOARDING_Checkbox_g08lcsk6_ON_TOGGLE_O');
                                                    logFirebaseEvent(
                                                        'Checkbox_update_page_state');
                                                    _model.acceptedMarketingEmails =
                                                        true;
                                                    safeSetState(() {});
                                                  } else {
                                                    logFirebaseEvent(
                                                        'ONBOARDING_Checkbox_g08lcsk6_ON_TOGGLE_O');
                                                    logFirebaseEvent(
                                                        'Checkbox_update_page_state');
                                                    _model.acceptedMarketingEmails =
                                                        false;
                                                    safeSetState(() {});
                                                  }
                                                },
                                                side: (FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText !=
                                                        null)
                                                    ? BorderSide(
                                                        width: 2,
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                      )
                                                    : null,
                                                activeColor:
                                                    FlutterFlowTheme.of(context)
                                                        .primary,
                                                checkColor:
                                                    FlutterFlowTheme.of(context)
                                                        .info,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.832,
                                            decoration: BoxDecoration(),
                                            child: Align(
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 0.0, 0.0, 8.0),
                                                child: RichText(
                                                  textScaler:
                                                      MediaQuery.of(context)
                                                          .textScaler,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'Get promotional content and updates about Attendrix and its affiliates via email. ',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '(Optional)',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.0,
                                                        ),
                                                      )
                                                    ],
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMediumFamily,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMediumIsCustom,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      FFButtonWidget(
                                        onPressed: !((_model.fullNameTextController
                                                            .text !=
                                                        '') &&
                                                (_model.rollNumberTextController
                                                            .text !=
                                                        '') &&
                                                (_model.semesterValue !=
                                                    null) &&
                                                (_model.branchValue != null &&
                                                    _model.branchValue != '') &&
                                                (_model.batchValue != null &&
                                                    _model.batchValue != '') &&
                                                (_model.checkboxValue1 == true))
                                            ? null
                                            : () async {
                                                logFirebaseEvent(
                                                    'ONBOARDING_PAGE_CONTINUE_BTN_ON_TAP');
                                                logFirebaseEvent(
                                                    'Button_validate_form');
                                                _model.academicProfileFormValidation =
                                                    true;
                                                if (_model.formKey1
                                                            .currentState ==
                                                        null ||
                                                    !_model
                                                        .formKey1.currentState!
                                                        .validate()) {
                                                  safeSetState(() => _model
                                                          .academicProfileFormValidation =
                                                      false);
                                                  return;
                                                }
                                                if (_model.semesterValue ==
                                                    null) {
                                                  _model.academicProfileFormValidation =
                                                      false;
                                                  safeSetState(() {});
                                                  return;
                                                }
                                                if (_model.branchValue ==
                                                    null) {
                                                  _model.academicProfileFormValidation =
                                                      false;
                                                  safeSetState(() {});
                                                  return;
                                                }
                                                if (_model.batchValue == null) {
                                                  _model.academicProfileFormValidation =
                                                      false;
                                                  safeSetState(() {});
                                                  return;
                                                }
                                                if (_model
                                                        .academicProfileFormValidation! &&
                                                    _model.checkboxValue1!) {
                                                  logFirebaseEvent(
                                                      'Button_show_snack_bar');
                                                  ScaffoldMessenger.of(context)
                                                      .clearSnackBars();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Updating enrollment details... Your academic profile is being configured.',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 2000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .tertiary,
                                                    ),
                                                  );
                                                  logFirebaseEvent(
                                                      'Button_page_view');
                                                  unawaited(
                                                    () async {
                                                      await _model
                                                          .onboardingPagesController
                                                          ?.nextPage(
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.ease,
                                                      );
                                                    }(),
                                                  );
                                                  _model.enrolledCoreCourses.clear();
                                                  await Future.wait([
                                                    Future(() async {
                                                      logFirebaseEvent(
                                                          'Button_custom_action');
                                                      _model.coreCourseData =
                                                          await actions
                                                              .getCoreCourses(
                                                        _model.batch!,
                                                      );
                                                    }),
                                                    Future(() async {
                                                      logFirebaseEvent(
                                                          'Button_custom_action');
                                                      _model.requiredElectives =
                                                          await actions
                                                              .getElectiveRequirementsList(
                                                        _model.batch!,
                                                        _model.semester!,
                                                      );
                                                      logFirebaseEvent(
                                                          'Button_custom_action');
                                                      _model.electiveCourseData =
                                                          await actions
                                                              .getElectiveCourses(
                                                        _model.batch!,
                                                      );
                                                    }),
                                                    Future(() async {
                                                      logFirebaseEvent(
                                                          'Button_custom_action');
                                                      _model.labCourseData =
                                                          await actions
                                                              .getLabCourses(
                                                        _model.batch!,
                                                      );
                                                    }),
                                                  ]);
                                                } else if (_model
                                                        .academicProfileFormValidation! &&
                                                    !_model.checkboxValue1!) {
                                                  logFirebaseEvent(
                                                      'Button_show_snack_bar');
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Before we can finish customizing Attendrix for your program and batch, we just need you to accept our Terms of Service. Click below to review and agree.',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                    ),
                                                  );
                                                } else {
                                                  logFirebaseEvent(
                                                      'Button_show_snack_bar');
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Oops! Looks like some details are missing. Please fill them out to proceed.',
                                                        style:
                                                            GoogleFonts.outfit(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                      backgroundColor:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .error,
                                                    ),
                                                  );
                                                }

                                                safeSetState(() {});
                                              },
                                        text: 'Continue',
                                        options: FFButtonOptions(
                                          width: double.infinity,
                                          height: 48.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20.0, 0.0, 20.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: FlutterFlowTheme.of(context)
                                              .velvetSky,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                font: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                          elevation: 2.0,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          disabledColor:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          disabledTextColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ].addToEnd(SizedBox(height: 40.0)),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    FlutterFlowTheme.of(context).alternate,
                                    Color(0x92927FDD)
                                  ],
                                  stops: [0.0, 0.1, 0.2, 1.0],
                                  begin: AlignmentDirectional(0.0, -1.0),
                                  end: AlignmentDirectional(0, 1.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/Research_New_Pin_Crop.gif',
                                        width: 200.0,
                                        height: 144.4,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      'Choose Your Username',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 20.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 8.0),
                                      child: Text(
                                        'This is how you\'ll be known across Attendrix. Craft something uniquely yours, or tap the magic wand for a suggestion.',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 14.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Form(
                                            key: _model.formKey2,
                                            autovalidateMode:
                                                AutovalidateMode.disabled,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 2.0, 8.0),
                                              child: Container(
                                                width: double.infinity,
                                                child: TextFormField(
                                                  controller: _model
                                                      .usernameTextController,
                                                  focusNode:
                                                      _model.usernameFocusNode,
                                                  onChanged: (_) =>
                                                      EasyDebounce.debounce(
                                                    '_model.usernameTextController',
                                                    Duration(
                                                        milliseconds: 1000),
                                                    () async {
                                                      logFirebaseEvent(
                                                          'ONBOARDING_username_ON_TEXTFIELD_CHANGE');
                                                      logFirebaseEvent(
                                                          'username_custom_action');
                                                      _model.isUsernameAvailableServerResponse =
                                                          await actions
                                                              .isUsernameAvailable(
                                                        _model
                                                            .usernameTextController
                                                            .text,
                                                      );
                                                      logFirebaseEvent(
                                                          'username_update_page_state');
                                                      _model.isUsernameAvailable =
                                                          _model
                                                              .isUsernameAvailableServerResponse!;
                                                      safeSetState(() {});

                                                      safeSetState(() {});
                                                    },
                                                  ),
                                                  autofocus: true,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: 'Username',
                                                    labelStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .labelLarge
                                                        .override(
                                                          fontFamily:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .labelLargeFamily,
                                                          color: Colors.black,
                                                          letterSpacing: 0.0,
                                                          useGoogleFonts:
                                                              !FlutterFlowTheme
                                                                      .of(context)
                                                                  .labelLargeIsCustom,
                                                        ),
                                                    hintStyle: FlutterFlowTheme
                                                            .of(context)
                                                        .bodyLarge
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLarge
                                                                    .fontStyle,
                                                          ),
                                                          color: Colors.black,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyLarge
                                                                  .fontStyle,
                                                        ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0x00000000),
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .error,
                                                        width: 2.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .background2,
                                                  ),
                                                  style:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyLarge
                                                          .override(
                                                            fontFamily:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeFamily,
                                                            color: Colors.black,
                                                            letterSpacing: 0.0,
                                                            useGoogleFonts:
                                                                !FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyLargeIsCustom,
                                                          ),
                                                  maxLength: 16,
                                                  maxLengthEnforcement:
                                                      MaxLengthEnforcement
                                                          .enforced,
                                                  buildCounter: (context,
                                                          {required currentLength,
                                                          required isFocused,
                                                          maxLength}) =>
                                                      null,
                                                  validator: _model
                                                      .usernameTextControllerValidator
                                                      .asValidator(context),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            '[a-zA-Z0-9]'))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  4.0, 0.0, 0.0, 0.0),
                                          child: FlutterFlowIconButton(
                                            borderRadius: 12.0,
                                            buttonSize: 50.0,
                                            fillColor:
                                                FlutterFlowTheme.of(context)
                                                    .primary,
                                            icon: Icon(
                                              FFIcons.kbxsMagicWand,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              logFirebaseEvent(
                                                  'ONBOARDING_PAGE_bxsMagicWand_ICN_ON_TAP');
                                              logFirebaseEvent(
                                                  'IconButton_custom_action');
                                              _model.generatedUsername =
                                                  await actions
                                                      .generateUsername(
                                                '',
                                              );
                                              logFirebaseEvent(
                                                  'IconButton_set_form_field');
                                              safeSetState(() {
                                                _model.usernameTextController
                                                        ?.text =
                                                    _model.generatedUsername!;
                                                _model.usernameFocusNode
                                                    ?.requestFocus();
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _model.usernameTextController
                                                          ?.selection =
                                                      TextSelection.collapsed(
                                                    offset: _model
                                                        .usernameTextController!
                                                        .text
                                                        .length,
                                                  );
                                                });
                                              });
                                              logFirebaseEvent(
                                                  'IconButton_custom_action');
                                              _model.isGeneratedUsernameAvailable =
                                                  await actions
                                                      .isUsernameAvailable(
                                                _model.generatedUsername!,
                                              );
                                              if (_model
                                                  .isGeneratedUsernameAvailable!) {
                                                logFirebaseEvent(
                                                    'IconButton_update_page_state');
                                                _model.username =
                                                    _model.generatedUsername;
                                                _model.isUsernameAvailable =
                                                    true;
                                                safeSetState(() {});
                                              } else {
                                                logFirebaseEvent(
                                                    'IconButton_update_page_state');
                                                _model.isUsernameAvailable =
                                                    false;
                                                _model.username = null;
                                                safeSetState(() {});
                                              }

                                              safeSetState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!_model.isUsernameAvailable)
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              'sorry, username already taken',
                                              style: FlutterFlowTheme.of(
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
                                                    color: Color(0xFFFF000F),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    2.0, 0.0, 0.0, 0.0),
                                            child: Icon(
                                              FFIcons.kalertTriangle,
                                              color: Color(0xFFFA000E),
                                              size: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (_model.isUsernameAvailable)
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 0.0, 0.0),
                                            child: Text(
                                              'username available',
                                              style: FlutterFlowTheme.of(
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
                                                    color: Color(0xFF0F00FF),
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    2.0, 0.0, 0.0, 0.0),
                                            child: Icon(
                                              FFIcons.ksealCheck,
                                              color: Color(0xFF0033FA),
                                              size: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    Align(
                                      alignment: AlignmentDirectional(1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 12.0, 0.0, 0.0),
                                        child: FFButtonWidget(
                                          onPressed: !_model.isUsernameAvailable
                                              ? null
                                              : () async {
                                                  logFirebaseEvent(
                                                      'ONBOARDING_PAGE_CONTINUE_BTN_ON_TAP');
                                                  logFirebaseEvent(
                                                      'Button_update_page_state');
                                                  _model.username = _model
                                                      .usernameTextController
                                                      .text;
                                                  safeSetState(() {});
                                                  logFirebaseEvent(
                                                      'Button_page_view');
                                                  await _model
                                                      .onboardingPagesController
                                                      ?.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
                                                },
                                          text: 'Continue',
                                          icon: Icon(
                                            FFIcons.karrowLeftMD,
                                            size: 22.0,
                                          ),
                                          options: FFButtonOptions(
                                            height: 40.0,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 0.0, 16.0, 0.0),
                                            iconAlignment: IconAlignment.end,
                                            iconPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 0.0),
                                            iconColor:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            textStyle: FlutterFlowTheme.of(
                                                    context)
                                                .titleSmall
                                                .override(
                                                  font: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                                  color: Colors.white,
                                                  fontSize: 17.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                ),
                                            elevation: 0.0,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            disabledColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            disabledTextColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ].addToEnd(SizedBox(height: 200.0)),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              primary: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .spacing
                                            .md,
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .spacing
                                            .md,
                                        0.0,
                                        0.0),
                                    child: Text(
                                      'Your courses for this semester:',
                                      style: FlutterFlowTheme.of(context)
                                          .headlineMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .headlineMediumFamily,
                                            letterSpacing: 0.0,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .headlineMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        18.0, 2.0, 0.0, 4.0),
                                    child: Text(
                                      'Core Courses:',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .labelMediumFamily,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .labelMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .spacing
                                            .md,
                                        0.0,
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .spacing
                                            .md,
                                        0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final coreCoursesListView =
                                            _model.coreCourseData!.toList();
                                        if (coreCoursesListView.isEmpty) {
                                          return Center(
                                            child: Image.asset(
                                              'assets/images/Empty_Icon.png',
                                              width: 100.0,
                                              height: 200.0,
                                            ),
                                          );
                                        }

                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: coreCoursesListView.length,
                                          itemBuilder: (context,
                                              coreCoursesListViewIndex) {
                                            final coreCoursesListViewItem =
                                                coreCoursesListView[
                                                    coreCoursesListViewIndex];
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0,
                                                      0.0,
                                                      0.0,
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .designToken
                                                          .spacing
                                                          .xs),
                                              child: wrapWithModel(
                                                model: _model
                                                    .coreCourseBlockModels
                                                    .getModel(
                                                  coreCoursesListViewItem
                                                      .courseId,
                                                  coreCoursesListViewIndex,
                                                ),
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: CoreCourseBlockWidget(
                                                  key: Key(
                                                    'Keyco4_${coreCoursesListViewItem.courseId}',
                                                  ),
                                                  coreCourseData:
                                                      coreCoursesListViewItem,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  StyledDivider(
                                    thickness: 2.0,
                                    indent: 10.0,
                                    endIndent: 10.0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    lineStyle: DividerLineStyle.dashed,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        18.0, 2.0, 0.0, 4.0),
                                    child: Text(
                                      'Lab Courses:',
                                      style: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .override(
                                            fontFamily:
                                                FlutterFlowTheme.of(context)
                                                    .labelMediumFamily,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts:
                                                !FlutterFlowTheme.of(context)
                                                    .labelMediumIsCustom,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .spacing
                                            .md,
                                        0.0,
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .spacing
                                            .md,
                                        0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final labCoursesListView = _model
                                            .labCourseData!
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

                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: labCoursesListView.length,
                                          itemBuilder: (context,
                                              labCoursesListViewIndex) {
                                            final labCoursesListViewItem =
                                                labCoursesListView[
                                                    labCoursesListViewIndex];
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 0.0, 0.0, 4.0),
                                              child: wrapWithModel(
                                                model: _model
                                                    .labSelectionBlockModels
                                                    .getModel(
                                                  labCoursesListViewItem
                                                      .courseCode,
                                                  labCoursesListViewIndex,
                                                ),
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child: LabSelectionBlockWidget(
                                                  key: Key(
                                                    'Keyu4o_${labCoursesListViewItem.courseCode}',
                                                  ),
                                                  requiredlabCourseCode:
                                                      labCoursesListViewItem
                                                          .courseCode,
                                                  courseBlocks:
                                                      _model.labCourseData!,
                                                  addSelectedLabCourse:
                                                      (selectedLabCourse) async {
                                                    logFirebaseEvent(
                                                        'ONBOARDING_Container_u4oh23uf_CALLBACK');
                                                    logFirebaseEvent(
                                                        'labSelection_block_update_page_state');
                                                    _model
                                                        .addToSelectedLabCourses(
                                                            selectedLabCourse);
                                                  },
                                                  removeSelectedLabCourse:
                                                      (selectedLabCourseToRemove) async {
                                                    logFirebaseEvent(
                                                        'ONBOARDING_Container_u4oh23uf_CALLBACK');
                                                    logFirebaseEvent(
                                                        'labSelection_block_update_page_state');
                                                    _model.removeFromSelectedLabCourses(
                                                        selectedLabCourseToRemove);
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  StyledDivider(
                                    thickness: 2.0,
                                    indent: 10.0,
                                    endIndent: 10.0,
                                    color:
                                        FlutterFlowTheme.of(context).alternate,
                                    lineStyle: DividerLineStyle.dashed,
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(-1.0, 0.0),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          18.0, 2.0, 0.0, 4.0),
                                      child: Text(
                                        'Elective Courses:',
                                        style: FlutterFlowTheme.of(context)
                                            .labelMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelMediumFamily,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelMediumIsCustom,
                                            ),
                                      ),
                                    ),
                                  ),
                                  if (valueOrDefault<bool>(
                                    (List<String> slotsList) {
                                      return slotsList
                                                  .where((s) =>
                                                      s.trim().isNotEmpty)
                                                  .map((s) =>
                                                      s.trim().toUpperCase())
                                                  .toSet()
                                                  .length <
                                              slotsList
                                                  .where((s) =>
                                                      s.trim().isNotEmpty)
                                                  .length;
                                    }(_model.selectedElectives
                                        .map((e) => e.slot)
                                        .toList()),
                                    false,
                                  ))
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          FlutterFlowTheme.of(context)
                                              .designToken
                                              .spacing
                                              .md,
                                          0.0,
                                          FlutterFlowTheme.of(context)
                                              .designToken
                                              .spacing
                                              .md,
                                          6.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFF9E6),
                                          borderRadius: BorderRadius.circular(
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .radius
                                                  .sm),
                                          border: Border.all(
                                            color: Color(0xFFE67E22),
                                            width: 2.5,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .spacing
                                                  .xs),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                FFIcons.kalertTriangle,
                                                color: Color(0xFF7D4412),
                                                size: 20.0,
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .designToken
                                                              .spacing
                                                              .xs,
                                                          0.0,
                                                          0.0,
                                                          0.0),
                                                  child: Text(
                                                    'Some selected electives share the same slot. This will create a schedule conflict and may affect how the app displays your calendar. If you\'re sure, you can still continue.',
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .outfit(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0xFF7D4412),
                                                          fontSize: 9.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .spacing
                                            .md,
                                        0.0,
                                        FlutterFlowTheme.of(context)
                                            .designToken
                                            .spacing
                                            .md,
                                        0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final requiredElectivesListView =
                                            _model.requiredElectives!.toList();
                                        if (requiredElectivesListView.isEmpty) {
                                          return Center(
                                            child: Image.asset(
                                              'assets/images/Empty_Icon.png',
                                              width: 100.0,
                                              height: 200.0,
                                            ),
                                          );
                                        }

                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              requiredElectivesListView.length,
                                          itemBuilder: (context,
                                              requiredElectivesListViewIndex) {
                                            final requiredElectivesListViewItem =
                                                requiredElectivesListView[
                                                    requiredElectivesListViewIndex];
                                            return Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0,
                                                      0.0,
                                                      0.0,
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .designToken
                                                          .spacing
                                                          .xs),
                                              child: wrapWithModel(
                                                model: _model
                                                    .electiveCourseBlockModels
                                                    .getModel(
                                                  requiredElectivesListViewIndex
                                                      .toString(),
                                                  requiredElectivesListViewIndex,
                                                ),
                                                updateCallback: () =>
                                                    safeSetState(() {}),
                                                child:
                                                    ElectiveCourseBlockWidget(
                                                  key: Key(
                                                    'Keyokr_${requiredElectivesListViewIndex.toString()}',
                                                  ),
                                                  electiveCategory:
                                                      requiredElectivesListViewItem,
                                                  electiveData: _model
                                                      .electiveCourseData!,
                                                  selectedElectiveCourse:
                                                      (electiveCourse) async {
                                                    logFirebaseEvent(
                                                        'ONBOARDING_Container_okrr1wgh_CALLBACK');
                                                    logFirebaseEvent(
                                                        'electiveCourse_block_update_page_state');
                                                    _model
                                                        .addToSelectedElectives(
                                                            electiveCourse);
                                                  },
                                                  removeSelectedElective:
                                                      (electiveCourseData) async {
                                                    logFirebaseEvent(
                                                        'ONBOARDING_Container_okrr1wgh_CALLBACK');
                                                    logFirebaseEvent(
                                                        'electiveCourse_block_update_page_state');
                                                    _model
                                                        .removeFromSelectedElectives(
                                                            electiveCourseData);
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 20.0, 16.0, 0.0),
                                    child: FFButtonWidget(
                                      onPressed: ((_model.requiredElectives
                                                      ?.length !=
                                                  _model.selectedElectives
                                                      .length) &&
                                              (_model.labCourseData?.length !=
                                                  _model.selectedLabCourses
                                                      .length))
                                          ? null
                                          : () async {
                                              logFirebaseEvent(
                                                  'ONBOARDING_PAGE_COMPLETE_BTN_ON_TAP');
                                              logFirebaseEvent(
                                                  'Button_page_view');
                                              unawaited(
                                                () async {
                                                  await _model
                                                      .onboardingPagesController
                                                      ?.nextPage(
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.ease,
                                                  );
                                                }(),
                                              );
                                              _model.enrolledCoreCourses.clear();
                                              for (int loop1Index = 0;
                                                  loop1Index <
                                                      _model.coreCourseData!
                                                          .length;
                                                  loop1Index++) {
                                                final currentLoop1Item =
                                                    _model.coreCourseData![
                                                        loop1Index];
                                                logFirebaseEvent(
                                                    'Button_update_page_state');
                                                _model.addToEnrolledCoreCourses(
                                                    EnrolledCourseStruct(
                                                  courseId:
                                                      currentLoop1Item.courseId,
                                                  courseCode: currentLoop1Item
                                                      .courseCode,
                                                  courseName: currentLoop1Item
                                                      .courseName,
                                                  courseType: currentLoop1Item
                                                      .courseTypeCode,
                                                  slot: currentLoop1Item.slot,
                                                  credits:
                                                      currentLoop1Item.credits,
                                                  isLab: false,
                                                  isElective: false,
                                                  attendance: AttendanceStruct(
                                                    attended: 0,
                                                    missed: 0,
                                                    percentage: 0.0,
                                                  ),
                                                ));
                                              }
                                              await Future.wait([
                                                Future(() async {
                                                  // CombineAllEnrolledCourses
                                                  logFirebaseEvent(
                                                      'Button_CombineAllEnrolledCourses');
                                                  _model.combinedEnrolledCourses =
                                                      await actions
                                                          .combineEnrolledCourses(
                                                    _model.enrolledCoreCourses
                                                        .toList(),
                                                    _model.selectedElectives
                                                        .toList(),
                                                    _model.selectedLabCourses
                                                        .toList(),
                                                  );
                                                  // UpdateUserProfile
                                                  logFirebaseEvent(
                                                      'Button_UpdateUserProfile');
                                                  FFAppState().userProfile =
                                                      UserProfileStruct(
                                                    userId: currentUserUid,
                                                    username: _model.username,
                                                    email: currentUserEmail,
                                                    role: UserRole.student.name,
                                                    departmentId: _model.branch,
                                                    batchId: _model.batch,
                                                    currentSemester:
                                                        _model.semester,
                                                    profileUpdatedAt:
                                                        getCurrentTimestamp,
                                                    enrolledCourses: _model
                                                        .combinedEnrolledCourses,
                                                    onboardingComplete: true,
                                                    amplixBalance: 0,
                                                    odometer: 0,
                                                  );
                                                  logFirebaseEvent(
                                                      'Button_custom_action');
                                                  _model.onboardingComplete =
                                                      await actions
                                                          .completeUserOnboarding(
                                                    _model.fullName!,
                                                    _model.rollNumber!,
                                                    _model.branch!,
                                                    _model.batch!,
                                                    FFAppState()
                                                        .userProfile
                                                        .currentSemester,
                                                    _model
                                                        .usernameTextController
                                                        .text,
                                                    _model.userBio,
                                                  );
                                                  logFirebaseEvent(
                                                      'Button_custom_action');
                                                  _model.courseEnrollmentComplete =
                                                      await actions
                                                          .completeCourseEnrollment(
                                                    FFAppState()
                                                        .userProfile
                                                        .enrolledCourses
                                                        .toList(),
                                                  );
                                                  if (_model
                                                          .onboardingComplete! &&
                                                      (_model.courseEnrollmentComplete
                                                              ?.statusCode ==
                                                          200)) {
                                                    logFirebaseEvent(
                                                        'Button_update_page_state');
                                                    _model.isOnboardingComplete =
                                                        true;
                                                    safeSetState(() {});
                                                  } else {
                                                    logFirebaseEvent(
                                                        'Button_stop_periodic_action');
                                                    _model.instantTimer
                                                        ?.cancel();
                                                    logFirebaseEvent(
                                                        'Button_update_page_state');
                                                    _model.onboardingProgress =
                                                        0.0;
                                                    _model.onboardingProgressMessage =
                                                        null;
                                                    _model.onboardingElapsedTIme =
                                                        0;
                                                    safeSetState(() {});
                                                    logFirebaseEvent(
                                                        'Button_page_view');
                                                    await _model
                                                        .onboardingPagesController
                                                        ?.previousPage(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.ease,
                                                    );
                                                    logFirebaseEvent(
                                                        'Button_show_snack_bar');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .clearSnackBars();
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          valueOrDefault<
                                                              String>(
                                                            _model.courseEnrollmentComplete!
                                                                    .success
                                                                ? '❌ Setup Failed: Something went wrong while saving your profile. Please check your connection and try again.'
                                                                : _model
                                                                    .courseEnrollmentComplete
                                                                    ?.message,
                                                            '❌ Setup Failed: Something went wrong while saving your profile. Please check your connection and try again.',
                                                          ),
                                                          style: GoogleFonts
                                                              .outfit(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .info,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12.0,
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
                                                  }
                                                }),
                                                Future(() async {
                                                  logFirebaseEvent(
                                                      'Button_start_periodic_action');
                                                  _model.instantTimer =
                                                      InstantTimer.periodic(
                                                    duration: Duration(
                                                        milliseconds: 1500),
                                                    callback: (timer) async {
                                                      logFirebaseEvent(
                                                          'Button_update_page_state');
                                                      _model
                                                          .onboardingProgress = _model
                                                              .onboardingProgress +
                                                          (_model.onboardingProgress <=
                                                                  0.8
                                                              ? 0.2
                                                              : 0.0);
                                                      _model.onboardingProgressMessage =
                                                          functions
                                                              .getRandomOnboardingStatus();
                                                      _model.onboardingElapsedTIme =
                                                          _model.onboardingElapsedTIme +
                                                              1;
                                                      safeSetState(() {});
                                                      if ((_model.onboardingElapsedTIme >=
                                                              7) &&
                                                          _model
                                                              .isOnboardingComplete) {
                                                        logFirebaseEvent(
                                                            'Button_stop_periodic_action');
                                                        _model.instantTimer
                                                            ?.cancel();
                                                        logFirebaseEvent(
                                                            'Button_navigate_to');

                                                        context.pushNamed(
                                                            DashboardWidget
                                                                .routeName);
                                                      }
                                                    },
                                                    startImmediately: true,
                                                  );
                                                }),
                                              ]);

                                              safeSetState(() {});
                                            },
                                      text: 'Complete',
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 45.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        iconPadding:
                                            EdgeInsetsDirectional.fromSTEB(
                                                0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        textStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmall
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .info,
                                              fontSize: 18.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleSmall
                                                      .fontStyle,
                                            ),
                                        elevation: 2.0,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        disabledColor:
                                            FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        disabledTextColor:
                                            FlutterFlowTheme.of(context)
                                                .primaryText,
                                      ),
                                    ),
                                  ),
                                ].addToEnd(SizedBox(height: 30.0)),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 20.0, 0.0, 0.0),
                                    child: Text(
                                      'Welcome to Attendrix',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 28.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ).animateOnPageLoad(animationsMap[
                                        'textOnPageLoadAnimation1']!),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 3.0, 0.0),
                                        child: Text(
                                          'Attendance,',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .success,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation2']!),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 3.0, 0.0),
                                        child: Text(
                                          'Reimagined.',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMediumFamily,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .velvetSky,
                                                fontSize: 18.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMediumIsCustom,
                                              ),
                                        ).animateOnPageLoad(animationsMap[
                                            'textOnPageLoadAnimation3']!),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 0.0, 24.0, 0.0),
                                    child: RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                'Built for attendance, timetables, notes, and\n',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  fontSize: 8.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts:
                                                      !FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumIsCustom,
                                                ),
                                          ),
                                          TextSpan(
                                            text: 'everything in between.',
                                            style: TextStyle(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .tertiary,
                                              fontSize: 12.0,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        ],
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily,
                                              color: Color(0xFF2C3E50),
                                              fontSize: 8.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.bold,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .bodyMediumIsCustom,
                                            ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ).animateOnPageLoad(animationsMap[
                                        'richTextOnPageLoadAnimation']!),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/flow.gif',
                                      width: 500.0,
                                      height: 400.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'assets/jsons/Animation_1733337186367.json',
                                        width: 24.0,
                                        height: 24.0,
                                        fit: BoxFit.contain,
                                        animate: true,
                                      ),
                                      AnimatedDefaultTextStyle(
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              fontSize: 10.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        duration: Duration(milliseconds: 600),
                                        curve: Curves.easeIn,
                                        child: Text(
                                          valueOrDefault<String>(
                                            _model.onboardingProgressMessage,
                                            'Setting Up Your Academic Profile',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20.0, 0.0, 20.0, 0.0),
                                    child: LinearPercentIndicator(
                                      percent: valueOrDefault<double>(
                                        _model.onboardingProgress,
                                        0.2,
                                      ),
                                      lineHeight: 12.0,
                                      animation: true,
                                      animateFromLastPercent: true,
                                      progressColor:
                                          FlutterFlowTheme.of(context).primary,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .alternate,
                                      barRadius: Radius.circular(12.0),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                  if (_model.onboardingElapsedTIme >= 4)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 100.0, 0.0, 0.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          logFirebaseEvent(
                                              'ONBOARDING_PAGE_CONTINUE_BTN_ON_TAP');
                                          logFirebaseEvent(
                                              'Button_navigate_to');

                                          context.goNamed(
                                            DashboardWidget.routeName,
                                            extra: <String, dynamic>{
                                              '__transition_info__':
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType
                                                        .topToBottom,
                                              ),
                                            },
                                          );

                                          logFirebaseEvent(
                                              'Button_stop_periodic_action');
                                          _model.instantTimer?.cancel();
                                        },
                                        text: 'Continue ',
                                        icon: Icon(
                                          FFIcons.karrowRight,
                                          size: 24.0,
                                        ),
                                        options: FFButtonOptions(
                                          width: 200.0,
                                          height: 35.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  16.0, 0.0, 16.0, 0.0),
                                          iconAlignment: IconAlignment.end,
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          iconColor:
                                              FlutterFlowTheme.of(context).info,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .titleSmall
                                              .override(
                                                fontFamily:
                                                    FlutterFlowTheme.of(context)
                                                        .titleSmallFamily,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                useGoogleFonts:
                                                    !FlutterFlowTheme.of(
                                                            context)
                                                        .titleSmallIsCustom,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ).animateOnActionTrigger(
                                        animationsMap[
                                            'buttonOnActionTriggerAnimation']!,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 16.0, 10.0, 16.0),
                          child: smooth_page_indicator.SmoothPageIndicator(
                            controller: _model.onboardingPagesController ??=
                                PageController(initialPage: 0),
                            count: 4,
                            axisDirection: Axis.horizontal,
                            onDotClicked: (i) async {
                              await _model.onboardingPagesController!
                                  .animateToPage(
                                i,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                              safeSetState(() {});
                            },
                            effect: smooth_page_indicator.ExpandingDotsEffect(
                              expansionFactor: 1.5,
                              spacing: 6.0,
                              radius: 12.0,
                              dotWidth: valueOrDefault<double>(
                                (MediaQuery.sizeOf(context).width - 80) / 4,
                                80.0,
                              ),
                              dotHeight: 6.0,
                              dotColor: FlutterFlowTheme.of(context).accent1,
                              activeDotColor:
                                  FlutterFlowTheme.of(context).primary,
                              paintStyle: PaintingStyle.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
