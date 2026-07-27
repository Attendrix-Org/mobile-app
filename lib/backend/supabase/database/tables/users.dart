import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  String get fullName => getField<String>('full_name')!;
  set fullName(String value) => setField<String>('full_name', value);

  String? get role => getField<String>('role');
  set role(String? value) => setField<String>('role', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  bool? get emailVerified => getField<bool>('email_verified');
  set emailVerified(bool? value) => setField<bool>('email_verified', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get username => getField<String>('username');
  set username(String? value) => setField<String>('username', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  String? get departmentId => getField<String>('department_id');
  set departmentId(String? value) => setField<String>('department_id', value);

  String? get batchId => getField<String>('batch_id');
  set batchId(String? value) => setField<String>('batch_id', value);

  int? get currentSemester => getField<int>('current_semester');
  set currentSemester(int? value) => setField<int>('current_semester', value);

  bool? get onboardingCompleted => getField<bool>('onboarding_completed');
  set onboardingCompleted(bool? value) =>
      setField<bool>('onboarding_completed', value);

  String? get rollNumber => getField<String>('roll_number');
  set rollNumber(String? value) => setField<String>('roll_number', value);

  int? get amplixBalance => getField<int>('amplix_balance');
  set amplixBalance(int? value) => setField<int>('amplix_balance', value);

  dynamic get enrolledCourses => getField<dynamic>('enrolled_courses');
  set enrolledCourses(dynamic value) =>
      setField<dynamic>('enrolled_courses', value);

  DateTime? get profileUpdatedAt => getField<DateTime>('profile_updated_at');
  set profileUpdatedAt(DateTime? value) =>
      setField<DateTime>('profile_updated_at', value);

  int? get odometer => getField<int>('odometer');
  set odometer(int? value) => setField<int>('odometer', value);

  String? get labGroup => getField<String>('lab_group');
  set labGroup(String? value) => setField<String>('lab_group', value);

  int? get minAttendanceTarget => getField<int>('min_attendance_target');
  set minAttendanceTarget(int? value) =>
      setField<int>('min_attendance_target', value);
}
