import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/components/class_block_calender_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'calendar_widget.dart' show CalendarWidget;
import 'package:flutter/material.dart';

class CalendarModel extends FlutterFlowModel<CalendarWidget> {
  ///  Local state fields for this page.

  List<ScheduledClassStruct> selectedDateClasses = [];
  void addToSelectedDateClasses(ScheduledClassStruct item) =>
      selectedDateClasses.add(item);
  void removeFromSelectedDateClasses(ScheduledClassStruct item) =>
      selectedDateClasses.remove(item);
  void removeAtIndexFromSelectedDateClasses(int index) =>
      selectedDateClasses.removeAt(index);
  void insertAtIndexInSelectedDateClasses(
          int index, ScheduledClassStruct item) =>
      selectedDateClasses.insert(index, item);
  void updateSelectedDateClassesAtIndex(
          int index, Function(ScheduledClassStruct) updateFn) =>
      selectedDateClasses[index] = updateFn(selectedDateClasses[index]);

  String? selectedDate;

  List<DateTime> dateRange = [];
  void addToDateRange(DateTime item) => dateRange.add(item);
  void removeFromDateRange(DateTime item) => dateRange.remove(item);
  void removeAtIndexFromDateRange(int index) => dateRange.removeAt(index);
  void insertAtIndexInDateRange(int index, DateTime item) =>
      dateRange.insert(index, item);
  void updateDateRangeAtIndex(int index, Function(DateTime) updateFn) =>
      dateRange[index] = updateFn(dateRange[index]);

  WeekendPolicy? weekendFilter = WeekendPolicy.excludeAll;

  DateRange? displayRange = DateRange.sevenDays;

  List<DateTime> displayDatesRange = [];
  void addToDisplayDatesRange(DateTime item) => displayDatesRange.add(item);
  void removeFromDisplayDatesRange(DateTime item) =>
      displayDatesRange.remove(item);
  void removeAtIndexFromDisplayDatesRange(int index) =>
      displayDatesRange.removeAt(index);
  void insertAtIndexInDisplayDatesRange(int index, DateTime item) =>
      displayDatesRange.insert(index, item);
  void updateDisplayDatesRangeAtIndex(int index, Function(DateTime) updateFn) =>
      displayDatesRange[index] = updateFn(displayDatesRange[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - generateDateRange] action in calendar widget.
  List<DateTime>? generatedDates;
  // Stores action output result for [Custom Action - executeScheduleQuery] action in calendar widget.
  List<ScheduledClassStruct>? selectedDateClassesQuery;
  // Stores action output result for [Custom Action - generateTimeline] action in calendar widget.
  List<DateTime>? generatedTimeline;
  // Stores action output result for [Custom Action - executeScheduleQuery] action in Container widget.
  List<ScheduledClassStruct>? selectedDateQuery;
  // Stores action output result for [Custom Action - generateTimeline] action in Container widget.
  List<DateTime>? newSelectedDateTimeline;
  // State field(s) for weekendPolicy widget.
  WeekendPolicy? weekendPolicyValue;
  FormFieldController<WeekendPolicy>? weekendPolicyValueController;
  // Stores action output result for [Custom Action - generateDateRange] action in weekendPolicy widget.
  List<DateTime>? updatedDateRangeViaWeekendPolicy;
  // State field(s) for displayRange widget.
  DateRange? displayRangeValue;
  FormFieldController<DateRange>? displayRangeValueController;
  // Stores action output result for [Custom Action - generateDateRange] action in displayRange widget.
  List<DateTime>? updatedDateRangeViaDisplayRange;
  // Models for classBlock_calender dynamic component.
  late FlutterFlowDynamicModels<ClassBlockCalenderModel>
      classBlockCalenderModels;

  @override
  void initState(BuildContext context) {
    classBlockCalenderModels =
        FlutterFlowDynamicModels(() => ClassBlockCalenderModel());
  }

  @override
  void dispose() {
    classBlockCalenderModels.dispose();
  }
}
