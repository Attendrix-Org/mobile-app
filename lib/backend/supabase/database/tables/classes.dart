import '../database.dart';

class ClassesTable extends SupabaseTable<ClassesRow> {
  @override
  String get tableName => 'classes';

  @override
  ClassesRow createRow(Map<String, dynamic> data) => ClassesRow(data);
}

class ClassesRow extends SupabaseDataRow {
  ClassesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ClassesTable();

  String? get classId => getField<String>('class_id');
  set classId(String? value) => setField<String>('class_id', value);

  String get classRef => getField<String>('class_ref')!;
  set classRef(String value) => setField<String>('class_ref', value);

  String get batchId => getField<String>('batch_id')!;
  set batchId(String value) => setField<String>('batch_id', value);

  String get semesterId => getField<String>('semester_id')!;
  set semesterId(String value) => setField<String>('semester_id', value);

  DateTime get scheduledStart => getField<DateTime>('scheduled_start')!;
  set scheduledStart(DateTime value) =>
      setField<DateTime>('scheduled_start', value);

  DateTime get scheduledEnd => getField<DateTime>('scheduled_end')!;
  set scheduledEnd(DateTime value) =>
      setField<DateTime>('scheduled_end', value);

  String? get venue => getField<String>('venue');
  set venue(String? value) => setField<String>('venue', value);

  bool? get isPlusSlot => getField<bool>('is_plus_slot');
  set isPlusSlot(bool? value) => setField<bool>('is_plus_slot', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get courseId => getField<String>('course_id')!;
  set courseId(String value) => setField<String>('course_id', value);

  String? get labGroup => getField<String>('lab_group');
  set labGroup(String? value) => setField<String>('lab_group', value);

  bool? get isExtraClass => getField<bool>('is_extra_class');
  set isExtraClass(bool? value) => setField<bool>('is_extra_class', value);

  String get scheduledDate => getField<String>('scheduled_date')!;
  set scheduledDate(String value) => setField<String>('scheduled_date', value);

  bool? get isCancelled => getField<bool>('is_cancelled');
  set isCancelled(bool? value) => setField<bool>('is_cancelled', value);

  DateTime? get cancelledAt => getField<DateTime>('cancelled_at');
  set cancelledAt(DateTime? value) => setField<DateTime>('cancelled_at', value);

  String? get cancellationReason => getField<String>('cancellation_reason');
  set cancellationReason(String? value) =>
      setField<String>('cancellation_reason', value);
}
