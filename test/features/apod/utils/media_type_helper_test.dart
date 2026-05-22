import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/utils/media_parser.dart';
import 'package:attendrix_app/features/apod/utils/media_type_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MediaTypeHelper Tests', () {
    const imageEntry = ApodEntry(
      date: '2024-10-24',
      explanation: 'Explanation',
      title: 'Title',
      url: 'https://apod.nasa.gov/image_960.jpg',
      hdurl: 'https://apod.nasa.gov/image_3837.jpg',
      mediaType: 'image',
    );

    const videoEntry = ApodEntry(
      date: '2024-10-20',
      explanation: 'Explanation',
      title: 'Title',
      url: 'https://www.youtube.com/embed/P3GkZe3nRQ0',
      mediaType: 'video',
    );

    test('should identify image entries correctly', () {
      expect(MediaTypeHelper.isImage(imageEntry), isTrue);
      expect(MediaTypeHelper.isVideo(imageEntry), isFalse);
    });

    test('should identify video entries correctly', () {
      expect(MediaTypeHelper.isImage(videoEntry), isFalse);
      expect(MediaTypeHelper.isVideo(videoEntry), isTrue);
    });

    test('should parse video for video entry, return null for image', () {
      final parsed = MediaTypeHelper.parseVideo(videoEntry);
      expect(parsed, isNotNull);
      expect(parsed!.provider, VideoProvider.youtube);
      expect(parsed.videoId, 'P3GkZe3nRQ0');

      expect(MediaTypeHelper.parseVideo(imageEntry), isNull);
    });

    test('should return hdurl if available, else url for image display', () {
      expect(
        MediaTypeHelper.getDisplayUrl(imageEntry),
        'https://apod.nasa.gov/image_3837.jpg',
      );

      const noHdEntry = ApodEntry(
        date: '2024-10-24',
        explanation: 'Explanation',
        title: 'Title',
        url: 'https://apod.nasa.gov/image_960.jpg',
        mediaType: 'image',
      );
      expect(
        MediaTypeHelper.getDisplayUrl(noHdEntry),
        'https://apod.nasa.gov/image_960.jpg',
      );
    });

    test('should return video thumbnail url for video display', () {
      expect(
        MediaTypeHelper.getDisplayUrl(videoEntry),
        'https://img.youtube.com/vi/P3GkZe3nRQ0/hqdefault.jpg',
      );

      final rawVideoEntry = videoEntry.copyWith(
        url: 'https://example.com/other-video',
      );
      expect(
        MediaTypeHelper.getDisplayUrl(rawVideoEntry),
        'https://example.com/other-video',
      );
    });

    test('should return correct media type label', () {
      expect(MediaTypeHelper.getMediaTypeLabel(imageEntry), 'Photo');
      expect(MediaTypeHelper.getMediaTypeLabel(videoEntry), 'Video');

      final unknownEntry = imageEntry.copyWith(mediaType: 'unknown');
      expect(MediaTypeHelper.getMediaTypeLabel(unknownEntry), 'Media');
    });
  });
}
