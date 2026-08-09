import '/backend/schema/enums/enums.dart';
import '/components/class_block_general_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'classes_widget.dart' show ClassesWidget;
import 'package:flutter/material.dart';

class ClassesModel extends FlutterFlowModel<ClassesWidget> {
  ///  Local state fields for this page.

  DateRange? dateRange = DateRange.sevenDays;

  WeekendPolicy? weekendPolicy = WeekendPolicy.excludeAll;

  List<DateTime> generatedDatesState = [];
  void addToGeneratedDatesState(DateTime item) => generatedDatesState.add(item);
  void removeFromGeneratedDatesState(DateTime item) =>
      generatedDatesState.remove(item);
  void removeAtIndexFromGeneratedDatesState(int index) =>
      generatedDatesState.removeAt(index);
  void insertAtIndexInGeneratedDatesState(int index, DateTime item) =>
      generatedDatesState.insert(index, item);
  void updateGeneratedDatesStateAtIndex(
          int index, Function(DateTime) updateFn) =>
      generatedDatesState[index] = updateFn(generatedDatesState[index]);

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - generatePastDateRange] action in classes widget.
  List<DateTime>? generatedDates;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // State field(s) for DropDown widget.
  DateRange? dropDownValue1;
  FormFieldController<DateRange>? dropDownValueController1;
  // Stores action output result for [Custom Action - generatePastDateRange] action in DropDown widget.
  List<DateTime>? generatedDatesDateRange;
  // State field(s) for DropDown widget.
  WeekendPolicy? dropDownValue2;
  FormFieldController<WeekendPolicy>? dropDownValueController2;
  // Stores action output result for [Custom Action - generatePastDateRange] action in DropDown widget.
  List<DateTime>? generatedDatesWeekendPolicy;
  // Models for classBlock_general dynamic component.
  late FlutterFlowDynamicModels<ClassBlockGeneralModel>
      classBlockGeneralModels1;
  // Models for classBlock_general dynamic component.
  late FlutterFlowDynamicModels<ClassBlockGeneralModel>
      classBlockGeneralModels2;

  @override
  void initState(BuildContext context) {
    classBlockGeneralModels1 =
        FlutterFlowDynamicModels(() => ClassBlockGeneralModel());
    classBlockGeneralModels2 =
        FlutterFlowDynamicModels(() => ClassBlockGeneralModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    classBlockGeneralModels1.dispose();
    classBlockGeneralModels2.dispose();
  }
}
