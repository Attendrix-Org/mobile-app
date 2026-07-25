import '../database.dart';

class ElectiveOfferingSemestersTable
    extends SupabaseTable<ElectiveOfferingSemestersRow> {
  @override
  String get tableName => 'elective_offering_semesters';

  @override
  ElectiveOfferingSemestersRow createRow(Map<String, dynamic> data) =>
      ElectiveOfferingSemestersRow(data);
}

class ElectiveOfferingSemestersRow extends SupabaseDataRow {
  ElectiveOfferingSemestersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ElectiveOfferingSemestersTable();

  String get offeringId => getField<String>('offering_id')!;
  set offeringId(String value) => setField<String>('offering_id', value);

  int get semesterNumber => getField<int>('semester_number')!;
  set semesterNumber(int value) => setField<int>('semester_number', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
