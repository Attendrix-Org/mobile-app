import '../database.dart';

class BatchesTable extends SupabaseTable<BatchesRow> {
  @override
  String get tableName => 'batches';

  @override
  BatchesRow createRow(Map<String, dynamic> data) => BatchesRow(data);
}

class BatchesRow extends SupabaseDataRow {
  BatchesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BatchesTable();

  String get batchId => getField<String>('batch_id')!;
  set batchId(String value) => setField<String>('batch_id', value);

  String get departmentId => getField<String>('department_id')!;
  set departmentId(String value) => setField<String>('department_id', value);

  int get batchNumber => getField<int>('batch_number')!;
  set batchNumber(int value) => setField<int>('batch_number', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get semesterId => getField<String>('semester_id');
  set semesterId(String? value) => setField<String>('semester_id', value);

  String get departmentName => getField<String>('department_name')!;
  set departmentName(String value) =>
      setField<String>('department_name', value);

  int get semesterNumber => getField<int>('semester_number')!;
  set semesterNumber(int value) => setField<int>('semester_number', value);
}
