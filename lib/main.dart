import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData();

    // Build text themes using Google Fonts: Outfit as primary, Plus Jakarta Sans
    // for headline/body slots. Provide common fallbacks for offline cases.
    final outfitText = GoogleFonts.outfitTextTheme(base.textTheme);
    final outfitPrimaryText = GoogleFonts.outfitTextTheme(base.primaryTextTheme);
    const fallbacks = <String>['Roboto', 'Helvetica Neue', 'Arial'];

    final textTheme = outfitText.copyWith(
      headlineLarge: GoogleFonts.plusJakartaSans(
        textStyle: outfitText.headlineLarge,
        fontFamilyFallback: fallbacks,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        textStyle: outfitText.headlineMedium,
        fontFamilyFallback: fallbacks,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        textStyle: outfitText.headlineSmall,
        fontFamilyFallback: fallbacks,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        textStyle: outfitText.bodyLarge,
        fontFamilyFallback: fallbacks,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        textStyle: outfitText.bodyMedium,
        fontFamilyFallback: fallbacks,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        textStyle: outfitText.bodySmall,
        fontFamilyFallback: fallbacks,
      ),
    );

    return MaterialApp(
      title: 'Attendrix',
      theme: base.copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: textTheme,
        primaryTextTheme: outfitPrimaryText,
        appBarTheme: base.appBarTheme.copyWith(
          titleTextStyle: GoogleFonts.outfit(
            textStyle: base.textTheme.titleLarge?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white),
          ),
        ),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        DashboardScreen.routeName: (context) => const DashboardScreen(),
      },
    );
  }
}
