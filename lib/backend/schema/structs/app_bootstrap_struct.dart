// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AppBootstrapStruct extends BaseStruct {
  AppBootstrapStruct({
    bool? onboardingCompleted,
    bool? needsForceUpdate,
    String? currentVersion,
    int? currentBuildNumber,
    String? versionDownloadLink,
    String? releaseNotes,
    bool? isWebAvailable,
    bool? hasError,
  })  : _onboardingCompleted = onboardingCompleted,
        _needsForceUpdate = needsForceUpdate,
        _currentVersion = currentVersion,
        _currentBuildNumber = currentBuildNumber,
        _versionDownloadLink = versionDownloadLink,
        _releaseNotes = releaseNotes,
        _isWebAvailable = isWebAvailable,
        _hasError = hasError;

  // "onboarding_completed" field.
  bool? _onboardingCompleted;
  bool get onboardingCompleted => _onboardingCompleted ?? false;
  set onboardingCompleted(bool? val) => _onboardingCompleted = val;

  bool hasOnboardingCompleted() => _onboardingCompleted != null;

  // "needs_force_update" field.
  bool? _needsForceUpdate;
  bool get needsForceUpdate => _needsForceUpdate ?? false;
  set needsForceUpdate(bool? val) => _needsForceUpdate = val;

  bool hasNeedsForceUpdate() => _needsForceUpdate != null;

  // "current_version" field.
  String? _currentVersion;
  String get currentVersion => _currentVersion ?? '';
  set currentVersion(String? val) => _currentVersion = val;

  bool hasCurrentVersion() => _currentVersion != null;

  // "current_build_number" field.
  int? _currentBuildNumber;
  int get currentBuildNumber => _currentBuildNumber ?? 0;
  set currentBuildNumber(int? val) => _currentBuildNumber = val;

  void incrementCurrentBuildNumber(int amount) =>
      currentBuildNumber = currentBuildNumber + amount;

  bool hasCurrentBuildNumber() => _currentBuildNumber != null;

  // "version_download_link" field.
  String? _versionDownloadLink;
  String get versionDownloadLink => _versionDownloadLink ?? '';
  set versionDownloadLink(String? val) => _versionDownloadLink = val;

  bool hasVersionDownloadLink() => _versionDownloadLink != null;

  // "release_notes" field.
  String? _releaseNotes;
  String get releaseNotes => _releaseNotes ?? '';
  set releaseNotes(String? val) => _releaseNotes = val;

  bool hasReleaseNotes() => _releaseNotes != null;

  // "is_web_available" field.
  bool? _isWebAvailable;
  bool get isWebAvailable => _isWebAvailable ?? false;
  set isWebAvailable(bool? val) => _isWebAvailable = val;

  bool hasIsWebAvailable() => _isWebAvailable != null;

  // "hasError" field.
  bool? _hasError;
  bool get hasError => _hasError ?? false;
  set hasError(bool? val) => _hasError = val;

  bool hasHasError() => _hasError != null;

  static AppBootstrapStruct fromMap(Map<String, dynamic> data) =>
      AppBootstrapStruct(
        onboardingCompleted: data['onboarding_completed'] as bool?,
        needsForceUpdate: data['needs_force_update'] as bool?,
        currentVersion: data['current_version'] as String?,
        currentBuildNumber: castToType<int>(data['current_build_number']),
        versionDownloadLink: data['version_download_link'] as String?,
        releaseNotes: data['release_notes'] as String?,
        isWebAvailable: data['is_web_available'] as bool?,
        hasError: data['hasError'] as bool?,
      );

  static AppBootstrapStruct? maybeFromMap(dynamic data) => data is Map
      ? AppBootstrapStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'onboarding_completed': _onboardingCompleted,
        'needs_force_update': _needsForceUpdate,
        'current_version': _currentVersion,
        'current_build_number': _currentBuildNumber,
        'version_download_link': _versionDownloadLink,
        'release_notes': _releaseNotes,
        'is_web_available': _isWebAvailable,
        'hasError': _hasError,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'onboarding_completed': serializeParam(
          _onboardingCompleted,
          ParamType.bool,
        ),
        'needs_force_update': serializeParam(
          _needsForceUpdate,
          ParamType.bool,
        ),
        'current_version': serializeParam(
          _currentVersion,
          ParamType.String,
        ),
        'current_build_number': serializeParam(
          _currentBuildNumber,
          ParamType.int,
        ),
        'version_download_link': serializeParam(
          _versionDownloadLink,
          ParamType.String,
        ),
        'release_notes': serializeParam(
          _releaseNotes,
          ParamType.String,
        ),
        'is_web_available': serializeParam(
          _isWebAvailable,
          ParamType.bool,
        ),
        'hasError': serializeParam(
          _hasError,
          ParamType.bool,
        ),
      }.withoutNulls;

  static AppBootstrapStruct fromSerializableMap(Map<String, dynamic> data) =>
      AppBootstrapStruct(
        onboardingCompleted: deserializeParam(
          data['onboarding_completed'],
          ParamType.bool,
          false,
        ),
        needsForceUpdate: deserializeParam(
          data['needs_force_update'],
          ParamType.bool,
          false,
        ),
        currentVersion: deserializeParam(
          data['current_version'],
          ParamType.String,
          false,
        ),
        currentBuildNumber: deserializeParam(
          data['current_build_number'],
          ParamType.int,
          false,
        ),
        versionDownloadLink: deserializeParam(
          data['version_download_link'],
          ParamType.String,
          false,
        ),
        releaseNotes: deserializeParam(
          data['release_notes'],
          ParamType.String,
          false,
        ),
        isWebAvailable: deserializeParam(
          data['is_web_available'],
          ParamType.bool,
          false,
        ),
        hasError: deserializeParam(
          data['hasError'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'AppBootstrapStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AppBootstrapStruct &&
        onboardingCompleted == other.onboardingCompleted &&
        needsForceUpdate == other.needsForceUpdate &&
        currentVersion == other.currentVersion &&
        currentBuildNumber == other.currentBuildNumber &&
        versionDownloadLink == other.versionDownloadLink &&
        releaseNotes == other.releaseNotes &&
        isWebAvailable == other.isWebAvailable &&
        hasError == other.hasError;
  }

  @override
  int get hashCode => const ListEquality().hash([
        onboardingCompleted,
        needsForceUpdate,
        currentVersion,
        currentBuildNumber,
        versionDownloadLink,
        releaseNotes,
        isWebAvailable,
        hasError
      ]);
}

AppBootstrapStruct createAppBootstrapStruct({
  bool? onboardingCompleted,
  bool? needsForceUpdate,
  String? currentVersion,
  int? currentBuildNumber,
  String? versionDownloadLink,
  String? releaseNotes,
  bool? isWebAvailable,
  bool? hasError,
}) =>
    AppBootstrapStruct(
      onboardingCompleted: onboardingCompleted,
      needsForceUpdate: needsForceUpdate,
      currentVersion: currentVersion,
      currentBuildNumber: currentBuildNumber,
      versionDownloadLink: versionDownloadLink,
      releaseNotes: releaseNotes,
      isWebAvailable: isWebAvailable,
      hasError: hasError,
    );
