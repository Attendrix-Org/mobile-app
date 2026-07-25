import '../database.dart';

class CoursesTable extends SupabaseTable<CoursesRow> {
  @override
  String get tableName => 'courses';

  @override
  CoursesRow createRow(Map<String, dynamic> data) => CoursesRow(data);
}

class CoursesRow extends SupabaseDataRow {
  CoursesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CoursesTable();

  String get courseCode => getField<String>('course_code')!;
  set courseCode(String value) => setField<String>('course_code', value);

  String get courseName => getField<String>('course_name')!;
  set courseName(String value) => setField<String>('course_name', value);

  String get courseTypeCode => getField<String>('course_type_code')!;
  set courseTypeCode(String value) =>
      setField<String>('course_type_code', value);

  bool? get isLab => getField<bool>('is_lab');
  set isLab(bool? value) => setField<bool>('is_lab', value);

  int get credits => getField<int>('credits')!;
  set credits(int value) => setField<int>('credits', value);

  String get departmentId => getField<String>('department_id')!;
  set departmentId(String value) => setField<String>('department_id', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get syllabusUrl => getField<String>('syllabus_url');
  set syllabusUrl(String? value) => setField<String>('syllabus_url', value);
}
