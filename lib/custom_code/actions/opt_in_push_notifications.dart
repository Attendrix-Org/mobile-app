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
import '/app_constants.dart';

Future<void> optInPushNotifications() async {
  try {
    OneSignal.User.pushSubscription.optIn();
    final subscriptionId = OneSignal.User.pushSubscription.id;
    if (subscriptionId != null && subscriptionId.isNotEmpty) {
      try {
        await SupaFlow.client.rpc('register_device', params: {
          'p_subscription_id': subscriptionId,
          'p_platform': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
          'p_app_version': FFAppConstants.appVersion,
        });
        debugPrint('Reactivated device $subscriptionId (is_active = true) in Supabase.');
      } catch (rpcErr) {
        debugPrint('RPC register_device error: $rpcErr');
      }
    }
    debugPrint('Push notifications opted in.');
  } catch (e, stackTrace) {
    debugPrint('OneSignal opt-in failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
