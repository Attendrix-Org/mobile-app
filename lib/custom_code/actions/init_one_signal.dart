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

Future<void> initOneSignal() async {
  try {
    // Enable verbose logging during development.
    // Change to OSLogLevel.none for production.
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(
      FFDevEnvironmentValues().oneSignalAppId,
    );

    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;

      if (data == null || data['type'] == null || data['id'] == null) {
        debugPrint('Notification clicked with missing type/id: $data');
        return;
      }

      debugPrint('Notification clicked: $data');

      FFAppState().pendingNotification = PendingNotificationStruct(
        type: data['type'].toString(),
        id: data['id'].toString(),
        hasValue: true,
      );
    });

    final accepted = await OneSignal.Notifications.requestPermission(true);

    debugPrint('OneSignal permission granted: $accepted');
  } catch (e, stackTrace) {
    debugPrint('OneSignal initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
