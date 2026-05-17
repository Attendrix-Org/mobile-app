import 'package:attendrix_app/screens/dashboard_screen.dart';
import 'package:attendrix_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData();

    // Build text themes using Google Fonts: Outfit as primary, Plus Jakarta Sans
    // for headline/body slots. Note: explicit font-family-fallbacks are
    // platform/SDK-dependent; Google Fonts will fall back to system fonts if
    // the remote font can't be fetched.
    final outfitText = GoogleFonts.outfitTextTheme(base.textTheme);
    final outfitPrimaryText = GoogleFonts.outfitTextTheme(
      base.primaryTextTheme,
    );

    final textTheme = outfitText.copyWith(
      headlineLarge: GoogleFonts.plusJakartaSans(
        textStyle: outfitText.headlineLarge,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        textStyle: outfitText.titleMedium,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(textStyle: outfitText.titleSmall),
      bodyLarge: GoogleFonts.plusJakartaSans(textStyle: outfitText.bodyLarge),
      bodyMedium: GoogleFonts.plusJakartaSans(textStyle: outfitText.bodyMedium),
      bodySmall: GoogleFonts.plusJakartaSans(textStyle: outfitText.bodySmall),
    );

    return MaterialApp(
      title: 'Attendrix',
      theme: base.copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: textTheme,
        primaryTextTheme: outfitPrimaryText,
        appBarTheme: base.appBarTheme.copyWith(
          titleTextStyle: GoogleFonts.outfit(
            textStyle:
                base.textTheme.titleLarge?.copyWith(color: Colors.white) ??
                const TextStyle(color: Colors.white),
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
