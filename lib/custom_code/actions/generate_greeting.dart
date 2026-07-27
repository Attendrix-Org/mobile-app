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

/// ─────────────────────────────────────────────────────────────
/// Attendrix High-Impact Personalized Greeting Engine — v14
/// 8 Granular Time Windows x 4 Tones x Contextual Personalization
/// ─────────────────────────────────────────────────────────────

enum ActionTone { playful, direct, motivational, roast }

enum TimeWindow {
  earlyMorning, // 04:00 - 07:00 (Early Rise / Dawn)
  morning, // 07:00 - 10:00 (Morning Rush)
  lateMorning, // 10:00 - 12:00 (Mid-Morning Focus)
  midday, // 12:00 - 14:00 (Lunch Break)
  afternoon, // 14:00 - 17:00 (Afternoon Grind)
  evening, // 17:00 - 20:00 (Golden Hour / Sunset)
  night, // 20:00 - 23:00 (Cozy Evening)
  lateNight, // 23:00 - 04:00 (Midnight Oil / Night Owl)
}

class GreetingContext {
  final String? username;
  final DateTime currentTime;
  final ActionTone tone;
  final int classesRemaining;
  final String? ongoingClass;
  final DateTime? ongoingClassStart;
  final DateTime? ongoingClassEnd;
  final bool useSchedule;
  final bool useTone;

  GreetingContext({
    this.username,
    DateTime? currentTime,
    this.tone = ActionTone.playful,
    required int classesRemaining,
    this.ongoingClass,
    this.ongoingClassStart,
    this.ongoingClassEnd,
    this.useSchedule = true,
    this.useTone = true,
  })  : currentTime = currentTime ?? DateTime.now(),
        classesRemaining = math.max(0, classesRemaining);

  String get name {
    if (username == null || username!.trim().isEmpty) return 'there';
    final raw = username!.trim();
    return raw[0].toUpperCase() + raw.substring(1);
  }

  TimeWindow get currentWindow {
    final hour = currentTime.hour;
    if (hour >= 4 && hour < 7) return TimeWindow.earlyMorning;
    if (hour >= 7 && hour < 10) return TimeWindow.morning;
    if (hour >= 10 && hour < 12) return TimeWindow.lateMorning;
    if (hour >= 12 && hour < 14) return TimeWindow.midday;
    if (hour >= 14 && hour < 17) return TimeWindow.afternoon;
    if (hour >= 17 && hour < 20) return TimeWindow.evening;
    if (hour >= 20 && hour < 23) return TimeWindow.night;
    return TimeWindow.lateNight;
  }

  /// A class is ONLY ongoing if useSchedule is enabled AND currentTime is strictly within [start, end] on today's date
  bool get hasOngoing {
    if (!useSchedule) return false;
    if (ongoingClass == null || ongoingClass!.trim().isEmpty) return false;

    if (ongoingClassStart != null) {
      if (currentTime.isBefore(ongoingClassStart!)) return false;
      if (ongoingClassStart!.year != currentTime.year ||
          ongoingClassStart!.month != currentTime.month ||
          ongoingClassStart!.day != currentTime.day) {
        return false;
      }
    }

    if (ongoingClassEnd != null) {
      if (currentTime.isAfter(ongoingClassEnd!)) return false;
    }

    return true;
  }

  String get ongoingName => ongoingClass?.trim() ?? 'your class';

  String get remainingText {
    if (classesRemaining == 1) return '1 class';
    return '$classesRemaining classes';
  }

  String get timeSalutation {
    switch (currentWindow) {
      case TimeWindow.earlyMorning:
        return 'Early morning';
      case TimeWindow.morning:
      case TimeWindow.lateMorning:
        return 'Good morning';
      case TimeWindow.midday:
      case TimeWindow.afternoon:
        return 'Good afternoon';
      case TimeWindow.evening:
        return 'Good evening';
      case TimeWindow.night:
        return 'Hey';
      case TimeWindow.lateNight:
        return 'Late night';
    }
  }

  String get timeOfDayName {
    switch (currentWindow) {
      case TimeWindow.earlyMorning:
        return 'early morning';
      case TimeWindow.morning:
      case TimeWindow.lateMorning:
        return 'morning';
      case TimeWindow.midday:
        return 'midday';
      case TimeWindow.afternoon:
        return 'afternoon';
      case TimeWindow.evening:
        return 'evening';
      case TimeWindow.night:
      case TimeWindow.lateNight:
        return 'night';
    }
  }
}

