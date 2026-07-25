// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ApodStruct extends BaseStruct {
  ApodStruct({
    String? apodDate,
    String? title,
    String? description,
    String? imageUrl,
    String? hdImageUrl,
    String? mediaType,
    String? shareUrl,
    String? copyright,
    DateTime? fetchedAt,
  })  : _apodDate = apodDate,
        _title = title,
        _description = description,
        _imageUrl = imageUrl,
        _hdImageUrl = hdImageUrl,
        _mediaType = mediaType,
        _shareUrl = shareUrl,
        _copyright = copyright,
        _fetchedAt = fetchedAt;

  // "apodDate" field.
  String? _apodDate;
  String get apodDate => _apodDate ?? '';
  set apodDate(String? val) => _apodDate = val;

  bool hasApodDate() => _apodDate != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "hdImageUrl" field.
  String? _hdImageUrl;
  String get hdImageUrl => _hdImageUrl ?? '';
  set hdImageUrl(String? val) => _hdImageUrl = val;

  bool hasHdImageUrl() => _hdImageUrl != null;

  // "mediaType" field.
  String? _mediaType;
  String get mediaType => _mediaType ?? '';
  set mediaType(String? val) => _mediaType = val;

  bool hasMediaType() => _mediaType != null;

  // "shareUrl" field.
  String? _shareUrl;
  String get shareUrl => _shareUrl ?? '';
  set shareUrl(String? val) => _shareUrl = val;

  bool hasShareUrl() => _shareUrl != null;

  // "copyright" field.
  String? _copyright;
  String get copyright => _copyright ?? '';
  set copyright(String? val) => _copyright = val;

  bool hasCopyright() => _copyright != null;

  // "fetchedAt" field.
  DateTime? _fetchedAt;
  DateTime? get fetchedAt => _fetchedAt;
  set fetchedAt(DateTime? val) => _fetchedAt = val;

  bool hasFetchedAt() => _fetchedAt != null;

  static ApodStruct fromMap(Map<String, dynamic> data) => ApodStruct(
        apodDate: data['apodDate'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        imageUrl: data['imageUrl'] as String?,
        hdImageUrl: data['hdImageUrl'] as String?,
        mediaType: data['mediaType'] as String?,
        shareUrl: data['shareUrl'] as String?,
        copyright: data['copyright'] as String?,
        fetchedAt: data['fetchedAt'] as DateTime?,
      );

  static ApodStruct? maybeFromMap(dynamic data) =>
      data is Map ? ApodStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'apodDate': _apodDate,
        'title': _title,
        'description': _description,
        'imageUrl': _imageUrl,
        'hdImageUrl': _hdImageUrl,
        'mediaType': _mediaType,
        'shareUrl': _shareUrl,
        'copyright': _copyright,
        'fetchedAt': _fetchedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'apodDate': serializeParam(
          _apodDate,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'hdImageUrl': serializeParam(
          _hdImageUrl,
          ParamType.String,
        ),
        'mediaType': serializeParam(
          _mediaType,
          ParamType.String,
        ),
        'shareUrl': serializeParam(
          _shareUrl,
          ParamType.String,
        ),
        'copyright': serializeParam(
          _copyright,
          ParamType.String,
        ),
        'fetchedAt': serializeParam(
          _fetchedAt,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static ApodStruct fromSerializableMap(Map<String, dynamic> data) =>
      ApodStruct(
        apodDate: deserializeParam(
          data['apodDate'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        hdImageUrl: deserializeParam(
          data['hdImageUrl'],
          ParamType.String,
          false,
        ),
        mediaType: deserializeParam(
          data['mediaType'],
          ParamType.String,
          false,
        ),
        shareUrl: deserializeParam(
          data['shareUrl'],
          ParamType.String,
          false,
        ),
        copyright: deserializeParam(
          data['copyright'],
          ParamType.String,
          false,
        ),
        fetchedAt: deserializeParam(
          data['fetchedAt'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'ApodStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ApodStruct &&
        apodDate == other.apodDate &&
        title == other.title &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        hdImageUrl == other.hdImageUrl &&
        mediaType == other.mediaType &&
        shareUrl == other.shareUrl &&
        copyright == other.copyright &&
        fetchedAt == other.fetchedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        apodDate,
        title,
        description,
        imageUrl,
        hdImageUrl,
        mediaType,
        shareUrl,
        copyright,
        fetchedAt
      ]);
}

ApodStruct createApodStruct({
  String? apodDate,
  String? title,
  String? description,
  String? imageUrl,
  String? hdImageUrl,
  String? mediaType,
  String? shareUrl,
  String? copyright,
  DateTime? fetchedAt,
}) =>
    ApodStruct(
      apodDate: apodDate,
      title: title,
      description: description,
      imageUrl: imageUrl,
      hdImageUrl: hdImageUrl,
      mediaType: mediaType,
      shareUrl: shareUrl,
      copyright: copyright,
      fetchedAt: fetchedAt,
    );
