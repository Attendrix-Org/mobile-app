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

Future<List<DateTime>> generateTimeline(
  DateTime selectedDate,
  List<DateTime> startTimes,
  List<DateTime> endTimes,
) async {
  const int startHour = 7;
  const int endHour = 18;

  assert(startTimes.length == endTimes.length);

  final timeline = <DateTime>{};

  // Add hourly markers only if they are not inside a class.
  for (int hour = startHour; hour <= endHour; hour++) {
    final marker = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
    );

    bool insideClass = false;

    for (int i = 0; i < startTimes.length; i++) {
      final start = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startTimes[i].hour,
        startTimes[i].minute,
      );

      final end = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        endTimes[i].hour,
        endTimes[i].minute,
      );

      if (marker.isAfter(start) && marker.isBefore(end)) {
        insideClass = true;
        break;
      }
    }

    if (!insideClass) {
      timeline.add(marker);
    }
  }

  // Always include every class start.
  for (final start in startTimes) {
    final normalized = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      start.hour,
      start.minute,
    );

    timeline.add(normalized);
  }

  return timeline.toList()..sort();
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
