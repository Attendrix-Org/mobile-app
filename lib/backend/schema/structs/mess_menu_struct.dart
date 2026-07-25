// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessMenuStruct extends BaseStruct {
  MessMenuStruct({
    int? weekday,
    String? meal,
    String? menu,
  })  : _weekday = weekday,
        _meal = meal,
        _menu = menu;

  // "weekday" field.
  int? _weekday;
  int get weekday => _weekday ?? 0;
  set weekday(int? val) => _weekday = val;

  void incrementWeekday(int amount) => weekday = weekday + amount;

  bool hasWeekday() => _weekday != null;

  // "meal" field.
  String? _meal;
  String get meal => _meal ?? '';
  set meal(String? val) => _meal = val;

  bool hasMeal() => _meal != null;

  // "menu" field.
  String? _menu;
  String get menu => _menu ?? '';
  set menu(String? val) => _menu = val;

  bool hasMenu() => _menu != null;

  static MessMenuStruct fromMap(Map<String, dynamic> data) => MessMenuStruct(
        weekday: castToType<int>(data['weekday']),
        meal: data['meal'] as String?,
        menu: data['menu'] as String?,
      );

  static MessMenuStruct? maybeFromMap(dynamic data) =>
      data is Map ? MessMenuStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'weekday': _weekday,
        'meal': _meal,
        'menu': _menu,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'weekday': serializeParam(
          _weekday,
          ParamType.int,
        ),
        'meal': serializeParam(
          _meal,
          ParamType.String,
        ),
        'menu': serializeParam(
          _menu,
          ParamType.String,
        ),
      }.withoutNulls;

  static MessMenuStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessMenuStruct(
        weekday: deserializeParam(
          data['weekday'],
          ParamType.int,
          false,
        ),
        meal: deserializeParam(
          data['meal'],
          ParamType.String,
          false,
        ),
        menu: deserializeParam(
          data['menu'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MessMenuStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessMenuStruct &&
        weekday == other.weekday &&
        meal == other.meal &&
        menu == other.menu;
  }

  @override
  int get hashCode => const ListEquality().hash([weekday, meal, menu]);
}

MessMenuStruct createMessMenuStruct({
  int? weekday,
  String? meal,
  String? menu,
}) =>
    MessMenuStruct(
      weekday: weekday,
      meal: meal,
      menu: menu,
    );
