import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/core_course_block_widget.dart';
import '/components/elective_course_block_widget.dart';
import '/components/lab_selection_block_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'onboarding_widget.dart' show OnboardingWidget;
import 'package:flutter/material.dart';

class OnboardingModel extends FlutterFlowModel<OnboardingWidget> {
  ///  Local state fields for this page.

  String? fullName;

  String? rollNumber;

  int? semester;

  String? branch;

  String? batch;

  String? userBio;

  bool acceptedTermsAndConditions = false;

  bool acceptedMarketingEmails = false;

  String? username;

  bool isUsernameAvailable = true;

  List<EnrolledCourseStruct> selectedElectives = [];
  void addToSelectedElectives(EnrolledCourseStruct item) =>
      selectedElectives.add(item);
  void removeFromSelectedElectives(EnrolledCourseStruct item) =>
      selectedElectives.remove(item);
  void removeAtIndexFromSelectedElectives(int index) =>
      selectedElectives.removeAt(index);
  void insertAtIndexInSelectedElectives(int index, EnrolledCourseStruct item) =>
      selectedElectives.insert(index, item);
  void updateSelectedElectivesAtIndex(
          int index, Function(EnrolledCourseStruct) updateFn) =>
      selectedElectives[index] = updateFn(selectedElectives[index]);

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

  List<EnrolledCourseStruct> enrolledCoreCourses = [];
  void addToEnrolledCoreCourses(EnrolledCourseStruct item) =>
      enrolledCoreCourses.add(item);
  void removeFromEnrolledCoreCourses(EnrolledCourseStruct item) =>
      enrolledCoreCourses.remove(item);
  void removeAtIndexFromEnrolledCoreCourses(int index) =>
      enrolledCoreCourses.removeAt(index);
  void insertAtIndexInEnrolledCoreCourses(
          int index, EnrolledCourseStruct item) =>
      enrolledCoreCourses.insert(index, item);
  void updateEnrolledCoreCoursesAtIndex(
          int index, Function(EnrolledCourseStruct) updateFn) =>
      enrolledCoreCourses[index] = updateFn(enrolledCoreCourses[index]);

  bool isOnboardingComplete = false;

  double onboardingProgress = 0.0;

  String? onboardingProgressMessage;

  int onboardingElapsedTIme = 0;

  List<SemestersRow> semesterData = [];
  void addToSemesterData(SemestersRow item) => semesterData.add(item);
  void removeFromSemesterData(SemestersRow item) => semesterData.remove(item);
  void removeAtIndexFromSemesterData(int index) => semesterData.removeAt(index);
  void insertAtIndexInSemesterData(int index, SemestersRow item) =>
      semesterData.insert(index, item);
  void updateSemesterDataAtIndex(int index, Function(SemestersRow) updateFn) =>
      semesterData[index] = updateFn(semesterData[index]);

  List<BatchesRow> batchData = [];
  void addToBatchData(BatchesRow item) => batchData.add(item);
  void removeFromBatchData(BatchesRow item) => batchData.remove(item);
  void removeAtIndexFromBatchData(int index) => batchData.removeAt(index);
  void insertAtIndexInBatchData(int index, BatchesRow item) =>
      batchData.insert(index, item);
  void updateBatchDataAtIndex(int index, Function(BatchesRow) updateFn) =>
      batchData[index] = updateFn(batchData[index]);

  bool dataLoaded = false;

