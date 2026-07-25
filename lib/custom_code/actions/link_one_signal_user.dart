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

// Automatic FlutterFlow Imports
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future linkOneSignalUser(
  String? supabaseUserId,
  String? email,
  String? batchId,
) async {
  // Edge Case 1: Avoid mapping if the critical Auth User ID is missing
  if (supabaseUserId == null || supabaseUserId.trim().isEmpty) {
    print(
        "OneSignal Setup Cancelled: Provided Supabase User ID is null or empty.");
    return;
  }

  try {
    final sanitizedUserId = supabaseUserId.trim();
    print("Mapping device token to Supabase User ID: $sanitizedUserId");

    // 1. Link the primary identity token
    await OneSignal.login(sanitizedUserId);

    // 2. Build the tagging map safely based on what arguments are available
    final Map<String, String> userTags = {};

    if (email != null && email.trim().isNotEmpty) {
      userTags['email'] = email
          .trim()
          .toLowerCase(); // Lowercase prevents casing mismatches in segmentation
    }

    if (batchId != null && batchId.trim().isNotEmpty) {
      userTags['batchId'] = batchId.trim();
    }

    // 3. Send the tags to OneSignal if we have any data
    if (userTags.isNotEmpty) {
      print("Sending target tags to OneSignal: $userTags");
      await OneSignal.User.addTags(userTags);
    }
  } catch (e) {
    // Edge Case 2: Handles API network drops or initialization lag gracefully
    print("Failed to sync identity and tags with OneSignal: $e");
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
