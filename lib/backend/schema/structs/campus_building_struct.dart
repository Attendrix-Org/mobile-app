// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CampusBuildingStruct extends BaseStruct {
  CampusBuildingStruct({
    String? id,
    String? name,
    String? category,
    double? lat,
    double? lng,
    String? nearestNodeId,
    double? snapDistM,
    String? description,
    String? createdAt,
  })  : _id = id,
        _name = name,
        _category = category,
        _lat = lat,
        _lng = lng,
        _nearestNodeId = nearestNodeId,
        _snapDistM = snapDistM,
        _description = description,
        _createdAt = createdAt;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;
  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;
  bool hasName() => _name != null;

  // "category" field.
  String? _category;
  String get category => _category ?? '';
  set category(String? val) => _category = val;
  bool hasCategory() => _category != null;

  // "lat" field.
  double? _lat;
  double get lat => _lat ?? 0.0;
  set lat(double? val) => _lat = val;
  bool hasLat() => _lat != null;

  // "lng" field.
  double? _lng;
  double get lng => _lng ?? 0.0;
  set lng(double? val) => _lng = val;
  bool hasLng() => _lng != null;

  // "nearest_node_id" field.
  String? _nearestNodeId;
  String get nearestNodeId => _nearestNodeId ?? '';
  set nearestNodeId(String? val) => _nearestNodeId = val;
  bool hasNearestNodeId() => _nearestNodeId != null;

  // "snap_dist_m" field.
  double? _snapDistM;
  double get snapDistM => _snapDistM ?? 0.0;
  set snapDistM(double? val) => _snapDistM = val;
  bool hasSnapDistM() => _snapDistM != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;
  bool hasDescription() => _description != null;

  // "created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;
  bool hasCreatedAt() => _createdAt != null;

  static CampusBuildingStruct fromMap(Map<String, dynamic> data) =>
      CampusBuildingStruct(
        id: data['id']?.toString(),
        name: data['name']?.toString(),
        category: (data['category'] ?? data['building_type'] ?? data['amenity'])?.toString(),
        lat: castToNum(data['lat'])?.toDouble(),
        lng: castToNum(data['lng'] ?? data['lon'])?.toDouble(),
        nearestNodeId: (data['nearest_node_id'] ?? data['nearestNodeId'])?.toString(),
        snapDistM: castToNum(data['snap_dist_m'] ?? data['snapDistM'])?.toDouble(),
        description: data['description']?.toString(),
        createdAt: (data['created_at'] ?? data['createdAt'])?.toString(),
      );

  static CampusBuildingStruct? maybeFromMap(dynamic data) =>
      data is Map ? CampusBuildingStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'category': _category,
        'lat': _lat,
        'lng': _lng,
        'nearest_node_id': _nearestNodeId,
        'snap_dist_m': _snapDistM,
        'description': _description,
        'created_at': _createdAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(_id, ParamType.String),
        'name': serializeParam(_name, ParamType.String),
        'category': serializeParam(_category, ParamType.String),
        'lat': serializeParam(_lat, ParamType.double),
        'lng': serializeParam(_lng, ParamType.double),
        'nearest_node_id': serializeParam(_nearestNodeId, ParamType.String),
        'snap_dist_m': serializeParam(_snapDistM, ParamType.double),
        'description': serializeParam(_description, ParamType.String),
        'created_at': serializeParam(_createdAt, ParamType.String),
      }.withoutNulls;

  static CampusBuildingStruct fromSerializableMap(Map<String, dynamic> data) =>
      CampusBuildingStruct(
        id: deserializeParam(data['id'], ParamType.String, false),
        name: deserializeParam(data['name'], ParamType.String, false),
        category: deserializeParam(data['category'], ParamType.String, false),
        lat: deserializeParam(data['lat'], ParamType.double, false),
        lng: deserializeParam(data['lng'], ParamType.double, false),
        nearestNodeId: deserializeParam(data['nearest_node_id'], ParamType.String, false),
        snapDistM: deserializeParam(data['snap_dist_m'], ParamType.double, false),
        description: deserializeParam(data['description'], ParamType.String, false),
        createdAt: deserializeParam(data['created_at'], ParamType.String, false),
      );

  @override
  String toString() => 'CampusBuildingStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CampusBuildingStruct &&
        id == other.id &&
        name == other.name &&
        category == other.category &&
        lat == other.lat &&
        lng == other.lng &&
        nearestNodeId == other.nearestNodeId &&
        snapDistM == other.snapDistM &&
        description == other.description &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        category,
        lat,
        lng,
        nearestNodeId,
        snapDistM,
        description,
        createdAt,
      ]);
}

CampusBuildingStruct createCampusBuildingStruct({
  String? id,
  String? name,
  String? category,
  double? lat,
  double? lng,
  String? nearestNodeId,
  double? snapDistM,
  String? description,
  String? createdAt,
}) =>
    CampusBuildingStruct(
      id: id,
      name: name,
      category: category,
      lat: lat,
      lng: lng,
      nearestNodeId: nearestNodeId,
      snapDistM: snapDistM,
      description: description,
      createdAt: createdAt,
    );
