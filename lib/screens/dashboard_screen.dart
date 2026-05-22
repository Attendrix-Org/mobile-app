import 'dart:async';

import 'package:attendrix_app/features/apod/presentation/pages/apod_detail_page.dart';
import 'package:attendrix_app/widgets/class_block.dart';
import 'package:attendrix_app/widgets/floating_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeBottomTab = 0;
  bool _isTodayTab = true;
  bool _isRefreshing = false;

  // Mock list of today's classes to showcase interactive checkmarks
  late List<Map<String, dynamic>> _todayClasses;
  late List<Map<String, dynamic>> _upcomingClasses;

  @override
  void initState() {
    super.initState();
    _todayClasses = [
      {
        'class_id': 'c1',
        'class_ref': 'REF-MATH3-001',
        'course_id': 'Mathematics III',
        'batch_id': 'BATCH-2026',
        'semester_id': 'sem1',
        'scheduled_start': DateTime.now().copyWith(hour: 9, minute: 0, second: 0),
        'scheduled_end': DateTime.now().copyWith(hour: 9, minute: 50, second: 0),
        'venue': 'Room 302',
        'is_plus_slot': false,
        'lab_group': 'A',
        'is_cancelled': false,
        'is_marked': false,
      },
      {
        'class_id': 'c2',
        'class_ref': 'REF-DSA-002',
        'course_id': 'Data Structures',
        'batch_id': 'BATCH-2026',
        'semester_id': 'sem1',
        'scheduled_start': DateTime.now().copyWith(hour: 10, minute: 0, second: 0),
        'scheduled_end': DateTime.now().copyWith(hour: 10, minute: 50, second: 0),
        'venue': 'CR 305',
        'is_plus_slot': true,
        'lab_group': 'B',
        'is_cancelled': false,
        'is_marked': true,
      },
      {
        'class_id': 'c3',
        'class_ref': 'REF-DBMS-003',
        'course_id': 'Database Management',
        'batch_id': 'BATCH-2026',
        'semester_id': 'sem1',
        'scheduled_start': DateTime.now().copyWith(hour: 11, minute: 0, second: 0),
        'scheduled_end': DateTime.now().copyWith(hour: 11, minute: 50, second: 0),
        'venue': 'Lab 2',
        'is_plus_slot': false,
        'lab_group': null,
        'is_cancelled': true,
        'is_marked': false,
      },
    ];

    _upcomingClasses = [
      {
        'class_id': 'c4',
        'class_ref': 'REF-MATH3-004',
        'course_id': 'Mathematics III',
        'batch_id': 'BATCH-2026',
        'semester_id': 'sem1',
        'scheduled_start': DateTime.now().add(const Duration(days: 1)).copyWith(hour: 10, minute: 0, second: 0),
        'scheduled_end': DateTime.now().add(const Duration(days: 1)).copyWith(hour: 10, minute: 50, second: 0),
        'venue': 'Room 302',
        'is_plus_slot': false,
        'lab_group': 'A',
        'is_cancelled': false,
      },
      {
        'class_id': 'c5',
        'class_ref': 'REF-OS-005',
        'course_id': 'Operating Systems',
        'batch_id': 'BATCH-2026',
        'semester_id': 'sem1',
        'scheduled_start': DateTime.now().add(const Duration(days: 2)).copyWith(hour: 11, minute: 0, second: 0),
        'scheduled_end': DateTime.now().add(const Duration(days: 2)).copyWith(hour: 11, minute: 50, second: 0),
        'venue': 'CR 306',
        'is_plus_slot': false,
        'lab_group': null,
        'is_cancelled': false,
      },
      {
        'class_id': 'c6',
        'class_ref': 'REF-SE-006',
        'course_id': 'Software Engineering',
        'batch_id': 'BATCH-2026',
        'semester_id': 'sem1',
        'scheduled_start': DateTime.now().add(const Duration(days: 3)).copyWith(hour: 14, minute: 0, second: 0),
        'scheduled_end': DateTime.now().add(const Duration(days: 3)).copyWith(hour: 14, minute: 50, second: 0),
        'venue': 'Lab 1',
        'is_plus_slot': true,
        'lab_group': 'B',
        'is_cancelled': false,
      },
    ];
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() {
      _isRefreshing = true;
    });
    // Simulate web api reload latency
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timetable updated successfully!'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showAstronomyDialog(BuildContext context) {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: 400,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cosmic Image
                    Stack(
                      children: [
                        Image.asset(
                          'assets/apod_nebula.png',
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: CircleAvatar(
                            backgroundColor: Colors.black.withValues(alpha: 0.5),
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stellar Crystal Nebula',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF15161E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Astronomy Picture of the Day',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF5FB4F4),
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'This mesmerizing image shows the vibrant crystalline gas clouds of the Stellar Crystal Nebula. Spanning across light-years, these formations are sculpted by stellar winds and ionized radiation from nearby newborn stars, shining in brilliant hues of violet, azure, and rose gold.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: const Color(0xFF606A85),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Action Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6F61EF),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                unawaited(Navigator.of(context).pushNamed(ApodDetailPage.routeName));
                              },
                              child: Text(
                                'Explore More',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
          );
        },
      ),
    );
  }


  Widget _buildHamburgerMenu(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          key: const Key('hamburger_menu_btn'),
          onTap: () => Scaffold.of(context).openDrawer(),
          behavior: HitTestBehavior.opaque,
          child: const HeroIcon(
            HeroIcons.bars3,
            color: Colors.black,
            size: 28,
          ),
        );
      },
    );
  }

  Widget _buildTabButton(String label, bool isActive) {
    const activeColor = Color(0xFF6F61EF);
    const inactiveColor = Color(0xFF606A85);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isTodayTab = label == 'Today';
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: isActive ? activeColor : inactiveColor,
              fontSize: 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isActive ? 60 : 0,
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeView() {
    final activeTodayCount = _todayClasses.where((c) => !(c['is_cancelled'] as bool)).length;
    final displayClassesCount = _isTodayTab ? activeTodayCount : _upcomingClasses.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    Widget homeContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Curved Sky Blue Header Container with vertical LinearGradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5AB4F5),
                Color(0xFF70C1FC),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.only(
            top: 60,
            bottom: 28,
            left: 24,
            right: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHamburgerMenu(context),
                  // Middle section: Tray Icon, 0, Flame emoji
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HeroIcon(
                        HeroIcons.inbox,
                        color: Colors.black,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '0',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '🔥',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  // Rewards Crystal Badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/Crystal_Animated_Icon_(1).gif',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.stars,
                          color: Colors.amber,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '[greetingMessageForUser]',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '[shortGreetingMessageForUser]',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.black.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              // Astronomy Banner: Semi-transparent dark capsule with black text and arrow
              GestureDetector(
                onTap: () => _showAstronomyDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "View Today's Astronomy Picture of the Day",
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const HeroIcon(
                        HeroIcons.arrowRight,
                        color: Colors.black,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Main card (ClassBlock) inside the curved gradient area
              const ClassBlock(
                category: '[Text Widget]',
                title: 'Mathematics III',
                subtitle: '[1] - [2]',
                footerText: '[Text Widget]',
                progress: 0,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

        // 3. Tab Switches Row
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 12),
          child: Row(
            children: [
              _buildTabButton('Today', _isTodayTab),
              const SizedBox(width: 48),
              _buildTabButton('Upcoming', !_isTodayTab),
            ],
          ),
        ),

        // Tab Divider
        const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

        // 4. Section Title Row + Refresh
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isTodayTab
                    ? "TODAY'S CLASSES ($displayClassesCount)"
                    : 'UPCOMING CLASSES ($displayClassesCount)',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF606A85),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              if (_isTodayTab)
                GestureDetector(
                  key: const Key('refresh_button'),
                  onTap: _handleRefresh,
                  child: Row(
                    children: [
                      Text(
                        'Refresh',
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6F61EF),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.refresh,
                        color: Color(0xFF6F61EF),
                        size: 18,
                      )
                          .animate(
                            target: _isRefreshing ? 1 : 0,
                          )
                          .rotate(
                            duration: 800.ms,
                            curve: Curves.easeInOut,
                          ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // 5. Scrollable list of class blocks
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: LayoutBuilder(
              key: ValueKey<bool>(_isTodayTab),
              builder: (context, constraints) {
                final itemWidth = isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;
                final listItems = (_isTodayTab ? _todayClasses : _upcomingClasses).map((c) {
                  Widget classCard;
                  if (_isTodayTab) {
                    classCard = ClassBlock_primary(
                      classId: c['class_id'] as String,
                      classRef: c['class_ref'] as String,
                      courseId: c['course_id'] as String,
                      batchId: c['batch_id'] as String,
                      semesterId: c['semester_id'] as String,
                      scheduledStart: c['scheduled_start'] as DateTime,
                      scheduledEnd: c['scheduled_end'] as DateTime,
                      venue: c['venue'] as String?,
                      isPlusSlot: c['is_plus_slot'] as bool,
                      labGroup: c['lab_group'] as String?,
                      isCancelled: c['is_cancelled'] as bool,
                      isMarked: c['is_marked'] as bool,
                      onAttendanceChanged: (val) {
                        setState(() {
                          c['is_marked'] = val;
                        });
                      },
                    );
                  } else {
                    classCard = ClassBlock_upcoming(
                      classId: c['class_id'] as String,
                      classRef: c['class_ref'] as String,
                      courseId: c['course_id'] as String,
                      batchId: c['batch_id'] as String,
                      semesterId: c['semester_id'] as String,
                      scheduledStart: c['scheduled_start'] as DateTime,
                      scheduledEnd: c['scheduled_end'] as DateTime,
                      venue: c['venue'] as String?,
                      isPlusSlot: c['is_plus_slot'] as bool,
                      labGroup: c['lab_group'] as String?,
                      isCancelled: c['is_cancelled'] as bool,
                    );
                  }

                  return SizedBox(
                    width: itemWidth,
                    child: classCard,
                  );
                }).toList();

                if (isWide) {
                  return Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: listItems,
                  );
                } else {
                  return Column(
                    children: listItems.map((child) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: child,
                    )).toList(),
                  );
                }
              },
            ),
          ),
        ),
        // Spacer at the bottom so the capsule navbar doesn't cover anything
        const SizedBox(height: 100),
      ],
    );

    if (isWide) {
      homeContent = Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: homeContent,
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: homeContent,
    );
  }

  Widget _buildPlaceholderView(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            title == 'Timetable'
                ? Icons.calendar_month
                : title == 'Analytics'
                    ? Icons.bar_chart
                    : Icons.person,
            size: 64,
            color: const Color(0xFF94A3B8),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF15161E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This is a premium $title section placeholder.',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF606A85),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: Drawer(
        backgroundColor: const Color(0xFFF8FAFC),
        child: Column(
          children: [
            // Custom modern drawer header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5AB4F5),
                    Color(0xFF70C1FC),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'S',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF5AB4F5),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shashank',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'shashank@attendrix.edu',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'STUDENT PORTAL',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Dashboard Drawer Item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: _activeBottomTab == 0 ? const Color(0xFFE2F1FD) : null,
                leading: HeroIcon(
                  HeroIcons.home,
                  color: _activeBottomTab == 0 ? const Color(0xFF6F61EF) : const Color(0xFF606A85),
                  style: _activeBottomTab == 0 ? HeroIconStyle.solid : HeroIconStyle.outline,
                ),
                title: Text(
                  'Dashboard',
                  style: GoogleFonts.outfit(
                    fontWeight: _activeBottomTab == 0 ? FontWeight.bold : FontWeight.w500,
                    color: _activeBottomTab == 0 ? const Color(0xFF6F61EF) : const Color(0xFF15161E),
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _activeBottomTab = 0;
                  });
                },
              ),
            ).animate().fadeIn(delay: 50.ms, duration: 250.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
            // Timetable Drawer Item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: _activeBottomTab == 1 ? const Color(0xFFE2F1FD) : null,
                leading: HeroIcon(
                  HeroIcons.calendar,
                  color: _activeBottomTab == 1 ? const Color(0xFF6F61EF) : const Color(0xFF606A85),
                  style: _activeBottomTab == 1 ? HeroIconStyle.solid : HeroIconStyle.outline,
                ),
                title: Text(
                  'Timetable',
                  style: GoogleFonts.outfit(
                    fontWeight: _activeBottomTab == 1 ? FontWeight.bold : FontWeight.w500,
                    color: _activeBottomTab == 1 ? const Color(0xFF6F61EF) : const Color(0xFF15161E),
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _activeBottomTab = 1;
                  });
                },
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 250.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
            // Analytics Drawer Item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: _activeBottomTab == 2 ? const Color(0xFFE2F1FD) : null,
                leading: HeroIcon(
                  HeroIcons.chartBar,
                  color: _activeBottomTab == 2 ? const Color(0xFF6F61EF) : const Color(0xFF606A85),
                  style: _activeBottomTab == 2 ? HeroIconStyle.solid : HeroIconStyle.outline,
                ),
                title: Text(
                  'Analytics',
                  style: GoogleFonts.outfit(
                    fontWeight: _activeBottomTab == 2 ? FontWeight.bold : FontWeight.w500,
                    color: _activeBottomTab == 2 ? const Color(0xFF6F61EF) : const Color(0xFF15161E),
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _activeBottomTab = 2;
                  });
                },
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 250.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
            // Profile Drawer Item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: _activeBottomTab == 3 ? const Color(0xFFE2F1FD) : null,
                leading: HeroIcon(
                  HeroIcons.user,
                  color: _activeBottomTab == 3 ? const Color(0xFF6F61EF) : const Color(0xFF606A85),
                  style: _activeBottomTab == 3 ? HeroIconStyle.solid : HeroIconStyle.outline,
                ),
                title: Text(
                  'Profile',
                  style: GoogleFonts.outfit(
                    fontWeight: _activeBottomTab == 3 ? FontWeight.bold : FontWeight.w500,
                    color: _activeBottomTab == 3 ? const Color(0xFF6F61EF) : const Color(0xFF15161E),
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _activeBottomTab = 3;
                  });
                },
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 250.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
            const Spacer(),
            const Divider(),
            // Logout Drawer Item
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const HeroIcon(
                  HeroIcons.arrowLeftOnRectangle,
                  color: Colors.red,
                ),
                title: Text(
                  'Logout',
                  style: GoogleFonts.outfit(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  unawaited(
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/',
                      (route) => false,
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 250.ms, duration: 250.ms).slideX(begin: -0.1, end: 0, curve: Curves.easeOut),
            const SizedBox(height: 16),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Content views
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_activeBottomTab),
                child: _activeBottomTab == 0
                    ? _buildHomeView()
                    : _activeBottomTab == 1
                        ? _buildPlaceholderView('Timetable')
                        : _activeBottomTab == 2
                            ? _buildPlaceholderView('Analytics')
                            : _buildPlaceholderView('Profile'),
              ),
            ),
          ),

          // Floating capsule Bottom Navbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavBar(
              currentIndex: _activeBottomTab,
              onTap: (index) {
                setState(() {
                  _activeBottomTab = index;
                });
              },
              items: const [
                FloatingNavBarItem(
                  icon: HeroIcons.home,
                  selectedIcon: HeroIcons.home,
                  label: 'Home',
                ),
                FloatingNavBarItem(
                  icon: HeroIcons.calendarDays,
                  selectedIcon: HeroIcons.calendarDays,
                  label: 'Schedule',
                ),
                FloatingNavBarItem(
                  icon: HeroIcons.chartBar,
                  selectedIcon: HeroIcons.chartBar,
                  label: 'Analytics',
                ),
                FloatingNavBarItem(
                  icon: HeroIcons.user,
                  selectedIcon: HeroIcons.user,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
