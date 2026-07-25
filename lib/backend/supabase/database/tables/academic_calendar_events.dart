import '../database.dart';

class AcademicCalendarEventsTable
    extends SupabaseTable<AcademicCalendarEventsRow> {
  @override
  String get tableName => 'academic_calendar_events';

  @override
  AcademicCalendarEventsRow createRow(Map<String, dynamic> data) =>
      AcademicCalendarEventsRow(data);
}

class AcademicCalendarEventsRow extends SupabaseDataRow {
  AcademicCalendarEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AcademicCalendarEventsTable();

  String? get eventId => getField<String>('event_id');
  set eventId(String? value) => setField<String>('event_id', value);

  String get semesterId => getField<String>('semester_id')!;
  set semesterId(String value) => setField<String>('semester_id', value);

  String get eventName => getField<String>('event_name')!;
  set eventName(String value) => setField<String>('event_name', value);

  DateTime get startDate => getField<DateTime>('start_date')!;
  set startDate(DateTime value) => setField<DateTime>('start_date', value);

  DateTime get endDate => getField<DateTime>('end_date')!;
  set endDate(DateTime value) => setField<DateTime>('end_date', value);

  String get eventType => getField<String>('event_type')!;
  set eventType(String value) => setField<String>('event_type', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get followsDay => getField<int>('follows_day');
  set followsDay(int? value) => setField<int>('follows_day', value);

  String? get formattedDate => getField<String>('formatted_date');
  set formattedDate(String? value) => setField<String>('formatted_date', value);
}
