import 'package:flutter/foundation.dart';

enum VideoProvider { youtube, vimeo, unknown }

@immutable
class ParsedVideo {
  const ParsedVideo({
    required this.provider,
    required this.videoId,
    required this.originalUrl,
    this.thumbnailUrl,
  });

  final VideoProvider provider;
  final String videoId;
  final String originalUrl;
  final String? thumbnailUrl;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParsedVideo &&
        other.provider == provider &&
        other.videoId == videoId &&
        other.originalUrl == originalUrl &&
        other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode => Object.hash(provider, videoId, originalUrl, thumbnailUrl);
}

class MediaParser {
  const MediaParser._();

  static ParsedVideo? parseVideoUrl(String url) {
    // Try YouTube patterns first
    final youtubeId = _extractYouTubeId(url);
    if (youtubeId != null) {
      return ParsedVideo(
        provider: VideoProvider.youtube,
        videoId: youtubeId,
        originalUrl: url,
        thumbnailUrl: 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg',
      );
    }

    // Try Vimeo
    final vimeoId = _extractVimeoId(url);
    if (vimeoId != null) {
      return ParsedVideo(
        provider: VideoProvider.vimeo,
        videoId: vimeoId,
        originalUrl: url,
      );
    }

    // Unknown video provider — still return a result with the raw URL
    // Only if the URL looks like an embed or video URL
    if (url.contains('embed') || url.contains('video') || url.contains('player')) {
      return ParsedVideo(
        provider: VideoProvider.unknown,
        videoId: '',
        originalUrl: url,
      );
    }

    return null; // Not a recognized video URL
  }

  // YouTube patterns:
  // https://www.youtube.com/embed/VIDEO_ID
  // https://www.youtube.com/watch?v=VIDEO_ID
  // https://youtu.be/VIDEO_ID
  // https://youtube.com/embed/VIDEO_ID?rel=0
  static String? _extractYouTubeId(String url) {
    // embed pattern
    final embedMatch = RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]+)').firstMatch(url);
    if (embedMatch != null) return embedMatch.group(1);

    // watch pattern
    final watchMatch = RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]+)').firstMatch(url);
    if (watchMatch != null) return watchMatch.group(1);

    // short URL
    final shortMatch = RegExp(r'youtu\.be/([a-zA-Z0-9_-]+)').firstMatch(url);
    if (shortMatch != null) return shortMatch.group(1);

    return null;
  }

  // Vimeo patterns:
  // https://vimeo.com/VIDEO_ID
  // https://player.vimeo.com/video/VIDEO_ID
  static String? _extractVimeoId(String url) {
    final playerMatch = RegExp(r'player\.vimeo\.com/video/(\d+)').firstMatch(url);
    if (playerMatch != null) return playerMatch.group(1);

    final standardMatch = RegExp(r'vimeo\.com/(\d+)').firstMatch(url);
    if (standardMatch != null) return standardMatch.group(1);

    return null;
  }
}
