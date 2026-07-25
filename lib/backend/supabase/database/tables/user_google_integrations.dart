import '../database.dart';

class UserGoogleIntegrationsTable
    extends SupabaseTable<UserGoogleIntegrationsRow> {
  @override
  String get tableName => 'user_google_integrations';

  @override
  UserGoogleIntegrationsRow createRow(Map<String, dynamic> data) =>
      UserGoogleIntegrationsRow(data);
}

class UserGoogleIntegrationsRow extends SupabaseDataRow {
  UserGoogleIntegrationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserGoogleIntegrationsTable();

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get googleEmail => getField<String>('google_email')!;
  set googleEmail(String value) => setField<String>('google_email', value);

  String? get calendarId => getField<String>('calendar_id');
  set calendarId(String? value) => setField<String>('calendar_id', value);

  String? get calendarColorId => getField<String>('calendar_color_id');
  set calendarColorId(String? value) =>
      setField<String>('calendar_color_id', value);

  bool? get isSyncEnabled => getField<bool>('is_sync_enabled');
  set isSyncEnabled(bool? value) => setField<bool>('is_sync_enabled', value);

  String get vaultSecretId => getField<String>('vault_secret_id')!;
  set vaultSecretId(String value) => setField<String>('vault_secret_id', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);

  DateTime? get lastSyncedAt => getField<DateTime>('last_synced_at');
  set lastSyncedAt(DateTime? value) =>
      setField<DateTime>('last_synced_at', value);

  String? get lastError => getField<String>('last_error');
  set lastError(String? value) => setField<String>('last_error', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
