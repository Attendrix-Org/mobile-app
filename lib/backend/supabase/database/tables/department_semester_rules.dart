import '../database.dart';

class DepartmentSemesterRulesTable
    extends SupabaseTable<DepartmentSemesterRulesRow> {
  @override
  String get tableName => 'department_semester_rules';

  @override
  DepartmentSemesterRulesRow createRow(Map<String, dynamic> data) =>
      DepartmentSemesterRulesRow(data);
}

class DepartmentSemesterRulesRow extends SupabaseDataRow {
  DepartmentSemesterRulesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DepartmentSemesterRulesTable();

  String? get ruleId => getField<String>('rule_id');
  set ruleId(String? value) => setField<String>('rule_id', value);

  String get departmentId => getField<String>('department_id')!;
  set departmentId(String value) => setField<String>('department_id', value);

  int get semesterNumber => getField<int>('semester_number')!;
  set semesterNumber(int value) => setField<int>('semester_number', value);

  String get electiveCategory => getField<String>('elective_category')!;
  set electiveCategory(String value) =>
      setField<String>('elective_category', value);

  int get requiredCount => getField<int>('required_count')!;
  set requiredCount(int value) => setField<int>('required_count', value);
}
