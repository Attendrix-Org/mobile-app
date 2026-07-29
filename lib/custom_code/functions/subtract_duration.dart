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

String subtractDuration(
  DateTime targetTime,
  DateTime currentTime,
) {
  // a Subtract Duration Function which will take in TargetTime and currentTime and Give The different in Relative Format such as 10 minutes Left, 2 Minutes Left, 2 Hours 3 minutes Left
  Duration difference = targetTime.difference(currentTime);

  if (difference.isNegative) {
    return "Class Completed!"; // Target time is in the past
  }

  int hours = difference.inHours;
  int minutes = difference.inMinutes.remainder(60);

  String hourPart = hours > 0 ? '$hours Hour${hours > 1 ? 's' : ''} ' : '';
  String minutePart =
      minutes > 0 ? '$minutes Minute${minutes > 1 ? 's' : ''} ' : '';

  return '${hourPart}${minutePart}Left'.trim();
}
