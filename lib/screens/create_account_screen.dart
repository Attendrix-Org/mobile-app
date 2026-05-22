import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});
  static const routeName = '/create-account';

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _passwordHasFocus = false;

  bool get _isPasswordValidLength => _passwordController.text.length >= 6;


  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(_onPasswordFocusChange);
    _passwordController.addListener(_onPasswordTextChange);
  }

  void _onPasswordFocusChange() {
    setState(() {
      _passwordHasFocus = _passwordFocusNode.hasFocus;
    });
  }

  void _onPasswordTextChange() {
    setState(() {}); // Rebuild to update password criteria indicator
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController
      ..removeListener(_onPasswordTextChange)
      ..dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode
      ..removeListener(_onPasswordFocusChange)
      ..dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      Timer(const Duration(milliseconds: 600), () {
        if (mounted) {
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Exact colors from DESIGN.md
    const primaryColor = Color(0xFF6F61EF);
    const primaryTextColor = Color(0xFF15161E);
    const secondaryTextColor = Color(0xFF606A85);
    const inputFillColor = Color(0xFFF1F4F8);

    // Google Logo SVG Path
    const googleLogoSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"/>
  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"/>
</svg>
''';

    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isWide ? const Color(0xFFF1F5F9) : Colors.white,
        body: SafeArea(
          top: !isWide, // Let the peach background run behind the status bar on mobile
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: isWide ? 480 : null,
                margin: isWide ? const EdgeInsets.symmetric(vertical: 40) : EdgeInsets.zero,
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
                  borderRadius: isWide ? BorderRadius.circular(24) : BorderRadius.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Top Illustration Area
                      AspectRatio(
                        aspectRatio: 393 / 315,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: isWide
                                    ? const BorderRadius.vertical(top: Radius.circular(24))
                                    : BorderRadius.zero,
                                child: Image.asset(
                                  'assets/login_screen_background.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -20, // Allow character with pen and laptop to sit correctly
                              child: Image.asset(
                                'assets/Young_Man_with_Laptop.png',
                                height: 240,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut).scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1),
                            curve: Curves.easeOutBack,
                          ),
              
              // 2. Form Content Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Create Your Account Heading
                      Text(
                        'Create Your Account',
                        style: GoogleFonts.outfit(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(
                            begin: 0.2,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 8),
                      // Sub-description
                      Text(
                        "Let's get started by filling out the form below.",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                          height: 1.4,
                        ),
                      ).animate().fadeIn(delay: 260.ms, duration: 400.ms).slideY(
                            begin: 0.2,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 24),
                      
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        autofocus: true,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        style: GoogleFonts.plusJakartaSans(
                          color: primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: secondaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: inputFillColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.mail_outline,
                              color: secondaryTextColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Enter email' : null,
                      ).animate().fadeIn(delay: 320.ms, duration: 400.ms).slideY(
                            begin: 0.15,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 16),
                      
                      // Password Field and Criteria Indicator
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            obscureText: _obscurePassword,
                            autofillHints: const [AutofillHints.newPassword],
                            textInputAction: TextInputAction.next,
                            style: GoogleFonts.plusJakartaSans(
                              color: primaryTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                color: secondaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              filled: true,
                              fillColor: inputFillColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              suffixIcon: IconButton(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return RotationTransition(
                                      turns: Tween<double>(begin: 0.75, end: 1)
                                          .animate(animation),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    key: ValueKey<bool>(_obscurePassword),
                                    color: secondaryTextColor,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (v) => (v == null || v.length < 6)
                                ? 'Password too short'
                                : null,
                          ),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: _passwordHasFocus
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _isPasswordValidLength
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                    ),
                                    child: Icon(
                                      _isPasswordValidLength
                                          ? Icons.check
                                          : Icons.close,
                                      size: 12,
                                      color: _isPasswordValidLength
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'At least 6 characters',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: _isPasswordValidLength
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                      fontWeight: _isPasswordValidLength
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            secondChild: const SizedBox.shrink(),
                          ),
                        ],
                      ).animate().fadeIn(delay: 380.ms, duration: 400.ms).slideY(
                            begin: 0.15,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 16),
 
                      // Confirm Password Field
                      TextFormField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        obscureText: _obscureConfirmPassword,
                        autofillHints: const [AutofillHints.newPassword],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        style: GoogleFonts.plusJakartaSans(
                          color: primaryTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: GoogleFonts.plusJakartaSans(
                            color: secondaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: inputFillColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          suffixIcon: IconButton(
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, animation) {
                                return RotationTransition(
                                  turns: Tween<double>(begin: 0.75, end: 1)
                                      .animate(animation),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                key: ValueKey<bool>(_obscureConfirmPassword),
                                color: secondaryTextColor,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Confirm password';
                          }
                          if (v != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 440.ms, duration: 400.ms).slideY(
                            begin: 0.15,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 24),
                      
                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: primaryColor.withValues(alpha: 0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
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
                                  'Create Account',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(
                            begin: 0.15,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 16),
                      
                      // Divider OR
                      Center(
                        child: Text(
                          '-- OR --',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: secondaryTextColor,
                          ),
                        ),
                      ).animate().fadeIn(delay: 560.ms, duration: 400.ms).slideY(
                            begin: 0.15,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 16),
                      
                      // Continue with Google Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Google Sign-In pressed')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryTextColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.string(
                                googleLogoSvg,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Continue with Google',
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 620.ms, duration: 400.ms).slideY(
                            begin: 0.15,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                      const SizedBox(height: 24),
                      
                      // Sign In link
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primaryTextColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Sign In here',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 680.ms, duration: 400.ms).slideY(
                            begin: 0.15,
                            end: 0,
                            curve: Curves.easeOutQuad,
                          ),
                    ],
                  ),
                ),
              ),
                    ],
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
