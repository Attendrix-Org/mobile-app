import '../database.dart';

class ChallengeTemplatesTable extends SupabaseTable<ChallengeTemplatesRow> {
  @override
  String get tableName => 'challenge_templates';

  @override
  ChallengeTemplatesRow createRow(Map<String, dynamic> data) =>
      ChallengeTemplatesRow(data);
}

class ChallengeTemplatesRow extends SupabaseDataRow {
  ChallengeTemplatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChallengeTemplatesTable();

  String get challengeId => getField<String>('challenge_id')!;
  set challengeId(String value) => setField<String>('challenge_id', value);

  String get challengeName => getField<String>('challenge_name')!;
  set challengeName(String value) => setField<String>('challenge_name', value);

  String get challengeDescription => getField<String>('challenge_description')!;
  set challengeDescription(String value) =>
      setField<String>('challenge_description', value);

  String get challengeType => getField<String>('challenge_type')!;
  set challengeType(String value) => setField<String>('challenge_type', value);

  String get challengeCondition => getField<String>('challenge_condition')!;
  set challengeCondition(String value) =>
      setField<String>('challenge_condition', value);

  dynamic get conditionParams => getField<dynamic>('condition_params');
  set conditionParams(dynamic value) =>
      setField<dynamic>('condition_params', value);

  int get targetValue => getField<int>('target_value')!;
  set targetValue(int value) => setField<int>('target_value', value);

  int? get amplixReward => getField<int>('amplix_reward');
  set amplixReward(int? value) => setField<int>('amplix_reward', value);

  int? get weeklyWeight => getField<int>('weekly_weight');
  set weeklyWeight(int? value) => setField<int>('weekly_weight', value);

  int? get monthlyWeight => getField<int>('monthly_weight');
  set monthlyWeight(int? value) => setField<int>('monthly_weight', value);

  int? get templateVersion => getField<int>('template_version');
  set templateVersion(int? value) => setField<int>('template_version', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
