import '../database.dart';

class TasksTable extends SupabaseTable<TasksRow> {
  @override
  String get tableName => 'tasks';

  @override
  TasksRow createRow(Map<String, dynamic> data) => TasksRow(data);
}

class TasksRow extends SupabaseDataRow {
  TasksRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TasksTable();

  String? get taskId => getField<String>('task_id');
  set taskId(String? value) => setField<String>('task_id', value);

  String get semesterId => getField<String>('semester_id')!;
  set semesterId(String value) => setField<String>('semester_id', value);

  String? get batchId => getField<String>('batch_id');
  set batchId(String? value) => setField<String>('batch_id', value);

  String get taskType => getField<String>('task_type')!;
  set taskType(String value) => setField<String>('task_type', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get dueDate => getField<DateTime>('due_date');
  set dueDate(DateTime? value) => setField<DateTime>('due_date', value);

  DateTime? get examStart => getField<DateTime>('exam_start');
  set examStart(DateTime? value) => setField<DateTime>('exam_start', value);

  DateTime? get examEnd => getField<DateTime>('exam_end');
  set examEnd(DateTime? value) => setField<DateTime>('exam_end', value);

  String? get venue => getField<String>('venue');
  set venue(String? value) => setField<String>('venue', value);

  double? get maxScore => getField<double>('max_score');
  set maxScore(double? value) => setField<double>('max_score', value);

  dynamic get attachments => getField<dynamic>('attachments');
  set attachments(dynamic value) => setField<dynamic>('attachments', value);

  bool? get isVisible => getField<bool>('is_visible');
  set isVisible(bool? value) => setField<bool>('is_visible', value);

  String get createdBy => getField<String>('created_by')!;
  set createdBy(String value) => setField<String>('created_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get courseCode => getField<String>('course_code')!;
  set courseCode(String value) => setField<String>('course_code', value);
}
