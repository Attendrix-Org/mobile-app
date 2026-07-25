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
import 'dart:convert';

/// ─────────────────────────────────────────────────────────────
/// Internal Types & Engine Logic
/// ─────────────────────────────────────────────────────────────

enum ActionTone { playful, direct, motivational, roast }

class GreetingContext {
  final String? username;
  final DateTime currentTime;
  final ActionTone tone;
  final int classesRemaining;
  final String? ongoingClass;

  GreetingContext({
    this.username,
    DateTime? currentTime,
    this.tone = ActionTone.playful,
    required int classesRemaining,
    this.ongoingClass,
  })  : currentTime = currentTime ?? DateTime.now(),
        classesRemaining = math.max(0, classesRemaining);

  String get name => (username == null || username!.trim().isEmpty)
      ? 'there'
      : username!.trim();

  bool get hasOngoing =>
      ongoingClass != null && ongoingClass!.trim().isNotEmpty;

  String get ongoingName => ongoingClass?.trim() ?? '';

  String get classPlural => classesRemaining == 1 ? 'class' : 'classes';

  String get timeGreeting {
    final hour = currentTime.hour;
    if (hour >= 4 && hour < 12) return 'Good morning';
    if (hour >= 12 && hour < 17) return 'Good afternoon';
    if (hour >= 17 && hour < 22) return 'Good evening';
    return 'Hey';
  }
}

class GreetingTemplate {
  final String id;
  final String Function(GreetingContext ctx) build;
  const GreetingTemplate(this.id, this.build);
}

class GreetingEngine {
  final math.Random _random;
  final List<String> _recentTemplateIds;
  final int maxHistorySize;

  GreetingEngine({
    math.Random? random,
    this.maxHistorySize = 10,
    List<String>? recentTemplateIds,
  })  : _random = random ?? math.Random(),
        _recentTemplateIds = List.from(recentTemplateIds ?? []);

  List<String> get recentTemplateIds => List.unmodifiable(_recentTemplateIds);

  String generate(GreetingContext ctx) {
    final candidatePool = _selectCandidatePool(ctx);
    final selectedTemplate = _pickFreshTemplate(candidatePool);
    return selectedTemplate.build(ctx);
  }

  List<GreetingTemplate> _selectCandidatePool(GreetingContext ctx) {
    if (ctx.hasOngoing) {
      return _ongoingClassMatrix[ctx.tone] ??
          _ongoingClassMatrix[ActionTone.playful]!;
    } else if (ctx.classesRemaining == 0) {
      return _noClassesMatrix[ctx.tone] ??
          _noClassesMatrix[ActionTone.playful]!;
    } else {
      return _upcomingClassesMatrix[ctx.tone] ??
          _upcomingClassesMatrix[ActionTone.playful]!;
    }
  }

  GreetingTemplate _pickFreshTemplate(List<GreetingTemplate> pool) {
    if (pool.isEmpty) {
      return const GreetingTemplate('fallback', (ctx) => 'Welcome back!');
    }
    final freshTemplates =
        pool.where((t) => !_recentTemplateIds.contains(t.id)).toList();
    final targetList = freshTemplates.isNotEmpty ? freshTemplates : pool;
    return targetList[_random.nextInt(targetList.length)];
  }

  // ─────────────────────────────────────────────────────────────
  // Static Matrices (Optimized once at class load time)
  // ─────────────────────────────────────────────────────────────

