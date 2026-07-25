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

List<String> getMessMenu(
  List<MessStruct> messes,
  String selectedMessId,
  int selectedWeekday,
  String mealType,
) {
  if (messes.isEmpty || selectedMessId.isEmpty || mealType.isEmpty) {
    return [];
  }

  // Find the selected mess.
  MessStruct? mess;
  for (final m in messes) {
    if (m.messId == selectedMessId) {
      mess = m;
      break;
    }
  }
  if (mess == null) return [];

  // Find the menu entry for the given weekday and meal.
  MessMenuStruct? entry;
  for (final e in mess.menu) {
    if (e.weekday == selectedWeekday &&
        e.meal.trim().toLowerCase() == mealType.trim().toLowerCase()) {
      entry = e;
      break;
    }
  }
  if (entry == null || entry.menu.trim().isEmpty) return [];

  String sanitize(String text) => text
      .replaceAll(RegExp(r'\r\n|\r|\n'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  return entry.menu
      .split('+')
      .map(sanitize)
      .where((section) => section.isNotEmpty)
      .toList();
}
