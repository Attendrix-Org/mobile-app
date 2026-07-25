// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessStruct extends BaseStruct {
  MessStruct({
    String? messId,
    String? name,
    List<MessMenuStruct>? menu,
  })  : _messId = messId,
        _name = name,
        _menu = menu;

  // "messId" field.
  String? _messId;
  String get messId => _messId ?? '';
  set messId(String? val) => _messId = val;

  bool hasMessId() => _messId != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "menu" field.
  List<MessMenuStruct>? _menu;
  List<MessMenuStruct> get menu => _menu ?? const [];
  set menu(List<MessMenuStruct>? val) => _menu = val;

  void updateMenu(Function(List<MessMenuStruct>) updateFn) {
    updateFn(_menu ??= []);
  }

  bool hasMenu() => _menu != null;

  static MessStruct fromMap(Map<String, dynamic> data) => MessStruct(
        messId: data['messId'] as String?,
        name: data['name'] as String?,
        menu: getStructList(
          data['menu'],
          MessMenuStruct.fromMap,
        ),
      );

  static MessStruct? maybeFromMap(dynamic data) =>
      data is Map ? MessStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'messId': _messId,
        'name': _name,
        'menu': _menu?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'messId': serializeParam(
          _messId,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'menu': serializeParam(
          _menu,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static MessStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessStruct(
        messId: deserializeParam(
          data['messId'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        menu: deserializeStructParam<MessMenuStruct>(
          data['menu'],
          ParamType.DataStruct,
          true,
          structBuilder: MessMenuStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'MessStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MessStruct &&
        messId == other.messId &&
        name == other.name &&
        listEquality.equals(menu, other.menu);
  }

  @override
  int get hashCode => const ListEquality().hash([messId, name, menu]);
}

MessStruct createMessStruct({
  String? messId,
  String? name,
}) =>
    MessStruct(
      messId: messId,
      name: name,
    );
