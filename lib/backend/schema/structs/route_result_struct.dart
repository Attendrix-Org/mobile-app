// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RouteResultStruct extends BaseStruct {
  RouteResultStruct({
    double? distanceM,
    int? durationMin,
    List<LatLng>? polyline,
    String? confidence,
    double? distanceMeters,
    int? durationSeconds,
    String? statusMessage,
    int? walkMinutes,
    int? leaveInMinutes,
    bool? isLeaveNow,
    bool? isLate,
    String? formattedDuration,
    String? formattedDistance,
  })  : _distanceM = distanceM,
        _durationMin = durationMin,
        _polyline = polyline,
        _confidence = confidence,
        _distanceMeters = distanceMeters,
        _durationSeconds = durationSeconds,
        _statusMessage = statusMessage,
        _walkMinutes = walkMinutes,
        _leaveInMinutes = leaveInMinutes,
        _isLeaveNow = isLeaveNow,
        _isLate = isLate,
        _formattedDuration = formattedDuration,
        _formattedDistance = formattedDistance;

  // "distanceM" field.
  double? _distanceM;
  double get distanceM => _distanceM ?? 0.0;
  set distanceM(double? val) => _distanceM = val;

  void incrementDistanceM(double amount) => distanceM = distanceM + amount;

  bool hasDistanceM() => _distanceM != null;

  // "durationMin" field.
  int? _durationMin;
  int get durationMin => _durationMin ?? 0;
  set durationMin(int? val) => _durationMin = val;

  void incrementDurationMin(int amount) => durationMin = durationMin + amount;

  bool hasDurationMin() => _durationMin != null;

  // "polyline" field.
  List<LatLng>? _polyline;
  List<LatLng> get polyline => _polyline ?? const [];
  set polyline(List<LatLng>? val) => _polyline = val;

  void updatePolyline(Function(List<LatLng>) updateFn) {
    updateFn(_polyline ??= []);
  }

  bool hasPolyline() => _polyline != null;

  // "confidence" field.
  String? _confidence;
  String get confidence => _confidence ?? '';
  set confidence(String? val) => _confidence = val;

  bool hasConfidence() => _confidence != null;

  // "distanceMeters" field.
  double? _distanceMeters;
  double get distanceMeters => _distanceMeters ?? 0.0;
  set distanceMeters(double? val) => _distanceMeters = val;

  void incrementDistanceMeters(double amount) =>
      distanceMeters = distanceMeters + amount;

  bool hasDistanceMeters() => _distanceMeters != null;

  // "durationSeconds" field.
  int? _durationSeconds;
  int get durationSeconds => _durationSeconds ?? 0;
  set durationSeconds(int? val) => _durationSeconds = val;

  void incrementDurationSeconds(int amount) =>
      durationSeconds = durationSeconds + amount;

  bool hasDurationSeconds() => _durationSeconds != null;

  // "statusMessage" field.
  String? _statusMessage;
  String get statusMessage => _statusMessage ?? '';
  set statusMessage(String? val) => _statusMessage = val;

  bool hasStatusMessage() => _statusMessage != null;

  // "walkMinutes" field.
  int? _walkMinutes;
  int get walkMinutes => _walkMinutes ?? 0;
  set walkMinutes(int? val) => _walkMinutes = val;

  void incrementWalkMinutes(int amount) => walkMinutes = walkMinutes + amount;

  bool hasWalkMinutes() => _walkMinutes != null;

  // "leaveInMinutes" field.
  int? _leaveInMinutes;
  int get leaveInMinutes => _leaveInMinutes ?? 0;
  set leaveInMinutes(int? val) => _leaveInMinutes = val;

  void incrementLeaveInMinutes(int amount) =>
      leaveInMinutes = leaveInMinutes + amount;

  bool hasLeaveInMinutes() => _leaveInMinutes != null;

  // "isLeaveNow" field.
  bool? _isLeaveNow;
  bool get isLeaveNow => _isLeaveNow ?? false;
  set isLeaveNow(bool? val) => _isLeaveNow = val;

  bool hasIsLeaveNow() => _isLeaveNow != null;

  // "isLate" field.
  bool? _isLate;
  bool get isLate => _isLate ?? false;
  set isLate(bool? val) => _isLate = val;

  bool hasIsLate() => _isLate != null;

  // "formattedDuration" field.
  String? _formattedDuration;
  String get formattedDuration => _formattedDuration ?? '';
  set formattedDuration(String? val) => _formattedDuration = val;

  bool hasFormattedDuration() => _formattedDuration != null;

  // "formattedDistance" field.
  String? _formattedDistance;
  String get formattedDistance => _formattedDistance ?? '';
  set formattedDistance(String? val) => _formattedDistance = val;

  bool hasFormattedDistance() => _formattedDistance != null;

  static RouteResultStruct fromMap(Map<String, dynamic> data) =>
      RouteResultStruct(
        distanceM: castToType<double>(data['distanceM']),
        durationMin: castToType<int>(data['durationMin']),
        polyline: getDataList(data['polyline']),
        confidence: data['confidence'] as String?,
        distanceMeters: castToType<double>(data['distanceMeters']),
        durationSeconds: castToType<int>(data['durationSeconds']),
        statusMessage: data['statusMessage'] as String?,
        walkMinutes: castToType<int>(data['walkMinutes']),
        leaveInMinutes: castToType<int>(data['leaveInMinutes']),
        isLeaveNow: data['isLeaveNow'] as bool?,
        isLate: data['isLate'] as bool?,
        formattedDuration: data['formattedDuration'] as String?,
        formattedDistance: data['formattedDistance'] as String?,
      );

  static RouteResultStruct? maybeFromMap(dynamic data) => data is Map
      ? RouteResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'distanceM': _distanceM,
        'durationMin': _durationMin,
        'polyline': _polyline,
        'confidence': _confidence,
        'distanceMeters': _distanceMeters,
        'durationSeconds': _durationSeconds,
        'statusMessage': _statusMessage,
        'walkMinutes': _walkMinutes,
        'leaveInMinutes': _leaveInMinutes,
        'isLeaveNow': _isLeaveNow,
        'isLate': _isLate,
        'formattedDuration': _formattedDuration,
        'formattedDistance': _formattedDistance,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'distanceM': serializeParam(
          _distanceM,
          ParamType.double,
        ),
        'durationMin': serializeParam(
          _durationMin,
          ParamType.int,
        ),
        'polyline': serializeParam(
          _polyline,
          ParamType.LatLng,
          isList: true,
        ),
        'confidence': serializeParam(
          _confidence,
          ParamType.String,
        ),
        'distanceMeters': serializeParam(
          _distanceMeters,
          ParamType.double,
        ),
        'durationSeconds': serializeParam(
          _durationSeconds,
          ParamType.int,
        ),
        'statusMessage': serializeParam(
          _statusMessage,
          ParamType.String,
        ),
        'walkMinutes': serializeParam(
          _walkMinutes,
          ParamType.int,
        ),
        'leaveInMinutes': serializeParam(
          _leaveInMinutes,
          ParamType.int,
        ),
        'isLeaveNow': serializeParam(
          _isLeaveNow,
          ParamType.bool,
        ),
        'isLate': serializeParam(
          _isLate,
          ParamType.bool,
        ),
        'formattedDuration': serializeParam(
          _formattedDuration,
          ParamType.String,
        ),
        'formattedDistance': serializeParam(
          _formattedDistance,
          ParamType.String,
        ),
      }.withoutNulls;

  static RouteResultStruct fromSerializableMap(Map<String, dynamic> data) =>
      RouteResultStruct(
        distanceM: deserializeParam(
          data['distanceM'],
          ParamType.double,
          false,
        ),
        durationMin: deserializeParam(
          data['durationMin'],
          ParamType.int,
          false,
        ),
        polyline: deserializeParam<LatLng>(
          data['polyline'],
          ParamType.LatLng,
          true,
        ),
        confidence: deserializeParam(
          data['confidence'],
          ParamType.String,
          false,
        ),
        distanceMeters: deserializeParam(
          data['distanceMeters'],
          ParamType.double,
          false,
        ),
        durationSeconds: deserializeParam(
          data['durationSeconds'],
          ParamType.int,
          false,
        ),
        statusMessage: deserializeParam(
          data['statusMessage'],
          ParamType.String,
          false,
        ),
        walkMinutes: deserializeParam(
          data['walkMinutes'],
          ParamType.int,
          false,
        ),
        leaveInMinutes: deserializeParam(
          data['leaveInMinutes'],
          ParamType.int,
          false,
        ),
        isLeaveNow: deserializeParam(
          data['isLeaveNow'],
          ParamType.bool,
          false,
        ),
        isLate: deserializeParam(
          data['isLate'],
          ParamType.bool,
          false,
        ),
        formattedDuration: deserializeParam(
          data['formattedDuration'],
          ParamType.String,
          false,
        ),
        formattedDistance: deserializeParam(
          data['formattedDistance'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RouteResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RouteResultStruct &&
        distanceM == other.distanceM &&
        durationMin == other.durationMin &&
        listEquality.equals(polyline, other.polyline) &&
        confidence == other.confidence &&
        distanceMeters == other.distanceMeters &&
        durationSeconds == other.durationSeconds &&
        statusMessage == other.statusMessage &&
        walkMinutes == other.walkMinutes &&
        leaveInMinutes == other.leaveInMinutes &&
        isLeaveNow == other.isLeaveNow &&
        isLate == other.isLate &&
        formattedDuration == other.formattedDuration &&
        formattedDistance == other.formattedDistance;
  }

  @override
  int get hashCode => const ListEquality().hash([
        distanceM,
        durationMin,
        polyline,
        confidence,
        distanceMeters,
        durationSeconds,
        statusMessage,
        walkMinutes,
        leaveInMinutes,
        isLeaveNow,
        isLate,
        formattedDuration,
        formattedDistance
      ]);
}

RouteResultStruct createRouteResultStruct({
  double? distanceM,
  int? durationMin,
  String? confidence,
  double? distanceMeters,
  int? durationSeconds,
  String? statusMessage,
  int? walkMinutes,
  int? leaveInMinutes,
  bool? isLeaveNow,
  bool? isLate,
  String? formattedDuration,
  String? formattedDistance,
}) =>
    RouteResultStruct(
      distanceM: distanceM,
      durationMin: durationMin,
      confidence: confidence,
      distanceMeters: distanceMeters,
      durationSeconds: durationSeconds,
      statusMessage: statusMessage,
      walkMinutes: walkMinutes,
      leaveInMinutes: leaveInMinutes,
      isLeaveNow: isLeaveNow,
      isLate: isLate,
      formattedDuration: formattedDuration,
      formattedDistance: formattedDistance,
    );
