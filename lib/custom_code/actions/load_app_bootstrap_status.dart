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

Future<AppBootstrapStruct> loadAppBootstrapStatus(
    String? storedVersionId) async {
  try {
    final response = await SupaFlow.client.rpc(
      'get_app_bootstrap_status',
      params: {'p_version_id': storedVersionId},
    );

    final rows = response as List;
    if (rows.isEmpty) {
      debugPrint('loadAppBootstrapStatus: empty response');
      return AppBootstrapStruct(onboardingCompleted: false);
    }

    final row = rows.first as Map<String, dynamic>;

    return AppBootstrapStruct(
      onboardingCompleted: row['onboarding_completed'] ?? false,
      needsForceUpdate: row['needs_force_update'] ?? false,
      currentVersion: row['current_version'] as String?,
      currentBuildNumber: row['current_build_number'] as int?,
      versionDownloadLink: row['version_download_link'] as String?,
      releaseNotes: row['release_notes'] as String?,
      isWebAvailable: row['is_web_available'] ?? false,
    );
  } catch (e, st) {
    debugPrint('loadAppBootstrapStatus error: $e\n$st');
    return AppBootstrapStruct(onboardingCompleted: false, hasError: true);
  }
}
