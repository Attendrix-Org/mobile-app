import '/backend/schema/util/schema_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class RouteResultStruct extends BaseStruct {
  RouteResultStruct({
    List<LatLng>? polyline,
    double? distanceMeters,
    String? formattedDistance,
    int? durationSeconds,
    String? formattedDuration,
    int? walkMinutes,
    int? leaveInMinutes,
    String? confidence,
    bool? isLate,
    bool? isLeaveNow,
    String? statusMessage,
    DateTime? departureTime,
    DateTime? arrivalTime,
  })  : _polyline = polyline,
        _distanceMeters = distanceMeters,
        _formattedDistance = formattedDistance,
        _durationSeconds = durationSeconds,
        _formattedDuration = formattedDuration,
        _walkMinutes = walkMinutes,
        _leaveInMinutes = leaveInMinutes,
        _confidence = confidence,
        _isLate = isLate,
        _isLeaveNow = isLeaveNow,
        _statusMessage = statusMessage,
        _departureTime = departureTime,
        _arrivalTime = arrivalTime;

  List<LatLng>? _polyline;
  List<LatLng> get polyline => _polyline ?? [];
  set polyline(List<LatLng>? val) => _polyline = val;
  bool hasPolyline() => _polyline != null;

  double? _distanceMeters;
  double get distanceMeters => _distanceMeters ?? 0.0;
  set distanceMeters(double? val) => _distanceMeters = val;
  bool hasDistanceMeters() => _distanceMeters != null;

  String? _formattedDistance;
  String get formattedDistance => _formattedDistance ?? '';
  set formattedDistance(String? val) => _formattedDistance = val;
  bool hasFormattedDistance() => _formattedDistance != null;

  int? _durationSeconds;
  int get durationSeconds => _durationSeconds ?? 0;
  set durationSeconds(int? val) => _durationSeconds = val;
  bool hasDurationSeconds() => _durationSeconds != null;

  String? _formattedDuration;
  String get formattedDuration => _formattedDuration ?? '';
  set formattedDuration(String? val) => _formattedDuration = val;
  bool hasFormattedDuration() => _formattedDuration != null;

  int? _walkMinutes;
  int get walkMinutes => _walkMinutes ?? 0;
  set walkMinutes(int? val) => _walkMinutes = val;
  bool hasWalkMinutes() => _walkMinutes != null;

  int? _leaveInMinutes;
  int get leaveInMinutes => _leaveInMinutes ?? 0;
  set leaveInMinutes(int? val) => _leaveInMinutes = val;
  bool hasLeaveInMinutes() => _leaveInMinutes != null;

  String? _confidence;
  String get confidence => _confidence ?? 'none';
  set confidence(String? val) => _confidence = val;
  bool hasConfidence() => _confidence != null;

  bool? _isLate;
  bool get isLate => _isLate ?? false;
  set isLate(bool? val) => _isLate = val;
  bool hasIsLate() => _isLate != null;

  bool? _isLeaveNow;
  bool get isLeaveNow => _isLeaveNow ?? false;
  set isLeaveNow(bool? val) => _isLeaveNow = val;
  bool hasIsLeaveNow() => _isLeaveNow != null;

  String? _statusMessage;
  String get statusMessage => _statusMessage ?? '';
  set statusMessage(String? val) => _statusMessage = val;
  bool hasStatusMessage() => _statusMessage != null;

  DateTime? _departureTime;
  DateTime? get departureTime => _departureTime;
  set departureTime(DateTime? val) => _departureTime = val;
  bool hasDepartureTime() => _departureTime != null;

  DateTime? _arrivalTime;
  DateTime? get arrivalTime => _arrivalTime;
  set arrivalTime(DateTime? val) => _arrivalTime = val;
  bool hasArrivalTime() => _arrivalTime != null;

  static RouteResultStruct fromMap(Map<String, dynamic> data) => RouteResultStruct(
        polyline: data['polyline'] != null
            ? (data['polyline'] as List)
                .map((e) => e is LatLng ? e : LatLng(e['latitude'] as double, e['longitude'] as double))
                .toList()
            : null,
        distanceMeters: castToNum(data['distanceMeters'] ?? data['distance_meters'])?.toDouble(),
        formattedDistance: (data['formattedDistance'] ?? data['formatted_distance'])?.toString(),
        durationSeconds: castToNum(data['durationSeconds'] ?? data['duration_seconds'])?.toInt(),
        formattedDuration: (data['formattedDuration'] ?? data['formatted_duration'])?.toString(),
        walkMinutes: castToNum(data['walkMinutes'] ?? data['walk_minutes'])?.toInt(),
        leaveInMinutes: castToNum(data['leaveInMinutes'] ?? data['leave_in_minutes'])?.toInt(),
        confidence: data['confidence']?.toString(),
        isLate: data['isLate'] ?? data['is_late'],
        isLeaveNow: data['isLeaveNow'] ?? data['is_leave_now'],
        statusMessage: (data['statusMessage'] ?? data['status_message'])?.toString(),
        departureTime: data['departureTime'] != null
            ? DateTime.tryParse(data['departureTime'].toString())
            : null,
        arrivalTime: data['arrivalTime'] != null
            ? DateTime.tryParse(data['arrivalTime'].toString())
            : null,
      );

  @override
  Map<String, dynamic> toMap() => {
        'polyline': _polyline,
        'distanceMeters': _distanceMeters,
        'formattedDistance': _formattedDistance,
        'durationSeconds': _durationSeconds,
        'formattedDuration': _formattedDuration,
        'walkMinutes': _walkMinutes,
        'leaveInMinutes': _leaveInMinutes,
        'confidence': _confidence,
        'isLate': _isLate,
        'isLeaveNow': _isLeaveNow,
        'statusMessage': _statusMessage,
        'departureTime': _departureTime?.toIso8601String(),
        'arrivalTime': _arrivalTime?.toIso8601String(),
      };

  @override
  Map<String, dynamic> toSerializableMap() => toMap();

  static RouteResultStruct fromSerializableMap(Map<String, dynamic> data) => fromMap(data);
}
