import '../database.dart';

class BusesTable extends SupabaseTable<BusesRow> {
  @override
  String get tableName => 'buses';

  @override
  BusesRow createRow(Map<String, dynamic> data) => BusesRow(data);
}

class BusesRow extends SupabaseDataRow {
  BusesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BusesTable();

  String? get busId => getField<String>('bus_id');
  set busId(String? value) => setField<String>('bus_id', value);

  String get routeName => getField<String>('route_name')!;
  set routeName(String value) => setField<String>('route_name', value);

  String get stopsSummary => getField<String>('stops_summary')!;
  set stopsSummary(String value) => setField<String>('stops_summary', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
