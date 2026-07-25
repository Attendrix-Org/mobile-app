// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PendingNotificationStruct extends BaseStruct {
  PendingNotificationStruct({
    String? type,
    String? id,
    bool? hasValue,
  })  : _type = type,
        _id = id,
        _hasValue = hasValue;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "hasValue" field.
  bool? _hasValue;
  bool get hasValue => _hasValue ?? false;
  set hasValue(bool? val) => _hasValue = val;

  bool hasHasValue() => _hasValue != null;

  static PendingNotificationStruct fromMap(Map<String, dynamic> data) =>
      PendingNotificationStruct(
        type: data['type'] as String?,
        id: data['id'] as String?,
        hasValue: data['hasValue'] as bool?,
      );

  static PendingNotificationStruct? maybeFromMap(dynamic data) => data is Map
      ? PendingNotificationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'type': _type,
        'id': _id,
        'hasValue': _hasValue,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'hasValue': serializeParam(
          _hasValue,
          ParamType.bool,
        ),
      }.withoutNulls;

  static PendingNotificationStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PendingNotificationStruct(
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        hasValue: deserializeParam(
          data['hasValue'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'PendingNotificationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PendingNotificationStruct &&
        type == other.type &&
        id == other.id &&
        hasValue == other.hasValue;
  }

  @override
  int get hashCode => const ListEquality().hash([type, id, hasValue]);
}

PendingNotificationStruct createPendingNotificationStruct({
  String? type,
  String? id,
  bool? hasValue,
}) =>
    PendingNotificationStruct(
      type: type,
      id: id,
      hasValue: hasValue,
    );
