import 'dart:async';
import 'dart:ui';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/apod_action_bar.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/apod_image_viewer.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/apod_video_player.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/expandable_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// The main detail page for a NASA Astronomy Picture of the Day (APOD) entry.
/// Supports shimmer loading via [Skeletonizer], custom error state screens,
/// and responsive tablet/mobile layouts.
class ApodDetailPage extends ConsumerStatefulWidget {
  const ApodDetailPage({
    super.key,
    this.entry,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });
  static const routeName = '/apod-detail';

  /// The APOD entry to display. If null and [isLoading] is true, a dummy entry
  /// is used for skeleton shimmers.
  final ApodEntry? entry;

  /// Whether the page is currently in a loading state.
  final bool isLoading;

  /// Error message, if any. If non-null, the "Lost in Space" error screen is shown.
  final String? errorMessage;

  /// Callback to retry fetching data after an error.
  final VoidCallback? onRetry;

  @override
  ConsumerState<ApodDetailPage> createState() => _ApodDetailPageState();
}

class _ApodDetailPageState extends ConsumerState<ApodDetailPage> {
  bool _isInitialized = false;
  ApodEntry? _currentEntry;
  late String _currentDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;

      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      _currentEntry = widget.entry;

      String? initialDate;

      if (routeArgs is Map<String, dynamic>) {
        _currentEntry = routeArgs['entry'] as ApodEntry?;
        initialDate = routeArgs['date'] as String?;
      } else if (routeArgs is ApodEntry) {
        _currentEntry = routeArgs;
      } else if (routeArgs is String) {
        initialDate = routeArgs;
      }

