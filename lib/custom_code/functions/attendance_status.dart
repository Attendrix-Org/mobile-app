import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String attendanceStatus(
  AttendanceStruct attendance,
  String userName,
  ActionTone tone,
) {
  int deterministicIndex(String input, int range) {
    if (range <= 0) {
      throw ArgumentError('range must be greater than 0');
    }

    const int fnvOffsetBasis = 0x811C9DC5;
    const int fnvPrime = 0x01000193;

    int hash = fnvOffsetBasis;

    for (final codeUnit in input.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * fnvPrime) & 0xFFFFFFFF;
    }

    return hash % range;
  }

  // Personalization helpers
  final String trimmedName = userName?.trim() ?? '';
  final String namePrefix = trimmedName.isNotEmpty ? '$trimmedName, ' : '';
  final String nameGreeting = trimmedName.isNotEmpty ? '$trimmedName' : 'Hey';

  final int attended = attendance.attended < 0 ? 0 : attendance.attended;
  final int missed = attendance.missed < 0 ? 0 : attendance.missed;
  final int required = attendance.required.clamp(0, 100);

  final int total = attended + missed;

  // Edge Case: No data
  if (total == 0) {
    return 'No attendance data available yet. Time to kick off the term!';
  }

  // Edge Case: No minimum requirement
  if (required == 0) {
    return 'No attendance rules here! You\'re free to attend at your own pace.';
  }

  // Edge Case: 100% required attendance
  if (required == 100) {
    final List<String> messages = switch (tone) {
      ActionTone.playful => [
          'This course demands absolute perfection! Missing even one session breaks your 100% streak.',
          'No safety nets here, $nameGreeting! Every single class is mandatory.',
        ],
      ActionTone.motivational => [
          '${namePrefix}this course requires 100% commitment. Keep going strong and attend every single class!',
          'Every session counts toward your success! Stay dedicated and maintain that 100% streak.',
        ],
      ActionTone.roast => [
          'Zero skip budget for this one. Show up to every single class, no excuses!',
          '100% required means 100% required, $nameGreeting. Don\'t even think about sleeping in.',
        ],
      ActionTone.direct => [
          'Attendance requirement is 100%. You cannot skip any classes for this course.',
          'Compulsory attendance in effect. Every session must be attended.',
        ],
    };

    final seed = 'lab|$attended|$missed|$userName|${tone.name}';
    return messages[deterministicIndex(seed, messages.length)];
  }

  // 1. Calculate max skippable classes
  final int maxSkippable = ((attended * 100.0 / required) - total).floor();

  if (maxSkippable > 0) {
    final String classLabel = maxSkippable == 1 ? 'class' : 'classes';
    final String moreClassLabel =
        maxSkippable == 1 ? 'more class' : 'more classes';

    final List<String> messages = switch (tone) {
      ActionTone.playful => [
          '${namePrefix}you are in the green zone! You can safely skip $maxSkippable $moreClassLabel and stay above $required%.',
          'Sweet freedom! You have a cushion of $maxSkippable $classLabel before hitting your $required% threshold.',
          'Look at that balance, $nameGreeting! You can miss $maxSkippable $moreClassLabel without dropping below $required%.',
        ],
      ActionTone.motivational => [
          'Great consistency, $nameGreeting! Your effort allows you to miss up to $maxSkippable $classLabel while keeping your $required% goal.',
          '${namePrefix}your regular attendance paid off! You have a solid cushion of $maxSkippable skippable $classLabel.',
          'Excellent work! You can comfortably skip $maxSkippable $moreClassLabel and still remain well above $required%.',
        ],
      ActionTone.roast => [
          '${namePrefix}you\'re practically rich in attendance. Ghost $maxSkippable $classLabel if you want, you\'ll still beat $required%.',
          'Don\'t get lazy now, but yes—you can disappear from $maxSkippable $classLabel and survive at $required%.',
          'You\'ve got $maxSkippable skippable $classLabel banked. Try not to spend them all in one week!',
        ],
      ActionTone.direct => [
          '${namePrefix}you can safely skip $maxSkippable $moreClassLabel and maintain your $required% target.',
          'Current buffer: $maxSkippable skippable $classLabel remaining above the $required% threshold.',
        ],
    };

    final seed = 'skip|$attended|$missed|$required|$userName|${tone.name}';
    return messages[deterministicIndex(seed, messages.length)];
  }

  final int numerator = required * total - 100 * attended;

  // 2. Exact threshold scenario (0 skippable, but not yet negative)
  if (numerator <= 0) {
    final List<String> messages = switch (tone) {
      ActionTone.playful => [
          '${namePrefix}you are right on the wire at $required%! Missing your next class will take you under.',
          'Living on the edge! You\'re exactly at $required%, so make sure you attend the next class to build a buffer.',
        ],
      ActionTone.motivational => [
          'You\'re holding steady right at the $required% mark, $nameGreeting! Attend your next class to build a safer cushion.',
          'Stay strong! You are exactly at $required%, and one more attended class gives you real breathing room.',
        ],
      ActionTone.roast => [
          'Zero buffer remaining, $nameGreeting. Miss the next class and you\'re officially in the danger zone.',
          'You\'re walking a tightrope at $required%. One skip and you go down!',
        ],
      ActionTone.direct => [
          'You are exactly at the $required% threshold. Do not skip your next class.',
          'No attendance buffer available. Attend the next class to remain compliant.',
        ],
    };

    final seed = 'threshold|$attended|$missed|$required|$userName|${tone.name}';
    return messages[deterministicIndex(seed, messages.length)];
  }

  // 3. Recovery scenario (must attend consecutive classes)
  final int denominator = 100 - required;
  final int needToAttend = (numerator / denominator).ceil();

  final List<String> messages = needToAttend == 1
      ? switch (tone) {
          ActionTone.playful => [
              '${namePrefix}you are right on the edge! Just show up to the very next class to get back above $required%.',
              'No skipping today, $nameGreeting! Attend 1 more class to pull your average back above $required%.',
            ],
          ActionTone.motivational => [
              'Almost there, $nameGreeting! Just 1 solid check-in at the next class gets you back into the safe $required% zone.',
              'You can easily fix this! Attend your next class to restore your $required% threshold.',
            ],
          ActionTone.roast => [
              'The skipping spree stops here. Show up to your next class or pay the price!',
              'You flew a bit too close to the sun. Be in your seat for the next class, $nameGreeting.',
            ],
          ActionTone.direct => [
              'You must attend the next class to return above the $required% threshold.',
              'Attendance deficit detected. Attend the next 1 class to regain compliance.',
            ],
        }
      : switch (tone) {
          ActionTone.playful => [
              'Time to lock in, $nameGreeting! You need to attend the next $needToAttend classes straight before you can think about skipping.',
              'Uh-oh, reserve depleted! Show up to $needToAttend consecutive classes to restore your $required% safety net.',
              '${namePrefix}your attendance needs a quick boost. Head to the next $needToAttend classes in a row to get back on track.',
            ],
          ActionTone.motivational => [
              'You can bounce back from this, $nameGreeting! Commit to attending the next $needToAttend classes to reach your $required% goal.',
              'A short streak will fix this! Attend $needToAttend consecutive classes to restore your buffer.',
              'Stay focused! You are $needToAttend continuous classes away from getting safely back above $required%.',
            ],
          ActionTone.roast => [
              '${namePrefix}the skipping party is officially over. Show your face in class $needToAttend times in a row, okay?',
              'You used up all your credits! Time to attend $needToAttend classes straight to save your $required% average.',
            ],
          ActionTone.direct => [
              '${namePrefix}you must attend the next $needToAttend consecutive classes to meet the $required% threshold.',
              'Below threshold. Required action: Attend $needToAttend upcoming classes continuously.',
            ],
        };

  final seed =
      'attend|$attended|$missed|$required|$needToAttend|$userName|${tone.name}';
  return messages[deterministicIndex(seed, messages.length)];
}
