import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/request_manager.dart';

import 'class_report_widget.dart' show ClassReportWidget;
import 'package:flutter/material.dart';

class ClassReportModel extends FlutterFlowModel<ClassReportWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - reportClassCancelled] action in Button widget.
  bool? reportStatus;

  /// Query cache managers for this widget.

  final _reportCacheManager =
      FutureRequestManager<List<ClassCancellationReportsRow>>();
  Future<List<ClassCancellationReportsRow>> reportCache({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<ClassCancellationReportsRow>> Function() requestFn,
  }) =>
      _reportCacheManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearReportCacheCache() => _reportCacheManager.clear();
  void clearReportCacheCacheKey(String? uniqueKey) =>
      _reportCacheManager.clearRequest(uniqueKey);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    /// Dispose query cache managers for this widget.

    clearReportCacheCache();
  }
}
