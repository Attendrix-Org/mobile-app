// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ScheduledClassStruct extends BaseStruct {
  ScheduledClassStruct({
    String? classId,
    String? courseId,
    String? courseCode,
    String? courseName,
    String? batchId,
    CourseType? courseCategory,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
    String? venue,
    String? labGroup,
    bool? isPlusSlot,
    bool? isExtraClass,
    bool? isAbsent,
  })  : _classId = classId,
        _courseId = courseId,
        _courseCode = courseCode,
        _courseName = courseName,
        _batchId = batchId,
        _courseCategory = courseCategory,
        _scheduledStart = scheduledStart,
        _scheduledEnd = scheduledEnd,
        _venue = venue,
        _labGroup = labGroup,
        _isPlusSlot = isPlusSlot,
        _isExtraClass = isExtraClass,
        _isAbsent = isAbsent;

  // "classId" field.
  String? _classId;
  String get classId => _classId ?? '';
  set classId(String? val) => _classId = val;

  bool hasClassId() => _classId != null;

  // "courseId" field.
  String? _courseId;
  String get courseId => _courseId ?? '';
  set courseId(String? val) => _courseId = val;

  bool hasCourseId() => _courseId != null;

  // "courseCode" field.
  String? _courseCode;
  String get courseCode => _courseCode ?? '';
  set courseCode(String? val) => _courseCode = val;

  bool hasCourseCode() => _courseCode != null;

  // "courseName" field.
  String? _courseName;
  String get courseName => _courseName ?? '';
  set courseName(String? val) => _courseName = val;

  bool hasCourseName() => _courseName != null;

  // "batchId" field.
  String? _batchId;
  String get batchId => _batchId ?? '';
  set batchId(String? val) => _batchId = val;

  bool hasBatchId() => _batchId != null;

  // "courseCategory" field.
  CourseType? _courseCategory;
  CourseType? get courseCategory => _courseCategory;
  set courseCategory(CourseType? val) => _courseCategory = val;

  bool hasCourseCategory() => _courseCategory != null;

  // "scheduledStart" field.
  DateTime? _scheduledStart;
  DateTime? get scheduledStart => _scheduledStart;
  set scheduledStart(DateTime? val) => _scheduledStart = val;

  bool hasScheduledStart() => _scheduledStart != null;

  // "scheduledEnd" field.
  DateTime? _scheduledEnd;
  DateTime? get scheduledEnd => _scheduledEnd;
  set scheduledEnd(DateTime? val) => _scheduledEnd = val;

  bool hasScheduledEnd() => _scheduledEnd != null;

  // "venue" field.
  String? _venue;
  String get venue => _venue ?? '';
  set venue(String? val) => _venue = val;

  bool hasVenue() => _venue != null;

  // "labGroup" field.
  String? _labGroup;
  String get labGroup => _labGroup ?? '';
  set labGroup(String? val) => _labGroup = val;

  bool hasLabGroup() => _labGroup != null;

  // "isPlusSlot" field.
  bool? _isPlusSlot;
  bool get isPlusSlot => _isPlusSlot ?? false;
  set isPlusSlot(bool? val) => _isPlusSlot = val;

  bool hasIsPlusSlot() => _isPlusSlot != null;

  // "isExtraClass" field.
  bool? _isExtraClass;
  bool get isExtraClass => _isExtraClass ?? false;
  set isExtraClass(bool? val) => _isExtraClass = val;

  bool hasIsExtraClass() => _isExtraClass != null;

  // "isAbsent" field.
  bool? _isAbsent;
  bool get isAbsent => _isAbsent ?? false;
  set isAbsent(bool? val) => _isAbsent = val;

  bool hasIsAbsent() => _isAbsent != null;

  static ScheduledClassStruct fromMap(Map<String, dynamic> data) =>
      ScheduledClassStruct(
        classId: data['classId'] as String?,
        courseId: data['courseId'] as String?,
        courseCode: data['courseCode'] as String?,
        courseName: data['courseName'] as String?,
        batchId: data['batchId'] as String?,
        courseCategory: data['courseCategory'] is CourseType
            ? data['courseCategory']
            : deserializeEnum<CourseType>(data['courseCategory']),
        scheduledStart: data['scheduledStart'] as DateTime?,
        scheduledEnd: data['scheduledEnd'] as DateTime?,
        venue: data['venue'] as String?,
        labGroup: data['labGroup'] as String?,
        isPlusSlot: data['isPlusSlot'] as bool?,
        isExtraClass: data['isExtraClass'] as bool?,
        isAbsent: data['isAbsent'] as bool?,
      );

  static ScheduledClassStruct? maybeFromMap(dynamic data) => data is Map
      ? ScheduledClassStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'classId': _classId,
        'courseId': _courseId,
        'courseCode': _courseCode,
        'courseName': _courseName,
        'batchId': _batchId,
        'courseCategory': _courseCategory?.serialize(),
        'scheduledStart': _scheduledStart,
        'scheduledEnd': _scheduledEnd,
        'venue': _venue,
        'labGroup': _labGroup,
        'isPlusSlot': _isPlusSlot,
        'isExtraClass': _isExtraClass,
        'isAbsent': _isAbsent,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'classId': serializeParam(
          _classId,
          ParamType.String,
        ),
        'courseId': serializeParam(
          _courseId,
          ParamType.String,
        ),
        'courseCode': serializeParam(
          _courseCode,
          ParamType.String,
        ),
        'courseName': serializeParam(
          _courseName,
          ParamType.String,
        ),
        'batchId': serializeParam(
          _batchId,
          ParamType.String,
        ),
        'courseCategory': serializeParam(
          _courseCategory,
          ParamType.Enum,
        ),
        'scheduledStart': serializeParam(
          _scheduledStart,
          ParamType.DateTime,
        ),
        'scheduledEnd': serializeParam(
          _scheduledEnd,
          ParamType.DateTime,
        ),
        'venue': serializeParam(
          _venue,
          ParamType.String,
        ),
        'labGroup': serializeParam(
          _labGroup,
          ParamType.String,
        ),
        'isPlusSlot': serializeParam(
          _isPlusSlot,
          ParamType.bool,
        ),
        'isExtraClass': serializeParam(
          _isExtraClass,
          ParamType.bool,
        ),
        'isAbsent': serializeParam(
          _isAbsent,
          ParamType.bool,
        ),
      }.withoutNulls;

  static ScheduledClassStruct fromSerializableMap(Map<String, dynamic> data) =>
      ScheduledClassStruct(
        classId: deserializeParam(
          data['classId'],
          ParamType.String,
          false,
        ),
        courseId: deserializeParam(
          data['courseId'],
          ParamType.String,
          false,
        ),
        courseCode: deserializeParam(
          data['courseCode'],
          ParamType.String,
          false,
        ),
        courseName: deserializeParam(
          data['courseName'],
          ParamType.String,
          false,
        ),
        batchId: deserializeParam(
          data['batchId'],
          ParamType.String,
          false,
        ),
        courseCategory: deserializeParam<CourseType>(
          data['courseCategory'],
          ParamType.Enum,
          false,
        ),
        scheduledStart: deserializeParam(
          data['scheduledStart'],
          ParamType.DateTime,
          false,
        ),
        scheduledEnd: deserializeParam(
          data['scheduledEnd'],
          ParamType.DateTime,
          false,
        ),
        venue: deserializeParam(
          data['venue'],
          ParamType.String,
          false,
        ),
        labGroup: deserializeParam(
          data['labGroup'],
          ParamType.String,
          false,
        ),
        isPlusSlot: deserializeParam(
          data['isPlusSlot'],
          ParamType.bool,
          false,
        ),
        isExtraClass: deserializeParam(
          data['isExtraClass'],
          ParamType.bool,
          false,
        ),
        isAbsent: deserializeParam(
          data['isAbsent'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'ScheduledClassStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ScheduledClassStruct &&
        classId == other.classId &&
        courseId == other.courseId &&
        courseCode == other.courseCode &&
        courseName == other.courseName &&
        batchId == other.batchId &&
        courseCategory == other.courseCategory &&
        scheduledStart == other.scheduledStart &&
        scheduledEnd == other.scheduledEnd &&
        venue == other.venue &&
        labGroup == other.labGroup &&
        isPlusSlot == other.isPlusSlot &&
        isExtraClass == other.isExtraClass &&
        isAbsent == other.isAbsent;
  }

  @override
  int get hashCode => const ListEquality().hash([
        classId,
        courseId,
        courseCode,
        courseName,
        batchId,
        courseCategory,
        scheduledStart,
        scheduledEnd,
        venue,
        labGroup,
        isPlusSlot,
        isExtraClass,
        isAbsent
      ]);
}

ScheduledClassStruct createScheduledClassStruct({
  String? classId,
  String? courseId,
  String? courseCode,
  String? courseName,
  String? batchId,
  CourseType? courseCategory,
  DateTime? scheduledStart,
  DateTime? scheduledEnd,
  String? venue,
  String? labGroup,
  bool? isPlusSlot,
  bool? isExtraClass,
  bool? isAbsent,
}) =>
    ScheduledClassStruct(
      classId: classId,
      courseId: courseId,
      courseCode: courseCode,
      courseName: courseName,
      batchId: batchId,
      courseCategory: courseCategory,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      venue: venue,
      labGroup: labGroup,
      isPlusSlot: isPlusSlot,
      isExtraClass: isExtraClass,
      isAbsent: isAbsent,
    );
