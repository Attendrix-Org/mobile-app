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
    final response = await SupaFlow.client.rpc('get_user_profile');

    Map<String, dynamic>? row;
    if (response is Map) {
      row = Map<String, dynamic>.from(response);
    } else if (response is List && response.isNotEmpty && response.first is Map) {
      row = Map<String, dynamic>.from(response.first as Map);
    }

    if (row == null) return UserProfileStruct();

    final enrolledList = (row['enrolledCourses'] ?? row['enrolled_courses']);

    return UserProfileStruct(
      userId: (row['userId'] ?? row['user_id'])?.toString(),
      username: row['username']?.toString() ?? '',
      email: row['email']?.toString() ?? '',
      role: row['role']?.toString() ?? '',
      departmentId: (row['departmentId'] ?? row['department_id'])?.toString() ?? '',
      batchId: (row['batchId'] ?? row['batch_id'])?.toString() ?? '',
      currentSemester: row['currentSemester'] ?? row['current_semester'] ?? 1,
      amplixBalance: row['amplixBalance'] ?? row['amplix_balance'] ?? 0,
      odometer: row['odometer'] ?? row['streak'] ?? 0,
      onboardingComplete: row['onboardingComplete'] == true ||
          row['onboarding_complete'] == true ||
          row['onboarding_completed'] == true,
      profileUpdatedAt: row['profileUpdatedAt'] != null
          ? DateTime.tryParse(row['profileUpdatedAt'].toString())
          : (row['profile_updated_at'] != null
              ? DateTime.tryParse(row['profile_updated_at'].toString())
              : null),
      enrolledCourses: enrolledList is List
          ? enrolledList.map((e) {
              if (e is Map) {
                return EnrolledCourseStruct.fromMap(Map<String, dynamic>.from(e));
              } else if (e is String) {
                return EnrolledCourseStruct(courseId: e, courseCode: e);
              }
              return EnrolledCourseStruct();
            }).toList()
          : [],
    );
  } catch (e) {
    debugPrint('loadUserProfile failed: $e');
    return UserProfileStruct();
  }
}
