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

import '/custom_code/actions/update_android_widget_from_app_state.dart';

// ─────────────────────────────────────────────────────────────────────────
// Report Class Cancellation Custom Action — FlutterFlow valid signature
// Reports a class as cancelled to Supabase and updates local AppState & Cache
// ─────────────────────────────────────────────────────────────────────────

Future<bool> reportClassCancelled(
  String? classId,
) async {
  if (classId == null || classId.trim().isEmpty) {
    debugPrint('reportClassCancelled: invalid or null classId provided.');
    return false;
  }

  final targetId = classId.trim();

  try {
    final response = await SupaFlow.client.rpc(
      'report_class_cancellation',
      params: {'p_class_id': targetId},
    );

    if (response is! Map) {
      debugPrint(
          'reportClassCancelled: unexpected response format (${response?.runtimeType})');
      return false;
    }

    final resMap = Map<String, dynamic>.from(response as Map);
    final bool success = resMap['success'] == true;
    final bool isCancelled = resMap['is_cancelled'] == true;
    final int reportCount = resMap['report_count'] ?? resMap['reports'] ?? 0;
    final int threshold = resMap['threshold'] ?? 1;

    debugPrint(
        'reportClassCancelled: RPC result for $targetId -> success=$success, isCancelled=$isCancelled ($reportCount/$threshold reports)');

    if (success) {
      // 1. Evict calendar date cache to force fresh schedule queries
      final calendarDates =
          List<String>.from(FFAppState().cacheMetaData.calendarDates);
      calendarDates.clear();

      // 2. If class is now officially cancelled, mark or remove from local AppState
      final dashboard =
          List<ScheduledClassStruct>.from(FFAppState().dashboardClasses);
      final calendar =
          List<ScheduledClassStruct>.from(FFAppState().calendarClasses);

      bool stateChanged = false;

      if (isCancelled) {
        dashboard.removeWhere((c) => c.classId == targetId);
        calendar.removeWhere((c) => c.classId == targetId);
        stateChanged = true;
      }

      FFAppState().update(() {
        FFAppState().cacheMetaData.calendarDates = calendarDates;
        if (stateChanged) {
          FFAppState().dashboardClasses = dashboard;
          FFAppState().calendarClasses = calendar;
        }
      });

      // 3. Sync Android widget bridge
      try {
        await updateAndroidWidgetFromAppState();
      } catch (_) {}

      return true;
    }
    return false;
  } catch (e) {
    debugPrint('reportClassCancelled: failed for $targetId -> $e');
    return false;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
