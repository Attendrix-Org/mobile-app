// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SyllabusModuleStruct extends BaseStruct {
  SyllabusModuleStruct({
    String? title,
    List<String>? topics,
  })  : _title = title,
        _topics = topics;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "topics" field.
  List<String>? _topics;
  List<String> get topics => _topics ?? const [];
  set topics(List<String>? val) => _topics = val;

  void updateTopics(Function(List<String>) updateFn) {
    updateFn(_topics ??= []);
  }

  bool hasTopics() => _topics != null;

  static SyllabusModuleStruct fromMap(Map<String, dynamic> data) =>
      SyllabusModuleStruct(
        title: data['title'] as String?,
        topics: getDataList(data['topics']),
      );

  static SyllabusModuleStruct? maybeFromMap(dynamic data) => data is Map
      ? SyllabusModuleStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'topics': _topics,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'topics': serializeParam(
          _topics,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static SyllabusModuleStruct fromSerializableMap(Map<String, dynamic> data) =>
      SyllabusModuleStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        topics: deserializeParam<String>(
          data['topics'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'SyllabusModuleStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SyllabusModuleStruct &&
        title == other.title &&
        listEquality.equals(topics, other.topics);
  }

  @override
  int get hashCode => const ListEquality().hash([title, topics]);
}

SyllabusModuleStruct createSyllabusModuleStruct({
  String? title,
}) =>
    SyllabusModuleStruct(
      title: title,
    );
