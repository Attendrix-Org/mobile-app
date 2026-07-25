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

double getScheduleProgress(
  DateTime startTime,
  DateTime endTime,
  DateTime currentTime,
) {
  // Edge Case: If end time is before or equal to start time (invalid range)
  if (!endTime.isAfter(startTime)) {
    return 0.0;
  }

  // Edge Case: Class hasn't started yet
  if (currentTime.isBefore(startTime)) {
    return 0.0;
  }

  // Edge Case: Class is already finished
  if (currentTime.isAfter(endTime)) {
    return 1.0;
  }

  final totalDurationInMs = endTime.difference(startTime).inMilliseconds;
  final elapsedDurationInMs = currentTime.difference(startTime).inMilliseconds;

  // Calculate percentage and clamp strictly between 0.0 and 1.0
  final progress = elapsedDurationInMs / totalDurationInMs;
  return progress.clamp(0.0, 1.0);
}
