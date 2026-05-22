import 'package:attendrix_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the login screen on startup', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('can navigate between login and create account screens', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Verify initially on Login Screen
    expect(find.text('Welcome Back!'), findsOneWidget);

    // Find, ensure visible, and tap on 'Sign Up Here'
    final signUpLink = find.text('Sign Up Here');
    expect(signUpLink, findsOneWidget);
    await tester.ensureVisible(signUpLink);
    await tester.tap(signUpLink);
    await tester.pumpAndSettle();

    // Verify we are now on Create Account Screen
    expect(find.text('Create Your Account'), findsOneWidget);
    expect(
      find.byType(TextFormField),
      findsNWidgets(3),
    ); // Email, Password, Confirm Password
    expect(find.text('Create Account'), findsOneWidget);

    // Find, ensure visible, and tap on 'Sign In here' to navigate back to Login
    final signInLink = find.text('Sign In here');
    expect(signInLink, findsOneWidget);
    await tester.ensureVisible(signInLink);
    await tester.tap(signInLink);
    await tester.pumpAndSettle();

    // Verify we are back on the Login screen
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}
