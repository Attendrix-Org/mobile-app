import '../database.dart';

class SlotOccurrencesTable extends SupabaseTable<SlotOccurrencesRow> {
  @override
  String get tableName => 'slot_occurrences';

  @override
  SlotOccurrencesRow createRow(Map<String, dynamic> data) =>
      SlotOccurrencesRow(data);
}

class SlotOccurrencesRow extends SupabaseDataRow {
  SlotOccurrencesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SlotOccurrencesTable();

  String get slotName => getField<String>('slot_name')!;
  set slotName(String value) => setField<String>('slot_name', value);

  int get slotSystem => getField<int>('slot_system')!;
  set slotSystem(int value) => setField<int>('slot_system', value);

  int get dayOfWeek => getField<int>('day_of_week')!;
  set dayOfWeek(int value) => setField<int>('day_of_week', value);

  int get periodNumber => getField<int>('period_number')!;
  set periodNumber(int value) => setField<int>('period_number', value);

  PostgresTime get startTime => getField<PostgresTime>('start_time')!;
  set startTime(PostgresTime value) =>
      setField<PostgresTime>('start_time', value);

  PostgresTime get endTime => getField<PostgresTime>('end_time')!;
  set endTime(PostgresTime value) => setField<PostgresTime>('end_time', value);

  bool? get isPlusSlot => getField<bool>('is_plus_slot');
  set isPlusSlot(bool? value) => setField<bool>('is_plus_slot', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
