import '/backend/schema/structs/index.dart';
import '/components/elective_search_block_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_search/text_search.dart';
import 'course_search_model.dart';
export 'course_search_model.dart';

class CourseSearchWidget extends StatefulWidget {
  const CourseSearchWidget({
    super.key,
    required this.electiveData,
    required this.selectedElective,
  });

  final List<ElectiveCourseStruct>? electiveData;
  final Future Function(ElectiveCourseStruct electiveCourse)? selectedElective;

  @override
  State<CourseSearchWidget> createState() => _CourseSearchWidgetState();
}

class _CourseSearchWidgetState extends State<CourseSearchWidget> {
  late CourseSearchModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CourseSearchModel());

    _model.searchBarTextController ??= TextEditingController();
    _model.searchBarFocusNode ??= FocusNode();

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
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14.0),
          topRight: Radius.circular(14.0),
        ),
      ),
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  0.0,
                  FlutterFlowTheme.of(context).designToken.spacing.sm,
                  0.0,
                  FlutterFlowTheme.of(context).designToken.spacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          FlutterFlowTheme.of(context).designToken.spacing.sm,
                          0.0,
                          FlutterFlowTheme.of(context).designToken.spacing.xs,
                          0.0),
                      child: Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.searchBarTextController,
                          focusNode: _model.searchBarFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.searchBarTextController',
                            Duration(milliseconds: 1000),
                            () async {
                              logFirebaseEvent(
                                  'COURSE_SEARCH_searchBar_ON_TEXTFIELD_CHA');
                              logFirebaseEvent('searchBar_simple_search');
                              safeSetState(() {
                                _model.simpleSearchResults = TextSearch((widget
                                            .electiveData!
                                            .map((e) => e.courseName)
                                            .toList() as List)
                                        .cast<String>()
                                        .map((str) => TextSearchItem.fromTerms(
                                            str, [str]))
                                        .toList())
                                    .search(_model.searchBarTextController.text)
                                    .map((r) => r.object)
                                    .toList();
                                ;
                              });
                              logFirebaseEvent(
                                  'searchBar_update_component_state');
                              _model.filteredElectiveData = widget
                                  .electiveData!
                                  .where((e) => _model.simpleSearchResults
                                      .contains(e.courseName))
                                  .toList()
                                  .cast<ElectiveCourseStruct>();
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
                            labelText: 'Search Electives...',
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelLarge
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelLargeFamily,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: !FlutterFlowTheme.of(context)
                                      .labelLargeIsCustom,
                                ),
                            hintStyle:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.outfit(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
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
                                color: FlutterFlowTheme.of(context).primary,
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
                                color: FlutterFlowTheme.of(context).error,
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
                                color: FlutterFlowTheme.of(context).error,
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
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .fontStyle,
                                  ),
                          validator: _model.searchBarTextControllerValidator
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
                          FlutterFlowTheme.of(context).designToken.spacing.sm,
                          0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          logFirebaseEvent(
                              'COURSE_SEARCH_COMP_Icon_3nzppmik_ON_TAP');
                          logFirebaseEvent('Icon_update_component_state');
                          _model.isSearchActive = false;
                          _model.filteredElectiveData = [];
                          logFirebaseEvent('Icon_reset_form_fields');
                          safeSetState(() {
                            _model.searchBarTextController?.clear();
                          });
                        },
                        child: Icon(
                          FFIcons.kxBold,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 28.0,
                        ),
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
                  if (_model.isSearchActive)
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          FlutterFlowTheme.of(context).designToken.spacing.sm,
                          0.0,
                          FlutterFlowTheme.of(context).designToken.spacing.sm,
                          0.0),
                      child: Builder(
                        builder: (context) {
                          final electiveDataListView =
                              _model.filteredElectiveData.toList();

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: electiveDataListView.length,
                            itemBuilder: (context, electiveDataListViewIndex) {
                              final electiveDataListViewItem =
                                  electiveDataListView[
                                      electiveDataListViewIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    0.0,
                                    0.0,
                                    FlutterFlowTheme.of(context)
                                        .designToken
                                        .spacing
                                        .xs),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'COURSE_SEARCH_Container_ruq6derk_ON_TAP');
                                    logFirebaseEvent(
                                        'electiveSearch_block_execute_callback');
                                    await widget.selectedElective?.call(
                                      electiveDataListViewItem,
                                    );
                                    logFirebaseEvent(
                                        'electiveSearch_block_bottom_sheet');
                                    Navigator.pop(context);
                                  },
                                  child: wrapWithModel(
                                    model: _model.electiveSearchBlockModels1
                                        .getModel(
                                      electiveDataListViewItem.courseId,
                                      electiveDataListViewIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ElectiveSearchBlockWidget(
                                      key: Key(
                                        'Keyruq_${electiveDataListViewItem.courseId}',
                                      ),
                                      electiveCourse: electiveDataListViewItem,
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
                          FlutterFlowTheme.of(context).designToken.spacing.sm,
                          0.0,
                          FlutterFlowTheme.of(context).designToken.spacing.sm,
                          0.0),
                      child: Builder(
                        builder: (context) {
                          final electiveData = widget.electiveData!.toList();

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: electiveData.length,
                            itemBuilder: (context, electiveDataIndex) {
                              final electiveDataItem =
                                  electiveData[electiveDataIndex];
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0,
                                    0.0,
                                    0.0,
                                    FlutterFlowTheme.of(context)
                                        .designToken
                                        .spacing
                                        .xs),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    logFirebaseEvent(
                                        'COURSE_SEARCH_Container_k5mozfy2_ON_TAP');
                                    logFirebaseEvent(
                                        'electiveSearch_block_execute_callback');
                                    await widget.selectedElective?.call(
                                      electiveDataItem,
                                    );
                                    logFirebaseEvent(
                                        'electiveSearch_block_bottom_sheet');
                                    Navigator.pop(context);
                                  },
                                  child: wrapWithModel(
                                    model: _model.electiveSearchBlockModels2
                                        .getModel(
                                      electiveDataItem.courseId,
                                      electiveDataIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ElectiveSearchBlockWidget(
                                      key: Key(
                                        'Keyk5m_${electiveDataItem.courseId}',
                                      ),
                                      electiveCourse: electiveDataItem,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ].addToEnd(SizedBox(height: 30.0)),
        ),
      ),
    );
  }
}
