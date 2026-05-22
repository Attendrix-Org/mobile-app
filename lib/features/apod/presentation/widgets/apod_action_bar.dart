import 'dart:async';
import 'dart:io';

import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ApodActionBar extends StatefulWidget {
  const ApodActionBar({
    required this.entry,
    required this.onOpenHD,
    super.key,
  });
  final ApodEntry entry;
  final VoidCallback onOpenHD;

  @override
  State<ApodActionBar> createState() => _ApodActionBarState();
}

class _ApodActionBarState extends State<ApodActionBar> {
  bool _isDownloading = false;
  double _downloadProgress = 0;
  bool _downloadSuccess = false;
  bool _isSaved = false;
  CancelToken? _downloadCancelToken;

  @override
  void dispose() {
    _downloadCancelToken?.cancel('Widget disposed');
    super.dispose();
  }

  Future<void> _handleShare() async {
    final text =
        '${widget.entry.title}\n\n'
        '${widget.entry.explanation}\n\n'
        'Media URL: ${widget.entry.hdurl ?? widget.entry.url}\n\n'
        'Published Date: ${widget.entry.date}';
    await Share.share(text, subject: widget.entry.title);
  }

  void _cancelDownload() {
    _downloadCancelToken?.cancel('User cancelled download');
    setState(() {
      _isDownloading = false;
      _downloadProgress = 0.0;
    });
  }

  Future<void> _handleDownload() async {
    if (_isDownloading || _downloadSuccess) return;

    // Check write permissions on Android 9 and below
    if (Platform.isAndroid) {
      const channel = MethodChannel('com.attendrix.app/downloads');
      try {
        final sdkInt =
            await channel.invokeMethod<int>('getAndroidVersion') ?? 30;
        if (sdkInt <= 28) {
          final status = await Permission.storage.request();
          if (status.isDenied) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Storage permission is required to download files.',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: const Color(0xFF131315),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            return;
          }
        }
      } on PlatformException catch (_) {
        // Fallback if method channel fails
        final status = await Permission.storage.request();
        if (status.isDenied) {
          return;
        }
      }
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadSuccess = false;
    });

    _downloadCancelToken = CancelToken();

    try {
      final dio = Dio();
      final url = widget.entry.hdurl ?? widget.entry.url;

      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
        cancelToken: _downloadCancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      if (response.data == null) {
        throw Exception('Failed to retrieve image data');
      }

      final bytes = Uint8List.fromList(response.data!);
      final cleanTitle = widget.entry.title
          .replaceAll(RegExp(r'[^\w\s\-]'), '')
          .replaceAll(' ', '_');
      final fileExtension = url.split('?').first.split('.').last;
      final finalExtension = fileExtension.length > 4 || fileExtension.isEmpty
          ? 'jpg'
          : fileExtension;
      final filename =
          'apod_${cleanTitle}_${widget.entry.date}.$finalExtension';

      String? savedPath;

      if (Platform.isAndroid) {
        const channel = MethodChannel('com.attendrix.app/downloads');
        savedPath = await channel.invokeMethod<String>('saveImageToDownloads', {
          'bytes': bytes,
          'filename': filename,
        });
      } else {
        final dir =
            await getDownloadsDirectory() ??
            await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes);
        savedPath = file.path;
      }

      if (!mounted) return;

      setState(() {
        _isDownloading = false;
        _downloadSuccess = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.greenAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Saved to $savedPath',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF131315),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _downloadSuccess = false;
          });
        }
      });
    } on Object catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        return;
      }
      if (!mounted) return;

      setState(() {
        _isDownloading = false;
        _downloadSuccess = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Download failed: ${e.toString().split('\n').first}',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF131315),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _handleCopyDesc() {
    unawaited(Clipboard.setData(ClipboardData(text: widget.entry.explanation)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.copy_all, color: Colors.greenAccent),
            const SizedBox(width: 8),
            Text(
              'Explanation copied to clipboard!',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF131315),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleVisitNasa() async {
    // Construct standard APOD webpage URL based on date (apYYMMDD.html)
    // E.g. 2024-10-24 -> ap241024.html
    final dateParts = widget.entry.date.split('-');
    if (dateParts.length == 3) {
      final yy = dateParts[0].substring(2);
      final mm = dateParts[1];
      final dd = dateParts[2];
      final nasaUrl = 'https://apod.nasa.gov/apod/ap$yy$mm$dd.html';
      final uri = Uri.parse(nasaUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to standard url if invalid
        final fallbackUri = Uri.parse(widget.entry.url);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
        }
      }
    } else {
      final uri = Uri.parse(widget.entry.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
    Widget? trailingWidget,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryBg = isDark
        ? const Color(0xFF8A80FF)
        : const Color(0xFF6F61EF);
    const primaryFg = Colors.white;

    final secondaryBg = isDark
        ? const Color(0xFF201F21)
        : const Color(0xFFFFFFFF);
    final secondaryBorder = isDark
        ? const Color(0xFF474554)
        : const Color(0xFFE2E8F0);
    final secondaryFg = isDark
        ? const Color(0xFFE5E1E4)
        : const Color(0xFF15161E);

    return Semantics(
      button: true,
      label: '$label action button',
      child: Material(
        color: isPrimary ? primaryBg : secondaryBg,
        borderRadius: isPrimary ? BorderRadius.circular(16) : null,
        shape: isPrimary
            ? null
            : RoundedRectangleBorder(
                side: BorderSide(color: secondaryBorder),
                borderRadius: BorderRadius.circular(16),
              ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (trailingWidget != null)
                      trailingWidget
                    else
                      Icon(
                        icon,
                        color: isPrimary ? primaryFg : secondaryFg,
                        size: 24,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: isPrimary ? primaryFg : secondaryFg,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Decide cross axis count based on layout width
        var crossAxisCount = 2;
        if (constraints.maxWidth >= 720) {
          crossAxisCount = 6;
        } else if (constraints.maxWidth >= 450) {
          crossAxisCount = 3;
        }

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: crossAxisCount == 6 ? 1.0 : 1.25,
          children: [
            // 1. Share (Primary Button)
            _buildActionButton(
              icon: Icons.share_rounded,
              label: 'Share',
              onTap: _handleShare,
              isPrimary: true,
            ),
            // 2. Download
            _buildActionButton(
              icon: _downloadSuccess
                  ? Icons.check_circle_outline
                  : Icons.download_rounded,
              label: _isDownloading
                  ? '${(_downloadProgress * 100).toInt()}%'
                  : _downloadSuccess
                  ? 'Saved'
                  : 'Download',
              onTap: _isDownloading ? _cancelDownload : _handleDownload,
              trailingWidget: _isDownloading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        value: _downloadProgress,
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFFC5C0FF)
                              : const Color(0xFF6F61EF),
                        ),
                      ),
                    )
                  : null,
            ),
            // 3. Open HD
            _buildActionButton(
              icon: Icons.open_in_full_rounded,
              label: 'Open HD',
              onTap: widget.onOpenHD,
            ),
            // 4. Copy Description
            _buildActionButton(
              icon: Icons.content_copy_rounded,
              label: 'Copy Desc',
              onTap: _handleCopyDesc,
            ),
            // 5. Visit NASA Source
            _buildActionButton(
              icon: Icons.rocket_launch_rounded,
              label: 'Visit NASA',
              onTap: _handleVisitNasa,
            ),
            // 6. Save
            _buildActionButton(
              icon: _isSaved ? Icons.favorite : Icons.favorite_border_rounded,
              label: _isSaved ? 'Favorited' : 'Save',
              onTap: () {
                setState(() {
                  _isSaved = !_isSaved;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
