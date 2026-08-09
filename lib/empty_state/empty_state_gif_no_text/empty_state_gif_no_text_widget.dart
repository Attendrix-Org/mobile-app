import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'empty_state_gif_no_text_model.dart';
export 'empty_state_gif_no_text_model.dart';

class EmptyStateGifNoTextWidget extends StatefulWidget {
  const EmptyStateGifNoTextWidget({
    super.key,
    String? imageUrl,
  }) : this.imageUrl =
            imageUrl ?? 'https://cdn-icons-gif.flaticon.com/16104/16104391.gif';

  final String imageUrl;

  @override
  State<EmptyStateGifNoTextWidget> createState() =>
      _EmptyStateGifNoTextWidgetState();
}

class _EmptyStateGifNoTextWidgetState extends State<EmptyStateGifNoTextWidget> {
  late EmptyStateGifNoTextModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptyStateGifNoTextModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        valueOrDefault<String>(
          widget.imageUrl,
          'https://cdn-icons-gif.flaticon.com/16104/16104391.gif',
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
