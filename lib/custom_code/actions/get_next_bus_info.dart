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

import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

Future<NextBusInfoStruct?> getNextBusInfo(
  List<BusRouteStruct> routes,
) async {
  if (routes.isEmpty) return null;

  double userLat;
  double userLng;
  try {
    final position = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.medium,
    ).timeout(const Duration(seconds: 5));
    userLat = position.latitude;
    userLng = position.longitude;
  } on TimeoutException {
    return null; // location fetch took too long — distinct from permission issues
  } catch (_) {
    // covers LocationServiceDisabledException, PermissionDeniedException, etc.
    // if you want to surface "enable location" vs "no bus nearby" differently
    // in the UI, this is the branch to split further.
    return null;
  }

  const Map<String, List<double>> campusStops = {
    'Mega Hostel Boys': [11.317167, 75.937750],
    'Ladies Hostel': [11.318306, 75.931000],
    'South Campus': [11.314861, 75.932639],
    'Main Gate': [11.320083, 75.932722],
    'Center Circle': [11.321333, 75.934083],
    'Architecture': [11.323028, 75.936722],
    'East Campus': [11.323361, 75.937194],
    'Department Building': [11.321778, 75.935111],
  };
  const double maxRadiusMeters = 600.0;
  const double walkingSpeedMetersPerMin = 80.0;

  String? nearestStop;
  double nearestDist = double.infinity;
  for (final entry in campusStops.entries) {
    final d =
        _haversineMeters(userLat, userLng, entry.value[0], entry.value[1]);
    if (d < nearestDist) {
      nearestDist = d;
      nearestStop = entry.key;
    }
  }
  if (nearestStop == null || nearestDist > maxRadiusMeters) return null;

  final now = DateTime.now();
  final nowMin = _minutesSinceMidnight(now);

  BusRouteStruct? bestRoute;
  BusTimingStruct? bestTiming;
  int bestDepartureMin = 1 << 30;
  int bestIndexInSorted = -1;
  List<BusTimingStruct>? bestSortedTimings;

  for (final route in routes) {
    if (!route.isActive) continue;
    if (route.timings.isEmpty) continue;

    // Only consider routes that actually serve the user's nearest stop.
    // Requires BusRoute.stopNames (List<String>) on the schema.
    if (!route.stopsSummary.contains(nearestStop)) continue;

    // Sort by ACTUAL departure time, not sortOrder — sortOrder is a
    // CMS display-order field and isn't guaranteed to track chronology.
    final sorted = List<BusTimingStruct>.from(route.timings)
      ..sort((a, b) =>
          _toMinutes(a.departureTime).compareTo(_toMinutes(b.departureTime)));

    for (var i = 0; i < sorted.length; i++) {
      final m = _toMinutes(sorted[i].departureTime);
      if (m >= nowMin) {
        if (m < bestDepartureMin) {
          bestDepartureMin = m;
          bestRoute = route;
          bestTiming = sorted[i];
          bestIndexInSorted = i;
          bestSortedTimings = sorted;
        }
        break; // safe now — list is genuinely time-sorted
      }
    }
  }

  if (bestRoute == null || bestTiming == null || bestSortedTimings == null) {
    // No route serving the nearest stop has a bus left today.
    // Consider a next-day fallback here if the UI needs one.
    return null;
  }

  final hasAnotherBusToday = bestIndexInSorted + 1 < bestSortedTimings.length;
  final minutesRemaining = bestDepartureMin - nowMin;
  final walkMinutes = (nearestDist / walkingSpeedMetersPerMin).ceil();

  final departureDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    bestDepartureMin ~/ 60,
    bestDepartureMin % 60,
  );

  return NextBusInfoStruct(
    routeName: bestRoute.routeName,
    nearestStop: nearestStop,
    departureTime: departureDateTime,
    minutesRemaining: minutesRemaining,
    isSpecial: bestTiming.isSpecial,
    hasAnotherBusToday: hasAnotherBusToday,
    walkingDistanceMeters: nearestDist.round(),
    walkingTimeMinutes: walkMinutes,
    lastUpdated: now,
    isAvailable: true,
    locatedPermissionEnabled: true, // we got here, so location was granted
  );
}

double _haversineMeters(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371000.0;
  final dLat = (lat2 - lat1) * pi / 180;
  final dLng = (lng2 - lng1) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) *
          cos(lat2 * pi / 180) *
          sin(dLng / 2) *
          sin(dLng / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return r * c;
}

int _toMinutes(String hhmm) {
  final parts = hhmm.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

int _minutesSinceMidnight(DateTime dt) => dt.hour * 60 + dt.minute;
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