  static final Map<ActionTone, List<GreetingTemplate>> _ongoingClassMatrix = {
    ActionTone.playful: [
      GreetingTemplate(
          'og_p1',
          (ctx) =>
              "Hope ${ctx.ongoingName} is treating you well, ${ctx.name}! ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} more ${ctx.classPlural} to go after this.' : 'This is your last class of the day!'}"),
      GreetingTemplate(
          'og_p2',
          (ctx) =>
              "In the zone during ${ctx.ongoingName}, ${ctx.name}? ${ctx.classesRemaining > 0 ? 'Hang in there, ${ctx.classesRemaining} left after this.' : 'Almost done for the day!'}"),
      GreetingTemplate(
          'og_p3',
          (ctx) =>
              "Powering through ${ctx.ongoingName}! ${ctx.classesRemaining > 0 ? 'Just ${ctx.classesRemaining} more ${ctx.classPlural} standing between you and freedom.' : 'Home stretch now!'}"),
      GreetingTemplate(
          'og_p4',
          (ctx) =>
              "Currently surviving ${ctx.ongoingName}, ${ctx.name}? ${ctx.classesRemaining > 0 ? 'Keep at it, ${ctx.classesRemaining} to go!' : 'Last hurdle of the day!'}"),
      GreetingTemplate(
          'og_p5',
          (ctx) =>
              "Multitasking in ${ctx.ongoingName}, ${ctx.name}? ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} more ${ctx.classPlural} until you can relax.' : 'Final stretch!'}"),
      GreetingTemplate(
          'og_p6',
          (ctx) =>
              "Sneaking a peek at Attendrix during ${ctx.ongoingName}? We won't tell! ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} left after this.' : 'You\'re almost free!'}"),
      GreetingTemplate(
          'og_p7',
          (ctx) =>
              "Absorbing knowledge in ${ctx.ongoingName}, ${ctx.name}? ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} ${ctx.classPlural} remaining today.' : 'Finish line ahead!'}"),
      GreetingTemplate(
          'og_p8',
          (ctx) =>
              "Hope your professor in ${ctx.ongoingName} isn't watching, ${ctx.name}! ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} to go after this.' : 'Last class!'}"),
      GreetingTemplate(
          'og_p9',
          (ctx) =>
              "Mid-class check-in for ${ctx.ongoingName}! ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} more ${ctx.classPlural} and the day is yours.' : 'Almost complete!'}"),
      GreetingTemplate(
          'og_p10',
          (ctx) =>
              "CRUSHING IT in ${ctx.ongoingName}, ${ctx.name}! Keep that momentum, ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} left!' : 'this is the final one!'}"),
      GreetingTemplate(
          'og_p11',
          (ctx) =>
              "Brain operating at maximum capacity in ${ctx.ongoingName}? ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} more ${ctx.classPlural} to conquer today.' : 'Final lap!'}"),
      GreetingTemplate(
          'og_p12',
          (ctx) =>
              "Taking mental notes in ${ctx.ongoingName}, ${ctx.name}? You're in the home stretch with ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} to go!' : 'the last session!'}"),
      GreetingTemplate(
          'og_p13',
          (ctx) =>
              "Surviving the slides in ${ctx.ongoingName}? Hang tight, ${ctx.name}, ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} ${ctx.classPlural} left!' : 'this is it!'}"),
      GreetingTemplate(
          'og_p14',
          (ctx) =>
              "Legend has it you're still awake in ${ctx.ongoingName}, ${ctx.name}! Just ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} to go after this.' : 'one more push!'}"),
      GreetingTemplate(
          'og_p15',
          (ctx) =>
              "Pro tip for ${ctx.ongoingName}: stay hydrated! ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} more ${ctx.classPlural} on today\'s schedule.' : 'You\'re on the final class!'}"),
      GreetingTemplate(
          'og_p16',
          (ctx) =>
              "Clock ticking in ${ctx.ongoingName}? Stay strong, ${ctx.name}! Only ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} ${ctx.classPlural} left today.' : 'almost done!'}"),
    ],
    ActionTone.direct: [
      GreetingTemplate(
          'og_d1',
          (ctx) =>
              "You're currently attending ${ctx.ongoingName}. ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} ${ctx.classPlural} remain today.' : 'This is your final class today.'}"),
      GreetingTemplate(
          'og_d2',
          (ctx) =>
              "Currently in ${ctx.ongoingName}. ${ctx.classesRemaining} ${ctx.classPlural} remaining after this."),
      GreetingTemplate(
          'og_d3',
          (ctx) =>
              "In progress: ${ctx.ongoingName}. ${ctx.classesRemaining > 0 ? 'Remaining schedule: ${ctx.classesRemaining} ${ctx.classPlural}.' : 'No remaining classes after this.'}"),
      GreetingTemplate(
          'og_d4',
          (ctx) =>
              "Status: In ${ctx.ongoingName}. ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} ${ctx.classPlural} left on today\'s schedule.' : 'Last session underway.'}"),
      GreetingTemplate(
          'og_d5',
          (ctx) =>
              "Current class: ${ctx.ongoingName}. Remaining classes today: ${ctx.classesRemaining}."),
      GreetingTemplate(
          'og_d6',
          (ctx) =>
              "Attending ${ctx.ongoingName}, ${ctx.name}. ${ctx.classesRemaining} ${ctx.classPlural} remaining."),
      GreetingTemplate(
          'og_d7',
          (ctx) =>
              "Live class: ${ctx.ongoingName}. ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} ${ctx.classPlural} remaining until schedule completion.' : 'Final session.'}"),
      GreetingTemplate(
          'og_d8',
          (ctx) =>
              "Active session: ${ctx.ongoingName}. Schedule progress: ${ctx.classesRemaining} ${ctx.classPlural} left."),
      GreetingTemplate(
          'og_d9',
          (ctx) =>
              "Currently in session: ${ctx.ongoingName}. ${ctx.classesRemaining} ${ctx.classPlural} remaining."),
      GreetingTemplate(
          'og_d10',
          (ctx) =>
              "In class: ${ctx.ongoingName}. Remaining today: ${ctx.classesRemaining} ${ctx.classPlural}."),
      GreetingTemplate(
          'og_d11',
          (ctx) =>
              "Class underway: ${ctx.ongoingName}. ${ctx.classesRemaining} ${ctx.classPlural} scheduled after this."),
      GreetingTemplate(
          'og_d12',
          (ctx) =>
              "Schedule alert: ${ctx.ongoingName} in progress. ${ctx.classesRemaining} ${ctx.classPlural} remaining."),
    ],
    ActionTone.motivational: [
      GreetingTemplate(
          'og_m1',
          (ctx) =>
              "Stay focused through ${ctx.ongoingName}. ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} more ${ctx.classPlural} and another productive day is yours.' : 'Finish this last session strong!'}"),
      GreetingTemplate(
          'og_m2',
          (ctx) =>
              "Give ${ctx.ongoingName} your full attention, ${ctx.name}. Every minute spent learning moves you closer to your goal."),
      GreetingTemplate(
          'og_m3',
          (ctx) =>
              "Make ${ctx.ongoingName} count! ${ctx.classesRemaining > 0 ? 'Keep that momentum going for the next ${ctx.classesRemaining} ${ctx.classPlural}.' : 'End the day on a high note!'}"),
      GreetingTemplate(
          'og_m4',
          (ctx) =>
              "Locked in on ${ctx.ongoingName}. You're making progress every single minute, ${ctx.name}."),
      GreetingTemplate(
          'og_m5',
          (ctx) =>
              "Every concept mastered in ${ctx.ongoingName} is a step toward your future. Stay sharp, ${ctx.name}!"),
      GreetingTemplate(
          'og_m6',
          (ctx) =>
              "Building excellence in ${ctx.ongoingName}! Finish this session strong, ${ctx.name}."),
      GreetingTemplate(
          'og_m7',
          (ctx) =>
              "Your dedication in ${ctx.ongoingName} today will pay off tenfold tomorrow. Keep striving, ${ctx.name}!"),
      GreetingTemplate(
          'og_m8',
          (ctx) =>
              "Turn your effort in ${ctx.ongoingName} into brilliance. You've got this, ${ctx.name}!"),
      GreetingTemplate(
          'og_m9',
          (ctx) =>
              "Great minds stay focused. Give ${ctx.ongoingName} your best energy, ${ctx.name}!"),
      GreetingTemplate(
          'og_m10',
          (ctx) =>
              "Knowledge is power, and you're claiming yours right now in ${ctx.ongoingName}."),
      GreetingTemplate(
          'og_m11',
          (ctx) =>
              "Stay driven through ${ctx.ongoingName}, ${ctx.name}. Success is built one class at a time."),
      GreetingTemplate(
          'og_m12',
          (ctx) =>
              "Push through ${ctx.ongoingName} with confidence! ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} more ${ctx.classPlural} to conquer today.' : 'Final session!'}"),
      GreetingTemplate(
          'og_m13',
          (ctx) =>
              "Focus is a superpower. Channel yours in ${ctx.ongoingName}, ${ctx.name}!"),
      GreetingTemplate(
          'og_m14',
          (ctx) =>
              "Keep your eyes on the prize while in ${ctx.ongoingName}. You are capable of amazing things!"),
    ],
    ActionTone.roast: [
      GreetingTemplate(
          'og_r1',
          (ctx) =>
              "Survived ${ctx.ongoingName} so far? Impressive. ${ctx.classesRemaining > 0 ? 'Only ${ctx.classesRemaining} more to endure.' : 'At least it is the last one.'}"),
      GreetingTemplate(
          'og_r2',
          (ctx) =>
              "Pretending to pay attention in ${ctx.ongoingName}, ${ctx.name}? ${ctx.classesRemaining > 0 ? 'Just ${ctx.classesRemaining} more classes left to survive today.' : 'Hang in there, almost free.'}"),
      GreetingTemplate(
          'og_r3',
          (ctx) =>
              "Staring at the clock in ${ctx.ongoingName}? ${ctx.classesRemaining > 0 ? '${ctx.classesRemaining} more ${ctx.classPlural} to suffer through after this.' : 'Almost time to escape.'}"),
      GreetingTemplate(
          'og_r4',
          (ctx) =>
              "Nodding along in ${ctx.ongoingName} like you understand everything? Keep up the good work, ${ctx.name}."),
      GreetingTemplate(
          'og_r5',
          (ctx) =>
              "Is ${ctx.ongoingName} putting you to sleep yet, ${ctx.name}? Try not to snore out loud."),
      GreetingTemplate(
          'og_r6',
          (ctx) =>
              "Checking Attendrix during ${ctx.ongoingName} because the lecture is *that* captivating, huh ${ctx.name}?"),
      GreetingTemplate(
          'og_r7',
          (ctx) =>
              "Blink twice if you need rescue from ${ctx.ongoingName}, ${ctx.name}."),
      GreetingTemplate(
          'og_r8',
          (ctx) =>
              "Mental battery at 3% in ${ctx.ongoingName}? ${ctx.classesRemaining > 0 ? 'Just ${ctx.classesRemaining} more classes of torture left!' : 'Last hurdle!'}"),
      GreetingTemplate(
          'og_r9',
          (ctx) =>
              "Hope your poker face in ${ctx.ongoingName} is convincing, ${ctx.name}."),
      GreetingTemplate(
          'og_r10',
          (ctx) =>
              "In ${ctx.ongoingName} or dreaming about food, ${ctx.name}? We know the truth."),
      GreetingTemplate(
          'og_r11',
          (ctx) =>
              "Calculating how much of ${ctx.ongoingName} you can miss without failing? Classic ${ctx.name}."),
      GreetingTemplate(
          'og_r12',
          (ctx) =>
              "Doodling in your notebook during ${ctx.ongoingName}, ${ctx.name}? We won't judge."),
      GreetingTemplate(
          'og_r13',
          (ctx) =>
              "If eyes could glaze over, yours would be donuts in ${ctx.ongoingName} right now."),
      GreetingTemplate(
          'og_r14',
          (ctx) =>
              "Trying to remember why you enrolled in ${ctx.ongoingName}? Hang in there, ${ctx.name}."),
    ],
  };

