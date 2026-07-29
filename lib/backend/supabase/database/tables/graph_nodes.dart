import '../database.dart';

class GraphNodesTable extends SupabaseTable<GraphNodesRow> {
  @override
  String get tableName => 'graph_nodes';

  @override
  GraphNodesRow createRow(Map<String, dynamic> data) => GraphNodesRow(data);
}

class GraphNodesRow extends SupabaseDataRow {
  GraphNodesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => GraphNodesTable();

  String get nodeId => getField<String>('node_id')!;
  set nodeId(String value) => setField<String>('node_id', value);

  double get lat => getField<double>('lat')!;
  set lat(double value) => setField<double>('lat', value);

  double get lng => getField<double>('lng')!;
  set lng(double value) => setField<double>('lng', value);
}
