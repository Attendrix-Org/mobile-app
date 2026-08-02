// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GraphEdgeStruct extends BaseStruct {
  GraphEdgeStruct({
    String? fromNode,
    String? toNode,
    double? distM,
    String? highway,
    String? wayId,
    List<GeometryStruct>? geometry,
  })  : _fromNode = fromNode,
        _toNode = toNode,
        _distM = distM,
        _highway = highway,
        _wayId = wayId,
        _geometry = geometry;

  // "fromNode" field.
  String? _fromNode;
  String get fromNode => _fromNode ?? '';
  set fromNode(String? val) => _fromNode = val;

  bool hasFromNode() => _fromNode != null;

  // "toNode" field.
  String? _toNode;
  String get toNode => _toNode ?? '';
  set toNode(String? val) => _toNode = val;

  bool hasToNode() => _toNode != null;

  // "distM" field.
  double? _distM;
  double get distM => _distM ?? 0.0;
  set distM(double? val) => _distM = val;

  void incrementDistM(double amount) => distM = distM + amount;

  bool hasDistM() => _distM != null;

  // "highway" field.
  String? _highway;
  String get highway => _highway ?? '';
  set highway(String? val) => _highway = val;

  bool hasHighway() => _highway != null;

  // "wayId" field.
  String? _wayId;
  String get wayId => _wayId ?? '';
  set wayId(String? val) => _wayId = val;

  bool hasWayId() => _wayId != null;

  // "geometry" field.
  List<GeometryStruct>? _geometry;
  List<GeometryStruct> get geometry => _geometry ?? const [];
  set geometry(List<GeometryStruct>? val) => _geometry = val;

  void updateGeometry(Function(List<GeometryStruct>) updateFn) {
    updateFn(_geometry ??= []);
  }

  bool hasGeometry() => _geometry != null;

  static GraphEdgeStruct fromMap(Map<String, dynamic> data) => GraphEdgeStruct(
        fromNode: data['fromNode'] as String?,
        toNode: data['toNode'] as String?,
        distM: castToType<double>(data['distM']),
        highway: data['highway'] as String?,
        wayId: data['wayId'] as String?,
        geometry: getStructList(
          data['geometry'],
          GeometryStruct.fromMap,
        ),
      );

  static GraphEdgeStruct? maybeFromMap(dynamic data) => data is Map
      ? GraphEdgeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fromNode': _fromNode,
        'toNode': _toNode,
        'distM': _distM,
        'highway': _highway,
        'wayId': _wayId,
        'geometry': _geometry?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fromNode': serializeParam(
          _fromNode,
          ParamType.String,
        ),
        'toNode': serializeParam(
          _toNode,
          ParamType.String,
        ),
        'distM': serializeParam(
          _distM,
          ParamType.double,
        ),
        'highway': serializeParam(
          _highway,
          ParamType.String,
        ),
        'wayId': serializeParam(
          _wayId,
          ParamType.String,
        ),
        'geometry': serializeParam(
          _geometry,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static GraphEdgeStruct fromSerializableMap(Map<String, dynamic> data) =>
      GraphEdgeStruct(
        fromNode: deserializeParam(
          data['fromNode'],
          ParamType.String,
          false,
        ),
        toNode: deserializeParam(
          data['toNode'],
          ParamType.String,
          false,
        ),
        distM: deserializeParam(
          data['distM'],
          ParamType.double,
          false,
        ),
        highway: deserializeParam(
          data['highway'],
          ParamType.String,
          false,
        ),
        wayId: deserializeParam(
          data['wayId'],
          ParamType.String,
          false,
        ),
        geometry: deserializeStructParam<GeometryStruct>(
          data['geometry'],
          ParamType.DataStruct,
          true,
          structBuilder: GeometryStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'GraphEdgeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is GraphEdgeStruct &&
        fromNode == other.fromNode &&
        toNode == other.toNode &&
        distM == other.distM &&
        highway == other.highway &&
        wayId == other.wayId &&
        listEquality.equals(geometry, other.geometry);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([fromNode, toNode, distM, highway, wayId, geometry]);
}

GraphEdgeStruct createGraphEdgeStruct({
  String? fromNode,
  String? toNode,
  double? distM,
  String? highway,
  String? wayId,
}) =>
    GraphEdgeStruct(
      fromNode: fromNode,
      toNode: toNode,
      distM: distM,
      highway: highway,
      wayId: wayId,
    );
