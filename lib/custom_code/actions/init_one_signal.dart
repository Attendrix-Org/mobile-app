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
import '/app_state.dart';
import '/app_constants.dart';

Future<void> initOneSignal() async {
  try {
    // Enable verbose logging during development.
    // Change to OSLogLevel.none for production.
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(
      FFDevEnvironmentValues().oneSignalAppId,
    );

    // Observe subscription changes (token refresh)
    OneSignal.User.pushSubscription.addObserver((state) async {
      final newId = state.current.id;
      final oldId = state.previous.id;
      if (newId != null && oldId != null && newId != oldId) {
        try {
          await SupaFlow.client.rpc('refresh_device_subscription', params: {
            'p_old_subscription_id': oldId,
            'p_new_subscription_id': newId,
          });
          debugPrint('Refreshed device subscription in Supabase: $oldId -> $newId');
        } catch (rpcErr) {
          debugPrint('RPC refresh_device_subscription failed: $rpcErr');
        }
      }
    });

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

    debugPrint('OneSignal permission granted ($accepted) [AppVersion: ${FFAppConstants.appVersion}]');
  } catch (e, stackTrace) {
    debugPrint('OneSignal initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
