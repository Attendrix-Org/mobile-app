// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LabSubBatchStruct extends BaseStruct {
  LabSubBatchStruct({
    String? courseId,
    String? subBatch,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
  })  : _courseId = courseId,
        _subBatch = subBatch,
        _dayOfWeek = dayOfWeek,
        _startTime = startTime,
        _endTime = endTime;

  // "course_id" field.
  String? _courseId;
  String get courseId => _courseId ?? '';
  set courseId(String? val) => _courseId = val;

  bool hasCourseId() => _courseId != null;

  // "sub_batch" field.
  String? _subBatch;
  String get subBatch => _subBatch ?? '';
  set subBatch(String? val) => _subBatch = val;

  bool hasSubBatch() => _subBatch != null;

  // "day_of_week" field.
  int? _dayOfWeek;
  int get dayOfWeek => _dayOfWeek ?? 0;
  set dayOfWeek(int? val) => _dayOfWeek = val;

  void incrementDayOfWeek(int amount) => dayOfWeek = dayOfWeek + amount;

  bool hasDayOfWeek() => _dayOfWeek != null;

  // "start_time" field.
  String? _startTime;
  String get startTime => _startTime ?? '';
  set startTime(String? val) => _startTime = val;

  bool hasStartTime() => _startTime != null;

  // "end_time" field.
  String? _endTime;
  String get endTime => _endTime ?? '';
  set endTime(String? val) => _endTime = val;

  bool hasEndTime() => _endTime != null;

  static LabSubBatchStruct fromMap(Map<String, dynamic> data) =>
      LabSubBatchStruct(
        courseId: data['course_id'] as String?,
        subBatch: data['sub_batch'] as String?,
        dayOfWeek: castToType<int>(data['day_of_week']),
        startTime: data['start_time'] as String?,
        endTime: data['end_time'] as String?,
      );

  static LabSubBatchStruct? maybeFromMap(dynamic data) => data is Map
      ? LabSubBatchStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'course_id': _courseId,
        'sub_batch': _subBatch,
        'day_of_week': _dayOfWeek,
        'start_time': _startTime,
        'end_time': _endTime,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'course_id': serializeParam(
          _courseId,
          ParamType.String,
        ),
        'sub_batch': serializeParam(
          _subBatch,
          ParamType.String,
        ),
        'day_of_week': serializeParam(
          _dayOfWeek,
          ParamType.int,
        ),
        'start_time': serializeParam(
          _startTime,
          ParamType.String,
        ),
        'end_time': serializeParam(
          _endTime,
          ParamType.String,
        ),
      }.withoutNulls;

  static LabSubBatchStruct fromSerializableMap(Map<String, dynamic> data) =>
      LabSubBatchStruct(
        courseId: deserializeParam(
          data['course_id'],
          ParamType.String,
          false,
        ),
        subBatch: deserializeParam(
          data['sub_batch'],
          ParamType.String,
          false,
        ),
        dayOfWeek: deserializeParam(
          data['day_of_week'],
          ParamType.int,
          false,
        ),
        startTime: deserializeParam(
          data['start_time'],
          ParamType.String,
          false,
        ),
        endTime: deserializeParam(
          data['end_time'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LabSubBatchStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LabSubBatchStruct &&
        courseId == other.courseId &&
        subBatch == other.subBatch &&
        dayOfWeek == other.dayOfWeek &&
        startTime == other.startTime &&
        endTime == other.endTime;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([courseId, subBatch, dayOfWeek, startTime, endTime]);
}

LabSubBatchStruct createLabSubBatchStruct({
  String? courseId,
  String? subBatch,
  int? dayOfWeek,
  String? startTime,
  String? endTime,
}) =>
    LabSubBatchStruct(
      courseId: courseId,
      subBatch: subBatch,
      dayOfWeek: dayOfWeek,
      startTime: startTime,
      endTime: endTime,
    );
