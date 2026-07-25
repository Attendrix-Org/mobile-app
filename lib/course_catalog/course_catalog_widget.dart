import '/backend/supabase/supabase.dart';
import '/components/course_catelog_block_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_search/text_search.dart';
import 'course_catalog_model.dart';
export 'course_catalog_model.dart';

class CourseCatalogWidget extends StatefulWidget {
  const CourseCatalogWidget({super.key});

  static String routeName = 'courseCatalog';
  static String routePath = 'courseCatalog';

  @override
  State<CourseCatalogWidget> createState() => _CourseCatalogWidgetState();
}

class _CourseCatalogWidgetState extends State<CourseCatalogWidget> {
  late CourseCatalogModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CourseCatalogModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'courseCatalog'});
    _model.searchBarTextController ??= TextEditingController();
    _model.searchBarFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CourseSyllabiRow>>(
      future: FFAppState().courseCatalog(
        uniqueQueryKey: 'COURSE_CATELOG',
        requestFn: () => CourseSyllabiTable().queryRows(
          queryFn: (q) => q,
        ),
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 25.0,
                height: 25.0,
                child: SpinKitFadingCube(
                  color: FlutterFlowTheme.of(context).primary,
                  size: 25.0,
                ),
              ),
            ),
          );
        }
        List<CourseSyllabiRow> courseCatalogCourseSyllabiRowList =
            snapshot.data!;

        return Title(
            title: 'courseCatalog',
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
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
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
                      logFirebaseEvent(
                          'COURSE_CATALOG_PAGE_arrowLeft_ICN_ON_TAP');
                      logFirebaseEvent('IconButton_navigate_back');
                      context.pop();
                    },
                  ),
                  title: Text(
                    'Course Catalog',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).headlineMediumFamily,
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 22.0,
                          letterSpacing: 0.0,
                          useGoogleFonts: !FlutterFlowTheme.of(context)
                              .headlineMediumIsCustom,
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              12.0,
                              0.0,
                              FlutterFlowTheme.of(context)
                                  .designToken
                                  .spacing
                                  .sm),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      FlutterFlowTheme.of(context)
                                          .designToken
                                          .spacing
                                          .sm,
                                      0.0,
                                      FlutterFlowTheme.of(context)
                                          .designToken
                                          .spacing
                                          .xs,
                                      0.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                      controller:
                                          _model.searchBarTextController,
                                      focusNode: _model.searchBarFocusNode,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        '_model.searchBarTextController',
                                        Duration(milliseconds: 1000),
                                        () async {
                                          logFirebaseEvent(
                                              'COURSE_CATALOG_searchBar_ON_TEXTFIELD_CH');
                                          logFirebaseEvent(
                                              'searchBar_simple_search');
                                          safeSetState(() {
                                            _model
                                                .simpleSearchResults = TextSearch(
                                                    (courseCatalogCourseSyllabiRowList
                                                            .map((e) =>
                                                                e.courseName)
                                                            .toList() as List)
                                                        .cast<String>()
                                                        .map((str) =>
                                                            TextSearchItem
                                                                .fromTerms(
                                                                    str, [str]))
                                                        .toList())
                                                .search(_model
                                                    .searchBarTextController
                                                    .text)
                                                .map((r) => r.object)
                                                .toList();
                                            ;
                                          });
                                          logFirebaseEvent(
                                              'searchBar_update_page_state');
                                          _model.searchfilteredCourses =
                                              courseCatalogCourseSyllabiRowList
                                                  .where((e) => _model
                                                      .simpleSearchResults
                                                      .contains(e.courseName))
                                                  .toList()
                                                  .cast<CourseSyllabiRow>();
                                          _model.isSearchActive = true;
                                          safeSetState(() {});
                                        },
                                      ),
                                      autofocus: true,
                                      autofillHints: [AutofillHints.email],
                                      textInputAction: TextInputAction.search,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: 'Search Courses...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelLarge
                                            .override(
                                              fontFamily:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLargeFamily,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              useGoogleFonts:
                                                  !FlutterFlowTheme.of(context)
                                                      .labelLargeIsCustom,
                                            ),
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyLarge
                                                        .fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .radius
                                                  .sm),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .radius
                                                  .sm),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .radius
                                                  .sm),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              FlutterFlowTheme.of(context)
                                                  .designToken
                                                  .radius
                                                  .sm),
                                        ),
                                        filled: true,
                                        fillColor: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        prefixIcon: Icon(
                                          FFIcons.ksearch,
                                        ),
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.outfit(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                      validator: _model
                                          .searchBarTextControllerValidator
                                          .asValidator(context),
                                    ),
                                  ),
                                ),
                              ),
                              if (_model.isSearchActive)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      0.0,
                                      FlutterFlowTheme.of(context)
                                          .designToken
                                          .spacing
                                          .sm,
                                      0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      logFirebaseEvent(
                                          'COURSE_CATALOG_PAGE_Icon_olzpmonl_ON_TAP');
                                      logFirebaseEvent(
                                          'Icon_update_page_state');
                                      _model.isSearchActive = false;
                                      _model.searchfilteredCourses = [];
                                      logFirebaseEvent(
                                          'Icon_reset_form_fields');
                                      safeSetState(() {
                                        _model.searchBarTextController?.clear();
                                      });
                                    },
                                    child: Icon(
                                      FFIcons.kxBold,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 28.0,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (_model.isSearchActive)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                FlutterFlowTheme.of(context)
                                    .designToken
                                    .spacing
                                    .sm,
                                0.0,
                                FlutterFlowTheme.of(context)
                                    .designToken
                                    .spacing
                                    .sm,
                                0.0),
                            child: Builder(
                              builder: (context) {
                                final courseSyllabusFilteredListView =
                                    _model.searchfilteredCourses.toList();

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:
                                      courseSyllabusFilteredListView.length,
                                  itemBuilder: (context,
                                      courseSyllabusFilteredListViewIndex) {
                                    final courseSyllabusFilteredListViewItem =
                                        courseSyllabusFilteredListView[
                                            courseSyllabusFilteredListViewIndex];
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 2.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          logFirebaseEvent(
                                              'COURSE_CATALOG_Container_tq99my3b_ON_TAP');
                                          logFirebaseEvent(
                                              'courseCatelog_block_custom_action');
                                          await actions.openSyllabusPdf(
                                            courseSyllabusFilteredListViewItem
                                                .syllabusPath,
                                          );
                                        },
                                        child: wrapWithModel(
                                          model: _model
                                              .courseCatelogBlockModels1
                                              .getModel(
                                            courseSyllabusFilteredListViewItem
                                                .syllabusId!,
                                            courseSyllabusFilteredListViewIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: CourseCatelogBlockWidget(
                                            key: Key(
                                              'Keytq9_${courseSyllabusFilteredListViewItem.syllabusId!}',
                                            ),
                                            courseSyllabus:
                                                functions.parseCourseSyllabus(
                                                    courseSyllabusFilteredListViewItem)!,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        if (!_model.isSearchActive)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                FlutterFlowTheme.of(context)
                                    .designToken
                                    .spacing
                                    .sm,
                                0.0,
                                FlutterFlowTheme.of(context)
                                    .designToken
                                    .spacing
                                    .sm,
                                0.0),
                            child: Builder(
                              builder: (context) {
                                final courseSyllabusListView =
                                    courseCatalogCourseSyllabiRowList.toList();

                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: courseSyllabusListView.length,
                                  itemBuilder:
                                      (context, courseSyllabusListViewIndex) {
                                    final courseSyllabusListViewItem =
                                        courseSyllabusListView[
                                            courseSyllabusListViewIndex];
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 2.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          logFirebaseEvent(
                                              'COURSE_CATALOG_Container_vcmweffd_ON_TAP');
                                          logFirebaseEvent(
                                              'courseCatelog_block_custom_action');
                                          await actions.openSyllabusPdf(
                                            courseSyllabusListViewItem
                                                .syllabusPath,
                                          );
                                        },
                                        child: wrapWithModel(
                                          model: _model
                                              .courseCatelogBlockModels2
                                              .getModel(
                                            courseSyllabusListViewItem
                                                .syllabusId!,
                                            courseSyllabusListViewIndex,
                                          ),
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: CourseCatelogBlockWidget(
                                            key: Key(
                                              'Keyvcm_${courseSyllabusListViewItem.syllabusId!}',
                                            ),
                                            courseSyllabus:
                                                functions.parseCourseSyllabus(
                                                    courseSyllabusListViewItem)!,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                      ].addToEnd(SizedBox(height: 40.0)),
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}
