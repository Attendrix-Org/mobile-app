import '../database.dart';

class ChallengeProgressClassesTable
    extends SupabaseTable<ChallengeProgressClassesRow> {
  @override
  String get tableName => 'challenge_progress_classes';

  @override
  ChallengeProgressClassesRow createRow(Map<String, dynamic> data) =>
      ChallengeProgressClassesRow(data);
}

class ChallengeProgressClassesRow extends SupabaseDataRow {
  ChallengeProgressClassesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChallengeProgressClassesTable();

  String get progressId => getField<String>('progress_id')!;
  set progressId(String value) => setField<String>('progress_id', value);

  String get classId => getField<String>('class_id')!;
  set classId(String value) => setField<String>('class_id', value);

  DateTime? get contributedAt => getField<DateTime>('contributed_at');
  set contributedAt(DateTime? value) =>
      setField<DateTime>('contributed_at', value);
}
