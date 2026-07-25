// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MarkAbsentResponseStruct extends BaseStruct {
  MarkAbsentResponseStruct({
    bool? success,
    bool? isAbsent,
    String? classId,
    String? userId,
    String? timestamp,
  })  : _success = success,
        _isAbsent = isAbsent,
        _classId = classId,
        _userId = userId,
        _timestamp = timestamp;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "is_absent" field.
  bool? _isAbsent;
  bool get isAbsent => _isAbsent ?? false;
  set isAbsent(bool? val) => _isAbsent = val;

  bool hasIsAbsent() => _isAbsent != null;

  // "class_id" field.
  String? _classId;
  String get classId => _classId ?? '';
  set classId(String? val) => _classId = val;

  bool hasClassId() => _classId != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "timestamp" field.
  String? _timestamp;
  String get timestamp => _timestamp ?? '';
  set timestamp(String? val) => _timestamp = val;

  bool hasTimestamp() => _timestamp != null;

  static MarkAbsentResponseStruct fromMap(Map<String, dynamic> data) =>
      MarkAbsentResponseStruct(
        success: data['success'] as bool?,
        isAbsent: data['is_absent'] as bool?,
        classId: data['class_id'] as String?,
        userId: data['user_id'] as String?,
        timestamp: data['timestamp'] as String?,
      );

  static MarkAbsentResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? MarkAbsentResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'is_absent': _isAbsent,
        'class_id': _classId,
        'user_id': _userId,
        'timestamp': _timestamp,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'is_absent': serializeParam(
          _isAbsent,
          ParamType.bool,
        ),
        'class_id': serializeParam(
          _classId,
          ParamType.String,
        ),
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.String,
        ),
      }.withoutNulls;

  static MarkAbsentResponseStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      MarkAbsentResponseStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        isAbsent: deserializeParam(
          data['is_absent'],
          ParamType.bool,
          false,
        ),
        classId: deserializeParam(
          data['class_id'],
          ParamType.String,
          false,
        ),
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MarkAbsentResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MarkAbsentResponseStruct &&
        success == other.success &&
        isAbsent == other.isAbsent &&
        classId == other.classId &&
        userId == other.userId &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([success, isAbsent, classId, userId, timestamp]);
}

MarkAbsentResponseStruct createMarkAbsentResponseStruct({
  bool? success,
  bool? isAbsent,
  String? classId,
  String? userId,
  String? timestamp,
}) =>
    MarkAbsentResponseStruct(
      success: success,
      isAbsent: isAbsent,
      classId: classId,
      userId: userId,
      timestamp: timestamp,
    );
