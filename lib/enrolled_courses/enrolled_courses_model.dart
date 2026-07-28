import '/backend/schema/structs/index.dart';
import '/components/core_course_block_widget.dart';
import '/components/elective_course_block_widget.dart';
import '/components/lab_selection_block_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'enrolled_courses_widget.dart' show EnrolledCoursesWidget;
import 'package:flutter/material.dart';

class EnrolledCoursesModel extends FlutterFlowModel<EnrolledCoursesWidget> {
  ///  Local state fields for this page.

  List<EnrolledCourseStruct> labCourseCatelog = [];
  void addToLabCourseCatelog(EnrolledCourseStruct item) =>
      labCourseCatelog.add(item);
  void removeFromLabCourseCatelog(EnrolledCourseStruct item) =>
      labCourseCatelog.remove(item);
  void removeAtIndexFromLabCourseCatelog(int index) =>
      labCourseCatelog.removeAt(index);
  void insertAtIndexInLabCourseCatelog(int index, EnrolledCourseStruct item) =>
      labCourseCatelog.insert(index, item);
  void updateLabCourseCatelogAtIndex(
          int index, Function(EnrolledCourseStruct) updateFn) =>
      labCourseCatelog[index] = updateFn(labCourseCatelog[index]);

  List<String> userElectiveRequirementList = [];
  void addToUserElectiveRequirementList(String item) =>
      userElectiveRequirementList.add(item);
  void removeFromUserElectiveRequirementList(String item) =>
      userElectiveRequirementList.remove(item);
  void removeAtIndexFromUserElectiveRequirementList(int index) =>
      userElectiveRequirementList.removeAt(index);
  void insertAtIndexInUserElectiveRequirementList(int index, String item) =>
      userElectiveRequirementList.insert(index, item);
  void updateUserElectiveRequirementListAtIndex(
          int index, Function(String) updateFn) =>
      userElectiveRequirementList[index] =
          updateFn(userElectiveRequirementList[index]);

  List<ElectiveCourseStruct> electiveCourseCatelog = [];
  void addToElectiveCourseCatelog(ElectiveCourseStruct item) =>
      electiveCourseCatelog.add(item);
  void removeFromElectiveCourseCatelog(ElectiveCourseStruct item) =>
      electiveCourseCatelog.remove(item);
  void removeAtIndexFromElectiveCourseCatelog(int index) =>
      electiveCourseCatelog.removeAt(index);
  void insertAtIndexInElectiveCourseCatelog(
          int index, ElectiveCourseStruct item) =>
      electiveCourseCatelog.insert(index, item);
  void updateElectiveCourseCatelogAtIndex(
          int index, Function(ElectiveCourseStruct) updateFn) =>
      electiveCourseCatelog[index] = updateFn(electiveCourseCatelog[index]);

  List<EnrolledCourseStruct> selectedLabCourses = [];
  void addToSelectedLabCourses(EnrolledCourseStruct item) =>
      selectedLabCourses.add(item);
  void removeFromSelectedLabCourses(EnrolledCourseStruct item) =>
      selectedLabCourses.remove(item);
  void removeAtIndexFromSelectedLabCourses(int index) =>
      selectedLabCourses.removeAt(index);
  void insertAtIndexInSelectedLabCourses(
          int index, EnrolledCourseStruct item) =>
      selectedLabCourses.insert(index, item);
  void updateSelectedLabCoursesAtIndex(
          int index, Function(EnrolledCourseStruct) updateFn) =>
      selectedLabCourses[index] = updateFn(selectedLabCourses[index]);

  List<EnrolledCourseStruct> selectedElectiveCourses = [];
  void addToSelectedElectiveCourses(EnrolledCourseStruct item) =>
      selectedElectiveCourses.add(item);
  void removeFromSelectedElectiveCourses(EnrolledCourseStruct item) =>
      selectedElectiveCourses.remove(item);
  void removeAtIndexFromSelectedElectiveCourses(int index) =>
      selectedElectiveCourses.removeAt(index);
  void insertAtIndexInSelectedElectiveCourses(
          int index, EnrolledCourseStruct item) =>
      selectedElectiveCourses.insert(index, item);
  void updateSelectedElectiveCoursesAtIndex(
          int index, Function(EnrolledCourseStruct) updateFn) =>
      selectedElectiveCourses[index] = updateFn(selectedElectiveCourses[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getLabCourses] action in enrolledCourses widget.
  List<EnrolledCourseStruct>? userLabCourses;
  // Stores action output result for [Custom Action - getElectiveRequirementsList] action in enrolledCourses widget.
  List<String>? userElectiveRequirement;
  // Stores action output result for [Custom Action - getElectiveCourses] action in enrolledCourses widget.
  List<ElectiveCourseStruct>? electiveCoursesCatalogQuery;
  // Models for coreCourse_block dynamic component.
  late FlutterFlowDynamicModels<CoreCourseBlockModel> coreCourseBlockModels;
  // Models for labSelection_block dynamic component.
  late FlutterFlowDynamicModels<LabSelectionBlockModel> labSelectionBlockModels;
  // Models for electiveCourse_block dynamic component.
  late FlutterFlowDynamicModels<ElectiveCourseBlockModel>
      electiveCourseBlockModels;
  // Stores action output result for [Custom Action - combineEnrolledCourses] action in Button widget.
  List<EnrolledCourseStruct>? combinedCourses;
  // Stores action output result for [Custom Action - completeCourseEnrollment] action in Button widget.
  FeedbackStruct? courseEnrollmentComplete;

  @override
  void initState(BuildContext context) {
    coreCourseBlockModels =
        FlutterFlowDynamicModels(() => CoreCourseBlockModel());
    labSelectionBlockModels =
        FlutterFlowDynamicModels(() => LabSelectionBlockModel());
    electiveCourseBlockModels =
        FlutterFlowDynamicModels(() => ElectiveCourseBlockModel());
  }

  @override
  void dispose() {
    coreCourseBlockModels.dispose();
    labSelectionBlockModels.dispose();
    electiveCourseBlockModels.dispose();
  }
}
