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

List<String> getEmptyStateMessage(
  DateTime? date,
  ActionTone? tone,
  String? seedKey,
) {
// 1. Const matrix scoped inside the function (Zero allocation on runtime)
  const Map<String, Map<String, Map<ActionTone, List<List<String>>>>>
      emptyStateMatrix = {
    'today': {
      'weekday': {
        ActionTone.playful: [
          [
            'A Quiet Day',
            'Nothing showed up for today. Enjoy the surprise class-free day!'
          ],
          [
            'Ghost Town',
            'No classes found today! Your timetable is officially taking a nap.'
          ],
          [
            'Free Pass!',
            'Looks like clear skies today—no scheduled classes on the radar.'
          ],
          [
            'Plot Twist',
            'Your schedule is totally blank today. Go do something fun!'
          ],
        ],
        ActionTone.direct: [
          [
            'No Classes Today',
            'No classes were recorded for today in your timetable.'
          ],
          [
            'Schedule Unoccupied',
            'There are no academic sessions registered for today.'
          ],
          [
            'No Academic Sessions',
            'No scheduled lectures or labs were found for today.'
          ],
          [
            'Blank Timetable',
            'No active classes are assigned to your schedule today.'
          ],
        ],
        ActionTone.motivational: [
          [
            'Unscheduled Freedom',
            'No classes today! Use this time to focus on your personal growth.'
          ],
          [
            'Opportunity Knocks',
            'A completely free day today. Turn this extra time into your competitive advantage.'
          ],
          [
            'Your Blank Canvas',
            'Zero classes today. Take charge of your schedule and build something meaningful.'
          ],
          [
            'Self-Directed Focus',
            'No lectures today—the perfect chance to study on your own terms.'
          ],
        ],
        ActionTone.roast: [
          [
            'Suspiciously Free',
            'No classes today... Try not to spend 8 hours convincing yourself you\'ll study tomorrow.'
          ],
          [
            'Boredom Incoming',
            'Zero classes today! Let\'s see how fast you rot on social media.'
          ],
          [
            'What\'s the Excuse?',
            'No classes today! So what\'s your excuse for being unproductive now?'
          ],
          [
            'Enjoy the Void',
            'A totally empty schedule. Try not to panic without a timetable telling you where to go.'
          ],
        ],
      },
      'weekend': {
        ActionTone.playful: [
          [
            'Weekend Mode',
            'No lectures. No labs. Just a well-deserved weekend.'
          ],
          [
            'Zero Alarm Day',
            'The campus is sleeping, and so should you. Enjoy the weekend!'
          ],
          [
            'Class-Free Zone',
            'No textbooks required today! Time to recharge those batteries.'
          ],
          [
            'Weekend Unlocked',
            'Schedule clear, brain off. Go enjoy your time off!'
          ],
        ],
        ActionTone.direct: [
          ['Weekend Schedule', 'No regular classes are scheduled for today.'],
          [
            'Non-Academic Day',
            'Regular classes are not scheduled on weekend dates.'
          ],
          [
            'Scheduled Break',
            'No academic sessions are scheduled for this weekend day.'
          ],
          [
            'Weekend Off',
            'Timetable records indicate no active academic sessions today.'
          ],
        ],
        ActionTone.motivational: [
          [
            'Rest & Recharge',
            'Use today to reset. Rest is just as essential as the hustle.'
          ],
          [
            'Weekend Momentum',
            'Stepping away from class gives you room to build on your own terms.'
          ],
          [
            'Reflect & Fuel Up',
            'No classes today—a great time to prepare for the week ahead.'
          ],
          [
            'Power Down',
            'Take pride in this week\'s effort and enjoy a well-earned break today.'
          ],
        ],
        ActionTone.roast: [
          [
            'Bed Rotting Authorized',
            'No classes today. Time to rot in bed for 14 hours straight.'
          ],
          [
            'Touch Grass',
            'No classes today. Go outside, look at sunlight, and remember what real life is.'
          ],
          [
            'Procrastination Haven',
            'Zero classes today, which means zero excuses for not cleaning your room.'
          ],
          [
            'Clock Off',
            'Finally, a day where you don\'t have to pretend you\'re taking notes.'
          ],
        ],
      },
    },
    'past': {
      'weekday': {
        ActionTone.playful: [
          [
            'History Lesson',
            'You survived this day! No classes were logged in the archives.'
          ],
          [
            'Blast from the Past',
            'Looking back, this was a totally class-free day.'
          ],
          [
            'Memory Lane',
            'No classes were found for this past date. Must have been a good day!'
          ],
          [
            'Clear History',
            'This day in the past was completely free of lectures.'
          ],
        ],
        ActionTone.direct: [
          ['Past Record Empty', 'No classes were recorded on this past date.'],
          ['Historical Log', 'No academic sessions were held on this day.'],
          ['Archive Blank', 'No timetable records exist for this past date.'],
          ['No Session Recorded', 'This past date had no scheduled classes.'],
        ],
        ActionTone.motivational: [
          [
            'In the Books',
            'A peaceful day in your past. Hope you made great use of it!'
          ],
          [
            'Reflect on Growth',
            'No classes were logged here. Every break helps sustain long-term focus.'
          ],
          [
            'Logged & Done',
            'Looking back at a clear day. Hope it gave you the energy you needed!'
          ],
          ['Past Balance', 'Even in the past, rest was part of the process.'],
        ],
        ActionTone.roast: [
          [
            'Ancient Procrastination',
            'Looking back at a day you did absolutely nothing? Nostalgic, isn\'t it?'
          ],
          [
            'Ghost from the Past',
            'Zero classes on this day and you probably still complained about being tired.'
          ],
          [
            'Waste of Yesterday',
            'No classes this day... and yet you still managed to achieve zero productivity.'
          ],
          [
            'Rewind & Regret',
            'Checking past empty schedules won\'t bring back the time you wasted scrolling.'
          ],
        ],
      },
      'weekend': {
        ActionTone.playful: [
          [
            'Old Weekend',
            'That was a weekend in the past! Hope it was a good one.'
          ],
          ['Past Weekend', 'No classes were scheduled for this weekend date.'],
          ['Weekend Memory', 'Just a quiet past weekend on record.'],
          ['Historical Break', 'No lectures logged on this past weekend.'],
        ],
        ActionTone.direct: [
          [
            'Past Weekend Log',
            'No regular classes were scheduled for this past weekend date.'
          ],
          ['Weekend Archive', 'Non-academic weekend date in history.'],
          ['Past Off-Day', 'Weekend record: zero classes assigned.'],
          ['Completed Weekend', 'No sessions recorded for this past weekend.'],
        ],
        ActionTone.motivational: [
          [
            'Past Recovery',
            'A past weekend well spent resting and recharging.'
          ],
          [
            'A Milestone Past',
            'Reflect on how far you\'ve come since this clear weekend.'
          ],
          [
            'Rest Well Spent',
            'No classes on this past weekend—hope it fueled your journey!'
          ],
          ['Looking Back', 'A smooth, class-free weekend in your history.'],
        ],
        ActionTone.roast: [
          [
            'Weekend Archaeology',
            'Digging up past weekends? Go live in the present, buddy.'
          ],
          [
            'Nostalgic Laziness',
            'Stalking past weekends when you didn\'t have classes? Move on.'
          ],
          [
            'Old News',
            'It was a weekend in the past. Why are you inspecting your own history?'
          ],
          [
            'History Buff',
            'Looking at an empty past weekend won\'t undo the work you have due now.'
          ],
        ],
      },
    },
    'future': {
      'weekday': {
        ActionTone.playful: [
          [
            'Future Clear!',
            'No classes on this upcoming day. Future-you is going to love this.'
          ],
          [
            'Ahead of the Game',
            'Looking ahead? No classes scheduled for this future day yet!'
          ],
          [
            'Sneak Peek',
            'Your future schedule looks completely clear for this date.'
          ],
          ['Plotting Ahead', 'No classes on the radar for this upcoming day!'],
        ],
        ActionTone.direct: [
          [
            'Future Schedule Empty',
            'No classes are currently scheduled for this future date.'
          ],
          [
            'Upcoming Off-Day',
            'No academic sessions registered for this date ahead.'
          ],
          [
            'Advance View',
            'Your timetable shows no entries for this future day.'
          ],
          ['Future Slot Clear', 'No classes assigned to this upcoming date.'],
        ],
        ActionTone.motivational: [
          [
            'Plan Ahead',
            'A clear day in your future! Block it out now for deep work or rest.'
          ],
          [
            'Future Potential',
            'Zero classes scheduled ahead. Start planning how to make it count!'
          ],
          [
            'Proactive Vision',
            'Looking into the future? Use this upcoming free day to get ahead.'
          ],
          [
            'Clear Horizon',
            'A bright, open day ahead on your schedule. Build something great!'
          ],
        ],
        ActionTone.roast: [
          [
            'Future Procrastination',
            'No classes on this future day. Already planning how to waste it?'
          ],
          [
            'Daydreaming Ahead',
            'Looking at future empty days because today is too overwhelming? Classic.'
          ],
          [
            'False Hope',
            'Zero classes scheduled for this future date. Don\'t get too excited, a professor might add one.'
          ],
          [
            'Planning to Slack',
            'Checking future free days to calculate maximum laziness? Respect the commitment.'
          ],
        ],
      },
      'weekend': {
        ActionTone.playful: [
          ['Future Weekend', 'An empty weekend waiting for you in the future!'],
          ['Weekend Ahead', 'No classes on this upcoming weekend date.'],
          [
            'Countdown to Freedom',
            'Looking forward to this future weekend? It\'s completely class-free!'
          ],
          [
            'Weekend on the Horizon',
            'No lectures assigned for this future weekend.'
          ],
        ],
        ActionTone.direct: [
          [
            'Upcoming Weekend',
            'No classes are scheduled for this future weekend date.'
          ],
          [
            'Future Non-Academic Day',
            'Regular classes are not scheduled on future weekends.'
          ],
          [
            'Weekend Preview',
            'Timetable reflects no classes for this upcoming weekend.'
          ],
          [
            'Future Break',
            'No scheduled academic sessions for this future weekend.'
          ],
        ],
        ActionTone.motivational: [
          [
            'Light at the End',
            'Keep pushing! This future weekend is completely clear for you.'
          ],
          [
            'Future Rest',
            'A clear weekend ahead—something great to work toward.'
          ],
          [
            'Earn Your Break',
            'Finish your current goals so you can fully enjoy this future weekend.'
          ],
          [
            'Ahead of the Curve',
            'Keep up the momentum today so this future weekend stays stress-free!'
          ],
        ],
        ActionTone.roast: [
          [
            'Future Couch Potato',
            'Checking a future weekend? Spoiler alert: you still won\'t do your homework.'
          ],
          [
            'Calendar Stalking',
            'Planning your future couch-potato sessions already? I admire the dedication.'
          ],
          [
            'Dreaming of Saturday',
            'Focus on today first! Stalking future weekends won\'t finish your current assignments.'
          ],
          [
            'Premature Celebration',
            'Celebrating a future weekend when you haven\'t even survived today yet? Bold move.'
          ],
        ],
      },
    },
  };

  // 2. Variable resolution
  final targetDate = date ?? DateTime.now();
  final targetTone = tone ?? ActionTone.playful;

  // Normalize dates to remove hours/minutes
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final checkDate = DateTime(targetDate.year, targetDate.month, targetDate.day);

  // Determine Time State (past, today, future)
  final String timeState = checkDate.isBefore(today)
      ? 'past'
      : (checkDate.isAfter(today) ? 'future' : 'today');

  // Determine Day Type (weekend vs weekday)
  final bool isWeekend = targetDate.weekday == DateTime.saturday ||
      targetDate.weekday == DateTime.sunday;
  final String dayType = isWeekend ? 'weekend' : 'weekday';

  // Retrieve message pool
  final pool = emptyStateMatrix[timeState]?[dayType]?[targetTone] ??
      emptyStateMatrix['today']!['weekday']![ActionTone.playful]!;

  // 3. Fast FNV-1a Hash calculation
  final String seed =
      "${checkDate.year}-${checkDate.month}-${checkDate.day}_${targetTone.name}_${seedKey ?? ''}";

  const int fnvOffsetBasis = 0x811C9DC5;
  const int fnvPrime = 0x01000193;
  int hash = fnvOffsetBasis;

  for (final codeUnit in seed.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * fnvPrime) & 0xFFFFFFFF;
  }

  final int index = hash.abs() % pool.length;

  return pool[index];
}