      if (_currentEntry != null) {
        _currentDate = _currentEntry!.date;
      } else if (initialDate != null) {
        _currentDate = initialDate;
      } else {
        // Fall back to today's date if no entry or date was provided
        final now = DateTime.now();
        _currentDate =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      }
    }
  }

  @override
  void didUpdateWidget(ApodDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.entry != oldWidget.entry) {
      setState(() {
        _currentEntry = widget.entry;
        if (_currentEntry != null) {
          _currentDate = _currentEntry!.date;
        }
      });
    }
  }

  bool _isTodayOrLater(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      return !date.isBefore(todayDate);
    } on FormatException catch (_) {
      return false;
    }
  }

  bool _isEarliestOrEarlier(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final earliest = DateTime(1995, 6, 16);
      return !date.isAfter(earliest);
    } on FormatException catch (_) {
      return false;
    }
  }

  void _navigateToPreviousDay() {
    try {
      final date = DateTime.parse(_currentDate);
      final prevDate = date.subtract(const Duration(days: 1));
      final prevDateStr =
          '${prevDate.year}-${prevDate.month.toString().padLeft(2, '0')}-${prevDate.day.toString().padLeft(2, '0')}';
      setState(() {
        _currentDate = prevDateStr;
      });
    } on FormatException catch (_) {}
  }

  void _navigateToNextDay() {
    try {
      final date = DateTime.parse(_currentDate);
      final nextDate = date.add(const Duration(days: 1));
      final nextDateStr =
          '${nextDate.year}-${nextDate.month.toString().padLeft(2, '0')}-${nextDate.day.toString().padLeft(2, '0')}';
      setState(() {
        _currentDate = nextDateStr;
      });
    } on FormatException catch (_) {}
  }

  void _handleRetry() {
    if (widget.onRetry != null) {
      widget.onRetry!();
    } else {
      final parsedDate = DateTime.parse(_currentDate);
      final normalizedDate = DateTime.utc(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
      );
      unawaited(ref.read(apodStateProvider(normalizedDate).notifier).refresh());
    }
  }

  // A mock entry to populate Skeletonizer when the real entry isn't loaded yet.
  static const ApodEntry _dummyEntry = ApodEntry(
    date: '2026-05-21',
    title: 'Loading Cosmic Archive Dataset from Deep Space...',
    explanation:
        'This is a placeholder explanation containing several sentences so that the shimmer skeleton matches the layout of the real NASA Astronomy Picture of the Day text details. The content will be replaced by actual scientific data once the server link is established.',
    url: 'https://images-assets.nasa.gov/image/PIA04921/PIA04921~orig.jpg',
    mediaType: 'image',
    copyright: 'NASA/JPL-Caltech',
    resolution: '4K Ultra HD',
    creditTitle: 'James Webb Space Telescope',
    creditDescription:
        'The James Webb Space Telescope is a space observatory designed primarily to conduct infrared astronomy. As the largest optical telescope in space, its high resolution and sensitivity allow it to view objects too old, distant, or faint for the Hubble Space Telescope.',
  );

  Widget _buildOfflineBanner(bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        border: Border(
          bottom: BorderSide(
            color: Colors.amber.withValues(alpha: 0.3),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off_rounded, color: Colors.amber, size: 18),
          const SizedBox(width: 8),
          Text(
            'Offline Mode — displaying cached data',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFFDE047) : const Color(0xFFCA8A04),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve which colors to use based on the "Celestial Archive" spec
    final canvasColor = isDark
        ? const Color(0xFF131315)
        : const Color(0xFFF8FAFC);
    final accentColor = isDark
        ? const Color(0xFFC5C0FF)
        : const Color(0xFF6F61EF);
    final surfaceColor = isDark ? const Color(0xFF201F21) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF353437)
        : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF15161E);
    final secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF606A85);

    // Watch Riverpod state
    final parsedDate = DateTime.parse(_currentDate);
    final normalizedDate = DateTime.utc(
      parsedDate.year,
      parsedDate.month,
      parsedDate.day,
    );
    final apodState = ref.watch(apodStateProvider(normalizedDate));

    var isLoading = widget.isLoading;
    var errorMessage = widget.errorMessage;
    ApodEntry? displayEntry;
    var isRefreshing = false;
    var isOffline = false;

    if (errorMessage != null) {
      if (widget.entry != null) {
        displayEntry = widget.entry;
      }
    } else if (isLoading && widget.entry == null) {
      // External loading
    } else {
      switch (apodState) {
        case ApodLoading():
          if (widget.entry != null && widget.entry!.date == _currentDate) {
            displayEntry = widget.entry;
          } else if (_currentEntry != null &&
              _currentEntry!.date == _currentDate) {
            displayEntry = _currentEntry;
          } else {
            isLoading = true;
          }
        case ApodSuccess(:final entry, isRefreshing: final isRefreshingValue):
          displayEntry = entry;
          isRefreshing = isRefreshingValue;
        case ApodCached(:final entry, isRefreshing: final isRefreshingValue):
          displayEntry = entry;
          isRefreshing = isRefreshingValue;
        case ApodOfflineFallback(
          :final entry,
          isRefreshing: final isRefreshingValue,
        ):
          displayEntry = entry;
          isOffline = true;
          isRefreshing = isRefreshingValue;
        case ApodError(errorMessage: final errorMessageValue):
          errorMessage = errorMessageValue;
      }
    }

    final entry = displayEntry ?? _dummyEntry;

    return Scaffold(
      backgroundColor: canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          key: const Key('apod_detail_back_btn'),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Cosmic Archive',
          style: GoogleFonts.outfit(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            key: const Key('apod_prev_day_btn'),
            icon: const Icon(Icons.arrow_back_rounded),
            color: textColor,
            onPressed: (isLoading || _isEarliestOrEarlier(_currentDate))
                ? null
                : _navigateToPreviousDay,
          ),
          IconButton(
            key: const Key('apod_next_day_btn'),
            icon: const Icon(Icons.arrow_forward_rounded),
            color: textColor,
            onPressed: (isLoading || _isTodayOrLater(_currentDate))
                ? null
                : _navigateToNextDay,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (isOffline) _buildOfflineBanner(isDark),
            if (isRefreshing)
              const LinearProgressIndicator(
                minHeight: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8A80FF)),
                backgroundColor: Colors.transparent,
              ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: _buildBodyContent(
                  context,
                  entry: entry,
                  isLoading: isLoading,
                  errorMessage: errorMessage,
                  isDark: isDark,
                  canvasColor: canvasColor,
                  accentColor: accentColor,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context, {
    required ApodEntry entry,
    required bool isLoading,
    required String? errorMessage,
    required bool isDark,
    required Color canvasColor,
    required Color accentColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    print('BUILD BODY CONTENT: isLoading = $isLoading');
    if (errorMessage != null && !isLoading) {
      return _buildLostInSpaceErrorView(
        context,
        errorMessage: errorMessage,
        isDark: isDark,
        accentColor: accentColor,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        textColor: textColor,
        secondaryTextColor: secondaryTextColor,
      );
    }

    return LayoutBuilder(
      key: ValueKey<bool>(isLoading),
      builder: (context, constraints) {
        print(
          'LAYOUT BUILDER RUNNING: isTablet = ${constraints.maxWidth > 720}',
        );
        final isTablet = constraints.maxWidth > 720;

        if (isTablet) {
          return Skeletonizer(
            key: const Key('apod_skeletonizer'),
            enabled: isLoading,
            child: _buildTabletLayout(
              context,
              entry: entry,
              isDark: isDark,
              accentColor: accentColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
          );
        } else {
          return Skeletonizer(
            key: const Key('apod_skeletonizer'),
            enabled: isLoading,
            child: _buildMobileLayout(
              context,
              entry: entry,
              isDark: isDark,
              accentColor: accentColor,
              surfaceColor: surfaceColor,
              borderColor: borderColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
          );
        }
      },
    );
  }

  // ==========================================
  // MOBILE SINGLE-COLUMN SCROLL LAYOUT
  // ==========================================
  Widget _buildMobileLayout(
    BuildContext context, {
    required ApodEntry entry,
    required bool isDark,
    required Color accentColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final mediaHeight = MediaQuery.of(context).size.height * 0.45;

    return RefreshIndicator(
      onRefresh: () async {
        final parsedDate = DateTime.parse(_currentDate);
        final normalizedDate = DateTime.utc(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
        );
        await ref.read(apodStateProvider(normalizedDate).notifier).refresh();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Hero Media Banner (Edge-to-Edge)
            _buildHeroMediaBanner(
              context,
              entry: entry,
              height: mediaHeight,
              isDark: isDark,
              accentColor: accentColor,
              textColor: textColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Title & Date
                  _buildHeaderTitle(entry, textColor, secondaryTextColor),
                  const SizedBox(height: 18),

                  // 3. Quick Info Badges (Horizontal scroll)
                  _buildQuickInfoBadges(
                    entry,
                    isDark: isDark,
                    accentColor: accentColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),

                  // 4. Description section
                  _buildDescriptionSection(
                    entry,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                  const SizedBox(height: 24),

                  // 5. Actions Grid
                  Text(
                    'ARCHIVE ACTIONS',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ApodActionBar(
                    entry: entry,
                    onOpenHD: () => _openHDImageViewer(context, entry),
                  ),
                  const SizedBox(height: 28),

                  // 6. Attribution Section
                  if (entry.creditTitle != null) ...[
                    _buildAttributionSection(
                      entry,
                      isDark: isDark,
                      accentColor: accentColor,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // 7. Related Accordions
                  _buildRelatedAccordions(
                    entry,
                    isDark: isDark,
                    accentColor: accentColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TABLET SPLIT-COLUMN LAYOUT
  // ==========================================
  Widget _buildTabletLayout(
    BuildContext context, {
    required ApodEntry entry,
    required bool isDark,
    required Color accentColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Column: Media Banner & Attribution/Accordions
        Expanded(
          flex: 5,
          child: RefreshIndicator(
            onRefresh: () async {
              final parsedDate = DateTime.parse(_currentDate);
              final normalizedDate = DateTime.utc(
                parsedDate.year,
                parsedDate.month,
                parsedDate.day,
              );
              await ref
                  .read(apodStateProvider(normalizedDate).notifier)
                  .refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeroMediaBanner(
                    context,
                    entry: entry,
                    height: 350,
                    borderRadius: BorderRadius.circular(24),
                    isDark: isDark,
                    accentColor: accentColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),
                  if (entry.creditTitle != null) ...[
                    _buildAttributionSection(
                      entry,
                      isDark: isDark,
                      accentColor: accentColor,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildRelatedAccordions(
                    entry,
                    isDark: isDark,
                    accentColor: accentColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Right Column: Metadata, Description & Actions
        Expanded(
          flex: 6,
          child: RefreshIndicator(
            onRefresh: () async {
              final parsedDate = DateTime.parse(_currentDate);
              final normalizedDate = DateTime.utc(
                parsedDate.year,
                parsedDate.month,
                parsedDate.day,
              );
              await ref
                  .read(apodStateProvider(normalizedDate).notifier)
                  .refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 24, right: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderTitle(entry, textColor, secondaryTextColor),
                  const SizedBox(height: 20),
                  _buildQuickInfoBadges(
                    entry,
                    isDark: isDark,
                    accentColor: accentColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(
                    entry,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'ARCHIVE ACTIONS',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ApodActionBar(
                    entry: entry,
                    onOpenHD: () => _openHDImageViewer(context, entry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SHARED UI COMPONENT BUILDERS
  // ==========================================

  void _openHDImageViewer(BuildContext context, ApodEntry entry) {
    print('=== OPEN HD IMAGE VIEWER CALLED ===');
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => ApodImageViewer(
            imageUrl: entry.hdurl ?? entry.url,
            title: entry.title,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroMediaBanner(
    BuildContext context, {
    required ApodEntry entry,
    required double height,
    required bool isDark,
    required Color accentColor,
    required Color textColor,
    BorderRadius? borderRadius,
  }) {
    if (entry.mediaType == 'video') {
      return Container(
        height: height,
        margin: borderRadius != null ? EdgeInsets.zero : null,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Colors.black,
        ),
        clipBehavior: Clip.antiAlias,
        child: ApodVideoPlayer(
          videoUrl: entry.url,
          height: height,
        ),
      );
    }

    final secondaryText = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF606A85);

    final gradientOverlay = Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              if (isDark) const Color(0xFF131315) else const Color(0xFFF8FAFC),
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.center,
          ),
        ),
      ),
    );

    final mediaTypeBadge = Positioned(
      top: 16,
      left: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            color: Colors.black.withValues(alpha: 0.55),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.photo,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  entry.mediaType.toUpperCase(),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      label: 'NASA APOD Image hero banner: ${entry.title}',
      image: true,
      child: GestureDetector(
        onTap: () => _openHDImageViewer(context, entry),
        child: Hero(
          tag: entry.hdurl ?? entry.url,
          child: Container(
            height: height,
            margin: borderRadius != null ? EdgeInsets.zero : null,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: isDark ? const Color(0xFF201F21) : const Color(0xFFE2E8F0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image loader
                CachedNetworkImage(
                  imageUrl: entry.url,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ColoredBox(
                    color: isDark
                        ? const Color(0xFF201F21)
                        : const Color(0xFFE2E8F0),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white30),
                    ),
                  ),
                  errorWidget: (context, url, error) => ColoredBox(
                    color: isDark
                        ? const Color(0xFF201F21)
                        : const Color(0xFFE2E8F0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_rounded,
                          color: secondaryText,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Cosmic Image Unavailable Offline',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: secondaryText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().scale(
                  begin: const Offset(1.05, 1.05),
                  end: const Offset(1, 1),
                  duration: 500.ms,
                  curve: Curves.easeOutCubic,
                ),
                gradientOverlay,
                mediaTypeBadge,
                // Hint to tap to view HD full-screen
                Positioned(
                  bottom: 12,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        color: Colors.black.withValues(alpha: 0.4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.zoom_in,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'TAP TO EXPAND HD',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white70,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTitle(
    ApodEntry entry,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entry.date.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: const Color(0xFF8A80FF),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.title,
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
            height: 1.25,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInfoBadges(
    ApodEntry entry, {
    required bool isDark,
    required Color accentColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
  }) {
    final badges = <Widget>[
      _buildPillBadge(
        icon: Icons.copyright_rounded,
        label: entry.copyright ?? 'Public Domain',
        isDark: isDark,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        textColor: textColor,
      ),
      _buildPillBadge(
        icon: Icons.hd_outlined,
        label: entry.resolution ?? 'Standard Res',
        isDark: isDark,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        textColor: textColor,
      ),
      _buildPillBadge(
        icon: entry.mediaType == 'video'
            ? Icons.videocam_outlined
            : Icons.photo_outlined,
        label: entry.mediaType == 'video' ? 'Video Media' : 'Image Media',
        isDark: isDark,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        textColor: textColor,
      ),
      _buildPillBadge(
        icon: Icons.calendar_today_outlined,
        label: entry.date,
        isDark: isDark,
        surfaceColor: surfaceColor,
        borderColor: borderColor,
        textColor: textColor,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: badges.map((badge) {
          final index = badges.indexOf(badge);
          final isLast = index == badges.length - 1;
          return Padding(
            padding: EdgeInsets.only(right: isLast ? 0.0 : 8.0),
            child: badge,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPillBadge({
    required IconData icon,
    required String label,
    required bool isDark,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isDark ? const Color(0xFFC5C0FF) : const Color(0xFF6F61EF),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(
    ApodEntry entry, {
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: Color(0xFF8A80FF),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'ABOUT THIS IMAGE',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ExpandableText(text: entry.explanation),
      ],
    );
  }

  Widget _buildAttributionSection(
    ApodEntry entry, {
    required bool isDark,
    required Color accentColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Round partner brand logo placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  (isDark ? const Color(0xFFC5C0FF) : const Color(0xFF6F61EF))
                      .withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.camera_rounded,
              color: isDark ? const Color(0xFFC5C0FF) : const Color(0xFF6F61EF),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PARTNER CREDIT',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: const Color(0xFF8A80FF),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.creditTitle ?? 'NASA/ESA Space Explorer Partner',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                if (entry.creditDescription != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    entry.creditDescription!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      height: 1.4,
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedAccordions(
    ApodEntry entry, {
    required bool isDark,
    required Color accentColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final accordionTheme = Theme.of(context).copyWith(
      dividerColor: Colors.transparent,
    );

    return Column(
      children: [
        Theme(
          data: accordionTheme,
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              key: const Key('copyright_accordion'),
              title: Text(
                'Copyright Details',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              iconColor: accentColor,
              collapsedIconColor: secondaryTextColor,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_person_outlined,
                        size: 16,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.copyright != null
                              ? '© All rights reserved to ${entry.copyright}. Educational and personal sharing permitted.'
                              : 'Public Domain. This work belongs to the public domain and has no copyright protection.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: secondaryTextColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Theme(
          data: accordionTheme,
          child: Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              key: const Key('source_url_accordion'),
              title: Text(
                'Source URL & API Metadata',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              iconColor: accentColor,
              collapsedIconColor: secondaryTextColor,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.link, size: 16, color: secondaryTextColor),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SelectableText(
                              entry.url,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: accentColor,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (entry.hdurl != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.link,
                              size: 16,
                              color: secondaryTextColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SelectableText(
                                entry.hdurl!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: accentColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 8),
                      Divider(color: borderColor, height: 16),
                      Text(
                        'API Endpoint: api.nasa.gov/planetary/apod',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // "LOST IN SPACE" ERROR VIEW
  // ==========================================
  Widget _buildLostInSpaceErrorView(
    BuildContext context, {
    required String errorMessage,
    required bool isDark,
    required Color accentColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Floating Satellite Vector Illustration
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor.withValues(alpha: 0.06),
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.3, 1.3),
                        duration: 2500.ms,
                        curve: Curves.easeOut,
                      )
                      .fadeOut(duration: 2500.ms),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withValues(alpha: 0.1),
                    ),
                  ),
                  Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: surfaceColor,
                          border: Border.all(color: borderColor),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.2 : 0.05,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.satellite_alt_rounded,
                          size: 40,
                          color: accentColor,
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .slideY(
                        begin: -0.15,
                        end: 0.15,
                        duration: 1800.ms,
                        curve: Curves.easeInOutBack,
                      ),
                  Positioned(
                    bottom: 0,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.signal_wifi_off_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Error Text Details
              Text(
                'Lost in Space',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  height: 1.5,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 32),

              // Retry CTA
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 200,
                  minHeight: 50,
                ),
                child: ElevatedButton.icon(
                  key: const Key('apod_error_retry_btn'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFF8A80FF)
                        : const Color(0xFF6F61EF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _handleRetry,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: Text(
                    'Retry Connection',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Status Timeout Info Pod
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.security_update_warning_rounded,
                          color: Colors.orangeAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'SYSTEM DIAGNOSTICS',
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Server Status: Gateway Timeout (504)\n'
                      '• Client Address: Space Station Network Terminal\n'
                      '• Active Mode: Local Offline Fallback Safe Mode',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 1.6,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
