import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import '/app_state.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/custom_code/functions/attendance_status.dart' as functions_att;
import '/custom_code/functions/get_mess_menu.dart' as functions;

/// Single public API for managing Attendrix Android Home Screen Widgets.
/// Supports Class Schedule Widget (Payload v4) and Mess Menu Widget (Payload v5).
class HomeWidgetService {
  static const String _androidClassWidgetReceiver = 'AttendrixClassWidgetReceiver';
  static const String _androidMessMenuWidgetReceiver = 'AttendrixMessMenuWidgetReceiver';
  static const String _widgetStateKey = 'widget_state_json';
  static const String _messMenuWidgetStateKey = 'mess_menu_widget_state_json';
  static const MethodChannel _channel = MethodChannel('com.attendrix.app/widget');

  /// Initialize HomeWidget bindings.
  static Future<void> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.com.attendrix.app');
    } catch (e) {
      // Non-fatal fallback for platforms without group ID support
    }
  }

  /// Campus meal time windows (24h).
  static const _mealSlots = [
    {'name': 'Breakfast', 'key': 'breakfast', 'time': '7:30 AM - 9:30 AM', 'startH': 7, 'startM': 30, 'endH': 9, 'endM': 30},
    {'name': 'Lunch', 'key': 'lunch', 'time': '12:00 PM - 2:00 PM', 'startH': 12, 'startM': 0, 'endH': 14, 'endM': 0},
    {'name': 'Snacks', 'key': 'eveningTea', 'time': '4:30 PM - 6:00 PM', 'startH': 16, 'startM': 30, 'endH': 18, 'endM': 0},
    {'name': 'Dinner', 'key': 'dinner', 'time': '7:30 PM - 9:30 PM', 'startH': 19, 'startM': 30, 'endH': 21, 'endM': 30},
  ];

  /// Classify the diet type of a raw menu string.
  static String _classifyDiet(String rawMenu) {
    final lower = rawMenu.toLowerCase();
    if (lower.contains('chicken') ||
        lower.contains('mutton') ||
        lower.contains('fish') ||
        lower.contains('prawns') ||
        lower.contains('beef') ||
        lower.contains('meat') ||
        lower.contains('pork')) {
      return 'NON_VEG';
    }
    if (lower.contains('egg') ||
        lower.contains('burjee') ||
        lower.contains('omelette') ||
        lower.contains('boiled egg')) {
      return 'EGG';
    }
    return 'VEG';
  }

  /// Parse raw menu string "Main Items + Staples" into separate fields.
  static Map<String, dynamic> _parseMeal({
    required String name,
    required String timeRange,
    required int startH,
    required int startM,
    required int endH,
    required int endM,
    required List<String> rawItems,
  }) {
    String mainSection = rawItems.isNotEmpty ? rawItems.first : '';
    String staplesSection = rawItems.length > 1 ? rawItems.sublist(1).join(', ') : '';

    final mainItems = mainSection
        .split(RegExp(r'[,/]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final dietType = _classifyDiet(mainSection);

    return {
      'mealName': name,
      'timeRange': timeRange,
      'startH': startH,
      'startM': startM,
      'endH': endH,
      'endM': endM,
      'mainItems': mainItems,
      'staples': staplesSection.trim(),
      'dietType': dietType,
      'items': rawItems,
    };
  }

  /// Automatically syncs both Class Schedule and Mess Menu widgets from FFAppState.
  static Future<void> syncFromAppState(FFAppState appState) async {
    try {
      final now = DateTime.now();
      final userName = appState.userProfile.username;
      final enrolledCourses = appState.userProfile.enrolledCourses;
      final actionTone = appState.userPreferences.preferredActionTone;

      // 1. Sync Mess Menu Widget
      final selectedMessId = appState.userPreferences.userMess;
      if (selectedMessId.isEmpty) {
        await updateMessMenu(
          messName: 'Mess Menu',
          state: 'Empty',
          emptyReason: 'NO_MESS_SELECTED',
        );
      } else {
        MessStruct? mess;
        for (final m in appState.Messes) {
          if (m.messId == selectedMessId || m.name == selectedMessId) {
            mess = m;
            break;
          }
        }

        if (mess == null) {
          await updateMessMenu(
            messName: 'Mess Menu',
            state: 'Empty',
            emptyReason: 'MESS_MISSING',
          );
        } else {
          final weekday = now.weekday; // 1 = Monday, 7 = Sunday
          final todayMeals = <Map<String, dynamic>>[];

          for (final slot in _mealSlots) {
            final rawItems = functions.getMessMenu(
              appState.Messes.toList(),
              mess.messId,
              weekday,
              slot['key']! as String,
            );
            if (rawItems.isNotEmpty) {
              todayMeals.add(_parseMeal(
                name: slot['name']! as String,
                timeRange: slot['time']! as String,
                startH: slot['startH']! as int,
                startM: slot['startM']! as int,
                endH: slot['endH']! as int,
                endM: slot['endM']! as int,
                rawItems: rawItems,
              ));
            }
          }

          final nowMinutes = now.hour * 60 + now.minute;
          Map<String, dynamic>? currentMeal;
          Map<String, dynamic>? nextMeal;

          for (final meal in todayMeals) {
            final startMin = (meal['startH'] as int) * 60 + (meal['startM'] as int);
            final endMin = (meal['endH'] as int) * 60 + (meal['endM'] as int);
            if (nowMinutes >= startMin && nowMinutes < endMin) {
              currentMeal = meal;
              break;
            }
          }

          for (final meal in todayMeals) {
            final startMin = (meal['startH'] as int) * 60 + (meal['startM'] as int);
            if (nowMinutes < startMin) {
              nextMeal = meal;
              break;
            }
          }

          if (currentMeal == null && nextMeal == null && todayMeals.isNotEmpty) {
            final tomorrowWeekday = (weekday % 7) + 1;
            final tomorrowBreakfastItems = functions.getMessMenu(
              appState.Messes.toList(),
              mess.messId,
              tomorrowWeekday,
              'breakfast',
            );
            if (tomorrowBreakfastItems.isNotEmpty) {
              final slot = _mealSlots.first;
              nextMeal = _parseMeal(
                name: "Tomorrow's Breakfast",
                timeRange: slot['time']! as String,
                startH: slot['startH']! as int,
                startM: slot['startM']! as int,
                endH: slot['endH']! as int,
                endM: slot['endM']! as int,
                rawItems: tomorrowBreakfastItems,
              );
            }
          }

          await updateMessMenu(
            messName: mess.name.isEmpty ? 'Mess Menu' : mess.name,
            currentMeal: currentMeal,
            nextMeal: nextMeal,
            todayMeals: todayMeals,
            state: todayMeals.isEmpty ? 'Empty' : 'Ready',
            emptyReason: todayMeals.isEmpty ? 'NO_MENU_AVAILABLE' : 'NO_MENU_AVAILABLE',
          );
        }
      }

      // 2. Sync Class Schedule Widget with Dynamic Attendance Status using User Preferences ActionTone
      final classes = appState.dashboardClasses
          .where((c) => c.scheduledStart != null && c.scheduledEnd != null)
          .toList()
        ..sort((a, b) => a.scheduledStart!.compareTo(b.scheduledStart!));

      if (classes.isEmpty) {
        await update({
          'version': 4,
          'state': 'Empty',
          'emptyReason': 'NO_TIMETABLE',
          'updatedAtMillis': now.millisecondsSinceEpoch,
        });
      } else {
        ScheduledClassStruct? currentClass = classes.firstWhereOrNull(
          (c) => !now.isBefore(c.scheduledStart!) && now.isBefore(c.scheduledEnd!),
        );

        final upcomingClasses = classes
            .where((c) => c.scheduledStart!.isAfter(now))
            .toList();

        final nextClass = upcomingClasses.firstOrNull;
        final upcomingRows = upcomingClasses
            .skip(1)
            .take(4)
            .map((c) => _classToJson(c, userName, enrolledCourses, actionTone))
            .toList();

        final progress = currentClass != null
            ? ((now.millisecondsSinceEpoch - currentClass.scheduledStart!.millisecondsSinceEpoch).toDouble() /
                    (currentClass.scheduledEnd!.millisecondsSinceEpoch - currentClass.scheduledStart!.millisecondsSinceEpoch).toDouble())
                .clamp(0.0, 1.0)
            : 0.0;

        final remainingMin = currentClass != null
            ? (currentClass.scheduledEnd!.difference(now).inMinutes).clamp(0, 1440)
            : 0;

        await update({
          'version': 4,
          'state': (currentClass != null || upcomingClasses.isNotEmpty) ? 'Ready' : 'Empty',
          'emptyReason': 'NO_CLASSES',
          'currentClass': currentClass != null ? _classToJson(currentClass, userName, enrolledCourses, actionTone) : null,
          'nextClass': nextClass != null ? _classToJson(nextClass, userName, enrolledCourses, actionTone) : null,
          'upcomingRows': upcomingRows,
          'progress': progress,
          'remainingMinutes': remainingMin,
          'updatedAtMillis': now.millisecondsSinceEpoch,
        });
      }
    } catch (_) {}
  }

  static Map<String, dynamic> _classToJson(
    ScheduledClassStruct c,
    String userName,
    List<EnrolledCourseStruct> enrolledCourses,
    ActionTone actionTone,
  ) {
    final isLabName = c.courseName.toLowerCase().contains('lab') || c.labGroup.isNotEmpty;

    final enrolled = enrolledCourses.firstWhereOrNull(
      (e) => (c.courseId.isNotEmpty && e.courseId == c.courseId) ||
             (c.courseCode.isNotEmpty && e.courseCode == c.courseCode) ||
             (c.courseName.isNotEmpty && e.courseName == c.courseName),
    );

    final attStruct = enrolled?.attendance ?? AttendanceStruct(
      attended: 0,
      missed: 0,
      percentage: 100.0,
      required: 80,
    );

    final String statusCaption = functions_att.attendanceStatus(
      attStruct,
      userName,
      actionTone,
    );

    return {
      'classId': c.classId,
      'courseName': c.courseName,
      'courseCode': c.courseCode,
      'courseCategory': c.courseCategory?.name ?? (enrolled?.electiveCategory ?? ''),
      'isLab': isLabName || (enrolled?.isLab ?? false),
      'isExtraClass': c.isExtraClass,
      'isPlusSlot': c.isPlusSlot,
      'venue': c.venue,
      'attendance': {
        'attended': attStruct.attended,
        'missed': attStruct.missed,
        'percentage': attStruct.percentage,
        'required': attStruct.required,
      },
      'statusCaption': statusCaption,
      'startMillis': c.scheduledStart!.millisecondsSinceEpoch,
      'endMillis': c.scheduledEnd!.millisecondsSinceEpoch,
      'isAbsent': c.isAbsent,
      'status': 'UPCOMING',
    };
  }

  /// Generic update method for Class Widget.
  static Future<bool> update(Map<String, dynamic> stateMap) async {
    try {
      final jsonStr = jsonEncode(stateMap);
      await HomeWidget.saveWidgetData(_widgetStateKey, jsonStr);
      await HomeWidget.updateWidget(
        name: _androidClassWidgetReceiver,
        androidName: _androidClassWidgetReceiver,
      );
      try {
        await _channel.invokeMethod('updateWidgetSnapshot', {'snapshotJson': jsonStr});
      } catch (_) {}
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Convenience API: Update current class details on Class Widget.
  static Future<bool> updateCurrentClass({
    required String classId,
    required String courseName,
    String courseCode = '',
    required String venue,
    required int startMillis,
    required int endMillis,
    bool isAbsent = false,
    double overallAttendancePercentage = 100.0,
    String state = 'Ready',
  }) async {
    return update({
      'version': 4,
      'state': state,
      'updatedAtMillis': DateTime.now().millisecondsSinceEpoch,
      'overallAttendancePercentage': overallAttendancePercentage,
      'currentClass': {
        'classId': classId,
        'courseName': courseName,
        'courseCode': courseCode,
        'venue': venue,
        'startMillis': startMillis,
        'endMillis': endMillis,
        'isAbsent': isAbsent,
        'status': 'LIVE',
      },
    });
  }

  /// Convenience API: Update Mess Menu Widget (Payload v5).
  static Future<bool> updateMessMenu({
    required String messName,
    Map<String, dynamic>? currentMeal,
    Map<String, dynamic>? nextMeal,
    List<Map<String, dynamic>> todayMeals = const [],
    String state = 'Ready',
    String emptyReason = 'NO_CLASSES',
  }) async {
    try {
      final payload = {
        'version': 5,
        'widgetType': 'mess_menu',
        'state': state,
        'emptyReason': emptyReason.toUpperCase(),
        'messName': messName,
        'currentMeal': currentMeal,
        'nextMeal': nextMeal,
        'todayMeals': todayMeals,
        'updatedAtMillis': DateTime.now().millisecondsSinceEpoch,
      };

      final jsonStr = jsonEncode(payload);
      await HomeWidget.saveWidgetData(_messMenuWidgetStateKey, jsonStr);
      await HomeWidget.updateWidget(
        name: _androidMessMenuWidgetReceiver,
        androidName: _androidMessMenuWidgetReceiver,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Convenience API: Update attendance status for a class.
  static Future<bool> updateAttendance({
    required String classId,
    required bool isAbsent,
  }) async {
    return update({
      'version': 4,
      'state': 'Ready',
      'updatedAtMillis': DateTime.now().millisecondsSinceEpoch,
      'absenceActionClassId': classId,
      'absenceActionStatus': 'Idle',
    });
  }

  /// Convenience API: Push a contextual empty state (WEEKEND, HOLIDAY, LOGGED_OUT, etc.)
  static Future<bool> setEmptyState(String emptyReason) async {
    await updateMessMenu(
      messName: 'Mess Menu',
      state: 'Empty',
      emptyReason: emptyReason,
    );
    return update({
      'version': 4,
      'state': 'Empty',
      'emptyReason': emptyReason.toUpperCase(),
      'updatedAtMillis': DateTime.now().millisecondsSinceEpoch,
      'currentClass': null,
      'nextClass': null,
      'upcomingRows': [],
    });
  }

  /// Request widget UI redraw.
  static Future<void> refresh() async {
    try {
      await HomeWidget.updateWidget(
        name: _androidClassWidgetReceiver,
        androidName: _androidClassWidgetReceiver,
      );
      await HomeWidget.updateWidget(
        name: _androidMessMenuWidgetReceiver,
        androidName: _androidMessMenuWidgetReceiver,
      );
      await _channel.invokeMethod('refreshWidgets');
    } catch (_) {}
  }

  /// Alias for refresh.
  static Future<void> refreshWidget() => refresh();

  /// Clear widget contents (e.g. on user sign out).
  static Future<bool> clear() => setEmptyState('LOGGED_OUT');

  /// Alias for clear.
  static Future<bool> clearWidget() => clear();
}
