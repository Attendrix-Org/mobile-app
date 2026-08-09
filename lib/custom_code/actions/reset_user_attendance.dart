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

import 'package:supabase_flutter/supabase_flutter.dart';

/// Custom Action to Reset Attendance Data of a User.
///
/// Verifies the user's password against Supabase Auth before resetting
/// attendance records (`absences` table) for [userId].
///
/// Returns `true` if the password is valid and attendance data was reset.
/// Returns `false` if password verification fails or on any error.
Future<bool> resetUserAttendance(
  String? userId,
  String? password,
) async {
  // 1. Input Validation
  if (userId == null || userId.trim().isEmpty) {
    debugPrint('resetUserAttendance: userId is required.');
    return false;
  }
  if (password == null || password.isEmpty) {
    debugPrint('resetUserAttendance: password is required.');
    return false;
  }

  try {
    final client = Supabase.instance.client;
    final currentUser = client.auth.currentUser;

    // 2. Verify Password via Supabase Auth Re-authentication
    final userEmail = currentUser?.email;
    if (userEmail == null) {
      debugPrint('resetUserAttendance: No active user email found.');
      return false;
    }

    try {
      await client.auth.signInWithPassword(
        email: userEmail,
        password: password,
      );
    } on AuthException catch (authError) {
      debugPrint('Password verification failed: ${authError.message}');
      return false;
    } catch (e) {
      debugPrint('Password authentication error: $e');
      return false;
    }

    // 3. Password Verified — Invoke Supabase RPC to Reset Attendance Data
    final response = await client.rpc(
      'reset_user_attendance_data',
      params: {
        'p_user_id': userId.trim(),
        'p_password': password,
      },
    );

    if (response is Map) {
      final success = response['success'] == true;
      if (success) {
        debugPrint('Attendance data reset successfully for user: $userId');
        return true;
      } else {
        debugPrint('Reset failed: ${response['message'] ?? 'Unknown error'}');
        return false;
      }
    } else if (response is bool) {
      return response;
    }

    return true;
  } catch (e) {
    debugPrint('Error in resetUserAttendance action: $e');
    return false;
  }
}
