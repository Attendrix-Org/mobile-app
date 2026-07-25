import '../database.dart';

class PgStatStatementsTable extends SupabaseTable<PgStatStatementsRow> {
  @override
  String get tableName => 'pg_stat_statements';

  @override
  PgStatStatementsRow createRow(Map<String, dynamic> data) =>
      PgStatStatementsRow(data);
}

class PgStatStatementsRow extends SupabaseDataRow {
  PgStatStatementsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PgStatStatementsTable();

  String? get userid => getField<String>('userid');
  set userid(String? value) => setField<String>('userid', value);

  String? get dbid => getField<String>('dbid');
  set dbid(String? value) => setField<String>('dbid', value);

  bool? get toplevel => getField<bool>('toplevel');
  set toplevel(bool? value) => setField<bool>('toplevel', value);

  int? get queryid => getField<int>('queryid');
  set queryid(int? value) => setField<int>('queryid', value);

  String? get query => getField<String>('query');
  set query(String? value) => setField<String>('query', value);

  int? get plans => getField<int>('plans');
  set plans(int? value) => setField<int>('plans', value);

  double? get totalPlanTime => getField<double>('total_plan_time');
  set totalPlanTime(double? value) =>
      setField<double>('total_plan_time', value);

  double? get minPlanTime => getField<double>('min_plan_time');
  set minPlanTime(double? value) => setField<double>('min_plan_time', value);

  double? get maxPlanTime => getField<double>('max_plan_time');
  set maxPlanTime(double? value) => setField<double>('max_plan_time', value);

  double? get meanPlanTime => getField<double>('mean_plan_time');
  set meanPlanTime(double? value) => setField<double>('mean_plan_time', value);

  double? get stddevPlanTime => getField<double>('stddev_plan_time');
  set stddevPlanTime(double? value) =>
      setField<double>('stddev_plan_time', value);

  int? get calls => getField<int>('calls');
  set calls(int? value) => setField<int>('calls', value);

  double? get totalExecTime => getField<double>('total_exec_time');
  set totalExecTime(double? value) =>
      setField<double>('total_exec_time', value);

  double? get minExecTime => getField<double>('min_exec_time');
  set minExecTime(double? value) => setField<double>('min_exec_time', value);

  double? get maxExecTime => getField<double>('max_exec_time');
  set maxExecTime(double? value) => setField<double>('max_exec_time', value);

  double? get meanExecTime => getField<double>('mean_exec_time');
  set meanExecTime(double? value) => setField<double>('mean_exec_time', value);

  double? get stddevExecTime => getField<double>('stddev_exec_time');
  set stddevExecTime(double? value) =>
      setField<double>('stddev_exec_time', value);

  int? get rows => getField<int>('rows');
  set rows(int? value) => setField<int>('rows', value);

  int? get sharedBlksHit => getField<int>('shared_blks_hit');
  set sharedBlksHit(int? value) => setField<int>('shared_blks_hit', value);

  int? get sharedBlksRead => getField<int>('shared_blks_read');
  set sharedBlksRead(int? value) => setField<int>('shared_blks_read', value);

  int? get sharedBlksDirtied => getField<int>('shared_blks_dirtied');
  set sharedBlksDirtied(int? value) =>
      setField<int>('shared_blks_dirtied', value);

  int? get sharedBlksWritten => getField<int>('shared_blks_written');
  set sharedBlksWritten(int? value) =>
      setField<int>('shared_blks_written', value);

  int? get localBlksHit => getField<int>('local_blks_hit');
  set localBlksHit(int? value) => setField<int>('local_blks_hit', value);

  int? get localBlksRead => getField<int>('local_blks_read');
  set localBlksRead(int? value) => setField<int>('local_blks_read', value);

  int? get localBlksDirtied => getField<int>('local_blks_dirtied');
  set localBlksDirtied(int? value) =>
      setField<int>('local_blks_dirtied', value);

  int? get localBlksWritten => getField<int>('local_blks_written');
  set localBlksWritten(int? value) =>
      setField<int>('local_blks_written', value);

  int? get tempBlksRead => getField<int>('temp_blks_read');
  set tempBlksRead(int? value) => setField<int>('temp_blks_read', value);

  int? get tempBlksWritten => getField<int>('temp_blks_written');
  set tempBlksWritten(int? value) => setField<int>('temp_blks_written', value);

  double? get sharedBlkReadTime => getField<double>('shared_blk_read_time');
  set sharedBlkReadTime(double? value) =>
      setField<double>('shared_blk_read_time', value);

  double? get sharedBlkWriteTime => getField<double>('shared_blk_write_time');
  set sharedBlkWriteTime(double? value) =>
      setField<double>('shared_blk_write_time', value);

  double? get localBlkReadTime => getField<double>('local_blk_read_time');
  set localBlkReadTime(double? value) =>
      setField<double>('local_blk_read_time', value);

  double? get localBlkWriteTime => getField<double>('local_blk_write_time');
  set localBlkWriteTime(double? value) =>
      setField<double>('local_blk_write_time', value);

  double? get tempBlkReadTime => getField<double>('temp_blk_read_time');
  set tempBlkReadTime(double? value) =>
      setField<double>('temp_blk_read_time', value);

  double? get tempBlkWriteTime => getField<double>('temp_blk_write_time');
  set tempBlkWriteTime(double? value) =>
      setField<double>('temp_blk_write_time', value);

  int? get walRecords => getField<int>('wal_records');
  set walRecords(int? value) => setField<int>('wal_records', value);

  int? get walFpi => getField<int>('wal_fpi');
  set walFpi(int? value) => setField<int>('wal_fpi', value);

  double? get walBytes => getField<double>('wal_bytes');
  set walBytes(double? value) => setField<double>('wal_bytes', value);

  int? get jitFunctions => getField<int>('jit_functions');
  set jitFunctions(int? value) => setField<int>('jit_functions', value);

  double? get jitGenerationTime => getField<double>('jit_generation_time');
  set jitGenerationTime(double? value) =>
      setField<double>('jit_generation_time', value);

  int? get jitInliningCount => getField<int>('jit_inlining_count');
  set jitInliningCount(int? value) =>
      setField<int>('jit_inlining_count', value);

  double? get jitInliningTime => getField<double>('jit_inlining_time');
  set jitInliningTime(double? value) =>
      setField<double>('jit_inlining_time', value);

  int? get jitOptimizationCount => getField<int>('jit_optimization_count');
  set jitOptimizationCount(int? value) =>
      setField<int>('jit_optimization_count', value);

  double? get jitOptimizationTime => getField<double>('jit_optimization_time');
  set jitOptimizationTime(double? value) =>
      setField<double>('jit_optimization_time', value);

  int? get jitEmissionCount => getField<int>('jit_emission_count');
  set jitEmissionCount(int? value) =>
      setField<int>('jit_emission_count', value);

  double? get jitEmissionTime => getField<double>('jit_emission_time');
  set jitEmissionTime(double? value) =>
      setField<double>('jit_emission_time', value);

  int? get jitDeformCount => getField<int>('jit_deform_count');
  set jitDeformCount(int? value) => setField<int>('jit_deform_count', value);

  double? get jitDeformTime => getField<double>('jit_deform_time');
  set jitDeformTime(double? value) =>
      setField<double>('jit_deform_time', value);

  DateTime? get statsSince => getField<DateTime>('stats_since');
  set statsSince(DateTime? value) => setField<DateTime>('stats_since', value);

  DateTime? get minmaxStatsSince => getField<DateTime>('minmax_stats_since');
  set minmaxStatsSince(DateTime? value) =>
      setField<DateTime>('minmax_stats_since', value);
}
