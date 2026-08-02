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

int relativeTime(
  DateTime currentTime,
  DateTime? classStart,
  DateTime? classEnd,
) {
  // A Custom Function which will output a string based on the relativeTime as upcoming, ongoing, completed
  if (classStart == null || classEnd == null) {
    return 0;
  }

  if (currentTime.isBefore(classStart)) {
    return 0;
  } else if (currentTime.isAfter(classEnd)) {
    return 1;
  } else {
    return 2;
  }
}
