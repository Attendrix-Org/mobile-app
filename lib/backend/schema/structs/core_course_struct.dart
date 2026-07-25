// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CoreCourseStruct extends BaseStruct {
  CoreCourseStruct({
    String? courseId,
    String? courseCode,
    String? courseName,
    int? credits,
    String? slot,
    String? courseTypeCode,
  })  : _courseId = courseId,
        _courseCode = courseCode,
        _courseName = courseName,
        _credits = credits,
        _slot = slot,
        _courseTypeCode = courseTypeCode;

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

  // "course_type_code" field.
  String? _courseTypeCode;
  String get courseTypeCode => _courseTypeCode ?? '';
  set courseTypeCode(String? val) => _courseTypeCode = val;

  bool hasCourseTypeCode() => _courseTypeCode != null;

  static CoreCourseStruct fromMap(Map<String, dynamic> data) =>
      CoreCourseStruct(
        courseId: data['course_id'] as String?,
        courseCode: data['course_code'] as String?,
        courseName: data['course_name'] as String?,
        credits: castToType<int>(data['credits']),
        slot: data['slot'] as String?,
        courseTypeCode: data['course_type_code'] as String?,
      );

  static CoreCourseStruct? maybeFromMap(dynamic data) => data is Map
      ? CoreCourseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'course_id': _courseId,
        'course_code': _courseCode,
        'course_name': _courseName,
        'credits': _credits,
        'slot': _slot,
        'course_type_code': _courseTypeCode,
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
        'credits': serializeParam(
          _credits,
          ParamType.int,
        ),
        'slot': serializeParam(
          _slot,
          ParamType.String,
        ),
        'course_type_code': serializeParam(
          _courseTypeCode,
          ParamType.String,
        ),
      }.withoutNulls;

  static CoreCourseStruct fromSerializableMap(Map<String, dynamic> data) =>
      CoreCourseStruct(
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
        courseTypeCode: deserializeParam(
          data['course_type_code'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CoreCourseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CoreCourseStruct &&
        courseId == other.courseId &&
        courseCode == other.courseCode &&
        courseName == other.courseName &&
        credits == other.credits &&
        slot == other.slot &&
        courseTypeCode == other.courseTypeCode;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([courseId, courseCode, courseName, credits, slot, courseTypeCode]);
}

CoreCourseStruct createCoreCourseStruct({
  String? courseId,
  String? courseCode,
  String? courseName,
  int? credits,
  String? slot,
  String? courseTypeCode,
}) =>
    CoreCourseStruct(
      courseId: courseId,
      courseCode: courseCode,
      courseName: courseName,
      credits: credits,
      slot: slot,
      courseTypeCode: courseTypeCode,
    );
