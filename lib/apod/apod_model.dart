import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'apod_widget.dart' show ApodWidget;
import 'package:flutter/material.dart';

class ApodModel extends FlutterFlowModel<ApodWidget> {
  ///  Local state fields for this page.

  String apodImageState =
      'https://assets.science.nasa.gov/dynamicimage/assets/science/missions/webb/science/2026/07/STScI-01KVT7DD8N4T05XGZCT15QZEZ9.png?w=512&h=512&fit=crop&crop=faces,focalpoint';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - convertPathToUploadedFile] action in APOD widget.
  FFUploadedFile? apodImage;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
