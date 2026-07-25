import '../database.dart';

class AchievementTemplatesTable extends SupabaseTable<AchievementTemplatesRow> {
  @override
  String get tableName => 'achievement_templates';

  @override
  AchievementTemplatesRow createRow(Map<String, dynamic> data) =>
      AchievementTemplatesRow(data);
}

class AchievementTemplatesRow extends SupabaseDataRow {
  AchievementTemplatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AchievementTemplatesTable();

  String get achievementId => getField<String>('achievement_id')!;
  set achievementId(String value) => setField<String>('achievement_id', value);

  String get achievementName => getField<String>('achievement_name')!;
  set achievementName(String value) =>
      setField<String>('achievement_name', value);

  String get achievementDescription =>
      getField<String>('achievement_description')!;
  set achievementDescription(String value) =>
      setField<String>('achievement_description', value);

  String? get badgeIcon => getField<String>('badge_icon');
  set badgeIcon(String? value) => setField<String>('badge_icon', value);

  String get achievementCondition => getField<String>('achievement_condition')!;
  set achievementCondition(String value) =>
      setField<String>('achievement_condition', value);

  int get thresholdValue => getField<int>('threshold_value')!;
  set thresholdValue(int value) => setField<int>('threshold_value', value);

  int? get amplixReward => getField<int>('amplix_reward');
  set amplixReward(int? value) => setField<int>('amplix_reward', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
