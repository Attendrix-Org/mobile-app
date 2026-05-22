import 'package:attendrix_app/features/apod/utils/media_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MediaParser Tests', () {
    test('should parse YouTube embed URL correctly', () {
      const url = 'https://www.youtube.com/embed/P3GkZe3nRQ0?rel=0';
      final parsed = MediaParser.parseVideoUrl(url);

      expect(parsed, isNotNull);
      expect(parsed!.provider, VideoProvider.youtube);
      expect(parsed.videoId, 'P3GkZe3nRQ0');
      expect(parsed.originalUrl, url);
      expect(
        parsed.thumbnailUrl,
        'https://img.youtube.com/vi/P3GkZe3nRQ0/hqdefault.jpg',
      );
    });

    test('should parse YouTube watch URL correctly', () {
      const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
      final parsed = MediaParser.parseVideoUrl(url);

      expect(parsed, isNotNull);
      expect(parsed!.provider, VideoProvider.youtube);
      expect(parsed.videoId, 'dQw4w9WgXcQ');
      expect(
        parsed.thumbnailUrl,
        'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
      );
    });

    test('should parse YouTube short URL correctly', () {
      const url = 'https://youtu.be/dQw4w9WgXcQ';
      final parsed = MediaParser.parseVideoUrl(url);

      expect(parsed, isNotNull);
      expect(parsed!.provider, VideoProvider.youtube);
      expect(parsed.videoId, 'dQw4w9WgXcQ');
    });

    test('should parse Vimeo standard URL correctly', () {
      const url = 'https://vimeo.com/123456789';
      final parsed = MediaParser.parseVideoUrl(url);

      expect(parsed, isNotNull);
      expect(parsed!.provider, VideoProvider.vimeo);
      expect(parsed.videoId, '123456789');
      expect(parsed.thumbnailUrl, isNull);
    });

    test('should parse Vimeo player URL correctly', () {
      const url = 'https://player.vimeo.com/video/123456789';
      final parsed = MediaParser.parseVideoUrl(url);

      expect(parsed, isNotNull);
      expect(parsed!.provider, VideoProvider.vimeo);
      expect(parsed.videoId, '123456789');
    });

    test('should parse unknown video URL with embed in path correctly', () {
      const url = 'https://example.com/embed/video-id';
      final parsed = MediaParser.parseVideoUrl(url);

      expect(parsed, isNotNull);
      expect(parsed!.provider, VideoProvider.unknown);
      expect(parsed.videoId, '');
      expect(parsed.originalUrl, url);
      expect(parsed.thumbnailUrl, isNull);
    });

    test('should return null for non-video URL', () {
      const url = 'https://apod.nasa.gov/apod/image/2410/image.jpg';
      final parsed = MediaParser.parseVideoUrl(url);

      expect(parsed, isNull);
    });
  });
}
