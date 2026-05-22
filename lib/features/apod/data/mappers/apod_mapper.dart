import 'package:attendrix_app/features/apod/data/dto/apod_dto.dart';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';

abstract final class ApodMapper {
  static ApodEntry fromDto(ApodDto dto) {
    return ApodEntry(
      date: dto.date,
      title: dto.title,
      explanation: dto.explanation,
      mediaType: dto.mediaType,
      url: dto.url,
      hdurl: dto.hdurl,
      copyright: dto.copyright,
      creditTitle: dto.copyright,
    );
  }

  static ApodDto toDto(ApodEntry entry) {
    return ApodDto(
      date: entry.date,
      title: entry.title,
      explanation: entry.explanation,
      mediaType: entry.mediaType,
      url: entry.url,
      hdurl: entry.hdurl,
      copyright: entry.copyright,
    );
  }
}
