import '../database.dart';

class UserCalendarEventsTable extends SupabaseTable<UserCalendarEventsRow> {
  @override
  String get tableName => 'user_calendar_events';

  @override
  UserCalendarEventsRow createRow(Map<String, dynamic> data) =>
      UserCalendarEventsRow(data);
}

class UserCalendarEventsRow extends SupabaseDataRow {
  UserCalendarEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserCalendarEventsTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get classId => getField<String>('class_id')!;
  set classId(String value) => setField<String>('class_id', value);

  String get googleEventId => getField<String>('google_event_id')!;
  set googleEventId(String value) => setField<String>('google_event_id', value);

  String? get syncState => getField<String>('sync_state');
  set syncState(String? value) => setField<String>('sync_state', value);

  DateTime? get syncedAt => getField<DateTime>('synced_at');
  set syncedAt(DateTime? value) => setField<DateTime>('synced_at', value);
}