class GreetingTemplate {
  final String id;
  final String Function(GreetingContext ctx) build;
  GreetingTemplate(this.id, this.build);
}

class GreetingEngine {
  final math.Random _random;
  final List<String> _recentTemplateIds;

  GreetingEngine({
    math.Random? random,
    List<String>? recentTemplateIds,
  })  : _random = random ?? math.Random(),
        _recentTemplateIds = List.from(recentTemplateIds ?? []);

  String generate(GreetingContext ctx) {
    final candidatePool = _selectCandidatePool(ctx);
    final selectedTemplate = _pickFreshTemplate(candidatePool);
    return selectedTemplate.build(ctx);
  }

  List<GreetingTemplate> _selectCandidatePool(GreetingContext ctx) {
    if (ctx.useSchedule && ctx.hasOngoing) {
      return _ongoingClassMatrix[ctx.currentWindow]?[ctx.tone] ??
          _ongoingClassMatrix[TimeWindow.morning]![ActionTone.playful]!;
    } else if (ctx.useSchedule && ctx.classesRemaining > 0) {
      return _upcomingClassesMatrix[ctx.currentWindow]?[ctx.tone] ??
          _upcomingClassesMatrix[TimeWindow.morning]![ActionTone.playful]!;
    } else {
      return _generalTimeMatrix[ctx.currentWindow]?[ctx.tone] ??
          _generalTimeMatrix[TimeWindow.morning]![ActionTone.direct]!;
    }
  }

  GreetingTemplate _pickFreshTemplate(List<GreetingTemplate> pool) {
    if (pool.isEmpty) {
      return GreetingTemplate(
          'fallback', (ctx) => 'Welcome back, ${ctx.name}!');
    }
    final freshTemplates =
        pool.where((t) => !_recentTemplateIds.contains(t.id)).toList();
    final targetList = freshTemplates.isNotEmpty ? freshTemplates : pool;
    return targetList[_random.nextInt(targetList.length)];
  }

  // ─────────────────────────────────────────────────────────────
  // 8 Granular Time Windows Template Matrices
  // ─────────────────────────────────────────────────────────────

