// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserPreferencesStruct extends BaseStruct {
  UserPreferencesStruct({
    bool? enableAPOD,
    TimeFormat? preferredTimeFormat,
    String? userMess,
    ActionTone? preferredActionTone,
    bool? atAGlanceView,
    int? defaultRequiredAttendance,
    bool? useScheduledClassesForGreetingMessage,
    bool? useActionToneForGreetingMessage,
  })  : _enableAPOD = enableAPOD,
        _preferredTimeFormat = preferredTimeFormat,
        _userMess = userMess,
        _preferredActionTone = preferredActionTone,
        _atAGlanceView = atAGlanceView,
        _defaultRequiredAttendance = defaultRequiredAttendance,
        _useScheduledClassesForGreetingMessage =
            useScheduledClassesForGreetingMessage,
        _useActionToneForGreetingMessage = useActionToneForGreetingMessage;

  // "enableAPOD" field.
  bool? _enableAPOD;
  bool get enableAPOD => _enableAPOD ?? true;
  set enableAPOD(bool? val) => _enableAPOD = val;

  bool hasEnableAPOD() => _enableAPOD != null;

  // "preferredTimeFormat" field.
  TimeFormat? _preferredTimeFormat;
  TimeFormat get preferredTimeFormat =>
      _preferredTimeFormat ?? TimeFormat.twelveHour;
  set preferredTimeFormat(TimeFormat? val) => _preferredTimeFormat = val;

  bool hasPreferredTimeFormat() => _preferredTimeFormat != null;

  // "userMess" field.
  String? _userMess;
  String get userMess => _userMess ?? '';
  set userMess(String? val) => _userMess = val;

  bool hasUserMess() => _userMess != null;

  // "preferredActionTone" field.
  ActionTone? _preferredActionTone;
  ActionTone get preferredActionTone =>
      _preferredActionTone ?? ActionTone.playful;
  set preferredActionTone(ActionTone? val) => _preferredActionTone = val;

  bool hasPreferredActionTone() => _preferredActionTone != null;

  // "atAGlanceView" field.
  bool? _atAGlanceView;
  bool get atAGlanceView => _atAGlanceView ?? true;
  set atAGlanceView(bool? val) => _atAGlanceView = val;

  bool hasAtAGlanceView() => _atAGlanceView != null;

  // "defaultRequiredAttendance" field.
  int? _defaultRequiredAttendance;
  int get defaultRequiredAttendance => _defaultRequiredAttendance ?? 80;
  set defaultRequiredAttendance(int? val) => _defaultRequiredAttendance = val;

  void incrementDefaultRequiredAttendance(int amount) =>
      defaultRequiredAttendance = defaultRequiredAttendance + amount;

  bool hasDefaultRequiredAttendance() => _defaultRequiredAttendance != null;

  // "useScheduledClassesForGreetingMessage" field.
  bool? _useScheduledClassesForGreetingMessage;
  bool get useScheduledClassesForGreetingMessage =>
      _useScheduledClassesForGreetingMessage ?? true;
  set useScheduledClassesForGreetingMessage(bool? val) =>
      _useScheduledClassesForGreetingMessage = val;

  bool hasUseScheduledClassesForGreetingMessage() =>
      _useScheduledClassesForGreetingMessage != null;

  // "useActionToneForGreetingMessage" field.
  bool? _useActionToneForGreetingMessage;
  bool get useActionToneForGreetingMessage =>
      _useActionToneForGreetingMessage ?? true;
  set useActionToneForGreetingMessage(bool? val) =>
      _useActionToneForGreetingMessage = val;

  bool hasUseActionToneForGreetingMessage() =>
      _useActionToneForGreetingMessage != null;

  static UserPreferencesStruct fromMap(Map<String, dynamic> data) =>
      UserPreferencesStruct(
        enableAPOD: data['enableAPOD'] as bool?,
        preferredTimeFormat: data['preferredTimeFormat'] is TimeFormat
            ? data['preferredTimeFormat']
            : deserializeEnum<TimeFormat>(data['preferredTimeFormat']),
        userMess: data['userMess'] as String?,
        preferredActionTone: data['preferredActionTone'] is ActionTone
            ? data['preferredActionTone']
            : deserializeEnum<ActionTone>(data['preferredActionTone']),
        atAGlanceView: data['atAGlanceView'] as bool?,
        defaultRequiredAttendance:
            castToType<int>(data['defaultRequiredAttendance']),
        useScheduledClassesForGreetingMessage:
            data['useScheduledClassesForGreetingMessage'] as bool?,
        useActionToneForGreetingMessage:
            data['useActionToneForGreetingMessage'] as bool?,
      );

  static UserPreferencesStruct? maybeFromMap(dynamic data) => data is Map
      ? UserPreferencesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'enableAPOD': _enableAPOD,
        'preferredTimeFormat': _preferredTimeFormat?.serialize(),
        'userMess': _userMess,
        'preferredActionTone': _preferredActionTone?.serialize(),
        'atAGlanceView': _atAGlanceView,
        'defaultRequiredAttendance': _defaultRequiredAttendance,
        'useScheduledClassesForGreetingMessage':
            _useScheduledClassesForGreetingMessage,
        'useActionToneForGreetingMessage': _useActionToneForGreetingMessage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'enableAPOD': serializeParam(
          _enableAPOD,
          ParamType.bool,
        ),
        'preferredTimeFormat': serializeParam(
          _preferredTimeFormat,
          ParamType.Enum,
        ),
        'userMess': serializeParam(
          _userMess,
          ParamType.String,
        ),
        'preferredActionTone': serializeParam(
          _preferredActionTone,
          ParamType.Enum,
        ),
        'atAGlanceView': serializeParam(
          _atAGlanceView,
          ParamType.bool,
        ),
        'defaultRequiredAttendance': serializeParam(
          _defaultRequiredAttendance,
          ParamType.int,
        ),
        'useScheduledClassesForGreetingMessage': serializeParam(
          _useScheduledClassesForGreetingMessage,
          ParamType.bool,
        ),
        'useActionToneForGreetingMessage': serializeParam(
          _useActionToneForGreetingMessage,
          ParamType.bool,
        ),
      }.withoutNulls;

  static UserPreferencesStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserPreferencesStruct(
        enableAPOD: deserializeParam(
          data['enableAPOD'],
          ParamType.bool,
          false,
        ),
        preferredTimeFormat: deserializeParam<TimeFormat>(
          data['preferredTimeFormat'],
          ParamType.Enum,
          false,
        ),
        userMess: deserializeParam(
          data['userMess'],
          ParamType.String,
          false,
        ),
        preferredActionTone: deserializeParam<ActionTone>(
          data['preferredActionTone'],
          ParamType.Enum,
          false,
        ),
        atAGlanceView: deserializeParam(
          data['atAGlanceView'],
          ParamType.bool,
          false,
        ),
        defaultRequiredAttendance: deserializeParam(
          data['defaultRequiredAttendance'],
          ParamType.int,
          false,
        ),
        useScheduledClassesForGreetingMessage: deserializeParam(
          data['useScheduledClassesForGreetingMessage'],
          ParamType.bool,
          false,
        ),
        useActionToneForGreetingMessage: deserializeParam(
          data['useActionToneForGreetingMessage'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'UserPreferencesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserPreferencesStruct &&
        enableAPOD == other.enableAPOD &&
        preferredTimeFormat == other.preferredTimeFormat &&
        userMess == other.userMess &&
        preferredActionTone == other.preferredActionTone &&
        atAGlanceView == other.atAGlanceView &&
        defaultRequiredAttendance == other.defaultRequiredAttendance &&
        useScheduledClassesForGreetingMessage ==
            other.useScheduledClassesForGreetingMessage &&
        useActionToneForGreetingMessage ==
            other.useActionToneForGreetingMessage;
  }

  @override
  int get hashCode => const ListEquality().hash([
        enableAPOD,
        preferredTimeFormat,
        userMess,
        preferredActionTone,
        atAGlanceView,
        defaultRequiredAttendance,
        useScheduledClassesForGreetingMessage,
        useActionToneForGreetingMessage
      ]);
}

UserPreferencesStruct createUserPreferencesStruct({
  bool? enableAPOD,
  TimeFormat? preferredTimeFormat,
  String? userMess,
  ActionTone? preferredActionTone,
  bool? atAGlanceView,
  int? defaultRequiredAttendance,
  bool? useScheduledClassesForGreetingMessage,
  bool? useActionToneForGreetingMessage,
}) =>
    UserPreferencesStruct(
      enableAPOD: enableAPOD,
      preferredTimeFormat: preferredTimeFormat,
      userMess: userMess,
      preferredActionTone: preferredActionTone,
      atAGlanceView: atAGlanceView,
      defaultRequiredAttendance: defaultRequiredAttendance,
      useScheduledClassesForGreetingMessage:
          useScheduledClassesForGreetingMessage,
      useActionToneForGreetingMessage: useActionToneForGreetingMessage,
    );
