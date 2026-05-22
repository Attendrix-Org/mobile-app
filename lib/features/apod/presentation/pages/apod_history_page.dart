import 'dart:async';
import 'package:attendrix_app/features/apod/domain/entities/apod_entry.dart';
import 'package:attendrix_app/features/apod/domain/result.dart';
import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:attendrix_app/features/apod/presentation/providers/apod_providers.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/calendar_explorer.dart';
import 'package:attendrix_app/features/apod/presentation/widgets/search_result_card.dart';
import 'package:attendrix_app/features/apod/utils/date_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ApodHistoryPage extends ConsumerStatefulWidget {
  const ApodHistoryPage({super.key});

  static const routeName = '/apod-history';

  @override
  ConsumerState<ApodHistoryPage> createState() => _ApodHistoryPageState();
}

class _ApodHistoryPageState extends ConsumerState<ApodHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  bool _isLoading = false;
  bool _showCalendar = false;
  String? _searchError;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String dateText) async {
    final validationError = DateValidator.getValidationError(dateText);
    if (validationError != null) {
      setState(() {
        _searchError = validationError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _searchError = null;
    });

    final parsedDate = DateTime.parse(dateText);
    final repo = ref.read(apodRepositoryProvider);
    final result = await repo.getApodForDate(parsedDate);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    switch (result) {
      case Success(:final data):
        // Add to viewed dates
        await ref.read(viewedDatesProvider.notifier).addViewedDate(data.date);
        // Add to recent searches
        await ref.read(recentSearchesProvider.notifier).addSearch(data.date);

        if (mounted) {
          _searchController.clear();
          _searchFocusNode.unfocus();
          unawaited(
            Navigator.of(context).pushNamed(
              ApodDetailPage.routeName,
              arguments: {
                'entry': data,
              },
            ),
          );
        }
      case Failure(:final failure):
        setState(() {
          _searchError = failure.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final canvasColor = isDark
        ? const Color(0xFF131315)
        : const Color(0xFFF8FAFC);
    final surfaceColor = isDark ? const Color(0xFF201F21) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF353437)
        : const Color(0xFFE2E8F0);
    final textColor = isDark ? Colors.white : const Color(0xFF15161E);
    final secondaryTextColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF606A85);
    final accentColor = isDark
        ? const Color(0xFFC5C0FF)
        : const Color(0xFF6F61EF);

    final isGrid = ref.watch(historyViewModeProvider);
    final recentSearches = ref.watch(recentSearchesProvider);
    final historyState = ref.watch(historyEntriesProvider);

    return Scaffold(
      backgroundColor: canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          key: const Key('apod_history_back_btn'),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Cosmic Archive Explorer',
          style: GoogleFonts.outfit(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Search Bar & Calendar toggle
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: _buildSearchSection(
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    borderColor: borderColor,
                    surfaceColor: surfaceColor,
                    accentColor: accentColor,
                  ),
                ),

                // Inline validation messages
                if (_searchError != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 8,
                    ),
                    child: Text(
                      _searchError!,
                      key: const Key('search_validation_error'),
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                // Collapsible Calendar Panel
                if (_showCalendar)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: CalendarExplorer(
                      onDateSelected: (date) {
                        final dateStr =
                            '${date.year}-'
                            '${date.month.toString().padLeft(2, '0')}-'
                            '${date.day.toString().padLeft(2, '0')}';
                        setState(() {
                          _showCalendar = false;
                        });
                        unawaited(_performSearch(dateStr));
                      },
                    ),
                  ),

                // 2. Recent Searches Horizontal List
                if (recentSearches.isNotEmpty)
                  _buildRecentSearchesSection(
                    recentSearches: recentSearches,
                    accentColor: accentColor,
                    secondaryTextColor: secondaryTextColor,
                    surfaceColor: surfaceColor,
                    borderColor: borderColor,
                  ),

                // 3. History Header with Layout Switcher
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ARCHIVE HISTORY',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: secondaryTextColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            key: const Key('history_grid_toggle'),
                            icon: Icon(
                              Icons.grid_view_rounded,
                              color: isGrid ? accentColor : secondaryTextColor,
                              size: 20,
                            ),
                            onPressed: () =>
                                ref
                                        .read(historyViewModeProvider.notifier)
                                        .state =
                                    true,
                          ),
                          IconButton(
                            key: const Key('history_list_toggle'),
                            icon: Icon(
                              Icons.view_list_rounded,
                              color: !isGrid ? accentColor : secondaryTextColor,
                              size: 20,
                            ),
                            onPressed: () =>
                                ref
                                        .read(historyViewModeProvider.notifier)
                                        .state =
                                    false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 4. Archive History List/Grid
                Expanded(
                  child: historyState.when(
                    data: (entries) {
                      if (entries.isEmpty) {
                        return _buildEmptyState(
                          context,
                          accentColor: accentColor,
                          secondaryTextColor: secondaryTextColor,
                        );
                      }
                      return _buildHistoryGridOrList(
                        entries: entries,
                        isGrid: isGrid,
                      );
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => _buildErrorState(
                      error.toString(),
                      accentColor: accentColor,
                      secondaryTextColor: secondaryTextColor,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textColor: textColor,
                    ),
                  ),
                ),
              ],
            ),

            // Global loading spinner overlay for search api request
            if (_isLoading)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection({
    required Color textColor,
    required Color secondaryTextColor,
    required Color borderColor,
    required Color surfaceColor,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: TextField(
        key: const Key('history_search_input'),
        controller: _searchController,
        focusNode: _searchFocusNode,
        keyboardType: TextInputType.datetime,
        inputFormatters: [DateTextInputFormatter()],
        style: GoogleFonts.plusJakartaSans(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by date (YYYY-MM-DD)',
          hintStyle: GoogleFonts.plusJakartaSans(color: secondaryTextColor),
          prefixIcon: Icon(Icons.search, color: secondaryTextColor),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear, color: secondaryTextColor),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchError = null;
                    });
                  },
                ),
              IconButton(
                key: const Key('calendar_toggle_btn'),
                icon: Icon(
                  _showCalendar
                      ? Icons.calendar_today_rounded
                      : Icons.calendar_month_rounded,
                  color: _showCalendar ? accentColor : secondaryTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _showCalendar = !_showCalendar;
                  });
                },
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: (val) {
          // Trigger rebuilding suffix icons when text changes
          setState(() {});
        },
        onSubmitted: (val) {
          if (val.isNotEmpty) {
            unawaited(_performSearch(val));
          }
        },
      ),
    );
  }

  Widget _buildRecentSearchesSection({
    required List<String> recentSearches,
    required Color accentColor,
    required Color secondaryTextColor,
    required Color surfaceColor,
    required Color borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RECENT SEARCHES',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: secondaryTextColor,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ref.read(recentSearchesProvider.notifier).clearSearches(),
                child: Text(
                  'Clear All',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentSearches.length,
            itemBuilder: (context, index) {
              final search = recentSearches[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InputChip(
                  key: Key('recent_search_chip_$search'),
                  label: Text(
                    search,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  backgroundColor: surfaceColor,
                  disabledColor: surfaceColor,
                  shadowColor: Colors.transparent,
                  selectedColor: accentColor.withValues(alpha: 0.12),
                  side: BorderSide(color: borderColor),
                  onPressed: () {
                    _searchController.text = search;
                    unawaited(_performSearch(search));
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHistoryGridOrList({
    required List<ApodEntry> entries,
    required bool isGrid,
  }) {
    if (isGrid) {
      return GridView.builder(
        key: const Key('history_grid_view'),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return SearchResultCard(
            key: Key('history_grid_item_${entry.date}'),
            entry: entry,
            isGrid: true,
          );
        },
      );
    } else {
      return ListView.builder(
        key: const Key('history_list_view'),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return SearchResultCard(
            key: Key('history_list_item_${entry.date}'),
            entry: entry,
            isGrid: false,
          );
        },
      );
    }
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required Color accentColor,
    required Color secondaryTextColor,
  }) {
    return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history_toggle_off_rounded,
                    size: 64,
                    color: secondaryTextColor.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No APODs viewed yet',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Begin your cosmic journey by checking out today's featured Astronomy Picture of the Day.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    key: const Key('explore_today_btn'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      // Navigate to today's APOD
                      unawaited(
                        Navigator.of(context).pushNamed(
                          ApodDetailPage.routeName,
                        ),
                      );
                    },
                    icon: const Icon(Icons.rocket_launch, size: 18),
                    label: Text(
                      'Explore Today’s APOD',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fade(duration: 400.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  Widget _buildErrorState(
    String error, {
    required Color accentColor,
    required Color secondaryTextColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: Colors.orangeAccent.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 16),
              Text(
                'Archive Sync Error',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () => ref.invalidate(historyEntriesProvider),
                child: Text(
                  'Retry Sync',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
