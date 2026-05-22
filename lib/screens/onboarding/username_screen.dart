import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  static const routeName = '/onboarding/username';

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _usernameController = TextEditingController();
  bool _usernameTaken = false;
  bool _isLoading = false;

  final List<String> _adjectives = [
    'cosmic',
    'stellar',
    'lunar',
    'cyber',
    'quantum',
    'neon',
    'atomic',
    'sonic',
    'turbo',
    'spectral',
  ];

  final List<String> _nouns = [
    'wanderer',
    'coder',
    'pixel',
    'hacker',
    'ninja',
    'explorer',
    'navigator',
    'maker',
    'wizard',
    'spark',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _generateUsername() {
    final random = Random();
    final adj = _adjectives[random.nextInt(_adjectives.length)];
    final noun = _nouns[random.nextInt(_nouns.length)];
    _usernameController.text = '$adj$noun';
    setState(() {
      _usernameTaken = false;
    });
  }

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    if (username.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username must be at least 3 characters'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _usernameTaken = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    if (username.toLowerCase() == 'shashank') {
      setState(() {
        _isLoading = false;
        _usernameTaken = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      unawaited(Navigator.of(context).pushNamed('/onboarding/profile'));
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6F61EF);
    const primaryTextColor = Color(0xFF15161E);
    const secondaryTextColor = Color(0xFF606A85);

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isWide ? const Color(0xFFF1F5F9) : null,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: isWide
              ? null
              : const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE8DEF8),
                      Color(0xFFEDE7F6),
                    ],
                  ),
                ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: isWide ? 480 : null,
                  margin: isWide
                      ? const EdgeInsets.symmetric(vertical: 40, horizontal: 20)
                      : EdgeInsets.zero,
                  decoration: isWide
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        )
                      : null,
                  child: ClipRRect(
                    borderRadius: isWide
                        ? BorderRadius.circular(24)
                        : BorderRadius.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Centered Illustration
                          Center(
                            child: Image.asset(
                              'assets/onboarding_cat_laptop.png',
                              height: 220,
                              fit: BoxFit.contain,
                            ),
                          ).animate().fadeIn(duration: 600.ms).scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1, 1),
                                curve: Curves.easeOutBack,
                              ),
                          const SizedBox(height: 32),

                          // 2. Heading + Subtitle
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Choose Your Username',
                                style: GoogleFonts.outfit(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "This will be your identity on Attendrix. We've suggest you to make "
                                'something cool—feel free to edit it!',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryTextColor,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(
                                begin: 0.2,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                          const SizedBox(height: 24),

                          // 3. Input Row
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _usernameController,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (_) => _submit(),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: primaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Username',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      color: secondaryTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(
                                        color: primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: _generateUsername,
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.auto_fix_high,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 320.ms, duration: 400.ms).slideY(
                                begin: 0.15,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),

                          // Error message
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _usernameTaken
                                ? Container(
                                    key: const ValueKey('error'),
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'sorry, username already taken 🚨',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFFD32F2F),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  )
                                : const SizedBox(key: ValueKey('empty')),
                          ),

                          const SizedBox(height: 32),

                          // 4. Continue button
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 160,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      primaryColor.withValues(alpha: 0.6),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        'Continue →',
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 440.ms, duration: 400.ms),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
