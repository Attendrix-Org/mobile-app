import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:attendrix_app/features/apod/data/mappers/apod_mapper.dart';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../fixtures/apod_fixtures.dart';

void main() {
  group('ApodMapper Tests', () {
    test('should map image ApodDto to ApodEntry correctly', () {
      final dto = ApodDto.fromJson(ApodFixtures.imageResponse);
      final entry = ApodMapper.fromDto(dto);

      expect(entry.date, dto.date);
      expect(entry.title, dto.title);
      expect(entry.explanation, dto.explanation);
      expect(entry.mediaType, dto.mediaType);
      expect(entry.url, dto.url);
      expect(entry.hdurl, dto.hdurl);
      expect(entry.copyright, dto.copyright);
      expect(entry.creditTitle, dto.copyright);
      expect(entry.resolution, isNull);
      expect(entry.creditDescription, isNull);
    });

    test('should map video ApodDto to ApodEntry correctly', () {
      final dto = ApodDto.fromJson(ApodFixtures.videoResponse);
      final entry = ApodMapper.fromDto(dto);

      expect(entry.date, dto.date);
      expect(entry.title, dto.title);
      expect(entry.explanation, dto.explanation);
      expect(entry.mediaType, dto.mediaType);
      expect(entry.url, dto.url);
      expect(entry.hdurl, dto.hdurl);
      expect(entry.copyright, dto.copyright);
      expect(entry.creditTitle, dto.copyright);
    });

    test('should map ApodEntry to ApodDto correctly', () {
      const entry = ApodEntry(
        date: '2024-10-24',
        title: 'Title',
        explanation: 'Explanation',
        mediaType: 'image',
        url: 'https://example.com/url',
        hdurl: 'https://example.com/hdurl',
        copyright: 'Copyright',
      );

      final dto = ApodMapper.toDto(entry);

      expect(dto.date, entry.date);
      expect(dto.title, entry.title);
      expect(dto.explanation, entry.explanation);
      expect(dto.mediaType, entry.mediaType);
      expect(dto.url, entry.url);
      expect(dto.hdurl, entry.hdurl);
      expect(dto.copyright, entry.copyright);
    });
  });
}
