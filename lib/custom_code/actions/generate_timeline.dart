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
  List<DateTime>? startTimes,
  List<DateTime>? endTimes,
) async {
  const int startHour = 7;
  const int endHour = 18;

  final starts = startTimes ?? [];
  final ends = endTimes ?? [];

  assert(starts.length == ends.length);

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

    for (int i = 0; i < starts.length; i++) {
      final start = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        starts[i].hour,
        starts[i].minute,
      );

      final end = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        ends[i].hour,
        ends[i].minute,
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
  for (final start in starts) {
    timeline.add(
      DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        start.hour,
        start.minute,
      ),
    );
  }

  return timeline.toList()..sort();
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
