import 'dart:async';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable search result card for APOD entries.
/// Adapts layout based on [isGrid] to render as a grid tile or a list tile.
class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    required this.entry,
    required this.isGrid,
    super.key,
  });

  final ApodEntry entry;
  final bool isGrid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark ? const Color(0xFF201F21) : Colors.white;
    final borderColor = isDark ? const Color(0xFF353437) : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF15161E);
    final secondaryTextColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF606A85);
    final accentColor = isDark ? const Color(0xFFC5C0FF) : const Color(0xFF6F61EF);

    if (isGrid) {
      return _buildGridTile(
        context,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
        accentColor: accentColor,
        isDark: isDark,
      );
    } else {
      return _buildListTile(
        context,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
        accentColor: accentColor,
        isDark: isDark,
      );
    }
  }

  Widget _buildGridTile(
    BuildContext context, {
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color accentColor,
    required bool isDark,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail Image
            CachedNetworkImage(
              imageUrl: entry.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => ColoredBox(
                color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF1F5F9),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => ColoredBox(
                color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF1F5F9),
                child: Icon(Icons.broken_image_rounded, color: secondaryTextColor, size: 28),
              ),
            ),

            // Bottom Gradient Overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.85),
                      Colors.black.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // Metadata & Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    entry.date,
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFC5C0FF),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    entry.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Media Type Icon Badge (top right)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  entry.mediaType == 'video' ? Icons.videocam : Icons.photo,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), curve: Curves.easeOutBack);
  }

  Widget _buildListTile(
    BuildContext context, {
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color accentColor,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Thumbnail (rounded)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: CachedNetworkImage(
                    imageUrl: entry.url,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ColoredBox(
                      color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF1F5F9),
                      child: const Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white24),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => ColoredBox(
                      color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF1F5F9),
                      child: Icon(Icons.broken_image_rounded, color: secondaryTextColor, size: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title and Date Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          entry.date,
                          style: GoogleFonts.outfit(
                            color: accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            entry.mediaType.toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: accentColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: 250.ms)
        .slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }

  void _navigateToDetail(BuildContext context) {
    unawaited(
      Navigator.of(context).pushNamed(
        ApodDetailPage.routeName,
        arguments: {
          'entry': entry,
        },
      ),
    );
  }
}
