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

DateTime combineDateAndTime(
  DateTime date,
  String time,
) {
  try {
    var sanitized = time.trim().toUpperCase();

    // Collapse multiple spaces
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');

    // Insert a space before AM/PM if missing
    sanitized = sanitized.replaceAllMapped(
      RegExp(r'(\d)(AM|PM)$'),
      (m) => '${m.group(1)} ${m.group(2)}',
    );

    // Convert "8 AM" -> "8:00 AM"
    sanitized = sanitized.replaceFirstMapped(
      RegExp(r'^(\d{1,2}) (AM|PM)$'),
      (m) => '${m.group(1)}:00 ${m.group(2)}',
    );

    final parsed = DateFormat('h:mm a').parseStrict(sanitized);

    final localDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      parsed.hour,
      parsed.minute,
    );

    return localDateTime.toUtc();
  } catch (_) {
    // Fallback: 8:00 AM on the provided date, converted to UTC
    return DateTime(
      date.year,
      date.month,
      date.day,
      8,
      0,
    ).toUtc();
  }
}
