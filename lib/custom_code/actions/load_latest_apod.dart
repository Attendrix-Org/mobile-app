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

Future<ApodStruct> loadLatestApod() async {
  try {
    final response = await SupaFlow.client.rpc('get_latest_apod');

    if (response == null) {
      return ApodStruct();
    }

    Map<String, dynamic>? data;
    if (response is List && response.isNotEmpty) {
      data = Map<String, dynamic>.from(response.first as Map);
    } else if (response is Map) {
      data = Map<String, dynamic>.from(response);
    }

    if (data == null) {
      return ApodStruct();
    }

    return ApodStruct(
      apodDate: (data['apodDate'] ?? data['apod_date'])?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      imageUrl: (data['imageUrl'] ?? data['image_url'])?.toString() ?? '',
      hdImageUrl: (data['hdImageUrl'] ?? data['hd_image_url'])?.toString() ?? '',
      mediaType: (data['mediaType'] ?? data['media_type'])?.toString() ?? '',
      shareUrl: (data['shareUrl'] ?? data['share_url'] ?? data['shareurl'])?.toString() ?? '',
      copyright: data['copyright']?.toString() ?? '',
      fetchedAt: data['fetchedAt'] != null
          ? DateTime.tryParse(data['fetchedAt'].toString())?.toLocal()
          : (data['fetched_at'] != null
              ? DateTime.tryParse(data['fetched_at'].toString())?.toLocal()
              : null),
    );
  } catch (e) {
    debugPrint('loadLatestApod failed: $e');
    return ApodStruct();
  }
}
