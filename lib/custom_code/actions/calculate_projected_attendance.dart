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

import 'dart:math';

Future<AttendanceCalculatorDataStruct> calculateProjectedAttendance(
  EnrolledCourseStruct? enrolledCourse,
  int? addToAttended,
  int? addToSkip,
  ActionTone? actionTone,
) async {
  final tone = actionTone ?? ActionTone.direct;

  // Guard: Null safety check
  if (enrolledCourse == null || enrolledCourse.attendance == null) {
    return AttendanceCalculatorDataStruct(
      projectedAttended: 0,
      projectedTotal: 0,
      projectedAttendance: 0.0,
      attendanceInsights: const [
        'No attendance data available for this course.'
      ],
    );
  }

  final attendance = enrolledCourse.attendance!;

  // Clamp non-negative input values
  final toAttend = (addToAttended ?? 0) < 0 ? 0 : (addToAttended ?? 0);
  final toSkip = (addToSkip ?? 0) < 0 ? 0 : (addToSkip ?? 0);

  final currentAttended = attendance.attended;
  final currentMissed = attendance.missed;
  final currentTotal = currentAttended + currentMissed;

  // Required attendance percentage derived from global user preferences (user_preferences table)
  final requiredPercent =
      (FFAppState().userPreferences.defaultRequiredAttendance > 0)
          ? FFAppState().userPreferences.defaultRequiredAttendance
          : (attendance.required > 0 ? attendance.required : 80);

  final projectedAttended = currentAttended + toAttend;
  final projectedTotal = currentTotal + toAttend + toSkip;

  final projectedAttendance = projectedTotal > 0
      ? _round2((projectedAttended / projectedTotal) * 100)
      : 0.0;

  final insights = _buildInsights(
    currentAttended: currentAttended,
    currentTotal: currentTotal,
    projectedAttended: projectedAttended,
    projectedTotal: projectedTotal,
    projectedAttendance: projectedAttendance,
    requiredPercent: requiredPercent,
    toAttend: toAttend,
    toSkip: toSkip,
    tone: tone,
  );

  return AttendanceCalculatorDataStruct(
    projectedAttended: projectedAttended,
    projectedTotal: projectedTotal,
    projectedAttendance: projectedAttendance,
    attendanceInsights: insights,
  );
}

double _round2(double v) => (v * 100).roundToDouble() / 100;

String _pickRandom(List<String> options) {
  final random = Random();
  return options[random.nextInt(options.length)];
}

