import 'package:attendrix_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget() {
    return const MyApp();
  }

  TextField getTextField(WidgetTester tester, Finder textFormFieldFinder) {
    return tester.widget<TextField>(
      find.descendant(
        of: textFormFieldFinder,
        matching: find.byType(TextField),
      ),
    );
  }

  group('LoginScreen Tests', () {
    testWidgets('Initial State - renders headings, fields, buttons and focuses email', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Check title and description
      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(
        find.text("Log in and pick up right where you left off. We've been saving your seat."),
        findsOneWidget,
      );

      // Check fields
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

      // Check buttons
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Continue with Google'), findsOneWidget);

      // Verify email field is autofocused
      final emailField = getTextField(tester, find.widgetWithText(TextFormField, 'Email'));
      expect(emailField.focusNode?.hasFocus, isTrue);
    });

    testWidgets('Form Validation - shows errors on invalid inputs', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Ensure login button is visible and tap it
      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      // Verify validation errors are shown
      expect(find.text('Enter email'), findsOneWidget);
      expect(find.text('Password too short'), findsOneWidget);

      // Fill in invalid email but short password
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '123');
      
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      // Email error should disappear, password error should remain
      expect(find.text('Enter email'), findsNothing);
      expect(find.text('Password too short'), findsOneWidget);
    });

    testWidgets('Interactive State - toggles password visibility', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      final passwordFinder = find.widgetWithText(TextFormField, 'Password');
      final obscureTextInitial = getTextField(tester, passwordFinder).obscureText;
      expect(obscureTextInitial, isTrue);

      // Find the toggle button (it's the suffix icon of the password field)
      final visibilityIcon = find.byIcon(Icons.visibility_off_outlined);
      expect(visibilityIcon, findsOneWidget);

      await tester.ensureVisible(visibilityIcon);
      await tester.tap(visibilityIcon);
      await tester.pumpAndSettle();

      final obscureTextToggled = getTextField(tester, passwordFinder).obscureText;
      expect(obscureTextToggled, isFalse);

      // Now icon should be visibility_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('Form Submission - redirects to dashboard on success', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Enter valid email and password
      await tester.enterText(find.widgetWithText(TextFormField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');

      // Tap login
      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.ensureVisible(loginBtn);
      await tester.tap(loginBtn);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      // Verify dashboard is shown
      expect(find.text('[greetingMessageForUser]'), findsOneWidget);
    });
  });
}
