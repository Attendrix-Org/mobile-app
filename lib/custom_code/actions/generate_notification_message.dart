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

import 'dart:math' as math;

class NotificationContext {
  final String? username;
  final ActionTone tone;
  final String? courseCode;
  final String? courseName;
  final String? venue;
  final int offsetMins;
  final int offsetHours;
  final String? mealName;
  final String? menu;
  final String? taskTitle;
  final String? examTitle;
  final int classCount;
  final int taskCount;
  final double? attendancePercentage;
  final double? targetPercentage;

  NotificationContext({
    this.username,
    this.tone = ActionTone.playful,
    this.courseCode,
    this.courseName,
    this.venue,
    this.offsetMins = 10,
    this.offsetHours = 24,
    this.mealName,
    this.menu,
    this.taskTitle,
    this.examTitle,
    this.classCount = 0,
    this.taskCount = 0,
    this.attendancePercentage,
    this.targetPercentage = 80.0,
  });

  String get name => (username == null || username!.trim().isEmpty) ? 'there' : username!.trim();
  String get cleanVenue => (venue == null || venue!.trim().isEmpty) ? 'Campus' : venue!.trim();
  String get cleanCourseCode => (courseCode == null || courseCode!.trim().isEmpty) ? 'Class' : courseCode!.trim();
  String get cleanCourseName => (courseName == null || courseName!.trim().isEmpty) ? cleanCourseCode : courseName!.trim();
  String get cleanMenu => (menu == null || menu!.trim().isEmpty) ? 'Check today\'s menu at the hall!' : menu!.trim();
}

class NotificationContent {
  final String title;
  final String body;

  const NotificationContent({required this.title, required this.body});
}

class NotificationTemplate {
  final String id;
  final NotificationContent Function(NotificationContext ctx) build;

  const NotificationTemplate(this.id, this.build);
}

class NotificationMessageEngine {
  final math.Random _random;
  final List<String> _recentTemplateIds;
  final int maxHistorySize;

  NotificationMessageEngine({
    math.Random? random,
    this.maxHistorySize = 25,
    List<String>? recentTemplateIds,
  })  : _random = random ?? math.Random(),
        _recentTemplateIds = List.from(recentTemplateIds ?? []);

  List<String> get recentTemplateIds => List.unmodifiable(_recentTemplateIds);

  NotificationContent generateUpcomingClass(NotificationContext ctx) => _generate(_upcomingClassMatrix, ctx, 'fallback_class_up');
  NotificationContent generateClassStarting(NotificationContext ctx) => _generate(_startingClassMatrix, ctx, 'fallback_class_start');
  NotificationContent generateClassEnding(NotificationContext ctx) => _generate(_endingClassMatrix, ctx, 'fallback_class_end');
  NotificationContent generateMissedCheckin(NotificationContext ctx) => _generate(_missedCheckinMatrix, ctx, 'fallback_checkin');
  NotificationContent generateLowAttendance(NotificationContext ctx) => _generate(_lowAttendanceMatrix, ctx, 'fallback_low_att');
  NotificationContent generateMessMeal(NotificationContext ctx) => _generate(_messMealMatrix, ctx, 'fallback_mess');
  NotificationContent generateTaskUpcoming(NotificationContext ctx) => _generate(_taskUpcomingMatrix, ctx, 'fallback_task_up');
  NotificationContent generateTaskDueToday(NotificationContext ctx) => _generate(_taskDueTodayMatrix, ctx, 'fallback_task_today');
  NotificationContent generateTaskOverdue(NotificationContext ctx) => _generate(_taskOverdueMatrix, ctx, 'fallback_task_overdue');
  NotificationContent generateExam3Days(NotificationContext ctx) => _generate(_exam3DaysMatrix, ctx, 'fallback_exam_3d');
  NotificationContent generateExam1Day(NotificationContext ctx) => _generate(_exam1DayMatrix, ctx, 'fallback_exam_1d');
  NotificationContent generateExam1Hour(NotificationContext ctx) => _generate(_exam1HourMatrix, ctx, 'fallback_exam_1h');
  NotificationContent generateDailyBrief(NotificationContext ctx) => _generate(_dailyBriefMatrix, ctx, 'fallback_brief');

