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

Future<bool> syncNowGoogleCalendar() async {
  try {
    final session = SupaFlow.client.auth.currentSession;
    final user = SupaFlow.client.auth.currentUser;

    if (session == null || user == null) {
      debugPrint('Sync Now error: User is not authenticated.');
      return false;
    }

    final response = await SupaFlow.client.functions.invoke(
      'google-calendar-sync-worker',
      headers: {
        'Authorization': 'Bearer ${session.accessToken}',
      },
      body: {
        'user_id': user.id,
      },
    );

    debugPrint('Sync Now Status: ${response.status}');
    debugPrint('Sync Now Response: ${response.data}');

    if (response.status == 200) {
      return true;
    }

    return false;
  } catch (e, stack) {
    debugPrint('Error triggering Sync Now: $e');
    debugPrint(stack.toString());
    return false;
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
