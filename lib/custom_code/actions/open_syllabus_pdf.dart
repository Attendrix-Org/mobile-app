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

import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show PlatformException;

const String _syllabusBucket = 'course-syllabi';

Future<bool> openSyllabusPdf(String? syllabusPath) async {
  // 1. Validate input
  if (syllabusPath == null || syllabusPath.trim().isEmpty) {
    debugPrint('openSyllabusPdf: syllabusPath is null or empty');
    return false;
  }

  // Normalize: strip any leading slash, guard against accidental full URLs
  String cleanPath = syllabusPath.trim();
  if (cleanPath.startsWith('http://') || cleanPath.startsWith('https://')) {
    debugPrint(
        'openSyllabusPdf: expected a relative path, got a full URL "$cleanPath"');
    return false;
  }
  if (cleanPath.startsWith('/')) {
    cleanPath = cleanPath.substring(1);
  }

  // Basic shape check: expects something like "ME/ME3322E.pdf"
  if (!cleanPath.toLowerCase().endsWith('.pdf')) {
    debugPrint('openSyllabusPdf: path does not look like a PDF "$cleanPath"');
    return false;
  }

  try {
    // 2. Confirm there's an active authenticated session
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      debugPrint('openSyllabusPdf: no active Supabase session');
      return false;
    }

    // 3. Request a signed URL (valid 1 hour)
    final String signedUrl = await Supabase.instance.client.storage
        .from(_syllabusBucket)
        .createSignedUrl(cleanPath, 3600);

    final Uri? signedUri = Uri.tryParse(signedUrl);
    if (signedUri == null) {
      debugPrint('openSyllabusPdf: invalid signed URL returned');
      return false;
    }

    // 4. Launch — try externalApplication first (browser/PDF app), fallback to platformDefault
    try {
      final bool launchedExternal = await launchUrl(
        signedUri,
        mode: LaunchMode.externalApplication,
      );
      if (launchedExternal) {
        return true;
      }
    } catch (e) {
      debugPrint('openSyllabusPdf: externalApplication launch failed: $e');
    }

    final bool launchedFallback = await launchUrl(
      signedUri,
      mode: LaunchMode.platformDefault,
    );

    if (!launchedFallback) {
      debugPrint('openSyllabusPdf: launchUrl fallback returned false');
      return false;
    }

    return true;
  } on StorageException catch (e) {
    // Thrown if the file doesn't exist or RLS denies access
    debugPrint('openSyllabusPdf: StorageException - ${e.message}');
    return false;
  } on PlatformException catch (e) {
    debugPrint('openSyllabusPdf: PlatformException - ${e.message}');
    return false;
  } catch (e) {
    debugPrint('openSyllabusPdf: unexpected error - $e');
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
