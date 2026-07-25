import '../database.dart';

class AbsencesTable extends SupabaseTable<AbsencesRow> {
  @override
  String get tableName => 'absences';

  @override
  AbsencesRow createRow(Map<String, dynamic> data) => AbsencesRow(data);
}

class AbsencesRow extends SupabaseDataRow {
  AbsencesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AbsencesTable();

  String? get absenceId => getField<String>('absence_id');
  set absenceId(String? value) => setField<String>('absence_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get classId => getField<String>('class_id')!;
  set classId(String value) => setField<String>('class_id', value);

  DateTime? get markedAt => getField<DateTime>('marked_at');
  set markedAt(DateTime? value) => setField<DateTime>('marked_at', value);

  String? get markedBy => getField<String>('marked_by');
  set markedBy(String? value) => setField<String>('marked_by', value);

  String get source => getField<String>('source')!;
  set source(String value) => setField<String>('source', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);
}
