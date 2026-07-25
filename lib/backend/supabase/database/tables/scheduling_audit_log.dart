import '../database.dart';

class SchedulingAuditLogTable extends SupabaseTable<SchedulingAuditLogRow> {
  @override
  String get tableName => 'scheduling_audit_log';

  @override
  SchedulingAuditLogRow createRow(Map<String, dynamic> data) =>
      SchedulingAuditLogRow(data);
}

class SchedulingAuditLogRow extends SupabaseDataRow {
  SchedulingAuditLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SchedulingAuditLogTable();

  String? get logId => getField<String>('log_id');
  set logId(String? value) => setField<String>('log_id', value);

  String get runId => getField<String>('run_id')!;
  set runId(String value) => setField<String>('run_id', value);

  String? get semesterId => getField<String>('semester_id');
  set semesterId(String? value) => setField<String>('semester_id', value);

  String? get batchId => getField<String>('batch_id');
  set batchId(String? value) => setField<String>('batch_id', value);

  DateTime? get executionTime => getField<DateTime>('execution_time');
  set executionTime(DateTime? value) =>
      setField<DateTime>('execution_time', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  String? get classId => getField<String>('class_id');
  set classId(String? value) => setField<String>('class_id', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  dynamic get details => getField<dynamic>('details');
  set details(dynamic value) => setField<dynamic>('details', value);

  String get courseCode => getField<String>('course_code')!;
  set courseCode(String value) => setField<String>('course_code', value);
}
