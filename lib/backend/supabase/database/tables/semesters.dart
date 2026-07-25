import '../database.dart';

class SemestersTable extends SupabaseTable<SemestersRow> {
  @override
  String get tableName => 'semesters';

  @override
  SemestersRow createRow(Map<String, dynamic> data) => SemestersRow(data);
}

class SemestersRow extends SupabaseDataRow {
  SemestersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SemestersTable();

  String? get semesterId => getField<String>('semester_id');
  set semesterId(String? value) => setField<String>('semester_id', value);

  String get semesterName => getField<String>('semester_name')!;
  set semesterName(String value) => setField<String>('semester_name', value);

  DateTime get startDate => getField<DateTime>('start_date')!;
  set startDate(DateTime value) => setField<DateTime>('start_date', value);

  DateTime get endDate => getField<DateTime>('end_date')!;
  set endDate(DateTime value) => setField<DateTime>('end_date', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get lockedAt => getField<DateTime>('locked_at');
  set lockedAt(DateTime? value) => setField<DateTime>('locked_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get semesterNumber => getField<int>('semester_number');
  set semesterNumber(int? value) => setField<int>('semester_number', value);

  int? get semesterSlotSystem => getField<int>('semester_slot_system');
  set semesterSlotSystem(int? value) =>
      setField<int>('semester_slot_system', value);
}
