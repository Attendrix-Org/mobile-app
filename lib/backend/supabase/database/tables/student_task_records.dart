import '../database.dart';

class StudentTaskRecordsTable extends SupabaseTable<StudentTaskRecordsRow> {
  @override
  String get tableName => 'student_task_records';

  @override
  StudentTaskRecordsRow createRow(Map<String, dynamic> data) =>
      StudentTaskRecordsRow(data);
}

class StudentTaskRecordsRow extends SupabaseDataRow {
  StudentTaskRecordsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StudentTaskRecordsTable();

  String? get recordId => getField<String>('record_id');
  set recordId(String? value) => setField<String>('record_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get taskId => getField<String>('task_id')!;
  set taskId(String value) => setField<String>('task_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  double? get obtainedMarks => getField<double>('obtained_marks');
  set obtainedMarks(double? value) => setField<double>('obtained_marks', value);

  String? get personalNote => getField<String>('personal_note');
  set personalNote(String? value) => setField<String>('personal_note', value);

  DateTime? get markedAt => getField<DateTime>('marked_at');
  set markedAt(DateTime? value) => setField<DateTime>('marked_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
