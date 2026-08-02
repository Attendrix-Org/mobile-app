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

import 'dart:developer' as developer;
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:async';

const Duration _orsTimeout = Duration(seconds: 12);
const double _fallbackWalkSpeedMps = 1.30;
const double _campusDetourFactor = 1.18;
const double _zeroDistanceThresholdM = 15.0;
const Duration _cacheTtl = Duration(days: 90);

Future<RouteResultStruct> calculateWalkRoute(
  LatLng origin,
  LatLng destination,
  bool includeGeometry,
  DateTime? targetArrivalTime,
  String orsApiKey,
  String?
      destinationBuildingId, // pass the building's id when known — required for cache to engage
) async {
  if (!_isValidCoordinate(origin) || !_isValidCoordinate(destination)) {
    developer.log('Invalid coordinates provided to calculateWalkRoute',
        name: 'Navigation');
    return _buildResult(
      distanceMeters: 0,
      durationSeconds: 0,
      polyline: [],
      confidence: 'none',
      targetArrivalTime: targetArrivalTime,
    );
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
          distanceMeters: cached['distance_meters'] as double,
          durationSeconds: cached['duration_seconds'] as int,
          polyline: [],
          confidence: cached['confidence'] as String,
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

  // Map/navigate path — always live, always exact origin.
  final result = await _callOrsAndFallback(
      origin, destination, includeGeometry, orsApiKey);
  return _buildResult(
    distanceMeters: result['distanceMeters'] as double,
    durationSeconds: result['durationSeconds'] as int,
    polyline: (result['polyline'] as List<LatLng>?) ?? const [],
    confidence: result['confidence'] as String,
    targetArrivalTime: targetArrivalTime,
  );
}

Future<Map<String, dynamic>> _callOrsAndFallback(
  LatLng origin,
  LatLng destination,
  bool includeGeometry,
  String orsApiKey,
) async {
  final uri = Uri.parse(
      'https://api.openrouteservice.org/v2/directions/foot-walking/geojson');
  try {
    final response = await http
        .post(
          uri,
          headers: {
            'Authorization': orsApiKey,
            'Content-Type': 'application/json; charset=utf-8'
          },
          body: jsonEncode({
            'coordinates': [
              [origin.longitude, origin.latitude], // ORS expects [lon, lat]
              [destination.longitude, destination.latitude]
            ],
            'geometry': includeGeometry,
            'instructions': false,
            'elevation': false,
          }),
        )
        .timeout(_orsTimeout);

    if (response.statusCode != 200) {
      _logResponseError(response.statusCode);
      return _fallbackData(origin, destination, 'approximate');
    }

    final data = jsonDecode(response.body);
    final feature = data['features'][0];
    final summary = feature['properties']['summary'];
    final distanceMeters = (summary['distance'] as num).toDouble();
    final durationSeconds = (summary['duration'] as num).round();

    List<LatLng>? points;
    if (includeGeometry && feature['geometry'] != null) {
      final coords = feature['geometry']['coordinates'] as List;
      points = coords
          .map<LatLng>(
              (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
          .toList();
    }

    return {
      'distanceMeters': distanceMeters,
      'durationSeconds': durationSeconds,
      'polyline': points,
      'confidence': 'exact',
    };
  } catch (e) {
    developer.log('ORS request exception: $e', name: 'Navigation');
    return _fallbackData(origin, destination, 'approximate');
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
        await SupaFlow.client.from('campus_buildings').select('id, lat, lon');
    String? bestId;
    double bestDist = double.infinity;
    for (final row in rows as List) {
      final d = _haversineMeters(
        point,
        LatLng((row['lat'] as num).toDouble(), (row['lon'] as num).toDouble()),
      );
      if (d < bestDist) {
        bestDist = d;
        bestId = row['id'] as String;
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
}) {
  final int walkMinutes =
      durationSeconds == 0 ? 0 : max(1, (durationSeconds / 60.0).ceil());
  int leaveInMinutes = 0;
  bool isLeaveNow = false;
  bool isLate = false;
  String statusMsg = '';

  if (targetArrivalTime != null) {
    final now = DateTime.now();
    final requiredDeparture =
        targetArrivalTime.subtract(Duration(seconds: durationSeconds));
    final diffSeconds = requiredDeparture.difference(now).inSeconds;
    leaveInMinutes = (diffSeconds / 60.0).round();
    if (diffSeconds < -60) {
      isLate = true;
      final lateMins = (diffSeconds.abs() / 60.0).round();
      statusMsg = 'Running $lateMins ${_pluralize('min', lateMins)} late';
    } else if (diffSeconds <= 120) {
      isLeaveNow = true;
      statusMsg = 'Leave now';
    } else {
      statusMsg =
          'Leave in $leaveInMinutes ${_pluralize('min', leaveInMinutes)}';
    }
  } else {
    statusMsg = '$walkMinutes ${_pluralize('min', walkMinutes)} walk';
  }

  return RouteResultStruct(
    distanceMeters: distanceMeters,
    formattedDistance: _formatDistance(distanceMeters),
    durationSeconds: durationSeconds,
    walkMinutes: walkMinutes,
    leaveInMinutes: leaveInMinutes,
    isLeaveNow: isLeaveNow,
    isLate: isLate,
    statusMessage: statusMsg,
    polyline: polyline,
    confidence: confidence,
  );
}

bool _isValidCoordinate(LatLng point) =>
    !point.latitude.isNaN &&
    !point.longitude.isNaN &&
    point.latitude >= -90.0 &&
    point.latitude <= 90.0 &&
    point.longitude >= -180.0 &&
    point.longitude <= 180.0;

String _formatDistance(double meters) {
  if (meters < 1000) {
    final rounded10 = (meters / 10).round() * 10;
    return '$rounded10 m';
  }
  return '${(meters / 1000.0).toStringAsFixed(1)} km';
}

String _pluralize(String word, int count) => count == 1 ? word : '${word}s';

double _haversineMeters(LatLng a, LatLng b) {
  const R = 6371000.0;
  final dLat = _deg2rad(b.latitude - a.latitude);
  final dLon = _deg2rad(b.longitude - a.longitude);
  final lat1 = _deg2rad(a.latitude);
  final lat2 = _deg2rad(b.latitude);
  final h = (sin(dLat / 2) * sin(dLat / 2)) +
      cos(lat1) * cos(lat2) * (sin(dLon / 2) * sin(dLon / 2));
  final c = 2 * atan2(sqrt(h), sqrt(1 - h));
  return R * c;
}

double _deg2rad(double deg) => deg * (pi / 180.0);

void _logResponseError(int code) {
  switch (code) {
    case 400:
      developer.log(
          'ORS 400: Invalid routing payload or unroutable coordinates',
          name: 'Navigation');
      break;
    case 401:
    case 403:
      developer.log('ORS $code: Unauthorized API key', name: 'Navigation');
      break;
    case 429:
      developer.log('ORS 429: Rate limit reached', name: 'Navigation');
      break;
    default:
      developer.log('ORS $code: Server error', name: 'Navigation');
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
