import '/backend/schema/structs/index.dart';
import '/components/elective_search_block_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'course_search_widget.dart' show CourseSearchWidget;
import 'package:flutter/material.dart';

class CourseSearchModel extends FlutterFlowModel<CourseSearchWidget> {
  ///  Local state fields for this component.

  List<ElectiveCourseStruct> filteredElectiveData = [];
  void addToFilteredElectiveData(ElectiveCourseStruct item) =>
      filteredElectiveData.add(item);
  void removeFromFilteredElectiveData(ElectiveCourseStruct item) =>
      filteredElectiveData.remove(item);
  void removeAtIndexFromFilteredElectiveData(int index) =>
      filteredElectiveData.removeAt(index);
  void insertAtIndexInFilteredElectiveData(
          int index, ElectiveCourseStruct item) =>
      filteredElectiveData.insert(index, item);
  void updateFilteredElectiveDataAtIndex(
          int index, Function(ElectiveCourseStruct) updateFn) =>
      filteredElectiveData[index] = updateFn(filteredElectiveData[index]);

  bool isSearchActive = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for searchBar widget.
  FocusNode? searchBarFocusNode;
  TextEditingController? searchBarTextController;
  String? Function(BuildContext, String?)? searchBarTextControllerValidator;
  List<String> simpleSearchResults = [];
  // Models for electiveSearch_block dynamic component.
  late FlutterFlowDynamicModels<ElectiveSearchBlockModel>
      electiveSearchBlockModels1;
  // Models for electiveSearch_block dynamic component.
  late FlutterFlowDynamicModels<ElectiveSearchBlockModel>
      electiveSearchBlockModels2;

  @override
  void initState(BuildContext context) {
    electiveSearchBlockModels1 =
        FlutterFlowDynamicModels(() => ElectiveSearchBlockModel());
    electiveSearchBlockModels2 =
        FlutterFlowDynamicModels(() => ElectiveSearchBlockModel());
  }

  @override
  void dispose() {
    searchBarFocusNode?.dispose();
    searchBarTextController?.dispose();

    electiveSearchBlockModels1.dispose();
    electiveSearchBlockModels2.dispose();
  }
}
