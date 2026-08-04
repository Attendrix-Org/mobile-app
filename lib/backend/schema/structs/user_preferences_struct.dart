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
    String? theme,
    String? timezone,
    String? language,
    bool? notificationsEnabled,
    bool? notifClassReminder,
    int? notifReminderMinutes,
    bool? notifClassCancelled,
    bool? notifTaskPublished,
    bool? notifTaskDueSoon,
    bool? notifExamReminder,
    bool? notifDailyBrief,
    bool? notifAttendanceAlert,
    bool? notifWeeklySummary,
    bool? quietHoursEnabled,
    String? quietHoursStart,
    String? quietHoursEnd,
  })  : _enableAPOD = enableAPOD,
        _preferredTimeFormat = preferredTimeFormat,
        _userMess = userMess,
        _preferredActionTone = preferredActionTone,
        _atAGlanceView = atAGlanceView,
        _defaultRequiredAttendance = defaultRequiredAttendance,
        _useScheduledClassesForGreetingMessage =
            useScheduledClassesForGreetingMessage,
        _useActionToneForGreetingMessage = useActionToneForGreetingMessage,
        _theme = theme,
        _timezone = timezone,
        _language = language,
        _notificationsEnabled = notificationsEnabled,
        _notifClassReminder = notifClassReminder,
        _notifReminderMinutes = notifReminderMinutes,
        _notifClassCancelled = notifClassCancelled,
        _notifTaskPublished = notifTaskPublished,
        _notifTaskDueSoon = notifTaskDueSoon,
        _notifExamReminder = notifExamReminder,
        _notifDailyBrief = notifDailyBrief,
        _notifAttendanceAlert = notifAttendanceAlert,
        _notifWeeklySummary = notifWeeklySummary,
        _quietHoursEnabled = quietHoursEnabled,
        _quietHoursStart = quietHoursStart,
        _quietHoursEnd = quietHoursEnd;

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

  // "theme" field.
  String? _theme;
  String get theme => _theme ?? 'system';
  set theme(String? val) => _theme = val;

  bool hasTheme() => _theme != null;

  // "timezone" field.
  String? _timezone;
  String get timezone => _timezone ?? 'Asia/Kolkata';
  set timezone(String? val) => _timezone = val;

  bool hasTimezone() => _timezone != null;

  // "language" field.
  String? _language;
  String get language => _language ?? 'en';
  set language(String? val) => _language = val;

  bool hasLanguage() => _language != null;

  // "notificationsEnabled" field.
  bool? _notificationsEnabled;
  bool get notificationsEnabled => _notificationsEnabled ?? true;
  set notificationsEnabled(bool? val) => _notificationsEnabled = val;

  bool hasNotificationsEnabled() => _notificationsEnabled != null;

  // "notifClassReminder" field.
  bool? _notifClassReminder;
  bool get notifClassReminder => _notifClassReminder ?? true;
  set notifClassReminder(bool? val) => _notifClassReminder = val;

  bool hasNotifClassReminder() => _notifClassReminder != null;

  // "notifReminderMinutes" field.
  int? _notifReminderMinutes;
  int get notifReminderMinutes => _notifReminderMinutes ?? 10;
  set notifReminderMinutes(int? val) => _notifReminderMinutes = val;

  void incrementNotifReminderMinutes(int amount) =>
      notifReminderMinutes = notifReminderMinutes + amount;

  bool hasNotifReminderMinutes() => _notifReminderMinutes != null;

  // "notifClassCancelled" field.
  bool? _notifClassCancelled;
  bool get notifClassCancelled => _notifClassCancelled ?? true;
  set notifClassCancelled(bool? val) => _notifClassCancelled = val;

  bool hasNotifClassCancelled() => _notifClassCancelled != null;

  // "notifTaskPublished" field.
  bool? _notifTaskPublished;
  bool get notifTaskPublished => _notifTaskPublished ?? true;
  set notifTaskPublished(bool? val) => _notifTaskPublished = val;

  bool hasNotifTaskPublished() => _notifTaskPublished != null;

  // "notifTaskDueSoon" field.
  bool? _notifTaskDueSoon;
  bool get notifTaskDueSoon => _notifTaskDueSoon ?? true;
  set notifTaskDueSoon(bool? val) => _notifTaskDueSoon = val;

  bool hasNotifTaskDueSoon() => _notifTaskDueSoon != null;

  // "notifExamReminder" field.
  bool? _notifExamReminder;
  bool get notifExamReminder => _notifExamReminder ?? true;
  set notifExamReminder(bool? val) => _notifExamReminder = val;

  bool hasNotifExamReminder() => _notifExamReminder != null;

  // "notifDailyBrief" field.
  bool? _notifDailyBrief;
  bool get notifDailyBrief => _notifDailyBrief ?? true;
  set notifDailyBrief(bool? val) => _notifDailyBrief = val;

  bool hasNotifDailyBrief() => _notifDailyBrief != null;

  // "notifAttendanceAlert" field.
  bool? _notifAttendanceAlert;
  bool get notifAttendanceAlert => _notifAttendanceAlert ?? true;
  set notifAttendanceAlert(bool? val) => _notifAttendanceAlert = val;

  bool hasNotifAttendanceAlert() => _notifAttendanceAlert != null;

  // "notifWeeklySummary" field.
  bool? _notifWeeklySummary;
  bool get notifWeeklySummary => _notifWeeklySummary ?? true;
  set notifWeeklySummary(bool? val) => _notifWeeklySummary = val;

  bool hasNotifWeeklySummary() => _notifWeeklySummary != null;

  // "quietHoursEnabled" field.
  bool? _quietHoursEnabled;
  bool get quietHoursEnabled => _quietHoursEnabled ?? true;
  set quietHoursEnabled(bool? val) => _quietHoursEnabled = val;

  bool hasQuietHoursEnabled() => _quietHoursEnabled != null;

  // "quietHoursStart" field.
  String? _quietHoursStart;
  String get quietHoursStart => _quietHoursStart ?? '22:00:00';
  set quietHoursStart(String? val) => _quietHoursStart = val;

  bool hasQuietHoursStart() => _quietHoursStart != null;

  // "quietHoursEnd" field.
  String? _quietHoursEnd;
  String get quietHoursEnd => _quietHoursEnd ?? '07:00:00';
  set quietHoursEnd(String? val) => _quietHoursEnd = val;

  bool hasQuietHoursEnd() => _quietHoursEnd != null;

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
        theme: data['theme'] as String?,
        timezone: data['timezone'] as String?,
        language: data['language'] as String?,
        notificationsEnabled: data['notificationsEnabled'] as bool?,
        notifClassReminder: data['notifClassReminder'] as bool?,
        notifReminderMinutes: castToType<int>(data['notifReminderMinutes']),
        notifClassCancelled: data['notifClassCancelled'] as bool?,
        notifTaskPublished: data['notifTaskPublished'] as bool?,
        notifTaskDueSoon: data['notifTaskDueSoon'] as bool?,
        notifExamReminder: data['notifExamReminder'] as bool?,
        notifDailyBrief: data['notifDailyBrief'] as bool?,
        notifAttendanceAlert: data['notifAttendanceAlert'] as bool?,
        notifWeeklySummary: data['notifWeeklySummary'] as bool?,
        quietHoursEnabled: data['quietHoursEnabled'] as bool?,
        quietHoursStart: data['quietHoursStart'] as String?,
        quietHoursEnd: data['quietHoursEnd'] as String?,
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
        'theme': _theme,
        'timezone': _timezone,
        'language': _language,
        'notificationsEnabled': _notificationsEnabled,
        'notifClassReminder': _notifClassReminder,
        'notifReminderMinutes': _notifReminderMinutes,
        'notifClassCancelled': _notifClassCancelled,
        'notifTaskPublished': _notifTaskPublished,
        'notifTaskDueSoon': _notifTaskDueSoon,
        'notifExamReminder': _notifExamReminder,
        'notifDailyBrief': _notifDailyBrief,
        'notifAttendanceAlert': _notifAttendanceAlert,
        'notifWeeklySummary': _notifWeeklySummary,
        'quietHoursEnabled': _quietHoursEnabled,
        'quietHoursStart': _quietHoursStart,
        'quietHoursEnd': _quietHoursEnd,
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
        'theme': serializeParam(
          _theme,
          ParamType.String,
        ),
        'timezone': serializeParam(
          _timezone,
          ParamType.String,
        ),
        'language': serializeParam(
          _language,
          ParamType.String,
        ),
        'notificationsEnabled': serializeParam(
          _notificationsEnabled,
          ParamType.bool,
        ),
        'notifClassReminder': serializeParam(
          _notifClassReminder,
          ParamType.bool,
        ),
        'notifReminderMinutes': serializeParam(
          _notifReminderMinutes,
          ParamType.int,
        ),
        'notifClassCancelled': serializeParam(
          _notifClassCancelled,
          ParamType.bool,
        ),
        'notifTaskPublished': serializeParam(
          _notifTaskPublished,
          ParamType.bool,
        ),
        'notifTaskDueSoon': serializeParam(
          _notifTaskDueSoon,
          ParamType.bool,
        ),
        'notifExamReminder': serializeParam(
          _notifExamReminder,
          ParamType.bool,
        ),
        'notifDailyBrief': serializeParam(
          _notifDailyBrief,
          ParamType.bool,
        ),
        'notifAttendanceAlert': serializeParam(
          _notifAttendanceAlert,
          ParamType.bool,
        ),
        'notifWeeklySummary': serializeParam(
          _notifWeeklySummary,
          ParamType.bool,
        ),
        'quietHoursEnabled': serializeParam(
          _quietHoursEnabled,
          ParamType.bool,
        ),
        'quietHoursStart': serializeParam(
          _quietHoursStart,
          ParamType.String,
        ),
        'quietHoursEnd': serializeParam(
          _quietHoursEnd,
          ParamType.String,
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
        theme: deserializeParam(
          data['theme'],
          ParamType.String,
          false,
        ),
        timezone: deserializeParam(
          data['timezone'],
          ParamType.String,
          false,
        ),
        language: deserializeParam(
          data['language'],
          ParamType.String,
          false,
        ),
        notificationsEnabled: deserializeParam(
          data['notificationsEnabled'],
          ParamType.bool,
          false,
        ),
        notifClassReminder: deserializeParam(
          data['notifClassReminder'],
          ParamType.bool,
          false,
        ),
        notifReminderMinutes: deserializeParam(
          data['notifReminderMinutes'],
          ParamType.int,
          false,
        ),
        notifClassCancelled: deserializeParam(
          data['notifClassCancelled'],
          ParamType.bool,
          false,
        ),
        notifTaskPublished: deserializeParam(
          data['notifTaskPublished'],
          ParamType.bool,
          false,
        ),
        notifTaskDueSoon: deserializeParam(
          data['notifTaskDueSoon'],
          ParamType.bool,
          false,
        ),
        notifExamReminder: deserializeParam(
          data['notifExamReminder'],
          ParamType.bool,
          false,
        ),
        notifDailyBrief: deserializeParam(
          data['notifDailyBrief'],
          ParamType.bool,
          false,
        ),
        notifAttendanceAlert: deserializeParam(
          data['notifAttendanceAlert'],
          ParamType.bool,
          false,
        ),
        notifWeeklySummary: deserializeParam(
          data['notifWeeklySummary'],
          ParamType.bool,
          false,
        ),
        quietHoursEnabled: deserializeParam(
          data['quietHoursEnabled'],
          ParamType.bool,
          false,
        ),
        quietHoursStart: deserializeParam(
          data['quietHoursStart'],
          ParamType.String,
          false,
        ),
        quietHoursEnd: deserializeParam(
          data['quietHoursEnd'],
          ParamType.String,
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
            other.useActionToneForGreetingMessage &&
        theme == other.theme &&
        timezone == other.timezone &&
        language == other.language &&
        notificationsEnabled == other.notificationsEnabled &&
        notifClassReminder == other.notifClassReminder &&
        notifReminderMinutes == other.notifReminderMinutes &&
        notifClassCancelled == other.notifClassCancelled &&
        notifTaskPublished == other.notifTaskPublished &&
        notifTaskDueSoon == other.notifTaskDueSoon &&
        notifExamReminder == other.notifExamReminder &&
        notifDailyBrief == other.notifDailyBrief &&
        notifAttendanceAlert == other.notifAttendanceAlert &&
        notifWeeklySummary == other.notifWeeklySummary &&
        quietHoursEnabled == other.quietHoursEnabled &&
        quietHoursStart == other.quietHoursStart &&
        quietHoursEnd == other.quietHoursEnd;
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
        useActionToneForGreetingMessage,
        theme,
        timezone,
        language,
        notificationsEnabled,
        notifClassReminder,
        notifReminderMinutes,
        notifClassCancelled,
        notifTaskPublished,
        notifTaskDueSoon,
        notifExamReminder,
        notifDailyBrief,
        notifAttendanceAlert,
        notifWeeklySummary,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd
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
  String? theme,
  String? timezone,
  String? language,
  bool? notificationsEnabled,
  bool? notifClassReminder,
  int? notifReminderMinutes,
  bool? notifClassCancelled,
  bool? notifTaskPublished,
  bool? notifTaskDueSoon,
  bool? notifExamReminder,
  bool? notifDailyBrief,
  bool? notifAttendanceAlert,
  bool? notifWeeklySummary,
  bool? quietHoursEnabled,
  String? quietHoursStart,
  String? quietHoursEnd,
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
      theme: theme,
      timezone: timezone,
      language: language,
      notificationsEnabled: notificationsEnabled,
      notifClassReminder: notifClassReminder,
      notifReminderMinutes: notifReminderMinutes,
      notifClassCancelled: notifClassCancelled,
      notifTaskPublished: notifTaskPublished,
      notifTaskDueSoon: notifTaskDueSoon,
      notifExamReminder: notifExamReminder,
      notifDailyBrief: notifDailyBrief,
      notifAttendanceAlert: notifAttendanceAlert,
      notifWeeklySummary: notifWeeklySummary,
      quietHoursEnabled: quietHoursEnabled,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
    );
