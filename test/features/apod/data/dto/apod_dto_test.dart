import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fixtures/apod_fixtures.dart';

void main() {
  group('ApodDto Serialization Tests', () {
    test('should parse image JSON correctly', () {
      final dto = ApodDto.fromJson(ApodFixtures.imageResponse);

      expect(dto.date, '2024-10-24');
      expect(dto.title, 'The Pillars of Creation');
      expect(dto.explanation, contains('pillars of gas'));
      expect(dto.mediaType, 'image');
      expect(
        dto.url,
        'https://apod.nasa.gov/apod/image/2410/PillarsOfCreation_Webb_960.jpg',
      );
      expect(
        dto.hdurl,
        'https://apod.nasa.gov/apod/image/2410/PillarsOfCreation_Webb_3837.jpg',
      );
      expect(dto.copyright, 'NASA, ESA, CSA, STScI');
      expect(dto.serviceVersion, 'v1');
      expect(dto.thumbnailUrl, isNull);
    });

    test('should parse video JSON correctly', () {
      final dto = ApodDto.fromJson(ApodFixtures.videoResponse);

      expect(dto.date, '2024-10-20');
      expect(dto.title, 'Mercury Flyover');
      expect(dto.explanation, contains('planet Mercury'));
      expect(dto.mediaType, 'video');
      expect(dto.url, 'https://www.youtube.com/embed/P3GkZe3nRQ0?rel=0');
      expect(dto.hdurl, isNull);
      expect(dto.copyright, isNull);
      expect(dto.serviceVersion, 'v1');
      expect(dto.thumbnailUrl, 'https://img.youtube.com/vi/P3GkZe3nRQ0/0.jpg');
    });

    test('should support JSON roundtrip serialization', () {
      final dto = ApodDto.fromJson(ApodFixtures.imageResponse);
      final json = dto.toJson();
      final roundtripDto = ApodDto.fromJson(json);

      expect(roundtripDto, equals(dto));
      expect(roundtripDto.hashCode, equals(dto.hashCode));
    });

    test('should handle missing optional fields gracefully', () {
      final minimalJson = <String, dynamic>{
        'date': '2024-10-20',
        'title': 'Minimal APOD',
        'explanation': 'Minimal explanation',
        'media_type': 'image',
        'url': 'https://example.com/image.jpg',
      };

      final dto = ApodDto.fromJson(minimalJson);

      expect(dto.date, '2024-10-20');
      expect(dto.title, 'Minimal APOD');
      expect(dto.explanation, 'Minimal explanation');
      expect(dto.mediaType, 'image');
      expect(dto.url, 'https://example.com/image.jpg');
      expect(dto.hdurl, isNull);
      expect(dto.copyright, isNull);
      expect(dto.serviceVersion, isNull);
      expect(dto.thumbnailUrl, isNull);
    });

    test('should create a copy of ApodDto with copyWith', () {
      final dto = ApodDto.fromJson(ApodFixtures.imageResponse);
      final copy = dto.copyWith(title: 'New Title');

      expect(copy.title, 'New Title');
      expect(copy.date, dto.date);
      expect(copy.explanation, dto.explanation);
      expect(copy.url, dto.url);
      expect(copy.hdurl, dto.hdurl);
      expect(copy.copyright, dto.copyright);
      expect(copy.mediaType, dto.mediaType);
      expect(copy.serviceVersion, dto.serviceVersion);
      expect(copy.thumbnailUrl, dto.thumbnailUrl);
      expect(dto.title, 'The Pillars of Creation'); // check original unchanged
    });
  });
}
