import '../database.dart';

class CourseSyllabiTable extends SupabaseTable<CourseSyllabiRow> {
  @override
  String get tableName => 'course_syllabi';

  @override
  CourseSyllabiRow createRow(Map<String, dynamic> data) =>
      CourseSyllabiRow(data);
}

class CourseSyllabiRow extends SupabaseDataRow {
  CourseSyllabiRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CourseSyllabiTable();

  String? get syllabusId => getField<String>('syllabus_id');
  set syllabusId(String? value) => setField<String>('syllabus_id', value);

  String get courseCode => getField<String>('course_code')!;
  set courseCode(String value) => setField<String>('course_code', value);

  String get syllabusPath => getField<String>('syllabus_path')!;
  set syllabusPath(String value) => setField<String>('syllabus_path', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get prerequisites => getField<String>('prerequisites');
  set prerequisites(String? value) => setField<String>('prerequisites', value);

  int? get lectureHours => getField<int>('lecture_hours');
  set lectureHours(int? value) => setField<int>('lecture_hours', value);

  int? get tutorialHours => getField<int>('tutorial_hours');
  set tutorialHours(int? value) => setField<int>('tutorial_hours', value);

  int? get practicalHours => getField<int>('practical_hours');
  set practicalHours(int? value) => setField<int>('practical_hours', value);

  int? get outsideHours => getField<int>('outside_hours');
  set outsideHours(int? value) => setField<int>('outside_hours', value);

  int? get lectureSessions => getField<int>('lecture_sessions');
  set lectureSessions(int? value) => setField<int>('lecture_sessions', value);

  List<String> get courseOutcomes => getListField<String>('course_outcomes');
  set courseOutcomes(List<String>? value) =>
      setListField<String>('course_outcomes', value);

  dynamic get modules => getField<dynamic>('modules');
  set modules(dynamic value) => setField<dynamic>('modules', value);

  List<String> get textbooks => getListField<String>('textbooks');
  set textbooks(List<String>? value) =>
      setListField<String>('textbooks', value);

  List<String> get referenceList => getListField<String>('reference_list');
  set referenceList(List<String>? value) =>
      setListField<String>('reference_list', value);

  String? get rawMarkdown => getField<String>('raw_markdown');
  set rawMarkdown(String? value) => setField<String>('raw_markdown', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get courseName => getField<String>('course_name')!;
  set courseName(String value) => setField<String>('course_name', value);
}
