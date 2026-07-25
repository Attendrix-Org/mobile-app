import '../database.dart';

class OauthStatesTable extends SupabaseTable<OauthStatesRow> {
  @override
  String get tableName => 'oauth_states';

  @override
  OauthStatesRow createRow(Map<String, dynamic> data) => OauthStatesRow(data);
}

class OauthStatesRow extends SupabaseDataRow {
  OauthStatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OauthStatesTable();

  String get state => getField<String>('state')!;
  set state(String value) => setField<String>('state', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get pkceVerifier => getField<String>('pkce_verifier')!;
  set pkceVerifier(String value) => setField<String>('pkce_verifier', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
