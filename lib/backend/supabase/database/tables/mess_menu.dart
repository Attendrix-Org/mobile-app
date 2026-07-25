import '../database.dart';

class MessMenuTable extends SupabaseTable<MessMenuRow> {
  @override
  String get tableName => 'mess_menu';

  @override
  MessMenuRow createRow(Map<String, dynamic> data) => MessMenuRow(data);
}

class MessMenuRow extends SupabaseDataRow {
  MessMenuRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MessMenuTable();

  String? get menuId => getField<String>('menu_id');
  set menuId(String? value) => setField<String>('menu_id', value);

  String? get messId => getField<String>('mess_id');
  set messId(String? value) => setField<String>('mess_id', value);

  int get weekday => getField<int>('weekday')!;
  set weekday(int value) => setField<int>('weekday', value);

  String get meal => getField<String>('meal')!;
  set meal(String value) => setField<String>('meal', value);

  String get menu => getField<String>('menu')!;
  set menu(String value) => setField<String>('menu', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
