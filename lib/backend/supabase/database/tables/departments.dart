import '../database.dart';

class DepartmentsTable extends SupabaseTable<DepartmentsRow> {
  @override
  String get tableName => 'departments';

  @override
  DepartmentsRow createRow(Map<String, dynamic> data) => DepartmentsRow(data);
}

class DepartmentsRow extends SupabaseDataRow {
  DepartmentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DepartmentsTable();

  String get departmentId => getField<String>('department_id')!;
  set departmentId(String value) => setField<String>('department_id', value);

  String get departmentName => getField<String>('department_name')!;
  set departmentName(String value) =>
      setField<String>('department_name', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
