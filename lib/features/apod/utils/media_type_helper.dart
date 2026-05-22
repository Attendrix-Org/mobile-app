import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/utils/media_parser.dart';

class MediaTypeHelper {
  const MediaTypeHelper._();

  static bool isImage(ApodEntry entry) => entry.mediaType == 'image';
  static bool isVideo(ApodEntry entry) => entry.mediaType == 'video';

  static ParsedVideo? parseVideo(ApodEntry entry) {
    if (!isVideo(entry)) return null;
    return MediaParser.parseVideoUrl(entry.url);
  }

  static String getDisplayUrl(ApodEntry entry) {
    if (isImage(entry)) {
      return entry.hdurl ?? entry.url;
    }
    // For videos, try to get a thumbnail
    final parsed = parseVideo(entry);
    return parsed?.thumbnailUrl ?? entry.url;
  }

  static String getMediaTypeLabel(ApodEntry entry) {
    return switch (entry.mediaType) {
      'image' => 'Photo',
      'video' => 'Video',
      _ => 'Media',
    };
  }
}
