// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:developer' as developer;
import 'dart:math';

/// Custom Action: Direct Supabase RPC Graph Walk Routing using LatLng.
///
/// Calls the Supabase RPC `get_shortest_walk_route` directly.
/// Computes shortest path over NIT Calicut graph database in Postgres using pgRouting.
Future<RouteResultStruct> calculateWalkRoute(
  LatLng origin,
  LatLng destination,
  bool includeGeometry,
  DateTime? targetArrivalTime,
) async {
  final double originLat = origin.latitude;
  final double originLng = origin.longitude;
  final double destLat = destination.latitude;
  final double destLng = destination.longitude;

  if (!_isValidCoordinate(originLat, originLng) || !_isValidCoordinate(destLat, destLng)) {
    return _buildEmptyResult(confidence: 'none');
  }

  if (_haversineMeters(originLat, originLng, destLat, destLng) < 15.0) {
    return _buildEmptyResult(confidence: 'exact');
  }

  try {
    final dynamic response = await SupaFlow.client.rpc(
      'get_shortest_walk_route',
      params: {
        'p_origin_lat': originLat,
        'p_origin_lng': originLng,
        'p_dest_lat': destLat,
        'p_dest_lng': destLng,
        'p_class_start_time': targetArrivalTime?.toUtc().toIso8601String(),
      },
    );

    if (response == null) {
      return _localHaversineFallback(originLat, originLng, destLat, destLng, targetArrivalTime);
    }

    final Map<String, dynamic> data = response is String
        ? jsonDecode(response) as Map<String, dynamic>
        : Map<String, dynamic>.from(response as Map);

    if (data.containsKey('error')) {
      return _localHaversineFallback(originLat, originLng, destLat, destLng, targetArrivalTime);
    }

    return RouteResultStruct.fromMap(data);
  } catch (e) {
    developer.log('calculateWalkRoute RPC exception: $e', name: 'Navigation');
    return _localHaversineFallback(originLat, originLng, destLat, destLng, targetArrivalTime);
  }
}

RouteResultStruct _localHaversineFallback(
  double oLat, double oLng, double dLat, double dLng,
  DateTime? targetArrivalTime,
) {
  final estimatedMeters = _haversineMeters(oLat, oLng, dLat, dLng) * 1.18;
  final durationSeconds = (estimatedMeters / 1.30).round();
  final walkMinutes = durationSeconds == 0 ? 0 : max(1, (durationSeconds / 60.0).ceil());

  int leaveInMinutes = 0;
  bool isLeaveNow = false;
  bool isLate = false;
  String statusMsg = '$walkMinutes ${walkMinutes == 1 ? 'min' : 'mins'} walk';

  if (targetArrivalTime != null) {
    final diffSeconds = targetArrivalTime
        .subtract(Duration(seconds: durationSeconds))
        .difference(DateTime.now())
        .inSeconds;
    leaveInMinutes = (diffSeconds / 60.0).round();
    if (diffSeconds < -60) {
      isLate = true;
      final lateMins = (diffSeconds.abs() / 60.0).round();
      statusMsg = 'Running $lateMins ${lateMins == 1 ? 'min' : 'mins'} late';
    } else if (diffSeconds <= 120) {
      isLeaveNow = true;
      statusMsg = 'Leave now';
    } else {
      statusMsg = 'Leave in $leaveInMinutes ${leaveInMinutes == 1 ? 'min' : 'mins'}';
    }
  }

  return RouteResultStruct(
    distanceMeters: estimatedMeters,
    formattedDistance: estimatedMeters < 1000
        ? '${(estimatedMeters / 10).round() * 10} m'
        : '${(estimatedMeters / 1000.0).toStringAsFixed(1)} km',
    durationSeconds: durationSeconds,
    formattedDuration: '$walkMinutes ${walkMinutes == 1 ? 'min' : 'mins'}',
    walkMinutes: walkMinutes,
    leaveInMinutes: leaveInMinutes,
    isLeaveNow: isLeaveNow,
    isLate: isLate,
    statusMessage: statusMsg,
    polyline: const [],
    confidence: 'approximate',
  );
}

RouteResultStruct _buildEmptyResult({required String confidence}) {
  return RouteResultStruct(
    distanceMeters: 0,
    formattedDistance: '',
    durationSeconds: 0,
    formattedDuration: '',
    walkMinutes: 0,
    leaveInMinutes: 0,
    isLeaveNow: false,
    isLate: false,
    statusMessage: '',
    polyline: const [],
    confidence: confidence,
  );
}

bool _isValidCoordinate(double lat, double lng) =>
    !lat.isNaN && !lng.isNaN && lat >= -90.0 && lat <= 90.0 && lng >= -180.0 && lng <= 180.0;

double _haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371000.0;
  final dLat = (lat2 - lat1) * (pi / 180.0);
  final dLon = (lon2 - lon1) * (pi / 180.0);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180.0) * cos(lat2 * pi / 180.0) * sin(dLon / 2) * sin(dLon / 2);
  return R * 2 * atan2(sqrt(a), sqrt(1 - a));
}
