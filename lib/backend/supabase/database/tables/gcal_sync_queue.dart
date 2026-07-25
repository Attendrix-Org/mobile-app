import '../database.dart';

class GcalSyncQueueTable extends SupabaseTable<GcalSyncQueueRow> {
  @override
  String get tableName => 'gcal_sync_queue';

  @override
  GcalSyncQueueRow createRow(Map<String, dynamic> data) =>
      GcalSyncQueueRow(data);
}

class GcalSyncQueueRow extends SupabaseDataRow {
  GcalSyncQueueRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GcalSyncQueueTable();

  int get jobId => getField<int>('job_id')!;
  set jobId(int value) => setField<int>('job_id', value);

  String get jobType => getField<String>('job_type')!;
  set jobType(String value) => setField<String>('job_type', value);

  dynamic get payload => getField<dynamic>('payload')!;
  set payload(dynamic value) => setField<dynamic>('payload', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get attempts => getField<int>('attempts');
  set attempts(int? value) => setField<int>('attempts', value);

  int? get maxAttempts => getField<int>('max_attempts');
  set maxAttempts(int? value) => setField<int>('max_attempts', value);

  DateTime? get nextRunAt => getField<DateTime>('next_run_at');
  set nextRunAt(DateTime? value) => setField<DateTime>('next_run_at', value);

  DateTime? get processingStartedAt =>
      getField<DateTime>('processing_started_at');
  set processingStartedAt(DateTime? value) =>
      setField<DateTime>('processing_started_at', value);

  String? get workerId => getField<String>('worker_id');
  set workerId(String? value) => setField<String>('worker_id', value);

  String? get lastError => getField<String>('last_error');
  set lastError(String? value) => setField<String>('last_error', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);
}
