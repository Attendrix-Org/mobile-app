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
import 'package:supabase_flutter/supabase_flutter.dart';
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

    debugPrint('Status: ${response.status}');
    debugPrint('Response: ${response.data}');

    if (response.data == null) {
      throw Exception('No response from Edge Function.');
    }

    final data = Map<String, dynamic>.from(response.data);

    final authUrl = data['authorization_url']?.toString();

    if (authUrl == null || authUrl.isEmpty) {
      throw Exception('Authorization URL not found.');
    }

    debugPrint('OAuth URL: $authUrl');

    final uri = Uri.parse(authUrl);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Failed to launch OAuth URL.');
    }
  } on PostgrestException catch (e, stack) {
    debugPrint('PostgrestException');
    debugPrint(e.message);
    debugPrint(e.hint);
    debugPrint(stack.toString());
    rethrow;
  } catch (e, stack) {
    debugPrint('Google Calendar OAuth Error');
    debugPrint(e.toString());
    debugPrint(stack.toString());
    rethrow;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
