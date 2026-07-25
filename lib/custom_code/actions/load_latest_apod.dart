// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future<ApodStruct> loadLatestApod() async {
  try {
    final response = await Supabase.instance.client.rpc('get_latest_apod');

    if (response == null) {
      return ApodStruct();
    }

    final row = (response as List).firstOrNull;
    if (row == null) {
      return ApodStruct();
    }

    final data = Map<String, dynamic>.from(row as Map);

    return ApodStruct(
      apodDate: data['apod_date'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['image_url'] as String? ?? '',
      hdImageUrl: data['hd_image_url'] as String? ?? '',
      mediaType: data['media_type'] as String? ?? '',
      shareUrl: data['share_url'] as String? ?? '',
      copyright: data['copyright'] as String? ?? '',
      fetchedAt: data['fetched_at'] != null
          ? DateTime.parse(data['fetched_at']).toLocal()
          : null,
    );
  } on PostgrestException catch (e) {
    debugPrint('loadLatestApod RPC failed: ${e.message}');
    return ApodStruct();
  } catch (e) {
    debugPrint('loadLatestApod failed: $e');
    return ApodStruct();
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the `</>` button on the right!
