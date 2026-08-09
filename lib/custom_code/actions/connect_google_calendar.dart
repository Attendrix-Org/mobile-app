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

    // Automatically select web vs mobile deep link redirect URI
    final redirectUri = kIsWeb
        ? '${Uri.base.origin}/google-calendar'
        : 'attendrix://attendrix.app/google-calendar';

    final response = await SupaFlow.client.functions.invoke(
      'google-calendar-auth',
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: {
        'redirect_uri': redirectUri,
      },
    );

    debugPrint('Status: ${response.status}');
    debugPrint('Response: ${response.data}');

    if (response.status != 200) {
      final errorMsg = response.data is Map
          ? (response.data['error'] ??
              response.data['message'] ??
              'HTTP ${response.status}')
          : 'HTTP ${response.status}';
      throw Exception('Edge Function Error: $errorMsg');
    }

    if (response.data == null) {
      throw Exception('No response data from Edge Function.');
    }

    final data = Map<String, dynamic>.from(response.data);

    final authUrl = data['authorization_url']?.toString();

    if (authUrl == null || authUrl.isEmpty) {
      throw Exception('Authorization URL not found in response.');
    }

    debugPrint('OAuth URL: $authUrl');

    final uri = Uri.parse(authUrl);

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Failed to launch OAuth URL in external browser.');
    }
  } on PostgrestException catch (e, stack) {
    debugPrint('PostgrestException: ${e.message}');
    debugPrint(e.hint);
    debugPrint(stack.toString());
    rethrow;
  } catch (e, stack) {
    debugPrint('Google Calendar OAuth Error: $e');
    debugPrint(stack.toString());
    rethrow;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
