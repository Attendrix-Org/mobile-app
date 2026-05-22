import 'package:flutter/foundation.dart';

@immutable
class MediaMetadata {
  const MediaMetadata({
    required this.mediaType,
    this.videoProvider,
    this.videoId,
    this.thumbnailUrl,
  });

  factory MediaMetadata.fromJson(Map<String, dynamic> json) {
    return MediaMetadata(
      mediaType: json['media_type'] as String,
      videoProvider: json['video_provider'] as String?,
      videoId: json['video_id'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }

  final String mediaType;
  final String? videoProvider;
  final String? videoId;
  final String? thumbnailUrl;

  Map<String, dynamic> toJson() => {
    'media_type': mediaType,
    'video_provider': videoProvider,
    'video_id': videoId,
    'thumbnail_url': thumbnailUrl,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MediaMetadata &&
        other.mediaType == mediaType &&
        other.videoProvider == videoProvider &&
        other.videoId == videoId &&
        other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode => Object.hash(
    mediaType,
    videoProvider,
    videoId,
    thumbnailUrl,
  );
}
