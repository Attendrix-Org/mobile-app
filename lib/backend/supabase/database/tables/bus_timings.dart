import '../database.dart';

class BusTimingsTable extends SupabaseTable<BusTimingsRow> {
  @override
  String get tableName => 'bus_timings';

  @override
  BusTimingsRow createRow(Map<String, dynamic> data) => BusTimingsRow(data);
}

class BusTimingsRow extends SupabaseDataRow {
  BusTimingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BusTimingsTable();

  String? get timingId => getField<String>('timing_id');
  set timingId(String? value) => setField<String>('timing_id', value);

  String? get busId => getField<String>('bus_id');
  set busId(String? value) => setField<String>('bus_id', value);

  PostgresTime get departureTime => getField<PostgresTime>('departure_time')!;
  set departureTime(PostgresTime value) =>
      setField<PostgresTime>('departure_time', value);

  bool? get isSpecial => getField<bool>('is_special');
  set isSpecial(bool? value) => setField<bool>('is_special', value);

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