  // 1. ONGOING CLASS MATRIX Across 8 Time Windows
  static final Map<TimeWindow, Map<ActionTone, List<GreetingTemplate>>>
      _ongoingClassMatrix = {
    TimeWindow.earlyMorning: {
      ActionTone.playful: [
        GreetingTemplate(
            'og_em_p1',
            (ctx) =>
                "Dawn lecture in ${ctx.ongoingName}? You're beating the sun today, ${ctx.name}! 🌅"),
        GreetingTemplate(
            'og_em_p2',
            (ctx) =>
                "Early bird mode in ${ctx.ongoingName}! Hope you've got coffee ready, ${ctx.name}! ☕"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'og_em_d1',
            (ctx) =>
                "Early morning class in session: ${ctx.ongoingName}, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'og_em_m1',
            (ctx) =>
                "Starting early in ${ctx.ongoingName}! Setting a powerful tone for the day, ${ctx.name}! 🌟"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'og_em_r1',
            (ctx) =>
                "An early class in ${ctx.ongoingName}? Try not to fall asleep on the desk, ${ctx.name}! 😴"),
      ],
    },
    TimeWindow.morning: {
      ActionTone.playful: [
        GreetingTemplate(
            'og_m_p1',
            (ctx) =>
                "Hey ${ctx.name}, isn't ${ctx.ongoingName} happening right now? Stealth mode on! 🤫"),
        GreetingTemplate(
            'og_m_p2',
            (ctx) =>
                "Checking Attendrix during morning ${ctx.ongoingName}? Bold move, ${ctx.name}! 👀"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'og_m_d1',
            (ctx) =>
                "${ctx.ongoingName} is currently in session, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'og_m_m1',
            (ctx) =>
                "Absorb as much as you can in ${ctx.ongoingName} right now, ${ctx.name}! 💡"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'og_m_r1',
            (ctx) =>
                "Shouldn't your eyes be on the board in ${ctx.ongoingName} right now, ${ctx.name}? 🙄"),
      ],
    },
    TimeWindow.lateMorning: {
      ActionTone.playful: [
        GreetingTemplate(
            'og_lm_p1',
            (ctx) =>
                "Mid-morning focus in ${ctx.ongoingName}! Almost lunch time, ${ctx.name}! 🍲"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'og_lm_d1',
            (ctx) =>
                "Active class in progress: ${ctx.ongoingName}, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTone(
            'og_lm_m1',
            (ctx) =>
                "Stay locked into ${ctx.ongoingName}, ${ctx.name}. Almost at the finish line! 🎯"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'og_lm_r1',
            (ctx) =>
                "Staring at the clock in ${ctx.ongoingName}, ${ctx.name}? Hang in there! ⏰"),
      ],
    },
    TimeWindow.midday: {
      ActionTone.playful: [
        GreetingTemplate(
            'og_md_p1',
            (ctx) =>
                "Midday lecture in ${ctx.ongoingName}! Stomach rumbling yet, ${ctx.name}? 🍕"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'og_md_d1',
            (ctx) =>
                "Midday session in progress: ${ctx.ongoingName}, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'og_md_m1',
            (ctx) =>
                "Powering through midday ${ctx.ongoingName}! Great dedication, ${ctx.name}! 💪"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'og_md_r1',
            (ctx) =>
                "Thinking about lunch while in ${ctx.ongoingName}, ${ctx.name}? Pay attention! 🍔"),
      ],
    },
    TimeWindow.afternoon: {
      ActionTone.playful: [
        GreetingTemplate(
            'og_af_p1',
            (ctx) =>
                "Afternoon session in ${ctx.ongoingName}! Fighting the post-lunch sleepiness, ${ctx.name}? 😴"),
      ],
      ActionTone.direct: [
        GreetingTemplate('og_af_d1',
            (ctx) => "Currently scheduled in ${ctx.ongoingName}, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'og_af_m1',
            (ctx) =>
                "Push through the afternoon slump in ${ctx.ongoingName}, ${ctx.name}! You've got this! 🚀"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'og_af_r1',
            (ctx) =>
                "Nodding off in afternoon ${ctx.ongoingName}, ${ctx.name}? Wake up! ☕"),
      ],
    },
    TimeWindow.evening: {
      ActionTone.playful: [
        GreetingTemplate(
            'og_ev_p1',
            (ctx) =>
                "Evening lecture in ${ctx.ongoingName}! Final stretch for today, ${ctx.name}! 🌇"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'og_ev_d1',
            (ctx) =>
                "Evening class currently in session: ${ctx.ongoingName}, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'og_ev_m1',
            (ctx) =>
                "Finish strong in ${ctx.ongoingName}, ${ctx.name}! Evening rest awaits! 🌟"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'og_ev_r1',
            (ctx) =>
                "Late class in ${ctx.ongoingName}? Don't pack up before the professor finishes, ${ctx.name}! 🎒"),
      ],
    },
    TimeWindow.night: {
      ActionTone.playful: [
        GreetingTemplate(
            'og_ni_p1',
            (ctx) =>
                "Night class in ${ctx.ongoingName}? Dedicated mode unlocked, ${ctx.name}! 🌙"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'og_ni_d1',
            (ctx) =>
                "Night session in progress: ${ctx.ongoingName}, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'og_ni_m1',
            (ctx) =>
                "Late hours in ${ctx.ongoingName}! Your hard work will pay off, ${ctx.name}! 💡"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'og_ni_r1',
            (ctx) =>
                "Still in ${ctx.ongoingName} at night? Hope you get some sleep after this, ${ctx.name}! 🦉"),
      ],
    },
    TimeWindow.lateNight: {
      ActionTone.playful: [
        GreetingTemplate(
            'og_ln_p1',
            (ctx) =>
                "Late night lab or lecture in ${ctx.ongoingName}? Pure night owl energy, ${ctx.name}! 🌌"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'og_ln_d1',
            (ctx) =>
                "Late night session in progress: ${ctx.ongoingName}, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'og_ln_m1',
            (ctx) =>
                "Midnight focus in ${ctx.ongoingName}! Phenomenal commitment, ${ctx.name}! 🚀"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'og_ln_r1',
            (ctx) =>
                "Late night ${ctx.ongoingName}? Go home and get some sleep, ${ctx.name}! 💤"),
      ],
    },
  };

