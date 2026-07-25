import '../database.dart';

class AchievementProgressTable extends SupabaseTable<AchievementProgressRow> {
  @override
  String get tableName => 'achievement_progress';

  @override
  AchievementProgressRow createRow(Map<String, dynamic> data) =>
      AchievementProgressRow(data);
}

class AchievementProgressRow extends SupabaseDataRow {
  AchievementProgressRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AchievementProgressTable();

  String? get achievementProgressId =>
      getField<String>('achievement_progress_id');
  set achievementProgressId(String? value) =>
      setField<String>('achievement_progress_id', value);

  String get studentId => getField<String>('student_id')!;
  set studentId(String value) => setField<String>('student_id', value);

  String get achievementId => getField<String>('achievement_id')!;
  set achievementId(String value) => setField<String>('achievement_id', value);

  int? get progress => getField<int>('progress');
  set progress(int? value) => setField<int>('progress', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get claimedAt => getField<DateTime>('claimed_at');
  set claimedAt(DateTime? value) => setField<DateTime>('claimed_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
