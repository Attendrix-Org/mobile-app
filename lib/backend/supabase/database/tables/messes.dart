import '../database.dart';

class MessesTable extends SupabaseTable<MessesRow> {
  @override
  String get tableName => 'messes';

  @override
  MessesRow createRow(Map<String, dynamic> data) => MessesRow(data);
}

class MessesRow extends SupabaseDataRow {
  MessesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MessesTable();

  String? get messId => getField<String>('mess_id');
  set messId(String? value) => setField<String>('mess_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
