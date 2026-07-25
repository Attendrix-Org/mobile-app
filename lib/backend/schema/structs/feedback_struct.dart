// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FeedbackStruct extends BaseStruct {
  FeedbackStruct({
    bool? success,
    int? statusCode,
    String? message,
  })  : _success = success,
        _statusCode = statusCode,
        _message = message;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "statusCode" field.
  int? _statusCode;
  int get statusCode => _statusCode ?? 0;
  set statusCode(int? val) => _statusCode = val;

  void incrementStatusCode(int amount) => statusCode = statusCode + amount;

  bool hasStatusCode() => _statusCode != null;

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  set message(String? val) => _message = val;

  bool hasMessage() => _message != null;

  static FeedbackStruct fromMap(Map<String, dynamic> data) => FeedbackStruct(
        success: data['success'] as bool?,
        statusCode: castToType<int>(data['statusCode']),
        message: data['message'] as String?,
      );

  static FeedbackStruct? maybeFromMap(dynamic data) =>
      data is Map ? FeedbackStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'statusCode': _statusCode,
        'message': _message,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'statusCode': serializeParam(
          _statusCode,
          ParamType.int,
        ),
        'message': serializeParam(
          _message,
          ParamType.String,
        ),
      }.withoutNulls;

  static FeedbackStruct fromSerializableMap(Map<String, dynamic> data) =>
      FeedbackStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        statusCode: deserializeParam(
          data['statusCode'],
          ParamType.int,
          false,
        ),
        message: deserializeParam(
          data['message'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'FeedbackStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FeedbackStruct &&
        success == other.success &&
        statusCode == other.statusCode &&
        message == other.message;
  }

  @override
  int get hashCode => const ListEquality().hash([success, statusCode, message]);
}

FeedbackStruct createFeedbackStruct({
  bool? success,
  int? statusCode,
  String? message,
}) =>
    FeedbackStruct(
      success: success,
      statusCode: statusCode,
      message: message,
    );
