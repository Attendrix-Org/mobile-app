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

String formatTimeString(
  String timeString,
  TimeFormat timeFormat,
) {
  if (timeString == null || timeString.trim().isEmpty) {
    return '--:--';
  }

  try {
    final cleanStr = timeString.trim();
    final parts = cleanStr.split(':');
    if (parts.length < 2) return cleanStr;

    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);

    if (timeFormat == TimeFormat.twentyFourHour) {
      final hStr = hour.toString().padLeft(2, '0');
      final mStr = minute.toString().padLeft(2, '0');
      return '$hStr:$mStr';
    }

    // 12-hour AM/PM format (default)
    final String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour % 12;
    if (displayHour == 0) displayHour = 12;

    final String mStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$mStr $period';
  } catch (e) {
    return timeString;
  }
}