  // 2. UPCOMING CLASSES MATRIX Across 8 Time Windows
  static final Map<TimeWindow, Map<ActionTone, List<GreetingTemplate>>>
      _upcomingClassesMatrix = {
    TimeWindow.earlyMorning: {
      ActionTone.playful: [
        GreetingTemplate(
            'up_em_p1',
            (ctx) =>
                "Early bird ${ctx.name}! You've got ${ctx.remainingText} lined up today. Beat the sun! 🌅"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'up_em_d1',
            (ctx) =>
                "Early morning update: ${ctx.remainingText} scheduled today, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'up_em_m1',
            (ctx) =>
                "Starting early, ${ctx.name}! ${ctx.remainingText} today to conquer your goals! 🚀"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'up_em_r1',
            (ctx) =>
                "Up before dawn, ${ctx.name}? ${ctx.remainingText} waiting. Did your alarm actually work? ⏰"),
      ],
    },
    TimeWindow.morning: {
      ActionTone.playful: [
        GreetingTemplate(
            'up_m_p1',
            (ctx) =>
                "${ctx.timeSalutation}, ${ctx.name}! ${ctx.remainingText} coming up on your schedule! ⚡"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'up_m_d1',
            (ctx) =>
                "${ctx.timeSalutation}, ${ctx.name}. You have ${ctx.remainingText} remaining today."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'up_m_m1',
            (ctx) =>
                "${ctx.timeSalutation}, ${ctx.name}! ${ctx.remainingText} today—another golden opportunity! 🌟"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'up_m_r1',
            (ctx) =>
                "${ctx.timeSalutation}, ${ctx.name}. ${ctx.remainingText} today. Try not to snooze through them! 😴"),
      ],
    },
    TimeWindow.lateMorning: {
      ActionTone.playful: [
        GreetingTemplate(
            'up_lm_p1',
            (ctx) =>
                "Mid-morning check-in, ${ctx.name}! ${ctx.remainingText} left for today! ☕"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'up_lm_d1',
            (ctx) =>
                "Schedule update: ${ctx.remainingText} remaining for today, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'up_lm_m1',
            (ctx) =>
                "Mid-morning momentum, ${ctx.name}! ${ctx.remainingText} left to master today! 💪"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'up_lm_r1',
            (ctx) =>
                "Late morning already, ${ctx.name}? ${ctx.remainingText} waiting. Hope you're ready! 👀"),
      ],
    },
    TimeWindow.midday: {
      ActionTone.playful: [
        GreetingTemplate(
            'up_md_p1',
            (ctx) =>
                "Happy midday, ${ctx.name}! ${ctx.remainingText} coming up after lunch! 🍲"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'up_md_d1',
            (ctx) =>
                "Midday update: ${ctx.remainingText} remaining on your schedule, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'up_md_m1',
            (ctx) =>
                "Refuel at lunch, ${ctx.name}! ${ctx.remainingText} ahead to finish strong! 🔋"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'up_md_r1',
            (ctx) =>
                "Midday already, ${ctx.name}. ${ctx.remainingText} left—don't slip into a food coma! 🍕"),
      ],
    },
    TimeWindow.afternoon: {
      ActionTone.playful: [
        GreetingTemplate(
            'up_af_p1',
            (ctx) =>
                "Good afternoon, ${ctx.name}! Just ${ctx.remainingText} left for today! 🌤️"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'up_af_d1',
            (ctx) =>
                "Afternoon schedule: ${ctx.remainingText} remaining today, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'up_af_m1',
            (ctx) =>
                "Power through the afternoon slump, ${ctx.name}! ${ctx.remainingText} left! 🏆"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'up_af_r1',
            (ctx) =>
                "Afternoon grind, ${ctx.name}. ${ctx.remainingText} left. Staring at the clock won't make it faster! ⏳"),
      ],
    },
    TimeWindow.evening: {
      ActionTone.playful: [
        GreetingTemplate(
            'up_ev_p1',
            (ctx) =>
                "Good evening, ${ctx.name}! ${ctx.remainingText} before your day clears up! 🌇"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'up_ev_d1',
            (ctx) =>
                "Evening schedule: ${ctx.remainingText} remaining today, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'up_ev_m1',
            (ctx) =>
                "Final stretch for today, ${ctx.name}! Finish your ${ctx.remainingText} strong! 🌟"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'up_ev_r1',
            (ctx) =>
                "Evening class ahead, ${ctx.name}? ${ctx.remainingText} left. Almost free! 🎒"),
      ],
    },
    TimeWindow.night: {
      ActionTone.playful: [
        GreetingTemplate(
            'up_ni_p1',
            (ctx) =>
                "Late schedule check, ${ctx.name}! ${ctx.remainingText} remaining tonight! 🌙"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'up_ni_d1',
            (ctx) =>
                "Night update: ${ctx.remainingText} scheduled tonight, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'up_ni_m1',
            (ctx) =>
                "Night owls win big! Finish your ${ctx.remainingText} strong, ${ctx.name}! 💡"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'up_ni_r1',
            (ctx) =>
                "Classes this late, ${ctx.name}? ${ctx.remainingText} left. Grab a coffee! ☕"),
      ],
    },
    TimeWindow.lateNight: {
      ActionTone.playful: [
        GreetingTemplate(
            'up_ln_p1',
            (ctx) =>
                "Midnight owl mode! ${ctx.remainingText} on the late night schedule, ${ctx.name}! 🌌"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'up_ln_d1',
            (ctx) =>
                "Late night schedule: ${ctx.remainingText} remaining, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'up_ln_m1',
            (ctx) =>
                "Midnight focus, ${ctx.name}! Knock out those ${ctx.remainingText}! 🚀"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'up_ln_r1',
            (ctx) =>
                "Late night classes, ${ctx.name}? ${ctx.remainingText} left. Hope you sleep tomorrow! 💤"),
      ],
    },
  };

