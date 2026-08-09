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

/// Custom Action to Permanently Delete User Account and All Data.
///
/// Requires the user to enter their [username] AND [password].
/// Verifies that [username] matches the logged-in user's username and
/// re-authenticates [password] via Supabase Auth before invoking RPC deletion.
///
/// Returns `true` if account was deleted successfully.
/// Returns `false` if username or password verification fails.
Future<bool> deleteUserAccount(
  String username,
  String password,
) async {
  // Validate inputs
  if (username.trim().isEmpty || password.isEmpty) {
    debugPrint('deleteUserAccount: Both username and password are required.');
    return false;
  }

  try {
    final client = Supabase.instance.client;
    final currentUser = client.auth.currentUser;

    if (currentUser == null) {
      debugPrint('deleteUserAccount: No authenticated user found.');
      return false;
    }

    final userId = currentUser.id;
    final userEmail = currentUser.email;

    if (userEmail == null) {
      debugPrint('deleteUserAccount: Logged in user email not found.');
      return false;
    }

    // Step 1: Verify Username against `public.users` table
    final userRow = await client
        .from('users')
        .select('username')
        .eq('id', userId)
        .maybeSingle();

    final actualUsername = userRow?['username']?.toString() ?? '';
    if (actualUsername.trim().toLowerCase() != username.trim().toLowerCase()) {
      debugPrint(
          'Username mismatch: Expected "$actualUsername", got "$username"');
      return false;
    }

    // Step 2: Re-authenticate Password via Supabase Auth
    try {
      await client.auth.signInWithPassword(
        email: userEmail,
        password: password,
      );
    } on AuthException catch (authErr) {
      debugPrint('Password verification failed: ${authErr.message}');
      return false;
    } catch (e) {
      debugPrint('Authentication error during delete account: $e');
      return false;
    }

    // Step 3: Invoke RPC function to purge account and public user rows
    final response = await client.rpc(
      'delete_user_account_permanently',
      params: {
        'p_user_id': userId,
        'p_username': username.trim(),
        'p_password': password,
      },
    );

    bool isSuccess = false;
    if (response is Map) {
      isSuccess = response['success'] == true;
    } else if (response is bool) {
      isSuccess = response;
    }

    if (isSuccess) {
      // Step 4: Sign out locally after successful account deletion
      try {
        await client.auth.signOut();
      } catch (signOutErr) {
        debugPrint('Sign out post-deletion warning: $signOutErr');
      }
      return true;
    } else {
      debugPrint(
          'Delete account RPC failed: ${response is Map ? response['message'] : 'Unknown error'}');
      return false;
    }
  } catch (e) {
    debugPrint('Error deleting user account: $e');
    return false;
  }
}
