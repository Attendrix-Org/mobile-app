import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/app_state.dart';
import '/custom_code/actions/generate_notification_message.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final NotificationMessageEngine _messageEngine = NotificationMessageEngine();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      await _notificationsPlugin.initialize(
        const InitializationSettings(android: androidSettings),
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;
      debugPrint('LocalNotificationService initialized successfully.');
    } catch (e) {
      debugPrint('LocalNotificationService initialization failed: $e');
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null && response.payload!.isNotEmpty) {
      final parts = response.payload!.split(':');
      if (parts.length >= 2) {
        FFAppState().pendingNotification = PendingNotificationStruct(
          type: parts[0],
          id: parts[1],
          hasValue: true,
        );
      }
    }
  }

  bool isWithinQuietHours(DateTime targetTime, UserPreferencesStruct prefs) {
    if (!prefs.quietHoursEnabled) return false;
    final startParts = prefs.quietHoursStart.split(':').map((e) => int.tryParse(e) ?? 0).toList();
    final endParts = prefs.quietHoursEnd.split(':').map((e) => int.tryParse(e) ?? 0).toList();
    
    final startMins = startParts[0] * 60 + (startParts.length > 1 ? startParts[1] : 0);
    final endMins = endParts[0] * 60 + (endParts.length > 1 ? endParts[1] : 0);
    if (startMins == endMins) return false; // Degenerate quiet hours check

    final targetMins = targetTime.hour * 60 + targetTime.minute;
    if (startMins > endMins) {
      return targetMins >= startMins || targetMins < endMins;
    } else {
      return targetMins >= startMins && targetMins < endMins;
    }
  }

  Future<void> syncNotificationsFromAppState() async {
    if (!_isInitialized) await initialize();

    final prefs = FFAppState().userPreferences;
    final profile = FFAppState().userProfile;
    final userName = profile.fullName.isNotEmpty ? profile.fullName.split(' ').first : 'Student';
    final tone = prefs.preferredActionTone;

    if (!prefs.atAGlanceView) { // Master notification toggle
      await _notificationsPlugin.cancelAll();
      final sp = await SharedPreferences.getInstance();
      await sp.setStringList('scheduled_notification_ids', []);
      return;
    }

    final now = DateTime.now();
    final cutoff = now.add(const Duration(days: 7));
    final activeIdMap = <int, String>{};
    final newScheduledIds = <int>[];

    // 1. SCHEDULE UPCOMING CLASSES
    if (prefs.enableAPOD) { // Class reminder toggle
      for (final cl in FFAppState().dashboardClasses) {
        if (cl.scheduledStart != null && cl.scheduledStart!.isAfter(now) && cl.scheduledStart!.isBefore(cutoff) && !cl.isAbsent) {
          final reminderTime = cl.scheduledStart!.subtract(const Duration(minutes: 10));
          if (reminderTime.isAfter(now)) {
            final dateISO = '${reminderTime.year}${reminderTime.month.toString().padLeft(2,'0')}${reminderTime.day.toString().padLeft(2,'0')}';
            final key = '${cl.classId}_upcoming_$dateISO';
            final id = _generateId(key, 100000, activeIdMap);
            final isQuiet = isWithinQuietHours(reminderTime, prefs);

            final ctx = NotificationContext(
              username: userName,
              tone: tone,
              courseCode: cl.courseCode,
              courseName: cl.courseName,
              venue: cl.venue,
              offsetMins: 10,
            );
            final content = _messageEngine.generateUpcomingClass(ctx);

            await _notificationsPlugin.zonedSchedule(
              id,
              content.title,
              content.body,
              tz.TZDateTime.from(reminderTime, tz.local),
              NotificationDetails(
                android: AndroidNotificationDetails(
                  isQuiet ? 'attendrix_classes_silent' : 'attendrix_classes',
                  'Class Reminders',
                  importance: isQuiet ? Importance.low : Importance.high,
                  priority: isQuiet ? Priority.low : Priority.high,
                ),
              ),
              androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
              payload: 'class:${cl.classId}',
            );
            newScheduledIds.add(id);
          }
        }
      }
    }

    // 2. RECONCILIATION & ORPHAN ALARM CANCELLATION
    final sp = await SharedPreferences.getInstance();
    final oldIdsRaw = sp.getStringList('scheduled_notification_ids') ?? [];
    final oldIds = oldIdsRaw.map(int.parse).toSet();
    final newIdsSet = newScheduledIds.toSet();

    final orphanedIds = oldIds.difference(newIdsSet);
    for (final orphanId in orphanedIds) {
      await _notificationsPlugin.cancel(orphanId);
    }

    await sp.setStringList('scheduled_notification_ids', newScheduledIds.map((e) => e.toString()).toList());
    debugPrint('LocalNotificationService: Sync complete. Scheduled: ${newScheduledIds.length}, Cancelled Orphans: ${orphanedIds.length}.');
  }

  int _generateId(String key, int base, Map<int, String> activeIdMap) {
    int rawHash = CRC32.compute(key);
    int candidate = base + (rawHash % 90000);
    while (activeIdMap.containsKey(candidate) && activeIdMap[candidate] != key) {
      candidate = base + ((candidate - base + 1) % 90000);
    }
    activeIdMap[candidate] = key;
    return candidate;
  }
}

class CRC32 {
  static final List<int> _table = List<int>.generate(256, (i) {
    int c = i;
    for (int k = 0; k < 8; k++) {
      c = (c & 1 != 0) ? (0xEDB88320 ^ (c >>> 1)) : (c >>> 1);
    }
    return c;
  });

  static int compute(String input) {
    final bytes = input.codeUnits;
    int crc = 0xFFFFFFFF;
    for (final b in bytes) {
      crc = (crc >>> 8) ^ _table[(crc ^ b) & 0xFF];
    }
    return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
  }
}
