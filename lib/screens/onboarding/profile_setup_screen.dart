import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  static const routeName = '/onboarding/profile';

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();

  int? _selectedSemester;
  String? _selectedBranch;
  int? _selectedBatch;
  bool _agreedToTerms = false;
  bool _agreedToMarketing = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service to continue.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedSemester == null ||
        _selectedBranch == null ||
        _selectedBatch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    unawaited(
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/dashboard',
        (route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6F61EF);
    const primaryTextColor = Color(0xFF15161E);
    const secondaryTextColor = Color(0xFF606A85);
    const inputFillColor = Color(0xFFF1F4F8);

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isWide ? const Color(0xFFF1F5F9) : Colors.white,
        body: SafeArea(
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Progress Bar Row
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1CBF9),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1CBF9),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 400.ms),
                          const SizedBox(height: 32),

                          // 2. Heading + Subtitle
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Let's Set Up Your Academic Profile",
                                style: GoogleFonts.outfit(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: primaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tell us your name, branch, batch & semester to '
                                "personalize your experience, you're almost there!",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: secondaryTextColor,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 400.ms),
                          const SizedBox(height: 28),

                          // 3. What should we call you?
                          Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'What should we call you?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _displayNameController,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: primaryTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '[Display Name]',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        color: secondaryTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      filled: true,
                                      fillColor: inputFillColor,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (value) =>
                                        (value == null || value.trim().isEmpty)
                                        ? 'Please enter your name'
                                        : null,
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 100.ms, duration: 400.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                          const SizedBox(height: 20),

                          // 4. What's your current semester?
                          Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "What's your current semester?",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    initialValue: _selectedSemester,
                                    hint: Text(
                                      'Semester',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: secondaryTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    items: List.generate(8, (i) => i + 1).map((
                                      i,
                                    ) {
                                      return DropdownMenuItem<int>(
                                        value: i,
                                        child: Text(
                                          'Semester $i',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: primaryTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedSemester = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: inputFillColor,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (val) => val == null
                                        ? 'Please select a semester'
                                        : null,
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 180.ms, duration: 400.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                          const SizedBox(height: 20),

                          // 5. Which branch are you in?
                          Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Which branch are you in?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    initialValue: _selectedBranch,
                                    hint: Text(
                                      'Branch',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: secondaryTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    items:
                                        [
                                          'Computer Science',
                                          'Mechanical Engineering',
                                          'Electrical Engineering',
                                          'Civil Engineering',
                                          'Electronics & Communication',
                                          'Chemical Engineering',
                                          'Information Technology',
                                          'Other',
                                        ].map((branch) {
                                          return DropdownMenuItem<String>(
                                            value: branch,
                                            child: Text(
                                              branch,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: primaryTextColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          );
                                        }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedBranch = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: inputFillColor,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (val) => val == null
                                        ? 'Please select a branch'
                                        : null,
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 260.ms, duration: 400.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                          const SizedBox(height: 20),

                          // 6. Which batch do you belong to?
                          Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Which batch do you belong to?',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    initialValue: _selectedBatch,
                                    hint: Text(
                                      'Batch',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: secondaryTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    items: List.generate(7, (i) => 2022 + i)
                                        .map((year) {
                                          return DropdownMenuItem<int>(
                                            value: year,
                                            child: Text(
                                              'Batch $year',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: primaryTextColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          );
                                        })
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedBatch = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: inputFillColor,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    validator: (val) => val == null
                                        ? 'Please select a batch'
                                        : null,
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 340.ms, duration: 400.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                          const SizedBox(height: 20),

                          // 7. Tell us about yourself: (Optional)
                          Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tell us about yourself: (Optional)',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: primaryTextColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _bioController,
                                    maxLines: 4,
                                    maxLength: 200,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: primaryTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Introduce yourself in a few words.',
                                      hintStyle: GoogleFonts.plusJakartaSans(
                                        color: secondaryTextColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      filled: true,
                                      fillColor: inputFillColor,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 420.ms, duration: 400.ms)
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                          const SizedBox(height: 24),

                          // Checkboxes
                          Column(
                            children: [
                              // Required Terms Checkbox
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _agreedToTerms,
                                    activeColor: primaryColor,
                                    onChanged: (val) {
                                      setState(() {
                                        _agreedToTerms = val ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.plusJakartaSans(
                                            color: secondaryTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text:
                                                  'I confirm that I have read and agree to the ',
                                            ),
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: GestureDetector(
                                                onTap: () {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Terms of Service clicked',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Terms of Service',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        color: const Color(
                                                          0xFFFF8C00,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            const TextSpan(text: ' and '),
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.middle,
                                              child: GestureDetector(
                                                onTap: () {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Privacy Policy clicked',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Privacy Policy',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        color: const Color(
                                                          0xFFFF8C00,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            const TextSpan(
                                              text: ' of Attendrix Inc.',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Optional Marketing Checkbox
                              CheckboxListTile(
                                value: _agreedToMarketing,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: primaryColor,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  'Get promotional content and updates about '
                                  'Attendrix via email. (Optional)',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: secondaryTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _agreedToMarketing = val ?? false;
                                  });
                                },
                              ),
                            ],
                          ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                          const SizedBox(height: 28),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: primaryColor
                                    .withValues(alpha: 0.6),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Text(
                                      'Continue',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ).animate().fadeIn(delay: 580.ms, duration: 400.ms),
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
