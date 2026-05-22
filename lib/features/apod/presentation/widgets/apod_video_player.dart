import 'dart:async';
import 'package:attendrix_app/features/apod/utils/media_parser.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ApodVideoPlayer extends StatefulWidget {
  const ApodVideoPlayer({
    required this.videoUrl,
    required this.height,
    super.key,
  });

  final String videoUrl;
  final double height;

  @override
  State<ApodVideoPlayer> createState() => _ApodVideoPlayerState();
}

class _ApodVideoPlayerState extends State<ApodVideoPlayer> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final controller = WebViewController();
    unawaited(controller.setJavaScriptMode(JavaScriptMode.unrestricted));
    unawaited(controller.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          if (mounted) {
            setState(() {
              _isLoading = true;
            });
          }
        },
        onPageFinished: (url) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        onWebResourceError: (error) {
          if (mounted) {
            setState(() {
              _error = error.description;
              _isLoading = false;
            });
          }
        },
      ),
    ));
    _controller = controller;

    _loadVideo();
  }

  void _loadVideo() {
    final parsed = MediaParser.parseVideoUrl(widget.videoUrl);
    if (parsed == null) {
      unawaited(_controller.loadRequest(Uri.parse(widget.videoUrl)));
      return;
    }

    var embedUrl = '';
    if (parsed.provider == VideoProvider.youtube) {
      embedUrl = 'https://www.youtube.com/embed/${parsed.videoId}?autoplay=1&mute=1&playsinline=1';
    } else if (parsed.provider == VideoProvider.vimeo) {
      embedUrl = 'https://player.vimeo.com/video/${parsed.videoId}?autoplay=1&muted=1&playsinline=1';
    } else {
      unawaited(_controller.loadRequest(Uri.parse(widget.videoUrl)));
      return;
    }

    // Wrap in responsive HTML body with security sandbox attributes on the iframe
    final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    body {
      margin: 0;
      padding: 0;
      background-color: #000;
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      width: 100vw;
    }
    iframe {
      width: 100%;
      height: 100%;
      border: none;
    }
  </style>
</head>
<body>
  <iframe 
    src="$embedUrl" 
    allow="autoplay; encrypted-media; picture-in-picture" 
    sandbox="allow-scripts allow-same-origin allow-presentation"
    allowfullscreen>
  </iframe>
</body>
</html>
''';

    unawaited(_controller.loadHtmlString(html));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      color: Colors.black,
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load video:\n$_error',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
