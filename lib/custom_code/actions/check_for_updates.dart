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

import '/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Custom Action triggered when the user clicks "Check For Updates".
///
/// Uses `FFAppConstants.appVersion` as the default current app version
/// and compares it with `current_version` from Supabase `app_version_control`.
///
/// Displays an Update Dialog if a newer version exists, or a SnackBar toast
/// if the user is on the latest version.
Future<bool> checkForUpdates(
  BuildContext context,
  String? appVersion,
  bool showUpToDateToast,
) async {
  try {
    final client = Supabase.instance.client;

    // Use passed appVersion parameter or fallback to FFAppConstants.appVersion
    final String currentAppVersion =
        (appVersion != null && appVersion.trim().isNotEmpty)
            ? appVersion.trim()
            : FFAppConstants.appVersion;

    // Query latest version record from app_version_control
    final response = await client
        .from('app_version_control')
        .select()
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      if (showUpToDateToast && context.mounted) {
        _showSnackBar(
          context,
          'Unable to check for updates at this time. Please try again later.',
          isError: true,
        );
      }
      return false;
    }

    final String latestVersion =
        response['current_version']?.toString() ?? currentAppVersion;
    final String? downloadUrl = response['version_download_link']?.toString();
    final bool forceUpdate = response['force_update'] == true;
    final String releaseNotes = response['release_notes']?.toString() ??
        'Bug fixes and performance improvements.';

    // Compare server version against current app version
    final bool isUpdateAvailable =
        _isVersionNewer(latestVersion, currentAppVersion);

    if (isUpdateAvailable) {
      if (context.mounted) {
        await _showUpdateDialog(
          context,
          latestVersion: latestVersion,
          releaseNotes: releaseNotes,
          downloadUrl: downloadUrl,
          forceUpdate: forceUpdate,
        );
      }
      return true;
    } else {
      if (showUpToDateToast && context.mounted) {
        _showSnackBar(
          context,
          'You are on the latest version ($currentAppVersion)!',
          isError: false,
        );
      }
      return false;
    }
  } catch (e) {
    debugPrint('Error in checkForUpdates custom action: $e');
    if (showUpToDateToast && context.mounted) {
      _showSnackBar(
        context,
        'Failed to check for updates. Please check your internet connection.',
        isError: true,
      );
    }
    return false;
  }
}

/// Helper method to compare semantic versions (e.g. "1.0.2" vs "1.0.1")
bool _isVersionNewer(String latest, String current) {
  try {
    final latestClean = latest.split('+')[0].trim();
    final currentClean = current.split('+')[0].trim();

    final latestParts =
        latestClean.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final currentParts =
        currentClean.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength = latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;

    for (int i = 0; i < maxLength; i++) {
      final l = i < latestParts.length ? latestParts[i] : 0;
      final c = i < currentParts.length ? currentParts[i] : 0;
      if (l > c) return true;
      if (l < c) return false;
    }
    return false;
  } catch (e) {
    return latest.trim() != current.trim();
  }
}

/// Helper method to display update dialog with release notes & download link
Future<void> _showUpdateDialog(
  BuildContext context, {
  required String latestVersion,
  required String releaseNotes,
  required String? downloadUrl,
  required bool forceUpdate,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: !forceUpdate,
    builder: (BuildContext dialogContext) {
      final theme = FlutterFlowTheme.of(dialogContext);
      return WillPopScope(
        onWillPop: () async => !forceUpdate,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: theme.secondaryBackground,
          title: Row(
            children: [
              Icon(
                Icons.system_update_rounded,
                color: theme.primary,
                size: 28.0,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  'Update Available (v$latestVersion)',
                  style: theme.headlineSmall.override(
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A new version of Attendrix is available!',
                style: theme.bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                'Release Notes:',
                style: theme.bodySmall.override(
                  fontFamily: 'Readex Pro',
                  color: theme.secondaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: theme.primaryBackground,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  releaseNotes,
                  style: theme.bodySmall.override(
                    fontFamily: 'Readex Pro',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            if (!forceUpdate)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Later',
                  style: theme.bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: theme.secondaryText,
                  ),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () async {
                if (downloadUrl != null && downloadUrl.isNotEmpty) {
                  final uri = Uri.parse(downloadUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
                if (!forceUpdate && dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(
                'Update Now',
                style: theme.bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Helper method to display clean SnackBar notifications
void _showSnackBar(BuildContext context, String message,
    {bool isError = false}) {
  final theme = FlutterFlowTheme.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? theme.error : theme.primary,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ),
  );
}
