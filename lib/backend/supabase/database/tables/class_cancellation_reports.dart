import '../database.dart';

class ClassCancellationReportsTable
    extends SupabaseTable<ClassCancellationReportsRow> {
  @override
  String get tableName => 'class_cancellation_reports';

  @override
  ClassCancellationReportsRow createRow(Map<String, dynamic> data) =>
      ClassCancellationReportsRow(data);
}

class ClassCancellationReportsRow extends SupabaseDataRow {
  ClassCancellationReportsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClassCancellationReportsTable();

  String? get reportId => getField<String>('report_id');
  set reportId(String? value) => setField<String>('report_id', value);

  String get classId => getField<String>('class_id')!;
  set classId(String value) => setField<String>('class_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get reportedAt => getField<DateTime>('reported_at');
  set reportedAt(DateTime? value) => setField<DateTime>('reported_at', value);
}
