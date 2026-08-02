// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:developer' as developer;

/// Custom Action to fetch CampusBuilding Data for a given buildingId.
/// Returns [CampusBuildingStruct].
///
/// Features:
/// 1. Verifies that currentTime is less than 1 hour away from [startTime].
/// 2. Checks if data already exists for [buildingId] in `FFAppState().campusBuildingData`.
/// 3. If cached, returns immediately without querying database.
/// 4. If not cached, queries Supabase table `campus_buildings`, caches result to AppState, and returns.
Future<CampusBuildingStruct?> getCampusBuildingData(
  String? buildingId,
  DateTime? startTime,
) async {
  if (buildingId == null || buildingId.trim().isEmpty) {
    return null;
  }

  // 1. Time Check: Verify currentTime is less than 1 Hour from startTime
  if (startTime != null) {
    final now = DateTime.now();
    final diffInSeconds = startTime.difference(now).inSeconds.abs();
    // 1 hour = 3600 seconds
    if (diffInSeconds > 3600) {
      developer.log(
        'getCampusBuildingData: Current time is more than 1 hour away from startTime ($diffInSeconds sec diff)',
        name: 'Navigation',
      );
      return null;
    }
  }

  final appState = FFAppState();

  // 2. Cache Check: Verify if data already exists for same buildingID in campusBuildingData List in AppState
  try {
    final cachedBuilding = appState.campusBuildingData.firstWhere(
      (b) => b.id == buildingId,
    );
    developer.log(
      'getCampusBuildingData: Returning cached building data from AppState for $buildingId',
      name: 'Navigation',
    );
    return cachedBuilding;
  } catch (_) {
    // Not found in cache — continue to query database
  }

  // 3. Query Database: Supabase table 'campus_buildings'
  try {
    final List<dynamic> rows = await SupaFlow.client
        .from('campus_buildings')
        .select()
        .eq('id', buildingId)
        .limit(1);

    if (rows.isNotEmpty) {
      final buildingData = Map<String, dynamic>.from(rows.first as Map);
      final buildingStruct = CampusBuildingStruct.fromMap(buildingData);

      // Cache to AppState
      appState.addToCampusBuildingData(buildingStruct);

      developer.log(
        'getCampusBuildingData: Fetched from DB and cached to AppState for $buildingId',
        name: 'Navigation',
      );
      return buildingStruct;
    }
  } catch (e) {
    developer.log('getCampusBuildingData exception: $e', name: 'Navigation');
  }

  return null;
}
