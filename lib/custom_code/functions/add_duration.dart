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

DateTime addDuration(
  DateTime startTime,
  int value,
  String unit,
) {
  switch (unit.trim().toLowerCase()) {
    case 'hour':
    case 'hours':
      return startTime.add(Duration(hours: value));

    case 'minute':
    case 'minutes':
      return startTime.add(Duration(minutes: value));

    case 'second':
    case 'seconds':
      return startTime.add(Duration(seconds: value));

    default:
      return startTime;
  }
}
