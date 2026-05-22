import 'package:flutter/foundation.dart';

@immutable
class ApodDto {
  const ApodDto({
    required this.date,
    required this.title,
    required this.explanation,
    required this.mediaType,
    required this.url,
    this.hdurl,
    this.copyright,
    this.serviceVersion,
    this.thumbnailUrl,
  });

  factory ApodDto.fromJson(Map<String, dynamic> json) {
    return ApodDto(
      date: json['date'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      mediaType: json['media_type'] as String,
      url: json['url'] as String,
      hdurl: json['hdurl'] as String?,
      copyright: json['copyright'] as String?,
      serviceVersion: json['service_version'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }

  final String date;
  final String title;
  final String explanation;
  final String mediaType;
  final String url;
  final String? hdurl;
  final String? copyright;
  final String? serviceVersion;
  final String? thumbnailUrl;

  Map<String, dynamic> toJson() => {
    'date': date,
    'title': title,
    'explanation': explanation,
    'media_type': mediaType,
    'url': url,
    'hdurl': hdurl,
    'copyright': copyright,
    'service_version': serviceVersion,
    'thumbnail_url': thumbnailUrl,
  };

  ApodDto copyWith({
    String? date,
    String? title,
    String? explanation,
    String? mediaType,
    String? url,
    String? hdurl,
    String? copyright,
    String? serviceVersion,
    String? thumbnailUrl,
  }) {
    return ApodDto(
      date: date ?? this.date,
      title: title ?? this.title,
      explanation: explanation ?? this.explanation,
      mediaType: mediaType ?? this.mediaType,
      url: url ?? this.url,
      hdurl: hdurl ?? this.hdurl,
      copyright: copyright ?? this.copyright,
      serviceVersion: serviceVersion ?? this.serviceVersion,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApodDto &&
        other.date == date &&
        other.title == title &&
        other.explanation == explanation &&
        other.mediaType == mediaType &&
        other.url == url &&
        other.hdurl == hdurl &&
        other.copyright == copyright &&
        other.serviceVersion == serviceVersion &&
        other.thumbnailUrl == thumbnailUrl;
  }

  @override
  int get hashCode => Object.hash(
    date,
    title,
    explanation,
    mediaType,
    url,
    hdurl,
    copyright,
    serviceVersion,
    thumbnailUrl,
  );
}
