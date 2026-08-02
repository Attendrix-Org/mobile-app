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

String? generateWalkMessage(
  int walkTime,
  int leaveIn,
  DateTime startTime,
  String tone,
) {
  final now = DateTime.now();

  // 1. Evaluate State String
  final String state;
  if (leaveIn > 15) {
    state = 'plentyOfTime';
  } else if (leaveIn > 0) {
    state = 'leavingSoon';
  } else if (leaveIn == 0) {
    state = 'leaveNow';
  } else if (-leaveIn < walkTime) {
    state = 'slightlyLate';
  } else {
    state = 'veryLate';
  }

  // 2. Normalize Tone String
  final normalizedTone = tone.trim().toLowerCase();

  // 3. Define Template Matrix inside function
  final Map<String, Map<String, List<String>>> matrix = {
    'plentyOfTime': {
      'direct': [
        'You have {leaveIn} min before your {walkTime} min walk.',
        'Leave in {leaveIn} min for your {walkTime} min walk.',
        'No rush—{walkTime} min walk, {leaveIn} min to go.',
        'Plenty of time. {walkTime} min walk, leave in {leaveIn} min.',
        'You\'re on schedule. {walkTime} min walk starts in {leaveIn} min.',
      ],
      'playful': [
        'Kick back for {leaveIn} more min—it\'s just a {walkTime} min walk.',
        'You\'ve earned a break! {walkTime} min walk starts in {leaveIn} min.',
        'No sprinting needed. Just a {walkTime} min stroll in {leaveIn} min.',
        'Plenty of breathing room before your {walkTime} min stroll.',
        'Future you leaves in {leaveIn} min for a {walkTime} min walk. Present you can chill.',
      ],
      'motivational': [
        'Stay ahead of schedule—{walkTime} min walk, leave in {leaveIn} min.',
        'Great pace today. Leave in {leaveIn} min for your {walkTime} min walk.',
        'Consistency is key. Relaxed {walkTime} min walk coming up.',
        'You\'re doing great! Enjoy the next {leaveIn} min before your {walkTime} min walk.',
        'Small habits build momentum. {walkTime} min walk in {leaveIn} min.',
      ],
      'roast': [
        'You have {leaveIn} min before a {walkTime} min walk. Try not to mess this up.',
        'Don\'t waste all {leaveIn} min scrolling before a simple {walkTime} min walk.',
        'It\'s just a {walkTime} min walk. Don\'t turn {leaveIn} min into being late.',
        'You actually have time for once. Don\'t ruin it.',
        'Enjoy these {leaveIn} min before the {walkTime} min walk—we both know what usually happens.',
      ],
    },
    'leavingSoon': {
      'direct': [
        'Leave in {leaveIn} min for your {walkTime} min walk.',
        'Time to wrap up—{walkTime} min walk starts in {leaveIn} min.',
        'Head out in {leaveIn} min for the {walkTime} min walk.',
        'Start getting ready. {walkTime} min walk, leave in {leaveIn} min.',
        'Your walk is {walkTime} min—head out in {leaveIn} min.',
      ],
      'playful': [
        'Your shoes are calling. {walkTime} min walk in {leaveIn} min.',
        'Wrap it up—your {walkTime} min walk starts in {leaveIn} min.',
        'Countdown started: {leaveIn} min until your {walkTime} min walk.',
        'Don\'t get too comfortable—{leaveIn} min left.',
        'Time to trade scrolling for strolling in {leaveIn} min.',
      ],
      'motivational': [
        'Stay focused—leave in {leaveIn} min for your {walkTime} min walk.',
        'Keep the streak alive! Head out in {leaveIn} min.',
        'Almost time to move. {walkTime} min walk in {leaveIn} min.',
        'Finish up and prepare to leave in {leaveIn} min.',
        'Every class counts. {walkTime} min walk starts in {leaveIn} min.',
      ],
      'roast': [
        'This is where you usually start procrastinating. {leaveIn} min left.',
        'It\'s a {walkTime} min walk. Don\'t test your luck.',
        'The clock is ticking. {leaveIn} min left before you go.',
        'Future you will regret ignoring this {leaveIn} min warning.',
        'Your {walkTime} min walk won\'t shorten itself. Leave in {leaveIn} min.',
      ],
    },
    'leaveNow': {
      'direct': [
        'Leave now for your {walkTime} min walk.',
        'Head out now—it\'s a {walkTime} min walk.',
        'It\'s time to go. Your walk takes {walkTime} min.',
        'Leave now to arrive on time.',
        'Now\'s the time. {walkTime} min walk ahead.',
      ],
      'playful': [
        'This is your cue! {walkTime} min walk ahead 🚶',
        'Adventure starts now—see you there in {walkTime} min!',
        'Shoes on, headphones in, let\'s go!',
        'No more excuses—your {walkTime} min walk awaits.',
        'Go go go! Time to start walking.',
      ],
      'motivational': [
        'Right on time! Leave now for a solid {walkTime} min walk.',
        'Keep up the great habits—head out now.',
        'Let\'s do this! Start your {walkTime} min walk.',
        'Showing up is winning. Go now!',
        'Stay consistent. Time to head out.',
      ],
      'roast': [
        'Move! Why are you still reading this screen?',
        'Your classroom isn\'t getting any closer. Go.',
        'Standing here won\'t shorten a {walkTime} min walk. Go!',
        'Seriously... go.',
        'Your bed isn\'t coming to class with you. Leave now.',
      ],
    },
    'slightlyLate': {
      'direct': [
        'Leave now—about {lateBy} min late, {walkTime} min walk.',
        'You\'re {lateBy} min behind. Head out now.',
        'Leave now to minimize the delay.',
        '{lateBy} min behind, but leaving now still saves most of class.',
        'You\'re slightly late. Go now, it\'s a {walkTime} min walk.',
      ],
      'playful': [
        'Tiny oops! Only {lateBy} min late if you hustle.',
        'Speed-walking mode activated! {walkTime} min walk ahead.',
        'Better hustle! Campus isn\'t getting any smaller.',
        'You\'re cutting it close—move fast.',
        'Quick feet, less regret! Go now.',
      ],
      'motivational': [
        'Don\'t give up—head out now.',
        'Better {lateBy} min late than absent! Go anyway.',
        'You can still catch most of class. Keep moving!',
        'Every minute matters. Start walking now!',
        'One slight delay doesn\'t ruin the day. Go now.',
      ],
      'roast': [
        'Impressive timing. Already {lateBy} min late.',
        'That "5-minute break" really worked out, huh?',
        'You\'re racing the attendance sheet. Go!',
        'Speed won\'t fix bad decisions, but start walking anyway.',
        'Late again? Time to power-walk.',
      ],
    },
    'veryLate': {
      'direct': [
        'You\'re {lateBy} min late. Head over now, it\'s a {walkTime} min walk.',
        'Class is underway, but it\'s still worth heading over.',
        'You\'re significantly behind. Leave immediately.',
        'Already {lateBy} min late—still worth going.',
        'Head to class as soon as possible.',
      ],
      'playful': [
        'Plot twist: class started {lateBy} min ago.',
        'Better make a cinematic entrance!',
        'Looks like time won this round. Start walking!',
        'Hope they saved you a seat!',
        'Time to speedrun your campus commute.',
      ],
      'motivational': [
        'Showing up late beats skipping completely. Go!',
        'Finish the day strong—head over now.',
        'Don\'t write off the whole class. Go anyway.',
        'One late class doesn\'t define your semester.',
        'Every lecture counts. Start walking now.',
      ],
      'roast': [
        'Peak procrastination achieved: {lateBy} min late.',
        'Your professor definitely noticed. Start walking.',
        'Maybe leave *before* class starts next time?',
        'Congratulations, you\'ve unlocked Late Again.',
        'Your attendance percentage is crying. Move!',
      ],
    },
  };

  // 4. Retrieve Templates with Direct Fallbacks
  final templates = matrix[state]?[normalizedTone] ??
      matrix[state]?['direct'] ??
      ['Leave in {leaveIn} min for a {walkTime} min walk.'];

  // 5. Deterministic Hash Computation (FNV-1a 32-bit inline)
  final dayOfYear = int.parse(
      '${now.year}${now.difference(DateTime(now.year, 1, 1)).inDays}');
  final hashInput =
      '${dayOfYear}_${state}_${normalizedTone}_${startTime.millisecondsSinceEpoch}_$walkTime';

  int hash = 2166136261;
  for (int i = 0; i < hashInput.length; i++) {
    hash ^= hashInput.codeUnitAt(i);
    hash = (hash * 16777619) & 0xFFFFFFFF;
  }

  final deterministicIndex = hash.abs() % templates.length;
  final selectedTemplate = templates[deterministicIndex];

  // 6. Formatting Inlined Variables
  final lateBy = leaveIn < 0 ? -leaveIn : 0;
  final hour = startTime.hour == 0
      ? 12
      : (startTime.hour > 12 ? startTime.hour - 12 : startTime.hour);
  final minute = startTime.minute.toString().padLeft(2, '0');
  final period = startTime.hour >= 12 ? 'PM' : 'AM';
  final formattedStartTime = '$hour:$minute $period';

  // 7. Interpolate & Return
  return selectedTemplate
      .replaceAll('{leaveIn}', leaveIn.toString())
      .replaceAll('{walkTime}', walkTime.toString())
      .replaceAll('{lateBy}', lateBy.toString())
      .replaceAll('{startTime}', formattedStartTime);
}