  NotificationContent _generate(
    Map<ActionTone, List<NotificationTemplate>> matrix,
    NotificationContext ctx,
    String fallbackId,
  ) {
    final pool = matrix[ctx.tone] ?? matrix[ActionTone.playful]!;
    final template = _pickFreshTemplate(pool, fallbackId);
    
    _recentTemplateIds.add(template.id);
    if (_recentTemplateIds.length > maxHistorySize) {
      _recentTemplateIds.removeAt(0);
    }

    return template.build(ctx);
  }

  NotificationTemplate _pickFreshTemplate(List<NotificationTemplate> pool, String fallbackId) {
    if (pool.isEmpty) {
      return NotificationTemplate(fallbackId, (ctx) => const NotificationContent(title: 'Attendrix Alert', body: 'Upcoming event on your schedule.'));
    }
    final fresh = pool.where((t) => !_recentTemplateIds.contains(t.id)).toList();
    final target = fresh.isNotEmpty ? fresh : pool;
    return target[_random.nextInt(target.length)];
  }

  // ─────────────────────────────────────────────────────────────
  // Multi-Variation Template Matrices
  // ─────────────────────────────────────────────────────────────

  // 1. UPCOMING CLASS (T - offsetMins)
  static final Map<ActionTone, List<NotificationTemplate>> _upcomingClassMatrix = {
    ActionTone.playful: [
      NotificationTemplate('cup_p1', (ctx) => NotificationContent(
        title: '⏰ Class in ${ctx.offsetMins} mins, ${ctx.name}!',
        body: '${ctx.cleanCourseCode} (${ctx.cleanCourseName}) starts soon at ${ctx.cleanVenue}. Don\'t be late!',
      )),
      NotificationTemplate('cup_p2', (ctx) => NotificationContent(
        title: '🏃 Grab your bag, ${ctx.name}!',
        body: '${ctx.cleanCourseCode} is starting in ${ctx.offsetMins}m at ${ctx.cleanVenue}. See you there!',
      )),
      NotificationTemplate('cup_p3', (ctx) => NotificationContent(
        title: '⚡ ${ctx.cleanCourseCode} Alert!',
        body: 'Heading to ${ctx.cleanVenue}? ${ctx.cleanCourseName} begins in ${ctx.offsetMins} minutes.',
      )),
      NotificationTemplate('cup_p4', (ctx) => NotificationContent(
        title: '📍 Next Stop: ${ctx.cleanVenue}',
        body: '${ctx.cleanCourseCode} starts in ${ctx.offsetMins}m, ${ctx.name}. Time to head out!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('cup_d1', (ctx) => NotificationContent(
        title: '📖 Class in ${ctx.offsetMins}m: ${ctx.cleanCourseCode}',
        body: '${ctx.cleanCourseName} starts at ${ctx.cleanVenue}.',
      )),
      NotificationTemplate('cup_d2', (ctx) => NotificationContent(
        title: '📍 Venue: ${ctx.cleanVenue} | ${ctx.cleanCourseCode}',
        body: 'Class starts in ${ctx.offsetMins} minutes.',
      )),
      NotificationTemplate('cup_d3', (ctx) => NotificationContent(
        title: '⏳ Upcoming: ${ctx.cleanCourseCode}',
        body: 'Scheduled start in ${ctx.offsetMins}m at ${ctx.cleanVenue}.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('cup_m1', (ctx) => NotificationContent(
        title: '🎯 Step Towards Success, ${ctx.name}!',
        body: '${ctx.cleanCourseCode} (${ctx.cleanCourseName}) starts in ${ctx.offsetMins}m at ${ctx.cleanVenue}. Give it 100%!',
      )),
      NotificationTemplate('cup_m2', (ctx) => NotificationContent(
        title: '💪 Keep the Streak Alive!',
        body: '${ctx.cleanCourseCode} starts in ${ctx.offsetMins} mins at ${ctx.cleanVenue}. Every class counts, ${ctx.name}!',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('cup_r1', (ctx) => NotificationContent(
        title: '👀 Still in bed, ${ctx.name}?',
        body: '${ctx.cleanCourseCode} starts in ${ctx.offsetMins}m at ${ctx.cleanVenue}. Future you is judging current you!',
      )),
      NotificationTemplate('cup_r2', (ctx) => NotificationContent(
        title: '🚨 Attendance Target Weeping!',
        body: '${ctx.name}, get up! ${ctx.cleanCourseCode} at ${ctx.cleanVenue} starts in ${ctx.offsetMins} mins!',
      )),
    ],
  };

  // 2. CLASS STARTING NOW (T - 0m)
  static final Map<ActionTone, List<NotificationTemplate>> _startingClassMatrix = {
    ActionTone.playful: [
      NotificationTemplate('cst_p1', (ctx) => NotificationContent(
        title: '🔔 Class Starting Now: ${ctx.cleanCourseCode}',
        body: 'Professor is in ${ctx.cleanVenue}! Slide into your seat, ${ctx.name}.',
      )),
      NotificationTemplate('cst_p2', (ctx) => NotificationContent(
        title: '🚪 Doors Closing at ${ctx.cleanVenue}!',
        body: '${ctx.cleanCourseCode} is officially underway. Don\'t miss attendance!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('cst_d1', (ctx) => NotificationContent(
        title: '▶️ CLASS STARTING: ${ctx.cleanCourseCode}',
        body: 'Venue: ${ctx.cleanVenue}. Session has begun.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('cst_m1', (ctx) => NotificationContent(
        title: '🚀 Class Begins! ${ctx.cleanCourseCode}',
        body: 'Time to learn, ${ctx.name}. ${ctx.cleanCourseName} is in session at ${ctx.cleanVenue}.',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('cst_r1', (ctx) => NotificationContent(
        title: '🏃 Late Check-in Alert, ${ctx.name}!',
        body: '${ctx.cleanCourseCode} is starting NOW at ${ctx.cleanVenue}. Hope you can run fast!',
      )),
    ],
  };

  // 3. CLASS ENDING
  static final Map<ActionTone, List<NotificationTemplate>> _endingClassMatrix = {
    ActionTone.playful: [
      NotificationTemplate('cend_p1', (ctx) => NotificationContent(
        title: '🎉 Class Ended: ${ctx.cleanCourseCode}',
        body: 'Great job surviving ${ctx.cleanCourseName}! Don\'t forget to check off your attendance.',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('cend_d1', (ctx) => NotificationContent(
        title: '🏁 Class Completed: ${ctx.cleanCourseCode}',
        body: 'Session at ${ctx.cleanVenue} has concluded.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('cend_m1', (ctx) => NotificationContent(
        title: '🌟 One Step Closer, ${ctx.name}!',
        body: '${ctx.cleanCourseCode} finished. You\'re making steady academic progress!',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('cend_r1', (ctx) => NotificationContent(
        title: '🔔 Class Over, ${ctx.name}!',
        body: 'Wake up! ${ctx.cleanCourseCode} just finished. Time to stretch.',
      )),
    ],
  };

  // 4. MISSED CHECK-IN (T + 15m post class end)
  static final Map<ActionTone, List<NotificationTemplate>> _missedCheckinMatrix = {
    ActionTone.playful: [
      NotificationTemplate('mck_p1', (ctx) => NotificationContent(
        title: '❓ Did you attend ${ctx.cleanCourseCode}?',
        body: '${ctx.cleanCourseName} just ended. Confirm attendance or mark absent in Attendrix!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('mck_d1', (ctx) => NotificationContent(
        title: '📋 Attendance Unconfirmed: ${ctx.cleanCourseCode}',
        body: 'Class ended. Update your attendance status.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('mck_m1', (ctx) => NotificationContent(
        title: '📊 Keep Your Stats Accurate, ${ctx.name}!',
        body: 'Log your attendance for ${ctx.cleanCourseCode} to keep your target on track.',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('mck_r1', (ctx) => NotificationContent(
        title: '👻 Bunked or Just Forgot, ${ctx.name}?',
        body: 'Confirm if you were in ${ctx.cleanCourseCode} or suffer the attendance penalty!',
      )),
    ],
  };

  // 5. LOW ATTENDANCE WARNING
  static final Map<ActionTone, List<NotificationTemplate>> _lowAttendanceMatrix = {
    ActionTone.playful: [
      NotificationTemplate('lat_p1', (ctx) => NotificationContent(
        title: '⚠️ Attendance Drop Alert: ${ctx.cleanCourseCode}',
        body: 'Your attendance is at ${ctx.attendancePercentage?.toStringAsFixed(1)}% (Target: ${ctx.targetPercentage?.toStringAsFixed(0)}%). Don\'t miss the next class!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('lat_d1', (ctx) => NotificationContent(
        title: '⚠️ Low Attendance: ${ctx.cleanCourseCode}',
        body: 'Current: ${ctx.attendancePercentage?.toStringAsFixed(1)}% | Target: ${ctx.targetPercentage?.toStringAsFixed(0)}%. Action required.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('lat_m1', (ctx) => NotificationContent(
        title: '📈 Turn It Around, ${ctx.name}!',
        body: '${ctx.cleanCourseCode} is at ${ctx.attendancePercentage?.toStringAsFixed(1)}%. Attend the next 2 classes to cross ${ctx.targetPercentage?.toStringAsFixed(0)}%!',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('lat_r1', (ctx) => NotificationContent(
        title: '🚨 Danger Zone, ${ctx.name}!',
        body: '${ctx.cleanCourseCode} attendance is at ${ctx.attendancePercentage?.toStringAsFixed(1)}%! Bunking another class = automatic debarment risk!',
      )),
    ],
  };

  // 6. MESS MEALS (Breakfast, Lunch, Snacks, Dinner)
  static final Map<ActionTone, List<NotificationTemplate>> _messMealMatrix = {
    ActionTone.playful: [
      NotificationTemplate('mess_p1', (ctx) => NotificationContent(
        title: '🍽️ ${ctx.mealName ?? "Meal"} Time, ${ctx.name}!',
        body: '${ctx.cleanMenu}',
      )),
      NotificationTemplate('mess_p2', (ctx) => NotificationContent(
        title: '😋 Hungry, ${ctx.name}? ${ctx.mealName} is Ready!',
        body: '${ctx.cleanMenu}',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('mess_d1', (ctx) => NotificationContent(
        title: '🍱 Mess Schedule: ${ctx.mealName ?? "Meal"}',
        body: '${ctx.cleanMenu}',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('mess_m1', (ctx) => NotificationContent(
        title: '⚡ Fuel Up with ${ctx.mealName ?? "Meal"}!',
        body: '${ctx.cleanMenu}. Stay healthy and energized, ${ctx.name}!',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('mess_r1', (ctx) => NotificationContent(
        title: '🍔 Food Alert, ${ctx.name}!',
        body: 'Don\'t skip ${ctx.mealName ?? "meal"} unless you want to spend Rs. 200 on Zomato! ${ctx.cleanMenu}',
      )),
    ],
  };

  // 7. TASK UPCOMING & DUE TODAY & OVERDUE
  static final Map<ActionTone, List<NotificationTemplate>> _taskUpcomingMatrix = {
    ActionTone.playful: [
      NotificationTemplate('tup_p1', (ctx) => NotificationContent(
        title: '📌 Task Due Soon, ${ctx.name}!',
        body: '"${ctx.taskTitle ?? 'Task'}" for ${ctx.cleanCourseCode} is due in ${ctx.offsetHours} hours.',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('tup_d1', (ctx) => NotificationContent(
        title: '📋 Deadline in ${ctx.offsetHours}h: ${ctx.taskTitle}',
        body: 'Course: ${ctx.cleanCourseCode}. Submit on time.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('tup_m1', (ctx) => NotificationContent(
        title: '🚀 Knock It Out, ${ctx.name}!',
        body: '"${ctx.taskTitle}" is due in ${ctx.offsetHours}h. Complete it now for stress-free learning!',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('tup_r1', (ctx) => NotificationContent(
        title: '⏰ Procrastination Alert!',
        body: '${ctx.name}, "${ctx.taskTitle}" is due in ${ctx.offsetHours}h. Close YouTube and start typing!',
      )),
    ],
  };

  static final Map<ActionTone, List<NotificationTemplate>> _taskDueTodayMatrix = {
    ActionTone.playful: [
      NotificationTemplate('tdt_p1', (ctx) => NotificationContent(
        title: '🚨 Task Due Today, ${ctx.name}!',
        body: '"${ctx.taskTitle}" for ${ctx.cleanCourseCode} is due before midnight.',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('tdt_d1', (ctx) => NotificationContent(
        title: '⚠️ DUE TODAY: ${ctx.taskTitle}',
        body: 'Course: ${ctx.cleanCourseCode}. Outstanding assignment.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('tdt_m1', (ctx) => NotificationContent(
        title: '🎯 Submission Day, ${ctx.name}!',
        body: 'Finish "${ctx.taskTitle}" today and keep your academic momentum high.',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('tdt_r1', (ctx) => NotificationContent(
        title: '🔥 Last Chance, ${ctx.name}!',
        body: '"${ctx.taskTitle}" is due TODAY. Don\'t lose marks over a missed deadline!',
      )),
    ],
  };

  static final Map<ActionTone, List<NotificationTemplate>> _taskOverdueMatrix = {
    ActionTone.playful: [
      NotificationTemplate('tov_p1', (ctx) => NotificationContent(
        title: '⚠️ Task Overdue: ${ctx.taskTitle}',
        body: 'This task was due 1 hour ago. Submit it as soon as possible, ${ctx.name}!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('tov_d1', (ctx) => NotificationContent(
        title: '❌ OVERDUE: ${ctx.taskTitle}',
        body: 'Course: ${ctx.cleanCourseCode}. Past deadline.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('tov_m1', (ctx) => NotificationContent(
        title: '⏳ Late is Better Than Never!',
        body: '${ctx.name}, submit "${ctx.taskTitle}" now to recover maximum marks.',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('tov_r1', (ctx) => NotificationContent(
        title: '💀 You Missed It, ${ctx.name}!',
        body: '"${ctx.taskTitle}" is officially OVERDUE. Turn it in before late penalties multiply!',
      )),
    ],
  };

  // 8. EXAM NOTIFICATIONS (3 Days, 1 Day, 1 Hour)
  static final Map<ActionTone, List<NotificationTemplate>> _exam3DaysMatrix = {
    ActionTone.playful: [
      NotificationTemplate('ex3_p1', (ctx) => NotificationContent(
        title: '🎓 Exam in 3 Days: ${ctx.examTitle}',
        body: 'Course: ${ctx.cleanCourseCode} at ${ctx.cleanVenue}. Time to start revision, ${ctx.name}!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('ex3_d1', (ctx) => NotificationContent(
        title: '🗓️ Exam Alert (3 Days): ${ctx.examTitle}',
        body: 'Course: ${ctx.cleanCourseCode} | Venue: ${ctx.cleanVenue}.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('ex3_m1', (ctx) => NotificationContent(
        title: '📚 Exam Prep Window Open!',
        body: '${ctx.name}, ${ctx.examTitle} is 3 days away at ${ctx.cleanVenue}. Review a module today!',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('ex3_r1', (ctx) => NotificationContent(
        title: '⚠️ 72 Hours Remaining, ${ctx.name}!',
        body: '${ctx.examTitle} is in 3 days. Time to open the syllabus for the first time!',
      )),
    ],
  };

  static final Map<ActionTone, List<NotificationTemplate>> _exam1DayMatrix = {
    ActionTone.playful: [
      NotificationTemplate('ex1_p1', (ctx) => NotificationContent(
        title: '🚨 Exam Tomorrow: ${ctx.examTitle}',
        body: 'Scheduled at ${ctx.cleanVenue}. Get good sleep and pack your hall ticket, ${ctx.name}!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('ex1_d1', (ctx) => NotificationContent(
        title: '🚨 EXAM TOMORROW: ${ctx.examTitle}',
        body: 'Venue: ${ctx.cleanVenue}. Final preparation reminder.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('ex1_m1', (ctx) => NotificationContent(
        title: '🌟 You Are Prepared, ${ctx.name}!',
        body: '${ctx.examTitle} is tomorrow at ${ctx.cleanVenue}. Trust your preparation and do your best!',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('ex1_r1', (ctx) => NotificationContent(
        title: '🔥 Midnight Oil Time, ${ctx.name}!',
        body: '${ctx.examTitle} is TOMORROW at ${ctx.cleanVenue}. All-nighter or strategic sleep?',
      )),
    ],
  };

  static final Map<ActionTone, List<NotificationTemplate>> _exam1HourMatrix = {
    ActionTone.playful: [
      NotificationTemplate('ex1h_p1', (ctx) => NotificationContent(
        title: '⏳ Exam in 1 Hour: ${ctx.examTitle}',
        body: 'Head to ${ctx.cleanVenue} now, ${ctx.name}. Good luck!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('ex1h_d1', (ctx) => NotificationContent(
        title: '⚡ EXAM IN 1 HOUR: ${ctx.examTitle}',
        body: 'Location: ${ctx.cleanVenue}. Proceed to examination hall.',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('ex1h_m1', (ctx) => NotificationContent(
        title: '🏆 Time to Shine, ${ctx.name}!',
        body: '${ctx.examTitle} starts in 1 hour at ${ctx.cleanVenue}. Take a deep breath & excel!',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('ex1h_r1', (ctx) => NotificationContent(
        title: '🚨 Final Countdown: 60 Mins!',
        body: '${ctx.name}, ${ctx.examTitle} starts in 1 hour at ${ctx.cleanVenue}. Put down the phone and walk!',
      )),
    ],
  };

  // 9. DAILY BRIEFING (7:00 AM)
  static final Map<ActionTone, List<NotificationTemplate>> _dailyBriefMatrix = {
    ActionTone.playful: [
      NotificationTemplate('db_p1', (ctx) => NotificationContent(
        title: '☀️ Good Morning, ${ctx.name}!',
        body: 'Today\'s Agenda: ${ctx.classCount} classes and ${ctx.taskCount} tasks pending. Have a great day!',
      )),
      NotificationTemplate('db_p2', (ctx) => NotificationContent(
        title: '☕ Today at a Glance, ${ctx.name}',
        body: 'You have ${ctx.classCount} classes scheduled today. Check your daily mess menu in Attendrix!',
      )),
    ],
    ActionTone.direct: [
      NotificationTemplate('db_d1', (ctx) => NotificationContent(
        title: '📅 Daily Briefing',
        body: 'Classes today: ${ctx.classCount} | Pending tasks: ${ctx.taskCount}',
      )),
    ],
    ActionTone.motivational: [
      NotificationTemplate('db_m1', (ctx) => NotificationContent(
        title: '🌅 Rise & Conquer, ${ctx.name}!',
        body: 'A productive day awaits! You have ${ctx.classCount} classes and ${ctx.taskCount} tasks scheduled.',
      )),
    ],
    ActionTone.roast: [
      NotificationTemplate('db_r1', (ctx) => NotificationContent(
        title: '⏰ Wake Up Call, ${ctx.name}!',
        body: '${ctx.classCount} classes and ${ctx.taskCount} tasks waiting for you today. No snoozing allowed!',
      )),
    ],
  };
}

Future<void> generateNotificationMessage() async {
  // Placeholder export function to satisfy FlutterFlow custom action structure
}
