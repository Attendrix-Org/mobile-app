import '../database.dart';

class RouteCacheTable extends SupabaseTable<RouteCacheRow> {
  @override
  String get tableName => 'route_cache';

  @override
  RouteCacheRow createRow(Map<String, dynamic> data) => RouteCacheRow(data);
}

class RouteCacheRow extends SupabaseDataRow {
  RouteCacheRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RouteCacheTable();

  String get originBuildingId => getField<String>('origin_building_id')!;
  set originBuildingId(String value) =>
      setField<String>('origin_building_id', value);

  String get destinationBuildingId =>
      getField<String>('destination_building_id')!;
  set destinationBuildingId(String value) =>
      setField<String>('destination_building_id', value);

  double get distanceMeters => getField<double>('distance_meters')!;
  set distanceMeters(double value) =>
      setField<double>('distance_meters', value);

  int get durationSeconds => getField<int>('duration_seconds')!;
  set durationSeconds(int value) => setField<int>('duration_seconds', value);

  String get confidence => getField<String>('confidence')!;
  set confidence(String value) => setField<String>('confidence', value);

  DateTime? get computedAt => getField<DateTime>('computed_at');
  set computedAt(DateTime? value) => setField<DateTime>('computed_at', value);
}
