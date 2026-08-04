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

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openGoogleCalendar(String? calendarId) async {
  const appUri = 'googlecalendar://';

  final webUri = (calendarId != null && calendarId.trim().isNotEmpty)
      ? 'https://calendar.google.com/calendar/u/0/r?cid=${Uri.encodeComponent(calendarId)}'
      : 'https://calendar.google.com/calendar/u/0/r';

  try {
    // Try opening the Google Calendar app first.
    if (await canLaunchUrl(Uri.parse(appUri))) {
      return await launchUrl(
        Uri.parse(appUri),
        mode: LaunchMode.externalApplication,
      );
    }

    // Fallback to the web version, opening the specific calendar if available.
    return await launchUrl(
      Uri.parse(webUri),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    debugPrint('Failed to open Google Calendar: $e');
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
