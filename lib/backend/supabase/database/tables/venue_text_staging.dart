import '../database.dart';

class VenueTextStagingTable extends SupabaseTable<VenueTextStagingRow> {
  @override
  String get tableName => 'venue_text_staging';

  @override
  VenueTextStagingRow createRow(Map<String, dynamic> data) =>
      VenueTextStagingRow(data);
}

class VenueTextStagingRow extends SupabaseDataRow {
  VenueTextStagingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VenueTextStagingTable();

  String get venueText => getField<String>('venue_text')!;
  set venueText(String value) => setField<String>('venue_text', value);

  String? get matchedBuildingId => getField<String>('matched_building_id');
  set matchedBuildingId(String? value) =>
      setField<String>('matched_building_id', value);

  String? get matchedBuildingName => getField<String>('matched_building_name');
  set matchedBuildingName(String? value) =>
      setField<String>('matched_building_name', value);

  double? get score => getField<double>('score');
  set score(double? value) => setField<double>('score', value);

  bool? get confirmed => getField<bool>('confirmed');
  set confirmed(bool? value) => setField<bool>('confirmed', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