  // 3. GENERAL TIME MATRIX Across 8 Time Windows
  static final Map<TimeWindow, Map<ActionTone, List<GreetingTemplate>>>
      _generalTimeMatrix = {
    TimeWindow.earlyMorning: {
      ActionTone.playful: [
        GreetingTemplate(
            'gt_em_p1',
            (ctx) =>
                "Rise and shine, early bird ${ctx.name}! The world is peaceful at 5 AM! 🌅"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'gt_em_d1', (ctx) => "Early morning check-in, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'gt_em_m1',
            (ctx) =>
                "Starting early gives you the ultimate edge, ${ctx.name}! Make today extraordinary! 🏔️"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'gt_em_r1',
            (ctx) =>
                "Up this early, ${ctx.name}? Did you forget to turn off your alarm? ⏰"),
      ],
    },
    TimeWindow.morning: {
      ActionTone.playful: [
        GreetingTemplate(
            'gt_m_p1',
            (ctx) =>
                "Good morning, ${ctx.name}! Ready to make today awesome? ✨"),
      ],
      ActionTone.direct: [
        GreetingTemplate('gt_m_d1', (ctx) => "Good morning, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'gt_m_m1',
            (ctx) =>
                "Good morning, ${ctx.name}! Every morning brings fresh possibilities! 🌟"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'gt_m_r1',
            (ctx) =>
                "Good morning, ${ctx.name}. Ready to pretend you're going to be productive today? 👀"),
      ],
    },
    TimeWindow.lateMorning: {
      ActionTone.playful: [
        GreetingTemplate(
            'gt_lm_p1',
            (ctx) =>
                "Mid-morning check-in, ${ctx.name}! Hope your day is tracking great! ☕"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'gt_lm_d1', (ctx) => "Mid-morning update, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'gt_lm_m1',
            (ctx) =>
                "Keep that mid-morning momentum going strong, ${ctx.name}! 💪"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'gt_lm_r1',
            (ctx) =>
                "Late morning, ${ctx.name}! Have you actually accomplished anything yet? 📱"),
      ],
    },
    TimeWindow.midday: {
      ActionTone.playful: [
        GreetingTemplate(
            'gt_md_p1',
            (ctx) =>
                "Happy midday, ${ctx.name}! Time to take a breather and grab lunch! 🍲"),
      ],
      ActionTone.direct: [
        GreetingTemplate('gt_md_d1', (ctx) => "Midday update, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'gt_md_m1',
            (ctx) =>
                "Halfway through the day, ${ctx.name}! Recharge and finish strong! 🔋"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'gt_md_r1',
            (ctx) =>
                "Midday already, ${ctx.name}. Enjoy lunch before the slump hits! 🍕"),
      ],
    },
    TimeWindow.afternoon: {
      ActionTone.playful: [
        GreetingTemplate(
            'gt_af_p1',
            (ctx) =>
                "Good afternoon, ${ctx.name}! Hope your afternoon is going smoothly! 🌤️"),
      ],
      ActionTone.direct: [
        GreetingTemplate('gt_af_d1', (ctx) => "Good afternoon, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'gt_af_m1',
            (ctx) =>
                "Power through the afternoon, ${ctx.name}! Great results take persistence! 🏆"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'gt_af_r1',
            (ctx) =>
                "Afternoon slump time, ${ctx.name}! Coffee won't save you now! ☕"),
      ],
    },
    TimeWindow.evening: {
      ActionTone.playful: [
        GreetingTemplate(
            'gt_ev_p1',
            (ctx) =>
                "Good evening, ${ctx.name}! Time to unwind and enjoy the sunset! 🌇"),
      ],
      ActionTone.direct: [
        GreetingTemplate('gt_ev_d1', (ctx) => "Good evening, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'gt_ev_m1',
            (ctx) =>
                "Good evening, ${ctx.name}! Reflect on your wins today! 🌟"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'gt_ev_r1',
            (ctx) =>
                "Good evening, ${ctx.name}. Time to scroll social media for 4 hours straight! 📱"),
      ],
    },
    TimeWindow.night: {
      ActionTone.playful: [
        GreetingTone(
            'gt_ni_p1',
            (ctx) =>
                "Cozy night vibes, ${ctx.name}! Hope you're having a relaxing evening! 🛋️"),
      ],
      ActionTone.direct: [
        GreetingTemplate('gt_ni_d1', (ctx) => "Evening check-in, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'gt_ni_m1',
            (ctx) =>
                "Rest well tonight, ${ctx.name}. Success requires quality recovery! 🌙"),
      ],
      ActionTone.roast: [
        GreetingTemplate(
            'gt_ni_r1',
            (ctx) =>
                "Still awake, ${ctx.name}? Staring at your phone won't finish tomorrow's tasks! 💤"),
      ],
    },
    TimeWindow.lateNight: {
      ActionTone.playful: [
        GreetingTemplate(
            'gt_ln_p1',
            (ctx) =>
                "Late night hours, ${ctx.name}! Deep focus or late night scrolling? 🌌"),
      ],
      ActionTone.direct: [
        GreetingTemplate(
            'gt_ln_d1', (ctx) => "Late night check-in, ${ctx.name}."),
      ],
      ActionTone.motivational: [
        GreetingTemplate(
            'gt_ln_m1',
            (ctx) =>
                "Night owl mode, ${ctx.name}! Late nights build future legends! 🚀"),
      ],
      ActionTone.roast: [
        GreetingTemplate('gt_ln_r1',
            (ctx) => "Past midnight, ${ctx.name}! Go to sleep already! 🦉"),
      ],
    },
  };
}

