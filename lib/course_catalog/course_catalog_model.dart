import '/backend/supabase/supabase.dart';
import '/components/course_catelog_block_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'course_catalog_widget.dart' show CourseCatalogWidget;
import 'package:flutter/material.dart';

class CourseCatalogModel extends FlutterFlowModel<CourseCatalogWidget> {
  ///  Local state fields for this page.

  bool isSearchActive = false;

  List<CourseSyllabiRow> searchfilteredCourses = [];
  void addToSearchfilteredCourses(CourseSyllabiRow item) =>
      searchfilteredCourses.add(item);
  void removeFromSearchfilteredCourses(CourseSyllabiRow item) =>
      searchfilteredCourses.remove(item);
  void removeAtIndexFromSearchfilteredCourses(int index) =>
      searchfilteredCourses.removeAt(index);
  void insertAtIndexInSearchfilteredCourses(int index, CourseSyllabiRow item) =>
      searchfilteredCourses.insert(index, item);
  void updateSearchfilteredCoursesAtIndex(
          int index, Function(CourseSyllabiRow) updateFn) =>
      searchfilteredCourses[index] = updateFn(searchfilteredCourses[index]);

  ///  State fields for stateful widgets in this page.

  // State field(s) for searchBar widget.
  FocusNode? searchBarFocusNode;
  TextEditingController? searchBarTextController;
  String? Function(BuildContext, String?)? searchBarTextControllerValidator;
  List<String> simpleSearchResults = [];
  // Models for courseCatelog_block dynamic component.
  late FlutterFlowDynamicModels<CourseCatelogBlockModel>
      courseCatelogBlockModels1;
  // Models for courseCatelog_block dynamic component.
  late FlutterFlowDynamicModels<CourseCatelogBlockModel>
      courseCatelogBlockModels2;

  @override
  void initState(BuildContext context) {
    courseCatelogBlockModels1 =
        FlutterFlowDynamicModels(() => CourseCatelogBlockModel());
    courseCatelogBlockModels2 =
        FlutterFlowDynamicModels(() => CourseCatelogBlockModel());
  }

  @override
  void dispose() {
    searchBarFocusNode?.dispose();
    searchBarTextController?.dispose();

    courseCatelogBlockModels1.dispose();
    courseCatelogBlockModels2.dispose();
  }
}
