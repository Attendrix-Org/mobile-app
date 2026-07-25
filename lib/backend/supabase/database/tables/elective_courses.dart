import '../database.dart';

class ElectiveCoursesTable extends SupabaseTable<ElectiveCoursesRow> {
  @override
  String get tableName => 'elective_courses';

  @override
  ElectiveCoursesRow createRow(Map<String, dynamic> data) =>
      ElectiveCoursesRow(data);
}

class ElectiveCoursesRow extends SupabaseDataRow {
  ElectiveCoursesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ElectiveCoursesTable();

  String? get offeringId => getField<String>('offering_id');
  set offeringId(String? value) => setField<String>('offering_id', value);

  String? get courseId => getField<String>('course_id');
  set courseId(String? value) => setField<String>('course_id', value);

  String get courseCode => getField<String>('course_code')!;
  set courseCode(String value) => setField<String>('course_code', value);

  String get departmentId => getField<String>('department_id')!;
  set departmentId(String value) => setField<String>('department_id', value);

  String get slotName => getField<String>('slot_name')!;
  set slotName(String value) => setField<String>('slot_name', value);

  int? get slotSystem => getField<int>('slot_system');
  set slotSystem(int? value) => setField<int>('slot_system', value);

  String? get venue => getField<String>('venue');
  set venue(String? value) => setField<String>('venue', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get enrolledStudentCount => getField<int>('enrolled_student_count');
  set enrolledStudentCount(int? value) =>
      setField<int>('enrolled_student_count', value);
}
