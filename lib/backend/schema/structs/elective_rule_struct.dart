// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ElectiveRuleStruct extends BaseStruct {
  ElectiveRuleStruct({
    String? electiveCategory,
    int? requiredCount,
  })  : _electiveCategory = electiveCategory,
        _requiredCount = requiredCount;

  // "elective_category" field.
  String? _electiveCategory;
  String get electiveCategory => _electiveCategory ?? '';
  set electiveCategory(String? val) => _electiveCategory = val;

  bool hasElectiveCategory() => _electiveCategory != null;

  // "required_count" field.
  int? _requiredCount;
  int get requiredCount => _requiredCount ?? 0;
  set requiredCount(int? val) => _requiredCount = val;

  void incrementRequiredCount(int amount) =>
      requiredCount = requiredCount + amount;

  bool hasRequiredCount() => _requiredCount != null;

  static ElectiveRuleStruct fromMap(Map<String, dynamic> data) =>
      ElectiveRuleStruct(
        electiveCategory: data['elective_category'] as String?,
        requiredCount: castToType<int>(data['required_count']),
      );

  static ElectiveRuleStruct? maybeFromMap(dynamic data) => data is Map
      ? ElectiveRuleStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'elective_category': _electiveCategory,
        'required_count': _requiredCount,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'elective_category': serializeParam(
          _electiveCategory,
          ParamType.String,
        ),
        'required_count': serializeParam(
          _requiredCount,
          ParamType.int,
        ),
      }.withoutNulls;

  static ElectiveRuleStruct fromSerializableMap(Map<String, dynamic> data) =>
      ElectiveRuleStruct(
        electiveCategory: deserializeParam(
          data['elective_category'],
          ParamType.String,
          false,
        ),
        requiredCount: deserializeParam(
          data['required_count'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ElectiveRuleStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ElectiveRuleStruct &&
        electiveCategory == other.electiveCategory &&
        requiredCount == other.requiredCount;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([electiveCategory, requiredCount]);
}

ElectiveRuleStruct createElectiveRuleStruct({
  String? electiveCategory,
  int? requiredCount,
}) =>
    ElectiveRuleStruct(
      electiveCategory: electiveCategory,
      requiredCount: requiredCount,
    );