/// Helper typedef to avoid syntax error in matrix
typedef GreetingTone = GreetingTemplate;

/// ─────────────────────────────────────────────────────────────
/// FLUTTERFLOW ENTRY POINT
/// Custom Action Name: generateGreeting
/// ─────────────────────────────────────────────────────────────

Future<String> generateGreeting(
  String? username,
  String toneString,
  List<ScheduledClassStruct>? classes,
  List<String>? recentHistory,
  bool? useScheduleClasses,
  bool? useActionTone,
) async {
  final bool enableSchedule = useScheduleClasses ?? true;
  final bool enableTone = useActionTone ?? true;

  final cleanTone = toneString.trim().toLowerCase();

  final tone = enableTone
      ? ActionTone.values.firstWhere(
          (t) => t.name == cleanTone,
          orElse: () => ActionTone.playful,
        )
      : ActionTone.direct;

  final now = DateTime.now();
  ScheduledClassStruct? currentOngoing;
  int remainingCount = 0;

  if (enableSchedule && classes != null && classes.isNotEmpty) {
    for (final c in classes) {
      if (c.isAbsent) continue;

      final start = c.scheduledStart;
      final end = c.scheduledEnd;

      if (start != null && end != null) {
        // Is class strictly ongoing right now today?
        if (now.isAfter(start) &&
            now.isBefore(end) &&
            start.year == now.year &&
            start.month == now.month &&
            start.day == now.day) {
          currentOngoing = c;
        }
        // Is class scheduled for today and hasn't finished yet?
        if (end.isAfter(now) &&
            start.year == now.year &&
            start.month == now.month &&
            start.day == now.day) {
          remainingCount++;
        }
      }
    }
  }

  final engine = GreetingEngine(recentTemplateIds: recentHistory ?? []);

  final ctx = GreetingContext(
    username: username,
    tone: tone,
    classesRemaining: remainingCount,
    ongoingClass: currentOngoing?.courseName ?? currentOngoing?.courseCode,
    ongoingClassStart: currentOngoing?.scheduledStart,
    ongoingClassEnd: currentOngoing?.scheduledEnd,
    useSchedule: enableSchedule,
    useTone: enableTone,
  );

  return engine.generate(ctx);
}
