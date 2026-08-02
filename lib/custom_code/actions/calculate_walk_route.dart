// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
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

  if (!_isValidCoordinate(originLat, originLng) ||
      !_isValidCoordinate(destLat, destLng)) {
    return _buildEmptyResult(confidence: 'none');
  }

  final rawHaversineMeters = _haversineMeters(origin, destination);
  if (rawHaversineMeters < _zeroDistanceThresholdM) {
    return _buildResult(
      distanceMeters: 0.0,
      durationSeconds: 0,
      polyline: [],
      confidence: 'exact',
      targetArrivalTime: targetArrivalTime,
    );
  }

  // Cache path — only for time-only requests (dashboard/timetable), never for the drawn map route.
  if (!includeGeometry && destinationBuildingId != null) {
    final originBuildingId = await _nearestBuildingId(origin);
    if (originBuildingId != null) {
      final cached = await _readCache(originBuildingId, destinationBuildingId);
      if (cached != null) {
        return _buildResult(
          distanceMeters: (cached['distance_meters'] as num).toDouble(),
          durationSeconds: (cached['duration_seconds'] as num).toInt(),
          polyline: [],
          confidence: (cached['confidence'] ?? 'approximate').toString(),
          targetArrivalTime: targetArrivalTime,
        );
      }
    }

    final result =
        await _callOrsAndFallback(origin, destination, false, orsApiKey);

    if (originBuildingId != null && result['confidence'] != 'none') {
      unawaited(_writeCache(
        originBuildingId,
        destinationBuildingId,
        result['distanceMeters'] as double,
        result['durationSeconds'] as int,
        result['confidence'] as String,
      ));
    }

    return _buildResult(
      distanceMeters: result['distanceMeters'] as double,
      durationSeconds: result['durationSeconds'] as int,
      polyline: const [],
      confidence: result['confidence'] as String,
      targetArrivalTime: targetArrivalTime,
    );
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
      return _localHaversineFallback(
          originLat, originLng, destLat, destLng, targetArrivalTime);
    }

    final Map<String, dynamic> data = response is String
        ? jsonDecode(response) as Map<String, dynamic>
        : Map<String, dynamic>.from(response as Map);

    if (data.containsKey('error')) {
      return _localHaversineFallback(
          originLat, originLng, destLat, destLng, targetArrivalTime);
    }

    return RouteResultStruct.fromMap(data);
  } catch (e) {
    developer.log('calculateWalkRoute RPC exception: $e', name: 'Navigation');
    return _localHaversineFallback(
        originLat, originLng, destLat, destLng, targetArrivalTime);
  }
}

Map<String, dynamic> _fallbackData(
  LatLng origin,
  LatLng destination,
  String confidence,
) {
  final straightLineMeters = _haversineMeters(origin, destination);
  final estimatedMeters = straightLineMeters * _campusDetourFactor;
  final durationSeconds = (estimatedMeters / _fallbackWalkSpeedMps).round();
  return {
    'distanceMeters': estimatedMeters,
    'durationSeconds': durationSeconds,
    'polyline': null,
    'confidence': confidence,
  };
}

Future<String?> _nearestBuildingId(LatLng point) async {
  try {
    final rows =
        await SupaFlow.client.from('campus_buildings').select('id, lat, lng');
    String? bestId;
    double bestDist = double.infinity;
    for (final row in rows as List) {
      final latVal = row['lat'];
      final lngVal = row['lng'] ?? row['lon'];
      if (latVal != null && lngVal != null) {
        final d = _haversineMeters(
          point,
          LatLng((latVal as num).toDouble(), (lngVal as num).toDouble()),
        );
        if (d < bestDist) {
          bestDist = d;
          bestId = row['id'] as String;
        }
      }
    }
    return bestId;
  } catch (e) {
    developer.log('Nearest-building lookup failed: $e', name: 'Navigation');
    return null; // caller falls through to a live ORS call, uncached — safe degradation
  }
}

Future<Map<String, dynamic>?> _readCache(String originId, String destId) async {
  try {
    final rows = await SupaFlow.client
        .from('route_cache')
        .select('distance_meters, duration_seconds, confidence, computed_at')
        .eq('origin_building_id', originId)
        .eq('destination_building_id', destId)
        .limit(1);
    if (rows is List && rows.isNotEmpty) {
      final row = rows.first;
      final computedAt = DateTime.parse(row['computed_at'] as String);
      if (DateTime.now().difference(computedAt) < _cacheTtl) {
        return row as Map<String, dynamic>;
      }
    }
  } catch (e) {
    developer.log('Cache read failed: $e', name: 'Navigation');
  }
  return null;
}

Future<void> _writeCache(
  String originId,
  String destId,
  double distanceMeters,
  int durationSeconds,
  String confidence,
) async {
  try {
    await SupaFlow.client.from('route_cache').upsert({
      'origin_building_id': originId,
      'destination_building_id': destId,
      'distance_meters': distanceMeters,
      'duration_seconds': durationSeconds,
      'confidence': confidence,
      'computed_at': DateTime.now().toIso8601String(),
    });
  } catch (e) {
    developer.log('Cache write failed: $e', name: 'Navigation');
  }
}

RouteResultStruct _buildResult({
  required double distanceMeters,
  required int durationSeconds,
  required List<LatLng> polyline,
  required String confidence,
  DateTime? targetArrivalTime,
) {
  final estimatedMeters = _haversineMeters(oLat, oLng, dLat, dLng) * 1.18;
  final durationSeconds = (estimatedMeters / 1.30).round();
  final walkMinutes =
      durationSeconds == 0 ? 0 : max(1, (durationSeconds / 60.0).ceil());

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
      statusMsg =
          'Leave in $leaveInMinutes ${leaveInMinutes == 1 ? 'min' : 'mins'}';
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
    !lat.isNaN &&
    !lng.isNaN &&
    lat >= -90.0 &&
    lat <= 90.0 &&
    lng >= -180.0 &&
    lng <= 180.0;

double _haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371000.0;
  final dLat = (lat2 - lat1) * (pi / 180.0);
  final dLon = (lon2 - lon1) * (pi / 180.0);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180.0) *
          cos(lat2 * pi / 180.0) *
          sin(dLon / 2) *
          sin(dLon / 2);
  return R * 2 * atan2(sqrt(a), sqrt(1 - a));
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
