import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/request_manager.dart';

import '/index.dart';
import 'manage_classes_widget.dart' show ManageClassesWidget;
import 'package:flutter/material.dart';

class ManageClassesModel extends FlutterFlowModel<ManageClassesWidget> {
  ///  Local state fields for this page.

  DateTime? selectedDate;

  List<DateTime> generatedDates = [];
  void addToGeneratedDates(DateTime item) => generatedDates.add(item);
  void removeFromGeneratedDates(DateTime item) => generatedDates.remove(item);
  void removeAtIndexFromGeneratedDates(int index) =>
      generatedDates.removeAt(index);
  void insertAtIndexInGeneratedDates(int index, DateTime item) =>
      generatedDates.insert(index, item);
  void updateGeneratedDatesAtIndex(int index, Function(DateTime) updateFn) =>
      generatedDates[index] = updateFn(generatedDates[index]);

  DateTime? classStartTime;

  DateTime? classEndTime;

  bool isExtraSlot = false;

  bool isPlusSlot = false;

  String? classVenue;

  String selectedCourseId = 'ME1001E';

  String classSlot = 'Regular Class Slot';

  List<ScheduledClassStruct> todayClasses = [];
  void addToTodayClasses(ScheduledClassStruct item) => todayClasses.add(item);
  void removeFromTodayClasses(ScheduledClassStruct item) =>
      todayClasses.remove(item);
  void removeAtIndexFromTodayClasses(int index) => todayClasses.removeAt(index);
  void insertAtIndexInTodayClasses(int index, ScheduledClassStruct item) =>
      todayClasses.insert(index, item);
  void updateTodayClassesAtIndex(
          int index, Function(ScheduledClassStruct) updateFn) =>
      todayClasses[index] = updateFn(todayClasses[index]);

  List<ScheduledClassStruct> upcomingClasses = [];
  void addToUpcomingClasses(ScheduledClassStruct item) =>
      upcomingClasses.add(item);
  void removeFromUpcomingClasses(ScheduledClassStruct item) =>
      upcomingClasses.remove(item);
  void removeAtIndexFromUpcomingClasses(int index) =>
      upcomingClasses.removeAt(index);
  void insertAtIndexInUpcomingClasses(int index, ScheduledClassStruct item) =>
      upcomingClasses.insert(index, item);
  void updateUpcomingClassesAtIndex(
          int index, Function(ScheduledClassStruct) updateFn) =>
      upcomingClasses[index] = updateFn(upcomingClasses[index]);

  List<ScheduledClassStruct> selectedDayClasses = [];
  void addToSelectedDayClasses(ScheduledClassStruct item) =>
      selectedDayClasses.add(item);
  void removeFromSelectedDayClasses(ScheduledClassStruct item) =>
      selectedDayClasses.remove(item);
  void removeAtIndexFromSelectedDayClasses(int index) =>
      selectedDayClasses.removeAt(index);
  void insertAtIndexInSelectedDayClasses(
          int index, ScheduledClassStruct item) =>
      selectedDayClasses.insert(index, item);
  void updateSelectedDayClassesAtIndex(
          int index, Function(ScheduledClassStruct) updateFn) =>
      selectedDayClasses[index] = updateFn(selectedDayClasses[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - generateDateRange] action in manageClasses widget.
  List<DateTime>? generatedDatesQuery;
  // Stores action output result for [Custom Action - executeScheduleQuery] action in manageClasses widget.
  List<ScheduledClassStruct>? todayClassesList;
  // Stores action output result for [Custom Action - executeScheduleQuery] action in manageClasses widget.
  List<ScheduledClassStruct>? upcomingClassesList;
  // Stores action output result for [Custom Action - executeScheduleQuery] action in Container widget.
  List<ScheduledClassStruct>? selectedDayClassesQuery;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for selectedCourse widget.
  String? selectedCourseValue;
  FormFieldController<String>? selectedCourseValueController;
  DateTime? datePicked;
  // State field(s) for classStartTime widget.
  FormFieldController<List<String>>? classStartTimeValueController;
  String? get classStartTimeValue =>
      classStartTimeValueController?.value?.firstOrNull;
  set classStartTimeValue(String? val) =>
      classStartTimeValueController?.value = val != null ? [val] : [];
  // State field(s) for classDuration widget.
  FormFieldController<List<String>>? classDurationValueController;
  String? get classDurationValue =>
      classDurationValueController?.value?.firstOrNull;
  set classDurationValue(String? val) =>
      classDurationValueController?.value = val != null ? [val] : [];
  // State field(s) for classEndTime widget.
  int? classEndTimeValue;
  // State field(s) for classVenue widget.
  FocusNode? classVenueFocusNode;
  TextEditingController? classVenueTextController;
  String? Function(BuildContext, String?)? classVenueTextControllerValidator;
  // State field(s) for isPlusSlot widget.
  FormFieldController<List<String>>? isPlusSlotValueController;
  String? get isPlusSlotValue => isPlusSlotValueController?.value?.firstOrNull;
  set isPlusSlotValue(String? val) =>
      isPlusSlotValueController?.value = val != null ? [val] : [];
  // State field(s) for isExtraClass widget.
  FormFieldController<List<String>>? isExtraClassValueController;
  String? get isExtraClassValue =>
      isExtraClassValueController?.value?.firstOrNull;
  set isExtraClassValue(String? val) =>
      isExtraClassValueController?.value = val != null ? [val] : [];
  // Stores action output result for [Custom Action - scheduleClass] action in scheduleButton widget.
  FeedbackStruct? schedulerFeedback;

  /// Query cache managers for this widget.

  final _userCoursesManager = FutureRequestManager<List<CoursesRow>>();
  Future<List<CoursesRow>> userCourses({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<CoursesRow>> Function() requestFn,
  }) =>
      _userCoursesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearUserCoursesCache() => _userCoursesManager.clear();
  void clearUserCoursesCacheKey(String? uniqueKey) =>
      _userCoursesManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
    classVenueFocusNode?.dispose();
    classVenueTextController?.dispose();

    /// Dispose query cache managers for this widget.

    clearUserCoursesCache();
  }
}
