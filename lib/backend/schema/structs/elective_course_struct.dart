// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ElectiveCourseStruct extends BaseStruct {
  ElectiveCourseStruct({
    String? courseId,
    String? courseCode,
    String? courseName,
    String? electiveCategory,
    int? credits,
    String? slot,
  })  : _courseId = courseId,
        _courseCode = courseCode,
        _courseName = courseName,
        _electiveCategory = electiveCategory,
        _credits = credits,
        _slot = slot;

  // "course_id" field.
  String? _courseId;
  String get courseId => _courseId ?? '';
  set courseId(String? val) => _courseId = val;

  bool hasCourseId() => _courseId != null;

  // "course_code" field.
  String? _courseCode;
  String get courseCode => _courseCode ?? '';
  set courseCode(String? val) => _courseCode = val;

  bool hasCourseCode() => _courseCode != null;

  // "course_name" field.
  String? _courseName;
  String get courseName => _courseName ?? '';
  set courseName(String? val) => _courseName = val;

  bool hasCourseName() => _courseName != null;

  // "elective_category" field.
  String? _electiveCategory;
  String get electiveCategory => _electiveCategory ?? '';
  set electiveCategory(String? val) => _electiveCategory = val;

  bool hasElectiveCategory() => _electiveCategory != null;

  // "credits" field.
  int? _credits;
  int get credits => _credits ?? 0;
  set credits(int? val) => _credits = val;

  void incrementCredits(int amount) => credits = credits + amount;

  bool hasCredits() => _credits != null;

  // "slot" field.
  String? _slot;
  String get slot => _slot ?? '';
  set slot(String? val) => _slot = val;

  bool hasSlot() => _slot != null;

  static ElectiveCourseStruct fromMap(Map<String, dynamic> data) =>
      ElectiveCourseStruct(
        courseId: data['course_id'] as String?,
        courseCode: data['course_code'] as String?,
        courseName: data['course_name'] as String?,
        electiveCategory: data['elective_category'] as String?,
        credits: castToType<int>(data['credits']),
        slot: data['slot'] as String?,
      );

  static ElectiveCourseStruct? maybeFromMap(dynamic data) => data is Map
      ? ElectiveCourseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'course_id': _courseId,
        'course_code': _courseCode,
        'course_name': _courseName,
        'elective_category': _electiveCategory,
        'credits': _credits,
        'slot': _slot,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'course_id': serializeParam(
          _courseId,
          ParamType.String,
        ),
        'course_code': serializeParam(
          _courseCode,
          ParamType.String,
        ),
        'course_name': serializeParam(
          _courseName,
          ParamType.String,
        ),
        'elective_category': serializeParam(
          _electiveCategory,
          ParamType.String,
        ),
        'credits': serializeParam(
          _credits,
          ParamType.int,
        ),
        'slot': serializeParam(
          _slot,
          ParamType.String,
        ),
      }.withoutNulls;

  static ElectiveCourseStruct fromSerializableMap(Map<String, dynamic> data) =>
      ElectiveCourseStruct(
        courseId: deserializeParam(
          data['course_id'],
          ParamType.String,
          false,
        ),
        courseCode: deserializeParam(
          data['course_code'],
          ParamType.String,
          false,
        ),
        courseName: deserializeParam(
          data['course_name'],
          ParamType.String,
          false,
        ),
        electiveCategory: deserializeParam(
          data['elective_category'],
          ParamType.String,
          false,
        ),
        credits: deserializeParam(
          data['credits'],
          ParamType.int,
          false,
        ),
        slot: deserializeParam(
          data['slot'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ElectiveCourseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ElectiveCourseStruct &&
        courseId == other.courseId &&
        courseCode == other.courseCode &&
        courseName == other.courseName &&
        electiveCategory == other.electiveCategory &&
        credits == other.credits &&
        slot == other.slot;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [courseId, courseCode, courseName, electiveCategory, credits, slot]);
}

ElectiveCourseStruct createElectiveCourseStruct({
  String? courseId,
  String? courseCode,
  String? courseName,
  String? electiveCategory,
  int? credits,
  String? slot,
}) =>
    ElectiveCourseStruct(
      courseId: courseId,
      courseCode: courseCode,
      courseName: courseName,
      electiveCategory: electiveCategory,
      credits: credits,
      slot: slot,
    );