  ///  State fields for stateful widgets in this page.

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - Query Rows] action in onboarding widget.
  List<SemestersRow>? semesterQueryData;
  // Stores action output result for [Backend Call - Query Rows] action in onboarding widget.
  List<BatchesRow>? batchDataQuery;
  // State field(s) for onboardingPages widget.
  PageController? onboardingPagesController;

  int get onboardingPagesCurrentIndex => onboardingPagesController != null &&
          onboardingPagesController!.hasClients &&
          onboardingPagesController!.page != null
      ? onboardingPagesController!.page!.round()
      : 0;
  // State field(s) for fullName widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;
  String? _fullNameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Name can’t be empty';
    }

    if (val.length < 4) {
      return 'Requires at least 4 characters.';
    }
    if (val.length > 18) {
      return 'Maximum 18 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for rollNumber widget.
  FocusNode? rollNumberFocusNode;
  TextEditingController? rollNumberTextController;
  String? Function(BuildContext, String?)? rollNumberTextControllerValidator;
  String? _rollNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Your Institute Roll Number is required';
    }

    if (val.length < 9) {
      return 'Invalid institute roll number.';
    }
    if (val.length > 9) {
      return 'Invalid institute roll number.';
    }
    if (!RegExp(
            '^[BMP]2[0-6]\\d{4}(AR|BT|CE|CH|CS|CY|EC|EE|EN|EP|MA|ME|MS|PE|PH)\$')
        .hasMatch(val)) {
      return 'Invalid institute roll number.';
    }
    return null;
  }

  // Stores action output result for [Custom Action - parseRollNumber] action in rollNumber widget.
  RollNumberDetailsStruct? parsedRollNumberDetails;
  // Stores action output result for [Backend Call - Query Rows] action in rollNumber widget.
  List<BatchesRow>? batchQueryData;
  // Stores action output result for [Custom Action - parseRollNumber] action in rollNumber widget.
  RollNumberDetailsStruct? parsedRollNumberDetailsCopy;
  // Stores action output result for [Backend Call - Query Rows] action in rollNumber widget.
  List<BatchesRow>? batchQueryDataCopy;
  // State field(s) for semester widget.
  int? semesterValue;
  FormFieldController<int>? semesterValueController;
  // Stores action output result for [Backend Call - Query Rows] action in semester widget.
  List<BatchesRow>? batchQueryDataViaSemester;
  // State field(s) for branch widget.
  String? branchValue;
  FormFieldController<String>? branchValueController;
  // State field(s) for batch widget.
  String? batchValue;
  FormFieldController<String>? batchValueController;
  // State field(s) for userBio widget.
  FocusNode? userBioFocusNode;
  TextEditingController? userBioTextController;
  String? Function(BuildContext, String?)? userBioTextControllerValidator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue1;
  // State field(s) for Checkbox widget.
  bool? checkboxValue2;
  // Stores action output result for [Validate Form] action in Button widget.
  bool? academicProfileFormValidation;
  // Stores action output result for [Custom Action - getCoreCourses] action in Button widget.
  List<CoreCourseStruct>? coreCourseData;
  // Stores action output result for [Custom Action - getElectiveRequirementsList] action in Button widget.
  List<String>? requiredElectives;
  // Stores action output result for [Custom Action - getElectiveCourses] action in Button widget.
  List<ElectiveCourseStruct>? electiveCourseData;
  // Stores action output result for [Custom Action - getLabCourses] action in Button widget.
  List<EnrolledCourseStruct>? labCourseData;
  // State field(s) for username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;
  String? _usernameTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Username is required';
    }

    if (val.length < 4) {
      return 'username must be atleast 4 characters long.';
    }

    if (!RegExp(kTextValidatorUsernameRegex).hasMatch(val)) {
      return 'Must start with a letter and can only contain letters, digits and - or _.';
    }
    return null;
  }

  // Stores action output result for [Custom Action - isUsernameAvailable] action in username widget.
  bool? isUsernameAvailableServerResponse;
  // Stores action output result for [Custom Action - generateUsername] action in IconButton widget.
  String? generatedUsername;
  // Stores action output result for [Custom Action - isUsernameAvailable] action in IconButton widget.
  bool? isGeneratedUsernameAvailable;
  // Models for coreCourse_block dynamic component.
  late FlutterFlowDynamicModels<CoreCourseBlockModel> coreCourseBlockModels;
  // Models for labSelection_block dynamic component.
  late FlutterFlowDynamicModels<LabSelectionBlockModel> labSelectionBlockModels;
  // Models for electiveCourse_block dynamic component.
  late FlutterFlowDynamicModels<ElectiveCourseBlockModel>
      electiveCourseBlockModels;
  // Stores action output result for [Custom Action - combineEnrolledCourses] action in Button widget.
  List<EnrolledCourseStruct>? combinedEnrolledCourses;
  // Stores action output result for [Custom Action - completeUserOnboarding] action in Button widget.
  bool? onboardingComplete;
  // Stores action output result for [Custom Action - completeCourseEnrollment] action in Button widget.
  FeedbackStruct? courseEnrollmentComplete;
  // Stores action output result for [Custom Action - generatePastDateRange] action in Button widget.
  List<DateTime>? generatedTimeline;
  // Stores action output result for [Custom Action - generateGreeting] action in Button widget.
  String? generatedGreetingMessageOnboarding;
  InstantTimer? instantTimer;

  @override
  void initState(BuildContext context) {
    fullNameTextControllerValidator = _fullNameTextControllerValidator;
    rollNumberTextControllerValidator = _rollNumberTextControllerValidator;
    usernameTextControllerValidator = _usernameTextControllerValidator;
    coreCourseBlockModels =
        FlutterFlowDynamicModels(() => CoreCourseBlockModel());
    labSelectionBlockModels =
        FlutterFlowDynamicModels(() => LabSelectionBlockModel());
    electiveCourseBlockModels =
        FlutterFlowDynamicModels(() => ElectiveCourseBlockModel());
  }

  @override
  void dispose() {
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    rollNumberFocusNode?.dispose();
    rollNumberTextController?.dispose();

    userBioFocusNode?.dispose();
    userBioTextController?.dispose();

    usernameFocusNode?.dispose();
    usernameTextController?.dispose();

    coreCourseBlockModels.dispose();
    labSelectionBlockModels.dispose();
    electiveCourseBlockModels.dispose();
    instantTimer?.cancel();
  }
}
