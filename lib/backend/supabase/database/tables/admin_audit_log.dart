import '../database.dart';

class AdminAuditLogTable extends SupabaseTable<AdminAuditLogRow> {
  @override
  String get tableName => 'admin_audit_log';

  @override
  AdminAuditLogRow createRow(Map<String, dynamic> data) =>
      AdminAuditLogRow(data);
}

class AdminAuditLogRow extends SupabaseDataRow {
  AdminAuditLogRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AdminAuditLogTable();

  String? get logId => getField<String>('log_id');
  set logId(String? value) => setField<String>('log_id', value);

  String get adminId => getField<String>('admin_id')!;
  set adminId(String value) => setField<String>('admin_id', value);

  String get actionType => getField<String>('action_type')!;
  set actionType(String value) => setField<String>('action_type', value);

  String get targetTable => getField<String>('target_table')!;
  set targetTable(String value) => setField<String>('target_table', value);

  String get targetId => getField<String>('target_id')!;
  set targetId(String value) => setField<String>('target_id', value);

  dynamic get beforeState => getField<dynamic>('before_state');
  set beforeState(dynamic value) => setField<dynamic>('before_state', value);

  dynamic get afterState => getField<dynamic>('after_state');
  set afterState(dynamic value) => setField<dynamic>('after_state', value);

  String? get semesterId => getField<String>('semester_id');
  set semesterId(String? value) => setField<String>('semester_id', value);

  DateTime? get performedAt => getField<DateTime>('performed_at');
  set performedAt(DateTime? value) => setField<DateTime>('performed_at', value);
}
