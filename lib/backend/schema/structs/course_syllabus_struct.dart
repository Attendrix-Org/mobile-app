// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CourseSyllabusStruct extends BaseStruct {
  CourseSyllabusStruct({
    String? courseCode,
    String? courseName,
    String? syllabusPath,
    String? prerequisites,
    int? lectureHours,
    int? tutorialHours,
    int? practicalHours,
    int? outsideHours,
    int? lectureSessions,
    List<String>? courseOutcomes,
    List<SyllabusModuleStruct>? modules,
    List<String>? textbooks,
    List<String>? references,
  })  : _courseCode = courseCode,
        _courseName = courseName,
        _syllabusPath = syllabusPath,
        _prerequisites = prerequisites,
        _lectureHours = lectureHours,
        _tutorialHours = tutorialHours,
        _practicalHours = practicalHours,
        _outsideHours = outsideHours,
        _lectureSessions = lectureSessions,
        _courseOutcomes = courseOutcomes,
        _modules = modules,
        _textbooks = textbooks,
        _references = references;

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

  // "syllabusPath" field.
  String? _syllabusPath;
  String get syllabusPath => _syllabusPath ?? '';
  set syllabusPath(String? val) => _syllabusPath = val;

  bool hasSyllabusPath() => _syllabusPath != null;

  // "prerequisites" field.
  String? _prerequisites;
  String get prerequisites => _prerequisites ?? '';
  set prerequisites(String? val) => _prerequisites = val;

  bool hasPrerequisites() => _prerequisites != null;

  // "lectureHours" field.
  int? _lectureHours;
  int get lectureHours => _lectureHours ?? 0;
  set lectureHours(int? val) => _lectureHours = val;

  void incrementLectureHours(int amount) =>
      lectureHours = lectureHours + amount;

  bool hasLectureHours() => _lectureHours != null;

  // "tutorialHours" field.
  int? _tutorialHours;
  int get tutorialHours => _tutorialHours ?? 0;
  set tutorialHours(int? val) => _tutorialHours = val;

  void incrementTutorialHours(int amount) =>
      tutorialHours = tutorialHours + amount;

  bool hasTutorialHours() => _tutorialHours != null;

  // "practicalHours" field.
  int? _practicalHours;
  int get practicalHours => _practicalHours ?? 0;
  set practicalHours(int? val) => _practicalHours = val;

  void incrementPracticalHours(int amount) =>
      practicalHours = practicalHours + amount;

  bool hasPracticalHours() => _practicalHours != null;

  // "outsideHours" field.
  int? _outsideHours;
  int get outsideHours => _outsideHours ?? 0;
  set outsideHours(int? val) => _outsideHours = val;

  void incrementOutsideHours(int amount) =>
      outsideHours = outsideHours + amount;

  bool hasOutsideHours() => _outsideHours != null;

  // "lectureSessions" field.
  int? _lectureSessions;
  int get lectureSessions => _lectureSessions ?? 0;
  set lectureSessions(int? val) => _lectureSessions = val;

  void incrementLectureSessions(int amount) =>
      lectureSessions = lectureSessions + amount;

  bool hasLectureSessions() => _lectureSessions != null;

  // "courseOutcomes" field.
  List<String>? _courseOutcomes;
  List<String> get courseOutcomes => _courseOutcomes ?? const [];
  set courseOutcomes(List<String>? val) => _courseOutcomes = val;

  void updateCourseOutcomes(Function(List<String>) updateFn) {
    updateFn(_courseOutcomes ??= []);
  }

  bool hasCourseOutcomes() => _courseOutcomes != null;

  // "modules" field.
  List<SyllabusModuleStruct>? _modules;
  List<SyllabusModuleStruct> get modules => _modules ?? const [];
  set modules(List<SyllabusModuleStruct>? val) => _modules = val;

  void updateModules(Function(List<SyllabusModuleStruct>) updateFn) {
    updateFn(_modules ??= []);
  }

  bool hasModules() => _modules != null;

  // "textbooks" field.
  List<String>? _textbooks;
  List<String> get textbooks => _textbooks ?? const [];
  set textbooks(List<String>? val) => _textbooks = val;

  void updateTextbooks(Function(List<String>) updateFn) {
    updateFn(_textbooks ??= []);
  }

  bool hasTextbooks() => _textbooks != null;

  // "references" field.
  List<String>? _references;
  List<String> get references => _references ?? const [];
  set references(List<String>? val) => _references = val;

  void updateReferences(Function(List<String>) updateFn) {
    updateFn(_references ??= []);
  }

  bool hasReferences() => _references != null;

  static CourseSyllabusStruct fromMap(Map<String, dynamic> data) =>
      CourseSyllabusStruct(
        courseCode: data['courseCode'] as String?,
        courseName: data['courseName'] as String?,
        syllabusPath: data['syllabusPath'] as String?,
        prerequisites: data['prerequisites'] as String?,
        lectureHours: castToType<int>(data['lectureHours']),
        tutorialHours: castToType<int>(data['tutorialHours']),
        practicalHours: castToType<int>(data['practicalHours']),
        outsideHours: castToType<int>(data['outsideHours']),
        lectureSessions: castToType<int>(data['lectureSessions']),
        courseOutcomes: getDataList(data['courseOutcomes']),
        modules: getStructList(
          data['modules'],
          SyllabusModuleStruct.fromMap,
        ),
        textbooks: getDataList(data['textbooks']),
        references: getDataList(data['references']),
      );

  static CourseSyllabusStruct? maybeFromMap(dynamic data) => data is Map
      ? CourseSyllabusStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'courseCode': _courseCode,
        'courseName': _courseName,
        'syllabusPath': _syllabusPath,
        'prerequisites': _prerequisites,
        'lectureHours': _lectureHours,
        'tutorialHours': _tutorialHours,
        'practicalHours': _practicalHours,
        'outsideHours': _outsideHours,
        'lectureSessions': _lectureSessions,
        'courseOutcomes': _courseOutcomes,
        'modules': _modules?.map((e) => e.toMap()).toList(),
        'textbooks': _textbooks,
        'references': _references,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'courseCode': serializeParam(
          _courseCode,
          ParamType.String,
        ),
        'courseName': serializeParam(
          _courseName,
          ParamType.String,
        ),
        'syllabusPath': serializeParam(
          _syllabusPath,
          ParamType.String,
        ),
        'prerequisites': serializeParam(
          _prerequisites,
          ParamType.String,
        ),
        'lectureHours': serializeParam(
          _lectureHours,
          ParamType.int,
        ),
        'tutorialHours': serializeParam(
          _tutorialHours,
          ParamType.int,
        ),
        'practicalHours': serializeParam(
          _practicalHours,
          ParamType.int,
        ),
        'outsideHours': serializeParam(
          _outsideHours,
          ParamType.int,
        ),
        'lectureSessions': serializeParam(
          _lectureSessions,
          ParamType.int,
        ),
        'courseOutcomes': serializeParam(
          _courseOutcomes,
          ParamType.String,
          isList: true,
        ),
        'modules': serializeParam(
          _modules,
          ParamType.DataStruct,
          isList: true,
        ),
        'textbooks': serializeParam(
          _textbooks,
          ParamType.String,
          isList: true,
        ),
        'references': serializeParam(
          _references,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static CourseSyllabusStruct fromSerializableMap(Map<String, dynamic> data) =>
      CourseSyllabusStruct(
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
        syllabusPath: deserializeParam(
          data['syllabusPath'],
          ParamType.String,
          false,
        ),
        prerequisites: deserializeParam(
          data['prerequisites'],
          ParamType.String,
          false,
        ),
        lectureHours: deserializeParam(
          data['lectureHours'],
          ParamType.int,
          false,
        ),
        tutorialHours: deserializeParam(
          data['tutorialHours'],
          ParamType.int,
          false,
        ),
        practicalHours: deserializeParam(
          data['practicalHours'],
          ParamType.int,
          false,
        ),
        outsideHours: deserializeParam(
          data['outsideHours'],
          ParamType.int,
          false,
        ),
        lectureSessions: deserializeParam(
          data['lectureSessions'],
          ParamType.int,
          false,
        ),
        courseOutcomes: deserializeParam<String>(
          data['courseOutcomes'],
          ParamType.String,
          true,
        ),
        modules: deserializeStructParam<SyllabusModuleStruct>(
          data['modules'],
          ParamType.DataStruct,
          true,
          structBuilder: SyllabusModuleStruct.fromSerializableMap,
        ),
        textbooks: deserializeParam<String>(
          data['textbooks'],
          ParamType.String,
          true,
        ),
        references: deserializeParam<String>(
          data['references'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'CourseSyllabusStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CourseSyllabusStruct &&
        courseCode == other.courseCode &&
        courseName == other.courseName &&
        syllabusPath == other.syllabusPath &&
        prerequisites == other.prerequisites &&
        lectureHours == other.lectureHours &&
        tutorialHours == other.tutorialHours &&
        practicalHours == other.practicalHours &&
        outsideHours == other.outsideHours &&
        lectureSessions == other.lectureSessions &&
        listEquality.equals(courseOutcomes, other.courseOutcomes) &&
        listEquality.equals(modules, other.modules) &&
        listEquality.equals(textbooks, other.textbooks) &&
        listEquality.equals(references, other.references);
  }

  @override
  int get hashCode => const ListEquality().hash([
        courseCode,
        courseName,
        syllabusPath,
        prerequisites,
        lectureHours,
        tutorialHours,
        practicalHours,
        outsideHours,
        lectureSessions,
        courseOutcomes,
        modules,
        textbooks,
        references
      ]);
}

CourseSyllabusStruct createCourseSyllabusStruct({
  String? courseCode,
  String? courseName,
  String? syllabusPath,
  String? prerequisites,
  int? lectureHours,
  int? tutorialHours,
  int? practicalHours,
  int? outsideHours,
  int? lectureSessions,
}) =>
    CourseSyllabusStruct(
      courseCode: courseCode,
      courseName: courseName,
      syllabusPath: syllabusPath,
      prerequisites: prerequisites,
      lectureHours: lectureHours,
      tutorialHours: tutorialHours,
      practicalHours: practicalHours,
      outsideHours: outsideHours,
      lectureSessions: lectureSessions,
    );
