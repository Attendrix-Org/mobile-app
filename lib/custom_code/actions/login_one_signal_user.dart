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
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> loginOneSignalUser(String? userId) async {
  if (userId == null || userId.trim().isEmpty) {
    debugPrint('loginOneSignalUser called with empty userId — skipping.');
    return;
  }

  try {
    await OneSignal.login(userId.trim());
    debugPrint('OneSignal logged in as $userId');
  } catch (e, stackTrace) {
    debugPrint('OneSignal login failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
