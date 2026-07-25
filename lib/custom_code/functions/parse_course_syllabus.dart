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

CourseSyllabusStruct? parseCourseSyllabus(CourseSyllabiRow row) {
  List<String> parseStringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }

    if (value is String) {
      return List<String>.from(jsonDecode(value));
    }

    return [];
  }

  List<SyllabusModuleStruct> parseModules(dynamic value) {
    if (value == null) return [];

    final List<dynamic> modules =
        value is String ? jsonDecode(value) : List<dynamic>.from(value);

    return modules.map((module) {
      final map = Map<String, dynamic>.from(module);

      return SyllabusModuleStruct(
        title: map['topic_title']?.toString() ?? '',
        topics: map['topics'] == null ? [] : List<String>.from(map['topics']),
      );
    }).toList();
  }

  return CourseSyllabusStruct(
    courseCode: row.courseCode,
    courseName: row.courseName,
    syllabusPath: row.syllabusPath,
    prerequisites: row.prerequisites ?? '',
    lectureHours: row.lectureHours ?? 0,
    tutorialHours: row.tutorialHours ?? 0,
    practicalHours: row.practicalHours ?? 0,
    outsideHours: row.outsideHours ?? 0,
    lectureSessions: row.lectureSessions ?? 0,
    courseOutcomes: parseStringList(row.courseOutcomes),
    modules: parseModules(row.modules),
    textbooks: parseStringList(row.textbooks),
    references: parseStringList(row.referenceList),
  );
}
