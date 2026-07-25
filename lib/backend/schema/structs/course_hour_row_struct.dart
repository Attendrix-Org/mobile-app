// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CourseHourRowStruct extends BaseStruct {
  CourseHourRowStruct({
    String? label,
    int? value,
  })  : _label = label,
        _value = value;

  // "label" field.
  String? _label;
  String get label => _label ?? '';
  set label(String? val) => _label = val;

  bool hasLabel() => _label != null;

  // "value" field.
  int? _value;
  int get value => _value ?? 0;
  set value(int? val) => _value = val;

  void incrementValue(int amount) => value = value + amount;

  bool hasValue() => _value != null;

  static CourseHourRowStruct fromMap(Map<String, dynamic> data) =>
      CourseHourRowStruct(
        label: data['label'] as String?,
        value: castToType<int>(data['value']),
      );

  static CourseHourRowStruct? maybeFromMap(dynamic data) => data is Map
      ? CourseHourRowStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'label': _label,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'label': serializeParam(
          _label,
          ParamType.String,
        ),
        'value': serializeParam(
          _value,
          ParamType.int,
        ),
      }.withoutNulls;

  static CourseHourRowStruct fromSerializableMap(Map<String, dynamic> data) =>
      CourseHourRowStruct(
        label: deserializeParam(
          data['label'],
          ParamType.String,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CourseHourRowStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CourseHourRowStruct &&
        label == other.label &&
        value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([label, value]);
}

CourseHourRowStruct createCourseHourRowStruct({
  String? label,
  int? value,
}) =>
    CourseHourRowStruct(
      label: label,
      value: value,
    );
