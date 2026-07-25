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

Future<void> connectGoogleCalendar() async {
  try {
    final session = SupaFlow.client.auth.currentSession;

    if (session == null) {
      throw Exception('User is not authenticated.');
    }

    final response = await SupaFlow.client.functions.invoke(
      'google-calendar-auth',
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
    );

    if (response.data == null) {
      throw Exception('No response from Edge Function.');
    }

    final authUrl = response.data['auth_url'];

    if (authUrl == null || authUrl.toString().isEmpty) {
      throw Exception('Authorization URL not returned.');
    }

    final uri = Uri.parse(authUrl);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch Google authentication.');
    }
  } catch (e, stack) {
    debugPrint('Google Calendar OAuth Error');
    debugPrint(e.toString());
    debugPrint(stack.toString());

    rethrow;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
