import '../database.dart';

class AmplixLedgerTable extends SupabaseTable<AmplixLedgerRow> {
  @override
  String get tableName => 'amplix_ledger';

  @override
  AmplixLedgerRow createRow(Map<String, dynamic> data) => AmplixLedgerRow(data);
}

class AmplixLedgerRow extends SupabaseDataRow {
  AmplixLedgerRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AmplixLedgerTable();

  String? get ledgerId => getField<String>('ledger_id');
  set ledgerId(String? value) => setField<String>('ledger_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get eventType => getField<String>('event_type')!;
  set eventType(String value) => setField<String>('event_type', value);

  int get points => getField<int>('points')!;
  set points(int value) => setField<int>('points', value);

  int get balanceAfter => getField<int>('balance_after')!;
  set balanceAfter(int value) => setField<int>('balance_after', value);

  String? get classId => getField<String>('class_id');
  set classId(String? value) => setField<String>('class_id', value);

  DateTime get eventDate => getField<DateTime>('event_date')!;
  set eventDate(DateTime value) => setField<DateTime>('event_date', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get achievementProgressId =>
      getField<String>('achievement_progress_id');
  set achievementProgressId(String? value) =>
      setField<String>('achievement_progress_id', value);

  String? get challengeProgressId => getField<String>('challenge_progress_id');
  set challengeProgressId(String? value) =>
      setField<String>('challenge_progress_id', value);
}
