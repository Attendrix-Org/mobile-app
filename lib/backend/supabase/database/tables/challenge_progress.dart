import '../database.dart';

class ChallengeProgressTable extends SupabaseTable<ChallengeProgressRow> {
  @override
  String get tableName => 'challenge_progress';

  @override
  ChallengeProgressRow createRow(Map<String, dynamic> data) =>
      ChallengeProgressRow(data);
}

class ChallengeProgressRow extends SupabaseDataRow {
  ChallengeProgressRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChallengeProgressTable();

  String? get progressId => getField<String>('progress_id');
  set progressId(String? value) => setField<String>('progress_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get challengeId => getField<String>('challenge_id')!;
  set challengeId(String value) => setField<String>('challenge_id', value);

  String get semesterId => getField<String>('semester_id')!;
  set semesterId(String value) => setField<String>('semester_id', value);

  String get periodKey => getField<String>('period_key')!;
  set periodKey(String value) => setField<String>('period_key', value);

  int get templateVersion => getField<int>('template_version')!;
  set templateVersion(int value) => setField<int>('template_version', value);

  int? get progress => getField<int>('progress');
  set progress(int? value) => setField<int>('progress', value);

  int get targetValue => getField<int>('target_value')!;
  set targetValue(int value) => setField<int>('target_value', value);

  int get amplixReward => getField<int>('amplix_reward')!;
  set amplixReward(int value) => setField<int>('amplix_reward', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  DateTime? get claimedAt => getField<DateTime>('claimed_at');
  set claimedAt(DateTime? value) => setField<DateTime>('claimed_at', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
