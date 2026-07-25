import '../database.dart';

class PgStatStatementsInfoTable extends SupabaseTable<PgStatStatementsInfoRow> {
  @override
  String get tableName => 'pg_stat_statements_info';

  @override
  PgStatStatementsInfoRow createRow(Map<String, dynamic> data) =>
      PgStatStatementsInfoRow(data);
}

class PgStatStatementsInfoRow extends SupabaseDataRow {
  PgStatStatementsInfoRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PgStatStatementsInfoTable();

  int? get dealloc => getField<int>('dealloc');
  set dealloc(int? value) => setField<int>('dealloc', value);

  DateTime? get statsReset => getField<DateTime>('stats_reset');
  set statsReset(DateTime? value) => setField<DateTime>('stats_reset', value);
}