  static final Map<ActionTone, List<GreetingTemplate>> _upcomingClassesMatrix =
      {
    ActionTone.playful: [
      GreetingTemplate(
          'up_p1',
          (ctx) =>
              "${ctx.timeGreeting}, ${ctx.name}! You've got a packed day with ${ctx.classesRemaining} ${ctx.classPlural} ahead—better make that first coffee count."),
      GreetingTemplate(
          'up_p2',
          (ctx) =>
              "Ready to dive in, ${ctx.name}? You have ${ctx.classesRemaining} ${ctx.classPlural} standing between you and freedom today."),
      GreetingTemplate(
          'up_p3',
          (ctx) =>
              "${ctx.timeGreeting}! ${ctx.classesRemaining} ${ctx.classPlural} lined up today. Let's get through them!"),
      GreetingTemplate(
          'up_p4',
          (ctx) =>
              "Game face on, ${ctx.name}! ${ctx.classesRemaining} ${ctx.classPlural} on today's agenda."),
      GreetingTemplate(
          'up_p5',
          (ctx) =>
              "${ctx.timeGreeting}, ${ctx.name}! ${ctx.classesRemaining} ${ctx.classPlural} on the horizon today. Let me know if you need back-up!"),
      GreetingTemplate(
          'up_p6',
          (ctx) =>
              "A wild day of ${ctx.classesRemaining} ${ctx.classPlural} has appeared, ${ctx.name}! Ready to battle?"),
      GreetingTemplate(
          'up_p7',
          (ctx) =>
              "Buckle up, ${ctx.name}! ${ctx.classesRemaining} ${ctx.classPlural} waiting for you today."),
      GreetingTemplate(
          'up_p8',
          (ctx) =>
              "Gear up, ${ctx.name}! ${ctx.classesRemaining} ${ctx.classPlural} on the schedule today."),
      GreetingTemplate(
          'up_p9',
          (ctx) =>
              "${ctx.timeGreeting}, superstar! ${ctx.classesRemaining} ${ctx.classPlural} to tackle today. Let's do this!"),
      GreetingTemplate(
          'up_p10',
          (ctx) =>
              "Fresh start, ${ctx.name}! ${ctx.classesRemaining} ${ctx.classPlural} on deck for today."),
      GreetingTemplate(
          'up_p11',
          (ctx) =>
              "Rolling up your sleeves for ${ctx.classesRemaining} ${ctx.classPlural} today, ${ctx.name}?"),
      GreetingTemplate(
          'up_p12',
          (ctx) =>
              "Coffee brewed and ready for ${ctx.classesRemaining} ${ctx.classPlural} today, ${ctx.name}?"),
      GreetingTemplate(
          'up_p13',
          (ctx) =>
              "System check: ${ctx.classesRemaining} ${ctx.classPlural} remaining today. Let's roll, ${ctx.name}!"),
      GreetingTemplate(
          'up_p14',
          (ctx) =>
              "${ctx.timeGreeting}, champion! ${ctx.classesRemaining} ${ctx.classPlural} on today's hit list."),
      GreetingTemplate(
          'up_p15',
          (ctx) =>
              "On your mark, get set, learn! ${ctx.classesRemaining} ${ctx.classPlural} scheduled today, ${ctx.name}."),
    ],
    ActionTone.direct: [
      GreetingTemplate(
          'up_d1',
          (ctx) =>
              "${ctx.timeGreeting}. You have ${ctx.classesRemaining} ${ctx.classPlural} scheduled today."),
      GreetingTemplate(
          'up_d2',
          (ctx) =>
              "Good day, ${ctx.name}. Your schedule has ${ctx.classesRemaining} ${ctx.classPlural} remaining today."),
      GreetingTemplate(
          'up_d3',
          (ctx) =>
              "Status update: ${ctx.classesRemaining} ${ctx.classPlural} on your schedule today, ${ctx.name}."),
      GreetingTemplate(
          'up_d4',
          (ctx) =>
              "Daily breakdown: ${ctx.classesRemaining} ${ctx.classPlural} remaining on your timetable."),
      GreetingTemplate(
          'up_d5',
          (ctx) =>
              "${ctx.timeGreeting}, ${ctx.name}. Schedule count: ${ctx.classesRemaining} ${ctx.classPlural} today."),
      GreetingTemplate(
          'up_d6',
          (ctx) =>
              "Schedule overview: ${ctx.classesRemaining} ${ctx.classPlural} to attend today."),
      GreetingTemplate(
          'up_d7',
          (ctx) =>
              "${ctx.classesRemaining} ${ctx.classPlural} remaining for today's session, ${ctx.name}."),
      GreetingTemplate(
          'up_d8',
          (ctx) =>
              "Timetable status: ${ctx.classesRemaining} ${ctx.classPlural} scheduled today."),
      GreetingTemplate(
          'up_d9',
          (ctx) =>
              "Today's load: ${ctx.classesRemaining} ${ctx.classPlural}. Prepare for your first session."),
      GreetingTemplate(
          'up_d10',
          (ctx) =>
              "${ctx.timeGreeting}. Remaining schedule: ${ctx.classesRemaining} ${ctx.classPlural} today."),
      GreetingTemplate(
          'up_d11',
          (ctx) =>
              "Class schedule: ${ctx.classesRemaining} ${ctx.classPlural} remaining today, ${ctx.name}."),
      GreetingTemplate(
          'up_d12',
          (ctx) =>
              "Daily log: ${ctx.classesRemaining} ${ctx.classPlural} pending today."),
    ],
    ActionTone.motivational: [
      GreetingTemplate(
          'up_m1',
          (ctx) =>
              "${ctx.timeGreeting}, ${ctx.name}. ${ctx.classesRemaining} ${ctx.classPlural} mean ${ctx.classesRemaining} opportunities to move forward. Make each one count."),
      GreetingTemplate(
          'up_m2',
          (ctx) =>
              "Rise and shine, ${ctx.name}! Tackle these ${ctx.classesRemaining} ${ctx.classPlural} with focus and momentum today."),
      GreetingTemplate(
          'up_m3',
          (ctx) =>
              "Today is yours for the taking, ${ctx.name}. ${ctx.classesRemaining} ${ctx.classPlural} ahead—let's conquer them one by one."),
      GreetingTemplate(
          'up_m4',
          (ctx) =>
              "${ctx.timeGreeting}! Turn today's ${ctx.classesRemaining} ${ctx.classPlural} into tomorrow's achievement."),
      GreetingTemplate(
          'up_m5',
          (ctx) =>
              "Great things take effort, ${ctx.name}. Show up strong for these ${ctx.classesRemaining} ${ctx.classPlural} today!"),
      GreetingTemplate(
          'up_m6',
          (ctx) =>
              "You are built for challenges, ${ctx.name}. Bring your best energy to all ${ctx.classesRemaining} ${ctx.classPlural} today!"),
      GreetingTemplate(
          'up_m7',
          (ctx) =>
              "Step by step, class by class. You're growing stronger today, ${ctx.name}!"),
      GreetingTemplate(
          'up_m8',
          (ctx) =>
              "Focus on the process, ${ctx.name}. ${ctx.classesRemaining} ${ctx.classPlural} today are stepping stones to your success."),
      GreetingTemplate(
          'up_m9',
          (ctx) =>
              "Believe in your potential today, ${ctx.name}! ${ctx.classesRemaining} ${ctx.classPlural} ahead—make them shine."),
      GreetingTemplate(
          'up_m10',
          (ctx) =>
              "Energy high, focus sharp. Let's make today count through all ${ctx.classesRemaining} ${ctx.classPlural}!"),
      GreetingTemplate(
          'up_m11',
          (ctx) =>
              "Your dedication today determines your victory tomorrow. Go crush those ${ctx.classesRemaining} ${ctx.classPlural}, ${ctx.name}!"),
      GreetingTemplate(
          'up_m12',
          (ctx) =>
              "Unstoppable mindset activated! ${ctx.classesRemaining} ${ctx.classPlural} stand no chance against your focus, ${ctx.name}."),
    ],
    ActionTone.roast: [
      GreetingTemplate(
          'up_r1',
          (ctx) =>
              "${ctx.classesRemaining} ${ctx.classPlural} today? Your timetable clearly woke up and chose violence."),
      GreetingTemplate(
          'up_r2',
          (ctx) =>
              "Look who has ${ctx.classesRemaining} ${ctx.classPlural} today. Hope you mentally prepared for this, ${ctx.name}."),
      GreetingTemplate(
          'up_r3',
          (ctx) =>
              "${ctx.timeGreeting}, ${ctx.name}. ${ctx.classesRemaining} ${ctx.classPlural} waiting for you. Try not to check the clock every 2 minutes."),
      GreetingTemplate(
          'up_r4',
          (ctx) =>
              "Ah, ${ctx.classesRemaining} ${ctx.classPlural} today. Time to test your coffee tolerance, ${ctx.name}."),
      GreetingTemplate(
          'up_r5',
          (ctx) =>
              "${ctx.classesRemaining} ${ctx.classPlural} today, ${ctx.name}? May the wifi be fast and the lectures be short."),
      GreetingTemplate(
          'up_r6',
          (ctx) =>
              "${ctx.timeGreeting}, ${ctx.name}. ${ctx.classesRemaining} ${ctx.classPlural} on the schedule. Don't look so thrilled!"),
      GreetingTemplate(
          'up_r7',
          (ctx) =>
              "Prepare your eyelids, ${ctx.name}: ${ctx.classesRemaining} ${ctx.classPlural} coming right at you today."),
      GreetingTemplate(
          'up_r8',
          (ctx) =>
              "${ctx.classesRemaining} ${ctx.classPlural} today? Hope you brought extra endurance, ${ctx.name}."),
      GreetingTemplate(
          'up_r9',
          (ctx) =>
              "Another day, another ${ctx.classesRemaining} ${ctx.classPlural} to survive. Courage, ${ctx.name}!"),
      GreetingTemplate(
          'up_r10',
          (ctx) =>
              "Who hurt your timetable, ${ctx.name}? ${ctx.classesRemaining} ${ctx.classPlural} today is borderline illegal."),
      GreetingTemplate(
          'up_r11',
          (ctx) =>
              "Good luck surviving all ${ctx.classesRemaining} ${ctx.classPlural} today, ${ctx.name}. You'll need it!"),
      GreetingTemplate(
          'up_r12',
          (ctx) =>
              "Time to put on your best 'I'm totally listening' face for ${ctx.classesRemaining} ${ctx.classPlural} today, ${ctx.name}."),
    ],
  };

