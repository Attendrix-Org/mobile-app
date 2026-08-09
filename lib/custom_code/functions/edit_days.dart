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

DateTime editDays(
  DateTime targetTime,
  int numOfdays,
  bool addorSubtract,
) {
  // A Function which will add/Subtract days from the target date and give a normalised dateTime
// Check if we need to add or subtract days
  if (addorSubtract) {
    return targetTime.add(Duration(days: numOfdays));
  } else {
    return targetTime.subtract(Duration(days: numOfdays));
  }
}
