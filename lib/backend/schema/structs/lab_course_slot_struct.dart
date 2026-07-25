// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LabCourseSlotStruct extends BaseStruct {
  LabCourseSlotStruct({
    String? courseId,
    String? courseCode,
    String? courseName,
    int? credits,
    String? slot,
    bool? hasSubBatches,
    List<LabSubBatchStruct>? subBatches,
  })  : _courseId = courseId,
        _courseCode = courseCode,
        _courseName = courseName,
        _credits = credits,
        _slot = slot,
        _hasSubBatches = hasSubBatches,
        _subBatches = subBatches;

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

  // "has_sub_batches" field.
  bool? _hasSubBatches;
  bool get hasSubBatches => _hasSubBatches ?? false;
  set hasSubBatches(bool? val) => _hasSubBatches = val;

  bool hasHasSubBatches() => _hasSubBatches != null;

  // "sub_batches" field.
  List<LabSubBatchStruct>? _subBatches;
  List<LabSubBatchStruct> get subBatches => _subBatches ?? const [];
  set subBatches(List<LabSubBatchStruct>? val) => _subBatches = val;

  void updateSubBatches(Function(List<LabSubBatchStruct>) updateFn) {
    updateFn(_subBatches ??= []);
  }

  bool hasSubBatchesField() => _subBatches != null;

  static LabCourseSlotStruct fromMap(Map<String, dynamic> data) =>
      LabCourseSlotStruct(
        courseId: data['course_id'] as String?,
        courseCode: data['course_code'] as String?,
        courseName: data['course_name'] as String?,
        credits: castToType<int>(data['credits']),
        slot: data['slot'] as String?,
        hasSubBatches: data['has_sub_batches'] as bool?,
        subBatches: getStructList(
          data['sub_batches'],
          LabSubBatchStruct.fromMap,
        ),
      );

  static LabCourseSlotStruct? maybeFromMap(dynamic data) => data is Map
      ? LabCourseSlotStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'course_id': _courseId,
        'course_code': _courseCode,
        'course_name': _courseName,
        'credits': _credits,
        'slot': _slot,
        'has_sub_batches': _hasSubBatches,
        'sub_batches': _subBatches?.map((e) => e.toMap()).toList(),
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
        'has_sub_batches': serializeParam(
          _hasSubBatches,
          ParamType.bool,
        ),
        'sub_batches': serializeParam(
          _subBatches,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static LabCourseSlotStruct fromSerializableMap(Map<String, dynamic> data) =>
      LabCourseSlotStruct(
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
        hasSubBatches: deserializeParam(
          data['has_sub_batches'],
          ParamType.bool,
          false,
        ),
        subBatches: deserializeStructParam<LabSubBatchStruct>(
          data['sub_batches'],
          ParamType.DataStruct,
          true,
          structBuilder: LabSubBatchStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'LabCourseSlotStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is LabCourseSlotStruct &&
        courseId == other.courseId &&
        courseCode == other.courseCode &&
        courseName == other.courseName &&
        credits == other.credits &&
        slot == other.slot &&
        hasSubBatches == other.hasSubBatches &&
        listEquality.equals(subBatches, other.subBatches);
  }

  @override
  int get hashCode => const ListEquality().hash([
        courseId,
        courseCode,
        courseName,
        credits,
        slot,
        hasSubBatches,
        subBatches
      ]);
}

LabCourseSlotStruct createLabCourseSlotStruct({
  String? courseId,
  String? courseCode,
  String? courseName,
  int? credits,
  String? slot,
  bool? hasSubBatches,
}) =>
    LabCourseSlotStruct(
      courseId: courseId,
      courseCode: courseCode,
      courseName: courseName,
      credits: credits,
      slot: slot,
      hasSubBatches: hasSubBatches,
    );
