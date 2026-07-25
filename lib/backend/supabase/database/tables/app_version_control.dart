import '../database.dart';

class AppVersionControlTable extends SupabaseTable<AppVersionControlRow> {
  @override
  String get tableName => 'app_version_control';

  @override
  AppVersionControlRow createRow(Map<String, dynamic> data) =>
      AppVersionControlRow(data);
}

class AppVersionControlRow extends SupabaseDataRow {
  AppVersionControlRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AppVersionControlTable();

  String? get versionId => getField<String>('version_id');
  set versionId(String? value) => setField<String>('version_id', value);

  String get currentVersion => getField<String>('current_version')!;
  set currentVersion(String value) =>
      setField<String>('current_version', value);

  int get buildNumber => getField<int>('build_number')!;
  set buildNumber(int value) => setField<int>('build_number', value);

  String? get versionDownloadLink => getField<String>('version_download_link');
  set versionDownloadLink(String? value) =>
      setField<String>('version_download_link', value);

  bool? get isWebAvailable => getField<bool>('is_web_available');
  set isWebAvailable(bool? value) => setField<bool>('is_web_available', value);

  bool? get forceUpdate => getField<bool>('force_update');
  set forceUpdate(bool? value) => setField<bool>('force_update', value);

  bool? get isCurrent => getField<bool>('is_current');
  set isCurrent(bool? value) => setField<bool>('is_current', value);

  String? get releaseNotes => getField<String>('release_notes');
  set releaseNotes(String? value) => setField<String>('release_notes', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
