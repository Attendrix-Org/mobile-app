import '../database.dart';

class BatchCoursesTable extends SupabaseTable<BatchCoursesRow> {
  @override
  String get tableName => 'batch_courses';

  @override
  BatchCoursesRow createRow(Map<String, dynamic> data) => BatchCoursesRow(data);
}

class BatchCoursesRow extends SupabaseDataRow {
  BatchCoursesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BatchCoursesTable();

  String? get offeringId => getField<String>('offering_id');
  set offeringId(String? value) => setField<String>('offering_id', value);

  String get batchId => getField<String>('batch_id')!;
  set batchId(String value) => setField<String>('batch_id', value);

  String get courseCode => getField<String>('course_code')!;
  set courseCode(String value) => setField<String>('course_code', value);

  String get courseSlot => getField<String>('course_slot')!;
  set courseSlot(String value) => setField<String>('course_slot', value);

  String? get courseId => getField<String>('course_id');
  set courseId(String? value) => setField<String>('course_id', value);

  bool? get isMandatory => getField<bool>('is_mandatory');
  set isMandatory(bool? value) => setField<bool>('is_mandatory', value);

  DateTime? get addedAt => getField<DateTime>('added_at');
  set addedAt(DateTime? value) => setField<DateTime>('added_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get enrolledStudentCount => getField<int>('enrolled_student_count');
  set enrolledStudentCount(int? value) =>
      setField<int>('enrolled_student_count', value);
}
