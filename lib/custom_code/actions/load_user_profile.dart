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

Future<UserProfileStruct> loadUserProfile() async {
  try {
    final response = await Supabase.instance.client.rpc('get_user_profile');

    final row = (response as List).first as Map<String, dynamic>;

    return UserProfileStruct(
      userId: row['user_id'],
      username: row['username'] ?? '',
      email: row['email'] ?? '',
      role: row['role'] ?? '',
      departmentId: row['department_id'] ?? '',
      batchId: row['batch_id'] ?? '',
      currentSemester: row['current_semester'] ?? 1,
      amplixBalance: row['amplix_balance'] ?? 0,
      odometer: row['odometer'] ?? 0,
      onboardingComplete: row['onboarding_completed'] ?? false,
      profileUpdatedAt: row['profile_updated_at'] != null
          ? DateTime.parse(row['profile_updated_at'])
          : null,
      enrolledCourses: (row['enrolled_courses'] as List<dynamic>)
          .map(
            (e) => EnrolledCourseStruct.fromMap(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  } on PostgrestException catch (_) {
    return UserProfileStruct();
  } catch (_) {
    return UserProfileStruct();
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
