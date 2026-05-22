import 'package:flutter/foundation.dart';

/// Represents a NASA Astronomy Picture of the Day (APOD) entry.
@immutable
class ApodEntry {

  const ApodEntry({
    required this.date,
    required this.explanation,
    required this.title,
    required this.url,
    required this.mediaType, this.hdurl,
    this.copyright,
    this.resolution,
    this.creditTitle,
    this.creditDescription,
  });

  /// Deserializes a map structure to an [ApodEntry] instance.
  factory ApodEntry.fromJson(Map<String, dynamic> json) {
    return ApodEntry(
      date: json['date'] as String,
      explanation: json['explanation'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      hdurl: json['hdurl'] as String?,
      mediaType: (json['media_type'] ?? 'image') as String,
      copyright: json['copyright'] as String?,
      resolution: json['resolution'] as String?,
      creditTitle: json['credit_title'] as String?,
      creditDescription: json['credit_description'] as String?,
    );
  }
  /// The date of the entry, in YYYY-MM-DD format.
  final String date;

  /// The description or explanation of the astronomy picture.
  final String explanation;

  /// The title of the picture.
  final String title;

  /// The URL to the standard-resolution media (image or video thumbnail).
  final String url;

  /// The URL to the high-definition media (optional).
  final String? hdurl;

  /// The type of media, typically "image" or "video".
  final String mediaType;

  /// The copyright holder or photo credit (optional).
  final String? copyright;

  /// The display resolution, e.g., "4K UHD" (optional, for UI styling).
  final String? resolution;

  /// The title of the attribution partner, e.g., "James Webb Space Telescope" (optional).
  final String? creditTitle;

  /// The description of the attribution partner (optional).
  final String? creditDescription;

  /// Creates a copy of this entry with replacement fields.
  ApodEntry copyWith({
    String? date,
    String? explanation,
    String? title,
    String? url,
    String? hdurl,
    String? mediaType,
    String? copyright,
    String? resolution,
    String? creditTitle,
    String? creditDescription,
  }) {
    return ApodEntry(
      date: date ?? this.date,
      explanation: explanation ?? this.explanation,
      title: title ?? this.title,
      url: url ?? this.url,
      hdurl: hdurl ?? this.hdurl,
      mediaType: mediaType ?? this.mediaType,
      copyright: copyright ?? this.copyright,
      resolution: resolution ?? this.resolution,
      creditTitle: creditTitle ?? this.creditTitle,
      creditDescription: creditDescription ?? this.creditDescription,
    );
  }

  /// Serializes this instance to a map structure.
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'explanation': explanation,
      'title': title,
      'url': url,
      'hdurl': hdurl,
      'media_type': mediaType,
      'copyright': copyright,
      'resolution': resolution,
      'credit_title': creditTitle,
      'credit_description': creditDescription,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApodEntry &&
        other.date == date &&
        other.explanation == explanation &&
        other.title == title &&
        other.url == url &&
        other.hdurl == hdurl &&
        other.mediaType == mediaType &&
        other.copyright == copyright &&
        other.resolution == resolution &&
        other.creditTitle == creditTitle &&
        other.creditDescription == creditDescription;
  }

  @override
  int get hashCode {
    return Object.hash(
      date,
      explanation,
      title,
      url,
      hdurl,
      mediaType,
      copyright,
      resolution,
      creditTitle,
      creditDescription,
    );
  }
}
