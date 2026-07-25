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

String? getRandomOnboardingStatus() {
  // A curated list of 20+ distinct academic profile loading strings
  final list = [
    "Setting Up Your Academic Profile...",
    "Synchronizing Batch Timetables...",
    "Calibrating Elective Slot Configurations...",
    "Finalizing Your Student Ledger...",
    "Constructing Your Personalized Calendar...",
    "Mapping Department Prerequisites...",
    "Architecting Attendance Analytics...",
    "Assembling Your Semester Course Matrix...",
    "Optimizing Lecture Slot Integrations...",
    "Establishing Secure Academic Tokens...",
    "Validating Roll Number Credentials...",
    "Configuring Core Curriculum Frameworks...",
    "Compiling Your Lab Sub-Batch Allocations...",
    "Structuring Elective Conflict Resolvers...",
    "Initializing Dashboard Analytics...",
    "Linking Dynamic Timetable Databases...",
    "Generating Smart Attendance Trackers...",
    "Indexing NITC Department Schemas...",
    "Preparing Your Academic Workspace...",
    "Securing Profile Verification Protocols...",
    "Polishing Your Attendrix Interface..."
  ];

  final random = math.Random();
  return list[random.nextInt(list.length)];
}
