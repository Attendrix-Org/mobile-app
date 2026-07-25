import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'metadata_row_model.dart';
export 'metadata_row_model.dart';

class MetadataRowWidget extends StatefulWidget {
  const MetadataRowWidget({
    super.key,
    String? label,
    String? value,
  })  : this.label = label ?? 'Department',
        this.value = value ?? 'Computer Science & Engineering';

  final String label;
  final String value;

  @override
  State<MetadataRowWidget> createState() => _MetadataRowWidgetState();
}

class _MetadataRowWidgetState extends State<MetadataRowWidget> {
  late MetadataRowModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MetadataRowModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100.0,
          child: Text(
            valueOrDefault<String>(
              widget.label,
              'Department',
            ),
            style: FlutterFlowTheme.of(context).labelMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                  lineHeight: 1.38,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).labelMediumIsCustom,
                ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            valueOrDefault<String>(
              widget.value,
              'Computer Science & Engineering',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w500,
                  lineHeight: 1.47,
                  useGoogleFonts:
                      !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                ),
          ),
        ),
      ].divide(SizedBox(width: 8.0)),
    );
  }
}
