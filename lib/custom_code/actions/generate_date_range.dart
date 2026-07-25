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

Future<List<DateTime>> generateDateRange(
  DateTime startDate,
  DateRange dateRange,
  WeekendPolicy weekendPolicy,
) async {
  final days = switch (dateRange) {
    DateRange.sevenDays => 7,
    DateRange.tenDays => 10,
    DateRange.thirtyDays => 30,
  };

  final result = <DateTime>[];

  final normalizedStart = DateTime(
    startDate.year,
    startDate.month,
    startDate.day,
  );

  var current = normalizedStart;

  while (result.length < days) {
    final isStartDay = current == normalizedStart;

    final isSaturday = current.weekday == DateTime.saturday;
    final isSunday = current.weekday == DateTime.sunday;

    final include = isStartDay ||
        switch (weekendPolicy) {
          WeekendPolicy.includeAll => true,
          WeekendPolicy.excludeAll => !isSaturday && !isSunday,
          WeekendPolicy.excludeSaturdays => !isSaturday,
          WeekendPolicy.excludeSundays => !isSunday,
        };

    if (include) {
      result.add(current);
    }

    current = current.add(const Duration(days: 1));
  }

  return result;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
