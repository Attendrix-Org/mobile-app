// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class EnrolledCourseStruct extends BaseStruct {
  EnrolledCourseStruct({
    String? courseId,
    String? courseCode,
    String? courseName,
    String? courseType,
    String? slot,
    int? credits,
    bool? isLab,
    bool? isElective,
    String? electiveCategory,
    AttendanceStruct? attendance,
  })  : _courseId = courseId,
        _courseCode = courseCode,
        _courseName = courseName,
        _courseType = courseType,
        _slot = slot,
        _credits = credits,
        _isLab = isLab,
        _isElective = isElective,
        _electiveCategory = electiveCategory,
        _attendance = attendance;

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

  // "courseType" field.
  String? _courseType;
  String get courseType => _courseType ?? '';
  set courseType(String? val) => _courseType = val;

  bool hasCourseType() => _courseType != null;

  // "slot" field.
  String? _slot;
  String get slot => _slot ?? '';
  set slot(String? val) => _slot = val;

  bool hasSlot() => _slot != null;

  // "credits" field.
  int? _credits;
  int get credits => _credits ?? 0;
  set credits(int? val) => _credits = val;

  void incrementCredits(int amount) => credits = credits + amount;

  bool hasCredits() => _credits != null;

  // "isLab" field.
  bool? _isLab;
  bool get isLab => _isLab ?? false;
  set isLab(bool? val) => _isLab = val;

  bool hasIsLab() => _isLab != null;

  // "isElective" field.
  bool? _isElective;
  bool get isElective => _isElective ?? false;
  set isElective(bool? val) => _isElective = val;

  bool hasIsElective() => _isElective != null;

  // "electiveCategory" field.
  String? _electiveCategory;
  String get electiveCategory => _electiveCategory ?? '';
  set electiveCategory(String? val) => _electiveCategory = val;

  bool hasElectiveCategory() => _electiveCategory != null;

  // "attendance" field.
  AttendanceStruct? _attendance;
  AttendanceStruct get attendance => _attendance ?? AttendanceStruct();
  set attendance(AttendanceStruct? val) => _attendance = val;

  void updateAttendance(Function(AttendanceStruct) updateFn) {
    updateFn(_attendance ??= AttendanceStruct());
  }

  bool hasAttendance() => _attendance != null;

  static EnrolledCourseStruct fromMap(Map<String, dynamic> data) =>
      EnrolledCourseStruct(
        courseId: data['courseId'] as String?,
        courseCode: data['courseCode'] as String?,
        courseName: data['courseName'] as String?,
        courseType: data['courseType'] as String?,
        slot: data['slot'] as String?,
        credits: castToType<int>(data['credits']),
        isLab: data['isLab'] as bool?,
        isElective: data['isElective'] as bool?,
        electiveCategory: data['electiveCategory'] as String?,
        attendance: data['attendance'] is AttendanceStruct
            ? data['attendance']
            : AttendanceStruct.maybeFromMap(data['attendance']),
      );

  static EnrolledCourseStruct? maybeFromMap(dynamic data) => data is Map
      ? EnrolledCourseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'courseId': _courseId,
        'courseCode': _courseCode,
        'courseName': _courseName,
        'courseType': _courseType,
        'slot': _slot,
        'credits': _credits,
        'isLab': _isLab,
        'isElective': _isElective,
        'electiveCategory': _electiveCategory,
        'attendance': _attendance?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
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
        'courseType': serializeParam(
          _courseType,
          ParamType.String,
        ),
        'slot': serializeParam(
          _slot,
          ParamType.String,
        ),
        'credits': serializeParam(
          _credits,
          ParamType.int,
        ),
        'isLab': serializeParam(
          _isLab,
          ParamType.bool,
        ),
        'isElective': serializeParam(
          _isElective,
          ParamType.bool,
        ),
        'electiveCategory': serializeParam(
          _electiveCategory,
          ParamType.String,
        ),
        'attendance': serializeParam(
          _attendance,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static EnrolledCourseStruct fromSerializableMap(Map<String, dynamic> data) =>
      EnrolledCourseStruct(
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
        courseType: deserializeParam(
          data['courseType'],
          ParamType.String,
          false,
        ),
        slot: deserializeParam(
          data['slot'],
          ParamType.String,
          false,
        ),
        credits: deserializeParam(
          data['credits'],
          ParamType.int,
          false,
        ),
        isLab: deserializeParam(
          data['isLab'],
          ParamType.bool,
          false,
        ),
        isElective: deserializeParam(
          data['isElective'],
          ParamType.bool,
          false,
        ),
        electiveCategory: deserializeParam(
          data['electiveCategory'],
          ParamType.String,
          false,
        ),
        attendance: deserializeStructParam(
          data['attendance'],
          ParamType.DataStruct,
          false,
          structBuilder: AttendanceStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'EnrolledCourseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is EnrolledCourseStruct &&
        courseId == other.courseId &&
        courseCode == other.courseCode &&
        courseName == other.courseName &&
        courseType == other.courseType &&
        slot == other.slot &&
        credits == other.credits &&
        isLab == other.isLab &&
        isElective == other.isElective &&
        electiveCategory == other.electiveCategory &&
        attendance == other.attendance;
  }

  @override
  int get hashCode => const ListEquality().hash([
        courseId,
        courseCode,
        courseName,
        courseType,
        slot,
        credits,
        isLab,
        isElective,
        electiveCategory,
        attendance
      ]);
}

EnrolledCourseStruct createEnrolledCourseStruct({
  String? courseId,
  String? courseCode,
  String? courseName,
  String? courseType,
  String? slot,
  int? credits,
  bool? isLab,
  bool? isElective,
  String? electiveCategory,
  AttendanceStruct? attendance,
}) =>
    EnrolledCourseStruct(
      courseId: courseId,
      courseCode: courseCode,
      courseName: courseName,
      courseType: courseType,
      slot: slot,
      credits: credits,
      isLab: isLab,
      isElective: isElective,
      electiveCategory: electiveCategory,
      attendance: attendance ?? AttendanceStruct(),
    );
