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

  group('CreateAccountScreen Tests', () {
    testWidgets(
      'Initial State - renders headings, fields, buttons and focuses email',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Navigate to Create Account screen
        final signUpLink = find.text('Sign Up Here');
        expect(signUpLink, findsOneWidget);
        await tester.ensureVisible(signUpLink);
        await tester.tap(signUpLink);
        await tester.pumpAndSettle();

        // Verify page headings
        expect(find.text('Create Your Account'), findsOneWidget);
        expect(
          find.text("Let's get started by filling out the form below."),
          findsOneWidget,
        );

        // Verify fields exist
        expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
        expect(
          find.widgetWithText(TextFormField, 'Confirm Password'),
          findsOneWidget,
        );

        // Verify email autofocused (since autofocus: true is set on the email field)
        final emailField = getTextField(
          tester,
          find.widgetWithText(TextFormField, 'Email'),
        );
        expect(emailField.focusNode?.hasFocus, isTrue);

        // Password helper should be in showSecond state (hidden)
        final crossFade = tester.widget<AnimatedCrossFade>(
          find.byType(AnimatedCrossFade),
        );
        expect(crossFade.crossFadeState, CrossFadeState.showSecond);
      },
    );

    testWidgets(
      'Password Criteria Helper - appears on focus and updates in real-time',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Navigate to Create Account screen
        final signUpLink = find.text('Sign Up Here');
        await tester.ensureVisible(signUpLink);
        await tester.tap(signUpLink);
        await tester.pumpAndSettle();

        // Tap on Password field to give it focus
        final passwordFinder = find.widgetWithText(TextFormField, 'Password');
        await tester.ensureVisible(passwordFinder);
        await tester.tap(passwordFinder);
        await tester.pumpAndSettle();

        // The password helper should now be in showFirst state (visible)
        final crossFade = tester.widget<AnimatedCrossFade>(
          find.byType(AnimatedCrossFade),
        );
        expect(crossFade.crossFadeState, CrossFadeState.showFirst);

        // Enter a short password
        await tester.enterText(passwordFinder, '123');
        await tester.pumpAndSettle();

        // Still should be visible
        final crossFadeShort = tester.widget<AnimatedCrossFade>(
          find.byType(AnimatedCrossFade),
        );
        expect(crossFadeShort.crossFadeState, CrossFadeState.showFirst);

        // Enter a valid password (6+ chars)
        await tester.enterText(passwordFinder, '123456');
        await tester.pumpAndSettle();

        // Helper should still be visible because Password field still has focus
        final crossFadeLong = tester.widget<AnimatedCrossFade>(
          find.byType(AnimatedCrossFade),
        );
        expect(crossFadeLong.crossFadeState, CrossFadeState.showFirst);

        // Let's unfocus the password field by tapping confirm password
        final confirmPasswordFinder = find.widgetWithText(
          TextFormField,
          'Confirm Password',
        );
        await tester.ensureVisible(confirmPasswordFinder);
        await tester.tap(confirmPasswordFinder);
        await tester.pumpAndSettle();

        // Helper should be back to showSecond state (hidden)
        final crossFadeAfter = tester.widget<AnimatedCrossFade>(
          find.byType(AnimatedCrossFade),
        );
        expect(crossFadeAfter.crossFadeState, CrossFadeState.showSecond);
      },
    );

    testWidgets(
      'Form Validation - validation errors, mismatches, and submissions',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Navigate to Create Account screen
        final signUpLink = find.text('Sign Up Here');
        await tester.ensureVisible(signUpLink);
        await tester.tap(signUpLink);
        await tester.pumpAndSettle();

        final createAccountBtn = find.widgetWithText(
          ElevatedButton,
          'Create Account',
        );

        // Tap Create Account without any input
        await tester.ensureVisible(createAccountBtn);
        await tester.tap(createAccountBtn);
        await tester.pumpAndSettle();

        expect(find.text('Enter email'), findsOneWidget);
        expect(find.text('Password too short'), findsOneWidget);
        expect(find.text('Confirm password'), findsOneWidget);

        // Input valid email, but invalid password
        final emailFinder = find.widgetWithText(TextFormField, 'Email');
        final passwordFinder = find.widgetWithText(TextFormField, 'Password');
        final confirmPasswordFinder = find.widgetWithText(
          TextFormField,
          'Confirm Password',
        );

        await tester.enterText(emailFinder, 'newuser@example.com');
        await tester.enterText(passwordFinder, '123');
        await tester.enterText(confirmPasswordFinder, '123');
        await tester.ensureVisible(createAccountBtn);
        await tester.tap(createAccountBtn);
        await tester.pumpAndSettle();

        expect(find.text('Enter email'), findsNothing);
        expect(find.text('Password too short'), findsOneWidget);
        expect(find.text('Confirm password'), findsNothing);

        // Input mismatching passwords
        await tester.enterText(passwordFinder, 'password123');
        await tester.enterText(confirmPasswordFinder, 'password321');
        await tester.ensureVisible(createAccountBtn);
        await tester.tap(createAccountBtn);
        await tester.pumpAndSettle();

        expect(find.text('Password too short'), findsNothing);
        expect(find.text('Passwords do not match'), findsOneWidget);

        // Input matching passwords and submit
        await tester.enterText(confirmPasswordFinder, 'password123');
        await tester.ensureVisible(createAccountBtn);
        await tester.tap(createAccountBtn);
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pumpAndSettle();

        // Should redirect to onboarding username screen
        expect(find.text('Choose Your Username'), findsOneWidget);
      },
    );

    testWidgets(
      'Interactive State - toggles password and confirm password visibility',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Navigate to Create Account screen
        final signUpLink = find.text('Sign Up Here');
        await tester.ensureVisible(signUpLink);
        await tester.tap(signUpLink);
        await tester.pumpAndSettle();

        final passwordFinder = find.widgetWithText(TextFormField, 'Password');
        final confirmPasswordFinder = find.widgetWithText(
          TextFormField,
          'Confirm Password',
        );

        // Both should start obscured
        expect(getTextField(tester, passwordFinder).obscureText, isTrue);
        expect(getTextField(tester, confirmPasswordFinder).obscureText, isTrue);

        // Find eye visibility off buttons (there should be two)
        final eyeButtons = find.byIcon(Icons.visibility_off_outlined);
        expect(eyeButtons, findsNWidgets(2));

        // Toggle first password field
        await tester.ensureVisible(eyeButtons.first);
        await tester.tap(eyeButtons.first);
        await tester.pumpAndSettle();

        expect(getTextField(tester, passwordFinder).obscureText, isFalse);
        expect(getTextField(tester, confirmPasswordFinder).obscureText, isTrue);

        // Toggle confirm password field (the remaining eye off button is now the second one)
        // Since first was toggled, its icon changed to visibility_outlined, so there is only one visibility_off_outlined now
        final remainingEyeButton = find.byIcon(Icons.visibility_off_outlined);
        expect(remainingEyeButton, findsOneWidget);

        await tester.ensureVisible(remainingEyeButton);
        await tester.tap(remainingEyeButton);
        await tester.pumpAndSettle();

        expect(getTextField(tester, passwordFinder).obscureText, isFalse);
        expect(
          getTextField(tester, confirmPasswordFinder).obscureText,
          isFalse,
        );
      },
    );
  });
}