List<String> _buildInsights({
  required int currentAttended,
  required int currentTotal,
  required int projectedAttended,
  required int projectedTotal,
  required double projectedAttendance,
  required int requiredPercent,
  required int toAttend,
  required int toSkip,
  required ActionTone tone,
}) {
  final insights = <String>[];
  final isSimulating = toAttend > 0 || toSkip > 0;
  final isOnTrack = projectedAttendance >= requiredPercent;
  final formattedPct = projectedAttendance.toStringAsFixed(1);

  // ---------------------------------------------------------------------------
  // INSIGHT 1: Primary Status Message
  // ---------------------------------------------------------------------------
  if (isSimulating) {
    if (isOnTrack) {
      switch (tone) {
        case ActionTone.playful:
          insights.add(_pickRandom([
            'Simulation looks clean! You hold steady at $formattedPct%. 🎯',
            'Look at you mathing! Your plan keeps you safe at $formattedPct%. 🔮',
            'Future looks bright! Simulated attendance hits $formattedPct%. ✨',
            'Scenario accepted! You stay comfortably in the clear at $formattedPct%. 😎',
            'Plotting your escape? You still sit pretty at $formattedPct%. 🏎️',
          ]));
          break;
        case ActionTone.motivational:
          insights.add(_pickRandom([
            'Great strategy! This simulation maintains your standing at $formattedPct%. 🚀',
            'Solid planning! Your projected attendance remains strong at $formattedPct%. 💪',
            'You are taking control of your goals! Standing firm at $formattedPct%. 🔥',
            'Smart moves ahead—your projected score stays high at $formattedPct%! 🌟',
            'Consistency pays off! Your simulated routine keeps you at $formattedPct%. 🎉',
          ]));
          break;
        case ActionTone.roast:
          insights.add(_pickRandom([
            'Barely surviving, but technically on track at $formattedPct%. 🤡',
            'Calculating the absolute bare minimum? You made it to $formattedPct%. 🤓',
            'Living life on the edge, but hey, $formattedPct% is technically passing. 🎢',
            'Congratulating yourself for doing basic math? Still sitting at $formattedPct%. 🥱',
            'You really tested the limits, but you scraped by at $formattedPct%. 🫡',
          ]));
          break;
        case ActionTone.direct:
        default:
          insights.add(_pickRandom([
            'Based on your simulation, you remain on track at $formattedPct%.',
            'Simulated attendance keeps you above threshold at $formattedPct%.',
            'Projected attendance is $formattedPct%, meeting requirement.',
            'Your calculated scenario lands you at $formattedPct%.',
            'Simulated outcome maintains standing at $formattedPct%.',
          ]));
          break;
      }
    } else {
      switch (tone) {
        case ActionTone.playful:
          insights.add(_pickRandom([
            'Uh oh, gravity hit! Simulation drops you to $formattedPct%. 📉',
            'Red alert! Your simulation puts you below target at $formattedPct%. 🚨',
            'Calculated yourself right into trouble ($formattedPct%). 😬',
            'Plot twist: this scenario takes you down to $formattedPct%. 💸',
            'Oof! That plan takes a nose-dive to $formattedPct%. 🪂',
          ]));
          break;
        case ActionTone.motivational:
          insights.add(_pickRandom([
            'A temporary setback! Simulation drops to $formattedPct%, but you can fix it. ⚡',
            'Target missed at $formattedPct%, but now you know what needs work! 📈',
            'Adjust your focus! This projection sits at $formattedPct%—time to level up! 🎯',
            'Don\'t lose heart! This trial drops to $formattedPct%, but recovery is near! 💡',
            'Every plan needs tuning. This scenario sits at $formattedPct%—let\'s rebuild! 🛠️',
          ]));
          break;
        case ActionTone.roast:
          insights.add(_pickRandom([
            'Bold choice to simulate failing... you dropped straight to $formattedPct%. 👏',
            'Did you really expect $formattedPct% to keep your professor happy? 🤦‍♂️',
            'Your simulation just blew up in your face: $formattedPct%. 💥',
            'Flunking in a simulation takes actual talent ($formattedPct%). 🏆',
            'Congrats, your hypothetical plan gets you flagged at $formattedPct%. 🚩',
          ]));
          break;
        case ActionTone.direct:
        default:
          insights.add(_pickRandom([
            'Simulation drops attendance to $formattedPct%, below required $requiredPercent%.',
            'Projected attendance falls short at $formattedPct%.',
            'Simulated scenario places you below target at $formattedPct%.',
            'Calculated attendance is $formattedPct% (Required: $requiredPercent%).',
            'Scenario results in deficit with $formattedPct% attendance.',
          ]));
          break;
      }
    }
  } else {
    // Non-simulation base status
    if (isOnTrack) {
      switch (tone) {
        case ActionTone.playful:
          insights.add(_pickRandom([
            'Currently cruising smoothly at $formattedPct%! 🚢',
            'Sitting pretty at $formattedPct%! Keep it up. 😉',
            'Look at you being responsible—$formattedPct% logged! 🏅',
            'All green signals here! You sit at $formattedPct%. 🟢',
            'No drama here! Sitting cozy at $formattedPct%. ☕',
          ]));
          break;
        case ActionTone.motivational:
          insights.add(_pickRandom([
            'Outstanding dedication! You are sitting strong at $formattedPct%. ⭐',
            'Keep up the momentum! You are on track at $formattedPct%. 🏆',
            'Your hard work shows—$formattedPct% attendance locked in! 💥',
            'Great discipline! Holding a solid $formattedPct% right now. 👍',
            'You are commanding your schedule with $formattedPct%! 👑',
          ]));
          break;
        case ActionTone.roast:
          insights.add(_pickRandom([
            'Surprise! You actually showed up enough for $formattedPct%. 😳',
            'You are at $formattedPct%... don\'t get lazy now. 👁️👄👁️',
            'You managed $formattedPct%. Want a golden star sticker? ⭐',
            'At $formattedPct%, you are barely dodging trouble. 🫣',
            'Floating at $formattedPct%. Try not to blow it. 🌬️',
          ]));
          break;
        case ActionTone.direct:
        default:
          insights.add(_pickRandom([
            'You are currently on track at $formattedPct%.',
            'Current attendance stands at $formattedPct%.',
            'Status: Satisfactory ($formattedPct%).',
            'Your attendance meets requirements at $formattedPct%.',
            'Holding steady at $formattedPct%.',
          ]));
          break;
      }
    } else {
      switch (tone) {
        case ActionTone.playful:
          insights.add(_pickRandom([
            'Whoopsie! You are in the splash zone at $formattedPct%. 🌊',
            'Danger zone! Sitting at $formattedPct% right now. ⚠️',
            'Attendance emergency! Standing at $formattedPct%. 🚑',
            'Your bed was too comfortable, huh? Standing at $formattedPct%. 🛌',
            'Mayday! You dropped to $formattedPct%. 🛟',
          ]));
          break;
        case ActionTone.motivational:
          insights.add(_pickRandom([
            'You are at $formattedPct%, but turnarounds start today! 💪',
            'Current status: $formattedPct%. Time to lock in and recover! 🔓',
            'Challenge accepted! $formattedPct% is just your starting line back up. 🧗',
            'Push through! You can pull this $formattedPct% back above target. ⚡',
            'Every class counts now! Time to raise that $formattedPct%. 📈',
          ]));
          break;
        case ActionTone.roast:
          insights.add(_pickRandom([
            'At $formattedPct%, your attendance is practically dynamic art. 🎨',
            'Did you forget you actually enrolled in this class? ($formattedPct%) 👻',
            'Is your pillow paying your tuition? You are down to $formattedPct%. 🛏️',
            'Down at $formattedPct%... your professor probably forgot your face. 🤷',
            'Sitting at $formattedPct%. Time to stop pretending you will "catch up." 🛑',
          ]));
          break;
        case ActionTone.direct:
        default:
          insights.add(_pickRandom([
            'You are currently below the required $requiredPercent% threshold.',
            'Current attendance ($formattedPct%) fails requirement.',
            'Deficit warning: Currently standing at $formattedPct%.',
            'Attendance critical at $formattedPct%.',
            'Status: Below minimum requirement ($formattedPct%).',
          ]));
          break;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // INSIGHT 2: Buffer Math OR Recovery Math
  // ---------------------------------------------------------------------------
  if (requiredPercent > 0 && requiredPercent < 100) {
    if (isOnTrack) {
      final rawSkippable =
          ((projectedAttended * 100 / requiredPercent) - projectedTotal);
      final cleanedSkippable = (rawSkippable * 1e6).round() / 1e6;
      final maxSkippable = cleanedSkippable.floor();

      if (maxSkippable > 0) {
        final plural = maxSkippable == 1 ? 'class' : 'classes';
        switch (tone) {
          case ActionTone.playful:
            insights.add(_pickRandom([
              'You have $maxSkippable free pass $plural in your back pocket. 🎟️',
              'Bank account full: You can ditch $maxSkippable $plural safely. 🏖️',
              'Snooze button allowance: $maxSkippable $plural available to skip. ⏰',
              'Feel like sleeping in? You have a $maxSkippable-$plural cushion! 😴',
              'Coupon un-locked! Skip $maxSkippable $plural without penalty. 🏷️',
            ]));
            break;
          case ActionTone.motivational:
            insights.add(_pickRandom([
              'Your hard work gave you a safety buffer of $maxSkippable $plural! 🛡️',
              'You built a strong safety margin to miss up to $maxSkippable $plural. 🏗️',
              'Earned breathing room: $maxSkippable $plural can be skipped if needed. 🧘',
              'Great positioning allows a cushion of $maxSkippable $plural! 🎯',
              'You earned flexibility: $maxSkippable $plural margin in reserve. 🔋',
            ]));
            break;
          case ActionTone.roast:
            insights.add(_pickRandom([
              'You can skip $maxSkippable $plural, but don\'t push your luck. 🛑',
              'Got $maxSkippable $plural to burn. Don\'t spend them all at once. 💸',
              'You can ditch $maxSkippable $plural, assuming you don\'t mess up. 🤏',
              'You have $maxSkippable $plural to skip. Try not to ruin it. 🤡',
              'Buffer of $maxSkippable $plural... try not to treat it like a challenge. 🎯',
            ]));
            break;
          case ActionTone.direct:
          default:
            insights.add(_pickRandom([
              'You can skip up to $maxSkippable $plural and stay above $requiredPercent%.',
              'Maximum skippable classes remaining: $maxSkippable.',
              'Buffer permits skipping $maxSkippable $plural without default.',
              'Safety margin: $maxSkippable $plural.',
              'You have allowance to miss $maxSkippable $plural.',
            ]));
            break;
        }
      } else {
        switch (tone) {
          case ActionTone.playful:
            insights.add(_pickRandom([
              'Zero room for error! Ditching 1 class breaks the streak. 🧊',
              'Walking a tightrope—no more skips allowed! 🎪',
              'Your skip wallet is empty! 0 skips left. 👛',
              'Ditch even one class and down you go! 🪂',
              'On the fine line—keep showing up! 🚶',
            ]));
            break;
          case ActionTone.motivational:
            insights.add(_pickRandom([
              'Hold the line! Any more missed classes drop you below $requiredPercent%. 🛑',
              'Protect your progress—no skips remaining! 🛡️',
              'Stay focused now; every session counts to maintain target! 🌟',
              'Keep up your streak! Skipping now compromises your standard. 🔥',
              'Guard your grade! Zero skip margin available. 🎯',
            ]));
            break;
          case ActionTone.roast:
            insights.add(_pickRandom([
              'Skip one more class and watch your grade crumble. 🪨',
              'Zero skips left. Don\'t even look at your bed tomorrow. 👁️',
              'You are one alarm fail away from complete disaster. ⏰',
              'No buffer left. Hope your car doesn\'t break down. 🚗',
              'Zero margin. One missed bus and it\'s over. 🚌',
            ]));
            break;
          case ActionTone.direct:
          default:
            insights.add(_pickRandom([
              'Skipping any additional classes drops you below $requiredPercent%.',
              'Zero skippable classes remaining.',
              'No further absence margin available.',
              'Additional skips will result in requirement failure.',
              'Buffer depleted: Next miss drops attendance below threshold.',
            ]));
            break;
        }
      }
    } else {
      final neededRaw =
          (requiredPercent * projectedTotal - 100 * projectedAttended) /
              (100 - requiredPercent);
      final cleanedNeeded = (neededRaw * 1e6).round() / 1e6;
      final needed = cleanedNeeded.ceil();

      if (needed > 0) {
        final plural = needed == 1 ? 'class' : 'classes';
        switch (tone) {
          case ActionTone.playful:
            insights.add(_pickRandom([
              'Time for a streak! Attend the next $needed $plural in a row. 🏃',
              'Lock in! You need a unbroken streak of $needed $plural. 🔒',
              'Attendance mission: Show up to the next $needed $plural! 🎟️',
              'Get your attendance points back: $needed straight hits required! 🎯',
              'Set 5 alarms! You need the next $needed $plural without fail. ⏰',
            ]));
            break;
          case ActionTone.motivational:
            insights.add(_pickRandom([
              'Attend the next $needed consecutive $plural to get right back on track! 💪',
              'Target recovery: Just $needed uninterrupted $plural to rebuild your score! 📈',
              'You\'ve got this! A $needed-$plural streak brings you back into the green. 🟢',
              'Climb back up! Attend $needed $plural in a row to reach safety. 🧗',
              'Stay disciplined! $needed straight sessions will secure your baseline. 🔥',
            ]));
            break;
          case ActionTone.roast:
            insights.add(_pickRandom([
              'Better move into the lecture hall—you need $needed $plural in a row. 🏕️',
              'Time to actually attend $needed straight $plural. No excuses. 🙄',
              'Set $needed alarms because you cannot miss a single class now. ⏰',
              'You owe the professor $needed consecutive appearances. 📜',
              'Start showing up. You need $needed straight hits to fix this mess. 🧹',
            ]));
            break;
          case ActionTone.direct:
          default:
            insights.add(_pickRandom([
              'You must attend the next $needed consecutive $plural to recover.',
              'Required recovery streak: $needed consecutive $plural.',
              'Attendance requirement: $needed unbroken sessions.',
              'Recovery target: Attend $needed uninterrupted $plural.',
              'To reach $requiredPercent%, $needed consecutive sessions are required.',
            ]));
            break;
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // INSIGHT 3: Delta Impact (if simulating)
  // ---------------------------------------------------------------------------
  if (isSimulating) {
    final currentAttendance = currentTotal > 0
        ? _round2((currentAttended / currentTotal) * 100)
        : 0.0;
    final diff = _round2(projectedAttendance - currentAttendance);

    if (diff > 0) {
      final diffStr = diff.toStringAsFixed(1);
      switch (tone) {
        case ActionTone.playful:
          insights.add(_pickRandom([
            'Nice boost! Adds +$diffStr% to your overall total. ⬆️',
            'Growth unlocked! Projected gain of +$diffStr%. 🌱',
            'Upward trend! This adds +$diffStr% to your score. 🚀',
            'Stonks! +$diffStr% overall gain simulated. 📈',
            'Sweet progress! Boosting your record by +$diffStr%. ✨',
          ]));
          break;
        case ActionTone.motivational:
          insights.add(_pickRandom([
            'This action yields a direct +$diffStr% improvement! 🌟',
            'Positive momentum! Increases your score by +$diffStr%. 💪',
            'Valuable gain! This decision lifts your average by +$diffStr%. 🏆',
            'Every session matters—adds +$diffStr% to your record! 🔥',
            'Building excellence: +$diffStr% overall attendance boost. ⚡',
          ]));
          break;
        case ActionTone.roast:
          insights.add(_pickRandom([
            'Slowly patching the damage with a tiny +$diffStr% boost. 🩹',
            'A modest +$diffStr% bump... don\'t throw a party yet. 🎈',
            'Gains +$diffStr%. Better than dropping, I suppose. 🥱',
            'Adding +$diffStr% back to your heavily bruised attendance. 🚑',
            'Congratulations on doing work: +$diffStr% gain. 🎖️',
          ]));
          break;
        case ActionTone.direct:
        default:
          insights.add(_pickRandom([
            'This simulation increases total attendance by +$diffStr%.',
            'Projected change: +$diffStr% overall.',
            'Net gain of +$diffStr% over current standing.',
            'Simulation delta: +$diffStr%.',
            'Overall percentage improves by +$diffStr%.',
          ]));
          break;
      }
    } else if (diff < 0) {
      final diffStr = diff.abs().toStringAsFixed(1);
      switch (tone) {
        case ActionTone.playful:
          insights.add(_pickRandom([
            'Ouch! Takes a -$diffStr% chunk out of your score. 🪓',
            'Ducking out lowers your total by -$diffStr%. 🕳️',
            'Cost of skipping: -$diffStr% overall penalty. 💸',
            'Taking a -$diffStr% hit on this scenario. 🥊',
            'Downward slide of -$diffStr% recorded. 🛷',
          ]));
          break;
        case ActionTone.motivational:
          insights.add(_pickRandom([
            'This scenario causes a -$diffStr% drop—reconsider if possible! ⚠️',
            'Heads up: This choice reduces overall score by -$diffStr%. 📉',
            'Calculated reduction of -$diffStr%. Stay focused on long term! 🎯',
            'Notice the -$diffStr% drop—try balancing with extra attendance! ⚖️',
            'Impact check: -$diffStr% total change in this model. 🔍',
          ]));
          break;
        case ActionTone.roast:
          insights.add(_pickRandom([
            'Say goodbye to -$diffStr% of your hard-earned record. 💸',
            'Chopping off -$diffStr% just like that? Bold strategy. 🔪',
            'Willfully burning -$diffStr% of your attendance... nice. 🔥',
            'Enjoy throwing away -$diffStr% overall percentage. 🗑️',
            'Your score takes a -$diffStr% punch to the gut. 👊',
          ]));
          break;
        case ActionTone.direct:
        default:
          insights.add(_pickRandom([
            'This simulation decreases total attendance by -$diffStr%.',
            'Projected change: -$diffStr% overall.',
            'Net reduction of -$diffStr% from current standing.',
            'Simulation delta: -$diffStr%.',
            'Overall percentage drops by -$diffStr%.',
          ]));
          break;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // INSIGHT 4: Milestone / General Context
  // ---------------------------------------------------------------------------
  if (projectedAttendance >= 90.0) {
    switch (tone) {
      case ActionTone.playful:
        insights.add(_pickRandom([
          'Star student status unlocked! ⭐️',
          'Honor roll vibes right here! 🎓',
          'Front-row seat energy! 🪑',
          'Overachiever detected! 🤖',
          'Flexing that 90%+ attendance! 💪',
        ]));
        break;
      case ActionTone.motivational:
        insights.add(_pickRandom([
          'Elite performance! Exceptional attendance record. 🏅',
          'You are setting the benchmark for excellence! 🌟',
          'Outstanding work maintaining top-tier status! 🚀',
          'Dedicating yourself at this level pays high dividends! 🔥',
          'Phenomenal consistency! Keep shining! ✨',
        ]));
        break;
      case ActionTone.roast:
        insights.add(_pickRandom([
          'Okay, nerd, leave some attendance for the rest of us. 🤓',
          'Do you live in the classroom or what? ⛺',
          'Overachieving won\'t get you extra credit, you know. 🙄',
          'Are you trying to get adopted by the professor? 👨‍🏫',
          '90%+? Someone clearly has no social life. 📱',
        ]));
        break;
      case ActionTone.direct:
      default:
        insights.add(_pickRandom([
          'Excellent standing (90%+ attendance achieved).',
          'Status: Tier 1 Attendance Record.',
          'Maintains superior attendance metric.',
          'Standing qualifies for highest attendance bracket.',
          'Consistently exceeds institutional expectations.',
        ]));
        break;
    }
  } else if (!isOnTrack) {
    switch (tone) {
      case ActionTone.playful:
        insights.add(_pickRandom([
          'Time to activate beast mode and dodge warnings! 🦾',
          'Time to make friends with the front row! 🏃‍♂️',
          'No more snoozing alarms until further notice! ⏰',
          'Operation Course Recovery starts now! 🕵️',
          'Swap those absences for attendance points! 🔁',
        ]));
        break;
      case ActionTone.motivational:
        insights.add(_pickRandom([
          'Protect your eligibility—prioritize upcoming sessions! 🛡️',
          'Turnarounds happen step-by-step—start tomorrow! 🌅',
          'You have full power to course-correct this metric! ⚡',
          'Commitment today secures your course credit tomorrow! 🎓',
          'Focus on your goal and rebuild your momentum! 🎯',
        ]));
        break;
      case ActionTone.roast:
        insights.add(_pickRandom([
          'Keep skipping and enjoy retaking this course next term. 🎟️',
          'Admin warning letter incoming in 3... 2... 1... ✉️',
          'Your attendance is lower than my phone battery percentage. 🔋',
          'At this rate, you are paying tuition just to sleep in. 💵',
          'Are you attending class or just donating money to the university? 💸',
        ]));
        break;
      case ActionTone.direct:
      default:
        insights.add(_pickRandom([
          'Action required: Avoid further unexcused absences.',
          'Risk notice: Attendance below policy requirement.',
          'Warning: Course credit eligibility compromised.',
          'Immediate attendance consistency required.',
          'Institutional action may occur if deficit persists.',
        ]));
        break;
    }
  } else if (toSkip > 2) {
    switch (tone) {
      case ActionTone.playful:
        insights.add(_pickRandom([
          'That is a lot of planned skipping! Watch your step. 🍌',
          'Careful! Burning through skips fast here. 🕯️',
          'You are spending skips like play money! 💸',
          'Skipping spree alert! Don\'t trip up. 🛑',
          'Slow down on the skip counter! 🏎️',
        ]));
        break;
      case ActionTone.motivational:
        insights.add(_pickRandom([
          'Plan wisely—preserving safety margins gives peace of mind! 🧘',
          'Strategic skipping is fine, but protect your buffer! 🛡️',
          'Keep reserves intact for unexpected emergencies! 🚨',
          'Smart planning keeps your future options open! 🔮',
          'Pace yourself to maintain high performance! 🏃',
        ]));
        break;
      case ActionTone.roast:
        insights.add(_pickRandom([
          'Simulating a vacation during semester time? 🏖️',
          'Trying to set a world record for most skipped classes? 🏆',
          'You are really addicted to pressing that skip button. 🔘',
          'Planning to vanish for half the semester, huh? 🫥',
          'At least pretend you want to go to class. 🎭',
        ]));
        break;
      case ActionTone.direct:
      default:
        insights.add(_pickRandom([
          'Caution: Rapid accumulation of skipped sessions.',
          'Multiple simulated absences significantly reduce safety margins.',
          'Pacing warning: Conserving skips recommended.',
          'High absence simulation detected.',
          'Ensure future schedule accommodates planned absences.',
        ]));
        break;
    }
  }

  // Return a maximum of 4 insights
  return insights.take(4).toList();
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
