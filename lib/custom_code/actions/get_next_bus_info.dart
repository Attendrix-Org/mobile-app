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
import 'package:geolocator/geolocator.dart';

/// Pure Server-Side Bus Info Action using Supabase RPC `get_upcoming_buses`.
///
/// Automatically queries Supabase Postgres database directly (`buses`, `bus_timings`, `bus_stops`).
/// Takes optional `routes` list and `userLocation` as a FlutterFlow LatLng.
Future<List<NextBusInfoStruct>> getNextBusInfo(
  List<BusRouteStruct>? routes,
  LatLng? userLocation,
) async {
  double lat = userLocation?.latitude ?? 0.0;
  double lng = userLocation?.longitude ?? 0.0;

  // Fetch device GPS location if location wasn't passed or is 0.0
  if (lat == 0.0 || lng == 0.0) {
    try {
      final position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(const Duration(seconds: 5));
      lat = position.latitude;
      lng = position.longitude;
    } catch (_) {
      // Default fallback to central NIT Calicut coordinates
      lat = 11.321333;
      lng = 75.934083;
    }
  }

  try {
    final response = await SupaFlow.client.rpc(
      'get_upcoming_buses',
      params: {
        'p_user_lat': lat,
        'p_user_lng': lng,
      },
    );

    if (response != null) {
      final List<dynamic> list = response is String
          ? (jsonDecode(response) as List<dynamic>)
          : (response as List<dynamic>);

      return list
          .map((item) =>
              NextBusInfoStruct.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
  } catch (e) {
    debugPrint('get_upcoming_buses RPC exception: $e');
  }

  return [];
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
