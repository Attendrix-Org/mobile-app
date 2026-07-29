import '../database.dart';

class CampusBuildingsTable extends SupabaseTable<CampusBuildingsRow> {
  @override
  String get tableName => 'campus_buildings';

  @override
  CampusBuildingsRow createRow(Map<String, dynamic> data) =>
      CampusBuildingsRow(data);
}

class CampusBuildingsRow extends SupabaseDataRow {
  CampusBuildingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CampusBuildingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  double get lat => getField<double>('lat')!;
  set lat(double value) => setField<double>('lat', value);

  double get lng => getField<double>('lng')!;
  set lng(double value) => setField<double>('lng', value);

  String get nearestNodeId => getField<String>('nearest_node_id')!;
  set nearestNodeId(String value) => setField<String>('nearest_node_id', value);

  double? get snapDistM => getField<double>('snap_dist_m');
  set snapDistM(double? value) => setField<double>('snap_dist_m', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
