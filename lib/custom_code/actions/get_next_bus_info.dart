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

import 'package:geolocator/geolocator.dart';

Future<RouteResultStruct> getNextBusInfo(
  List<BusRouteStruct>? routes,
  LatLng? userLocation,
) async {
  const double fallbackLat = 11.321333;
  const double fallbackLng = 75.934083;

  // ---------------------------------------------------------------------------
  // 1. Resolve location
  // ---------------------------------------------------------------------------

  double? lat = userLocation?.latitude;
  double? lng = userLocation?.longitude;

  final hasValidLocation = lat != null &&
      lng != null &&
      lat.isFinite &&
      lng.isFinite &&
      lat != 0.0 &&
      lng != 0.0;

  // ---------------------------------------------------------------------------
  // 2. Prefer last known location
  // ---------------------------------------------------------------------------

  if (!hasValidLocation) {
    lat = null;
    lng = null;

    try {
      final lastKnown = await Geolocator.getLastKnownPosition();

      if (lastKnown != null &&
          lastKnown.latitude.isFinite &&
          lastKnown.longitude.isFinite &&
          lastKnown.latitude != 0.0 &&
          lastKnown.longitude != 0.0) {
        lat = lastKnown.latitude;
        lng = lastKnown.longitude;
      }
    } catch (e) {
      debugPrint('Last known location error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 3. Get fresh GPS only when necessary
  // ---------------------------------------------------------------------------

  if (lat == null || lng == null) {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (serviceEnabled) {
        var permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever) {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
            ),
          ).timeout(
            const Duration(seconds: 5),
          );

          if (position.latitude.isFinite &&
              position.longitude.isFinite &&
              position.latitude != 0.0 &&
              position.longitude != 0.0) {
            lat = position.latitude;
            lng = position.longitude;
          }
        }
      }
    } catch (e) {
      debugPrint('Current location error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 4. Fallback location
  // ---------------------------------------------------------------------------

  lat ??= fallbackLat;
  lng ??= fallbackLng;

  // ---------------------------------------------------------------------------
  // 5. Build allowed route IDs
  // ---------------------------------------------------------------------------

  final Set<String> allowedBusIds = routes == null
      ? <String>{}
      : routes
          .map((route) => route.busId.trim())
          .where((id) => id.isNotEmpty)
          .toSet();

  // ---------------------------------------------------------------------------
  // 6. Query Supabase
  // ---------------------------------------------------------------------------

  try {
    final response = await SupaFlow.client.rpc(
      'get_upcoming_buses',
      params: {
        'p_user_lat': lat,
        'p_user_lng': lng,
      },
    );

    if (response == null) {
      return _emptyRouteResult();
    }

    // -------------------------------------------------------------------------
    // Normalize RPC response
    // -------------------------------------------------------------------------

    final List<dynamic> rows;

    if (response is String) {
      final decoded = jsonDecode(response);

      if (decoded is! List) {
        return _emptyRouteResult();
      }

      rows = decoded;
    } else if (response is List) {
      rows = response;
    } else {
      return _emptyRouteResult();
    }

    // -------------------------------------------------------------------------
    // 7. Process returned routes
    // -------------------------------------------------------------------------

    for (final rawRow in rows) {
      if (rawRow is! Map) {
        continue;
      }

      final row = Map<String, dynamic>.from(rawRow);

      final busId = _stringValue(
        row['busId'] ?? row['bus_id'],
      );

      // If routes were supplied, only process those routes.
      if (allowedBusIds.isNotEmpty && !allowedBusIds.contains(busId)) {
        continue;
      }

      final routeName = _stringValue(
        row['routeName'] ?? row['route_name'],
      );

      final nearestStopName = _stringValue(
        row['nearestStopName'] ??
            row['nearest_stop_name'] ??
            row['nearest_stop'],
      );

      final walkTimeMinutes = _intValue(
        row['walkTimeMinutes'] ?? row['walk_time_minutes'] ?? row['walk_time'],
      );

      // -----------------------------------------------------------------------
      // 8. Parse timings
      // -----------------------------------------------------------------------

      final rawTimings = row['timings'];

      final parsedArrivals = <Map<String, dynamic>>[];

      if (rawTimings is List) {
        for (final rawTiming in rawTimings) {
          if (rawTiming is! Map) {
            continue;
          }

          final timing = Map<String, dynamic>.from(rawTiming);

          final destination = _stringValue(
            timing['destination'] ??
                timing['destination_name'] ??
                timing['stop_name'],
          );

          final arrivalTime = _parseDateTime(
            timing['arrivalTime'] ??
                timing['arrival_time'] ??
                timing['scheduledTime'] ??
                timing['scheduled_time'],
          );

          if (arrivalTime == null) {
            continue;
          }

          final now = DateTime.now();

          final difference = arrivalTime.difference(now);

          // Ignore buses that have already departed.
          if (difference.isNegative) {
            continue;
          }

          // Calculate minutes remaining.
          //
          // ceil() prevents a bus arriving in 30 seconds from being
          // displayed as "0 minutes" when it has not actually arrived.
          final arrivalMinutes = (difference.inSeconds / 60).ceil();

          parsedArrivals.add({
            'destination': destination,
            'arrivalTime': arrivalTime,
            'arrivalMinutes': arrivalMinutes,
          });
        }
      }

      // -----------------------------------------------------------------------
      // 9. Sort by arrival time
      // -----------------------------------------------------------------------

      parsedArrivals.sort(
        (a, b) {
          final DateTime aTime = a['arrivalTime'] as DateTime;

          final DateTime bTime = b['arrivalTime'] as DateTime;

          return aTime.compareTo(bTime);
        },
      );

      // -----------------------------------------------------------------------
      // 10. Build BusArrivalStruct list
      // -----------------------------------------------------------------------

      final arrivals = <BusArrivalStruct>[];

      for (int i = 0; i < parsedArrivals.length; i++) {
        final arrival = parsedArrivals[i];

        final DateTime arrivalTime = arrival['arrivalTime'] as DateTime;

        final String destination = arrival['destination'] as String;

        final int arrivalMinutes = arrival['arrivalMinutes'] as int;

        arrivals.add(
          BusArrivalStruct(
            busId: busId,
            destination: destination,
            arrivalMinutes: arrivalMinutes,
            arrivalTime: arrivalTime,
            isNext: i == 0,
            isAvailable: true,
          ),
        );
      }

      // -----------------------------------------------------------------------
      // 11. Determine next bus
      // -----------------------------------------------------------------------

      final bool hasAvailableBus = arrivals.isNotEmpty;

      final BusArrivalStruct? nextBus = hasAvailableBus ? arrivals.first : null;

      // -----------------------------------------------------------------------
      // 12. Return RouteResultStruct
      // -----------------------------------------------------------------------

      return RouteResultStruct(
        busId: busId,
        routeName: routeName,
        walkTimeMinutes: walkTimeMinutes,
        nearestStopName: nearestStopName,
        nextBusDestination: nextBus?.destination ?? '',
        nextBusMinutes: nextBus?.arrivalMinutes ?? 0,
        nextBusTime: nextBus?.arrivalTime ?? DateTime.now(),
        availableBuses: arrivals,
        updatedAt: DateTime.now(),
        hasAvailableBus: hasAvailableBus,
      );
    }

    // -------------------------------------------------------------------------
    // No matching route
    // -------------------------------------------------------------------------

    return _emptyRouteResult();
  } catch (e, stackTrace) {
    debugPrint(
      'get_upcoming_buses error: $e',
    );

    debugPrint(
      '$stackTrace',
    );

    return _emptyRouteResult();
  }
}

// -----------------------------------------------------------------------------
// Empty RouteResultStruct
// -----------------------------------------------------------------------------

RouteResultStruct _emptyRouteResult() {
  return RouteResultStruct(
    busId: '',
    routeName: '',
    walkTimeMinutes: 0,
    nearestStopName: '',
    nextBusDestination: '',
    nextBusMinutes: 0,
    nextBusTime: DateTime.now(),
    availableBuses: [],
    updatedAt: DateTime.now(),
    hasAvailableBus: false,
  );
}

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------

String _stringValue(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString();
}

int _intValue(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is double) {
    return value.round();
  }

  return int.tryParse(
        value?.toString() ?? '',
      ) ??
      0;
}

DateTime? _parseDateTime(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is DateTime) {
    return value;
  }

  return DateTime.tryParse(
    value.toString(),
  );
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