  static final Map<ActionTone, List<GreetingTemplate>> _noClassesMatrix = {
    ActionTone.playful: [
      GreetingTemplate(
          'nc_p1',
          (ctx) =>
              "No classes today? Sounds like the perfect excuse to build something cool."),
      GreetingTemplate(
          'nc_p2',
          (ctx) =>
              "Zero classes on your schedule today, ${ctx.name}! Enjoy the break or catch up on passion projects."),
      GreetingTemplate(
          'nc_p3',
          (ctx) =>
              "Clear schedule alert! Zero classes today, ${ctx.name}. Go live your best life."),
      GreetingTemplate(
          'nc_p4',
          (ctx) =>
              "No classes on the radar today! Time to relax or get ahead of next week."),
      GreetingTemplate(
          'nc_p5',
          (ctx) =>
              "FREEDOM! Zero classes today, ${ctx.name}. Go treat yourself!"),
      GreetingTemplate(
          'nc_p6',
          (ctx) =>
              "The schedule is officially clear! What's the master plan for today, ${ctx.name}?"),
      GreetingTemplate(
          'nc_p7',
          (ctx) =>
              "No classes today, ${ctx.name}! Time to sleep in, gaming mode on, or hit the gym."),
      GreetingTemplate('nc_p8',
          (ctx) => "Clean slate today! Zero classes to attend, ${ctx.name}."),
      GreetingTemplate(
          'nc_p9',
          (ctx) =>
              "All clear on the class front today! Enjoy the sweet silence, ${ctx.name}."),
      GreetingTemplate(
          'nc_p10',
          (ctx) =>
              "Schedule score: 0 classes! You've unlocked maximum free time today, ${ctx.name}."),
      GreetingTemplate(
          'nc_p11',
          (ctx) =>
              "No classes today! Time to binge a show or work on that side hustle, ${ctx.name}."),
      GreetingTemplate(
          'nc_p12',
          (ctx) =>
              "Zero classes today, ${ctx.name}! Rest up and recharge those mental batteries."),
    ],
    ActionTone.direct: [
      GreetingTemplate(
          'nc_d1', (ctx) => "You have no classes scheduled today."),
      GreetingTemplate(
          'nc_d2',
          (ctx) =>
              "Schedule is clear, ${ctx.name}. No remaining classes today."),
      GreetingTemplate('nc_d3', (ctx) => "Zero remaining classes for today."),
      GreetingTemplate('nc_d4', (ctx) => "Status: No classes scheduled today."),
      GreetingTemplate('nc_d5',
          (ctx) => "Timetable status: Clear. No sessions remaining today."),
      GreetingTemplate(
          'nc_d6',
          (ctx) =>
              "No active or upcoming classes on today's schedule, ${ctx.name}."),
      GreetingTemplate('nc_d7', (ctx) => "Daily status: 0 classes remaining."),
      GreetingTemplate(
          'nc_d8', (ctx) => "Zero sessions today. Your schedule is empty."),
      GreetingTemplate('nc_d9',
          (ctx) => "Schedule clear: No classes for the rest of today."),
      GreetingTemplate(
          'nc_d10',
          (ctx) =>
              "All classes completed or none scheduled today, ${ctx.name}."),
      GreetingTemplate(
          'nc_d11', (ctx) => "Class count today: 0. Enjoy your free time."),
    ],
    ActionTone.motivational: [
      GreetingTemplate('nc_m1',
          (ctx) => "A free day is an opportunity. Use it well, ${ctx.name}."),
      GreetingTemplate(
          'nc_m2',
          (ctx) =>
              "No classes today, ${ctx.name}! Take this time to recharge or push forward on your own terms."),
      GreetingTemplate(
          'nc_m3',
          (ctx) =>
              "An empty schedule is a blank canvas. Rest up or make progress on your personal goals, ${ctx.name}."),
      GreetingTemplate(
          'nc_m4',
          (ctx) =>
              "Rest is part of the work. Recharge your mind and body today, ${ctx.name}!"),
      GreetingTemplate(
          'nc_m5',
          (ctx) =>
              "Use today's free schedule to reflect, plan, and come back stronger tomorrow, ${ctx.name}."),
      GreetingTemplate(
          'nc_m6',
          (ctx) =>
              "Freedom to focus on what matters most to you today. Make it meaningful, ${ctx.name}!"),
      GreetingTemplate(
          'nc_m7',
          (ctx) =>
              "Take a deep breath and appreciate your free day. Balance is key to success, ${ctx.name}."),
      GreetingTemplate(
          'nc_m8',
          (ctx) =>
              "No classes today! A great chance to sharpen your skills outside the classroom."),
      GreetingTemplate(
          'nc_m9',
          (ctx) =>
              "Invest today's extra time into your personal growth, ${ctx.name}."),
      GreetingTemplate(
          'nc_m10',
          (ctx) =>
              "Enjoy your well-earned break today, ${ctx.name}. Rest fuels future achievements!"),
    ],
    ActionTone.roast: [
      GreetingTemplate(
          'nc_r1',
          (ctx) =>
              "No classes today. Try not to spend the entire day convincing yourself you'll start studying tomorrow."),
      GreetingTemplate(
          'nc_r2',
          (ctx) =>
              "A completely empty schedule today, ${ctx.name}. Let's see how long before pure boredom sets in."),
      GreetingTemplate(
          'nc_r3',
          (ctx) =>
              "Zero classes today! So, what's the excuse for procrastinating now, ${ctx.name}?"),
      GreetingTemplate(
          'nc_r4',
          (ctx) =>
              "No classes today, ${ctx.name}. Time to scroll social media for 8 hours straight."),
      GreetingTemplate(
          'nc_r5',
          (ctx) =>
              "Zero classes today! Try to do at least one productive thing, ${ctx.name}."),
      GreetingTemplate(
          'nc_r6',
          (ctx) =>
              "No classes today? Don't pretend you're actually going to study, ${ctx.name}."),
      GreetingTemplate(
          'nc_r7',
          (ctx) =>
              "Clear schedule today, ${ctx.name}. Try not to nap through the entire day!"),
      GreetingTemplate(
          'nc_r8',
          (ctx) =>
              "No classes on the schedule. Time to stare at your phone in bed all day, ${ctx.name}."),
      GreetingTemplate(
          'nc_r9',
          (ctx) =>
              "Zero classes today! Enjoy doing absolutely nothing, ${ctx.name}."),
      GreetingTemplate(
          'nc_r10',
          (ctx) =>
              "No classes today. Remember: staring at the wall doesn't count as studying, ${ctx.name}."),
    ],
  };
}

/// ─────────────────────────────────────────────────────────────
/// FLUTTERFLOW ENTRY POINT
/// Custom Action Name: generateGreetingMessage
/// ─────────────────────────────────────────────────────────────

Future<String> generateGreetingMessage(
  String? username,
  String toneString,
  int classesRemaining,
  String? ongoingClass,
  List<String>? recentHistory,
) async {
  final cleanTone = toneString.trim().toLowerCase();

  final tone = ActionTone.values.firstWhere(
    (t) => t.name == cleanTone,
    orElse: () => ActionTone.playful,
  );

  final engine = GreetingEngine(recentTemplateIds: recentHistory ?? []);

  final ctx = GreetingContext(
    username: username,
    tone: tone,
    classesRemaining: classesRemaining,
    ongoingClass: ongoingClass,
  );

  return engine.generate(ctx);
}
