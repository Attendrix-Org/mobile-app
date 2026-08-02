import 'dart:convert';
import 'package:flutter/services.dart';

class FFDevEnvironmentValues {
  static const String currentEnvironment = 'Production';
  static const String environmentValuesPath =
      'assets/environment_values/environment.json';

  static final FFDevEnvironmentValues _instance =
      FFDevEnvironmentValues._internal();

  factory FFDevEnvironmentValues() {
    return _instance;
  }

  FFDevEnvironmentValues._internal();

  Future<void> initialize() async {
    try {
      final String response =
          await rootBundle.loadString(environmentValuesPath);
      final data = await json.decode(response);
      _oneSignalAppId = data['oneSignalAppId'];
      _orsAPIKEY = data['orsAPIKEY'];
    } catch (e) {
      print('Error loading environment values: $e');
    }
  }

  String _oneSignalAppId = '';
  String get oneSignalAppId => _oneSignalAppId;

  String _orsAPIKEY = '';
  String get orsAPIKEY => _orsAPIKEY;
}
