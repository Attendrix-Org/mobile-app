import '../database.dart';

class AuditLogTable extends SupabaseTable<AuditLogRow> {
  @override
  String get tableName => 'audit_log';

  @override
  AuditLogRow createRow(Map<String, dynamic> data) => AuditLogRow(data);
}

class AuditLogRow extends SupabaseDataRow {
  AuditLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AuditLogTable();

  int get auditId => getField<int>('audit_id')!;
  set auditId(int value) => setField<int>('audit_id', value);

  String get tableNameField => getField<String>('table_name')!;
  set tableNameField(String value) => setField<String>('table_name', value);

  String get operation => getField<String>('operation')!;
  set operation(String value) => setField<String>('operation', value);

  String? get actorId => getField<String>('actor_id');
  set actorId(String? value) => setField<String>('actor_id', value);

  String? get rowPk => getField<String>('row_pk');
  set rowPk(String? value) => setField<String>('row_pk', value);

  dynamic get oldData => getField<dynamic>('old_data');
  set oldData(dynamic value) => setField<dynamic>('old_data', value);

  dynamic get newData => getField<dynamic>('new_data');
  set newData(dynamic value) => setField<dynamic>('new_data', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
