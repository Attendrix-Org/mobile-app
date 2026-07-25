// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserProfileStruct extends BaseStruct {
  UserProfileStruct({
    String? userId,
    String? username,
    String? email,
    String? role,
    String? departmentId,
    String? batchId,
    int? currentSemester,
    List<EnrolledCourseStruct>? enrolledCourses,
    int? amplixBalance,
    DateTime? profileUpdatedAt,
    bool? onboardingComplete,
    int? odometer,
  })  : _userId = userId,
        _username = username,
        _email = email,
        _role = role,
        _departmentId = departmentId,
        _batchId = batchId,
        _currentSemester = currentSemester,
        _enrolledCourses = enrolledCourses,
        _amplixBalance = amplixBalance,
        _profileUpdatedAt = profileUpdatedAt,
        _onboardingComplete = onboardingComplete,
        _odometer = odometer;

  // "userId" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "username" field.
  String? _username;
  String get username => _username ?? '';
  set username(String? val) => _username = val;

  bool hasUsername() => _username != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  // "departmentId" field.
  String? _departmentId;
  String get departmentId => _departmentId ?? '';
  set departmentId(String? val) => _departmentId = val;

  bool hasDepartmentId() => _departmentId != null;

  // "batchId" field.
  String? _batchId;
  String get batchId => _batchId ?? '';
  set batchId(String? val) => _batchId = val;

  bool hasBatchId() => _batchId != null;

  // "currentSemester" field.
  int? _currentSemester;
  int get currentSemester => _currentSemester ?? 0;
  set currentSemester(int? val) => _currentSemester = val;

  void incrementCurrentSemester(int amount) =>
      currentSemester = currentSemester + amount;

  bool hasCurrentSemester() => _currentSemester != null;

  // "enrolledCourses" field.
  List<EnrolledCourseStruct>? _enrolledCourses;
  List<EnrolledCourseStruct> get enrolledCourses =>
      _enrolledCourses ?? const [];
  set enrolledCourses(List<EnrolledCourseStruct>? val) =>
      _enrolledCourses = val;

  void updateEnrolledCourses(Function(List<EnrolledCourseStruct>) updateFn) {
    updateFn(_enrolledCourses ??= []);
  }

  bool hasEnrolledCourses() => _enrolledCourses != null;

  // "amplixBalance" field.
  int? _amplixBalance;
  int get amplixBalance => _amplixBalance ?? 0;
  set amplixBalance(int? val) => _amplixBalance = val;

  void incrementAmplixBalance(int amount) =>
      amplixBalance = amplixBalance + amount;

  bool hasAmplixBalance() => _amplixBalance != null;

  // "profileUpdatedAt" field.
  DateTime? _profileUpdatedAt;
  DateTime? get profileUpdatedAt => _profileUpdatedAt;
  set profileUpdatedAt(DateTime? val) => _profileUpdatedAt = val;

  bool hasProfileUpdatedAt() => _profileUpdatedAt != null;

  // "onboardingComplete" field.
  bool? _onboardingComplete;
  bool get onboardingComplete => _onboardingComplete ?? false;
  set onboardingComplete(bool? val) => _onboardingComplete = val;

  bool hasOnboardingComplete() => _onboardingComplete != null;

  // "odometer" field.
  int? _odometer;
  int get odometer => _odometer ?? 0;
  set odometer(int? val) => _odometer = val;

  void incrementOdometer(int amount) => odometer = odometer + amount;

  bool hasOdometer() => _odometer != null;

  static UserProfileStruct fromMap(Map<String, dynamic> data) =>
      UserProfileStruct(
        userId: data['userId'] as String?,
        username: data['username'] as String?,
        email: data['email'] as String?,
        role: data['role'] as String?,
        departmentId: data['departmentId'] as String?,
        batchId: data['batchId'] as String?,
        currentSemester: castToType<int>(data['currentSemester']),
        enrolledCourses: getStructList(
          data['enrolledCourses'],
          EnrolledCourseStruct.fromMap,
        ),
        amplixBalance: castToType<int>(data['amplixBalance']),
        profileUpdatedAt: data['profileUpdatedAt'] as DateTime?,
        onboardingComplete: data['onboardingComplete'] as bool?,
        odometer: castToType<int>(data['odometer']),
      );

  static UserProfileStruct? maybeFromMap(dynamic data) => data is Map
      ? UserProfileStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'userId': _userId,
        'username': _username,
        'email': _email,
        'role': _role,
        'departmentId': _departmentId,
        'batchId': _batchId,
        'currentSemester': _currentSemester,
        'enrolledCourses': _enrolledCourses?.map((e) => e.toMap()).toList(),
        'amplixBalance': _amplixBalance,
        'profileUpdatedAt': _profileUpdatedAt,
        'onboardingComplete': _onboardingComplete,
        'odometer': _odometer,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'userId': serializeParam(
          _userId,
          ParamType.String,
        ),
        'username': serializeParam(
          _username,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
        'departmentId': serializeParam(
          _departmentId,
          ParamType.String,
        ),
        'batchId': serializeParam(
          _batchId,
          ParamType.String,
        ),
        'currentSemester': serializeParam(
          _currentSemester,
          ParamType.int,
        ),
        'enrolledCourses': serializeParam(
          _enrolledCourses,
          ParamType.DataStruct,
          isList: true,
        ),
        'amplixBalance': serializeParam(
          _amplixBalance,
          ParamType.int,
        ),
        'profileUpdatedAt': serializeParam(
          _profileUpdatedAt,
          ParamType.DateTime,
        ),
        'onboardingComplete': serializeParam(
          _onboardingComplete,
          ParamType.bool,
        ),
        'odometer': serializeParam(
          _odometer,
          ParamType.int,
        ),
      }.withoutNulls;

  static UserProfileStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserProfileStruct(
        userId: deserializeParam(
          data['userId'],
          ParamType.String,
          false,
        ),
        username: deserializeParam(
          data['username'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
        departmentId: deserializeParam(
          data['departmentId'],
          ParamType.String,
          false,
        ),
        batchId: deserializeParam(
          data['batchId'],
          ParamType.String,
          false,
        ),
        currentSemester: deserializeParam(
          data['currentSemester'],
          ParamType.int,
          false,
        ),
        enrolledCourses: deserializeStructParam<EnrolledCourseStruct>(
          data['enrolledCourses'],
          ParamType.DataStruct,
          true,
          structBuilder: EnrolledCourseStruct.fromSerializableMap,
        ),
        amplixBalance: deserializeParam(
          data['amplixBalance'],
          ParamType.int,
          false,
        ),
        profileUpdatedAt: deserializeParam(
          data['profileUpdatedAt'],
          ParamType.DateTime,
          false,
        ),
        onboardingComplete: deserializeParam(
          data['onboardingComplete'],
          ParamType.bool,
          false,
        ),
        odometer: deserializeParam(
          data['odometer'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'UserProfileStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is UserProfileStruct &&
        userId == other.userId &&
        username == other.username &&
        email == other.email &&
        role == other.role &&
        departmentId == other.departmentId &&
        batchId == other.batchId &&
        currentSemester == other.currentSemester &&
        listEquality.equals(enrolledCourses, other.enrolledCourses) &&
        amplixBalance == other.amplixBalance &&
        profileUpdatedAt == other.profileUpdatedAt &&
        onboardingComplete == other.onboardingComplete &&
        odometer == other.odometer;
  }

  @override
  int get hashCode => const ListEquality().hash([
        userId,
        username,
        email,
        role,
        departmentId,
        batchId,
        currentSemester,
        enrolledCourses,
        amplixBalance,
        profileUpdatedAt,
        onboardingComplete,
        odometer
      ]);
}

UserProfileStruct createUserProfileStruct({
  String? userId,
  String? username,
  String? email,
  String? role,
  String? departmentId,
  String? batchId,
  int? currentSemester,
  int? amplixBalance,
  DateTime? profileUpdatedAt,
  bool? onboardingComplete,
  int? odometer,
}) =>
    UserProfileStruct(
      userId: userId,
      username: username,
      email: email,
      role: role,
      departmentId: departmentId,
      batchId: batchId,
      currentSemester: currentSemester,
      amplixBalance: amplixBalance,
      profileUpdatedAt: profileUpdatedAt,
      onboardingComplete: onboardingComplete,
      odometer: odometer,
    );
