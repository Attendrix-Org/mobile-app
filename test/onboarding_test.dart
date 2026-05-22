import 'package:attendrix_app/screens/onboarding/profile_setup_screen.dart';
import 'package:attendrix_app/screens/onboarding/username_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      routes: {
        '/onboarding/username': (context) => const UsernameScreen(),
        '/onboarding/profile': (context) => const ProfileSetupScreen(),
        '/dashboard': (context) => const Scaffold(body: Text('Dashboard Screen')),
      },
      home: child,
    );
  }

  group('UsernameScreen Tests', () {
    testWidgets('Initial State - renders illustrations, headings, input, and continue button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UsernameScreen()));
      await tester.pumpAndSettle();

      // Heading and Subtitle
      expect(find.text('Choose Your Username'), findsOneWidget);
      expect(
        find.text(
          "This will be your identity on Attendrix. We've suggest you to make something cool—feel free to edit it!",
        ),
        findsOneWidget,
      );

      // Input field
      expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);

      // Magic wand button
      expect(find.byIcon(Icons.auto_fix_high), findsOneWidget);

      // Continue button
      expect(find.widgetWithText(ElevatedButton, 'Continue →'), findsOneWidget);
    });

    testWidgets('Validation - shows snackbar if username is less than 3 characters', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UsernameScreen()));
      await tester.pumpAndSettle();

      final usernameField = find.widgetWithText(TextFormField, 'Username');
      await tester.enterText(usernameField, 'ab');
      await tester.pumpAndSettle();

      final continueBtn = find.widgetWithText(ElevatedButton, 'Continue →');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Verify SnackBar shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Username must be at least 3 characters'), findsOneWidget);
    });

    testWidgets('Uniqueness Check - entered username shashank shows taken message', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UsernameScreen()));
      await tester.pumpAndSettle();

      final usernameField = find.widgetWithText(TextFormField, 'Username');
      await tester.enterText(usernameField, 'shashank');
      await tester.pumpAndSettle();

      final continueBtn = find.widgetWithText(ElevatedButton, 'Continue →');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      
      // Wait for delayed validation (300ms)
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Verify username taken error message is shown
      expect(find.text('sorry, username already taken 🚨'), findsOneWidget);
    });

    testWidgets('Magic Wand - auto generates username on click', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UsernameScreen()));
      await tester.pumpAndSettle();

      final magicWandBtn = find.byIcon(Icons.auto_fix_high);
      await tester.tap(magicWandBtn);
      await tester.pumpAndSettle();

      // Get username text form field value
      final textFormField = tester.widget<TextFormField>(find.byType(TextFormField));
      final usernameValue = textFormField.controller?.text ?? '';
      
      expect(usernameValue, isNotEmpty);
      expect(usernameValue.length, greaterThanOrEqualTo(3));
    });

    testWidgets('Submission - valid username navigates to profile screen', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UsernameScreen()));
      await tester.pumpAndSettle();

      final usernameField = find.widgetWithText(TextFormField, 'Username');
      await tester.enterText(usernameField, 'cool_coder');
      await tester.pumpAndSettle();

      final continueBtn = find.widgetWithText(ElevatedButton, 'Continue →');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);

      // Wait for delayed validation (300ms)
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Should now be on Profile Setup Screen
      expect(find.text("Let's Set Up Your Academic Profile"), findsOneWidget);
    });

    testWidgets('Responsive check - renders wide layout if width > 600', (tester) async {
      // Set screen size to wide
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(buildTestWidget(const UsernameScreen()));
      await tester.pumpAndSettle();

      // Find the card container
      final cardFinder = find.byType(Container);
      // Verify wide screen container width is applied in layout (there will be a Container with width 480)
      final wideContainer = tester.widgetList<Container>(cardFinder).firstWhere(
        (c) => c.constraints?.maxWidth == 480,
        orElse: () => throw Exception('Wide container not found'),
      );
      expect(wideContainer, isNotNull);

      // Reset view size
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });

  group('ProfileSetupScreen Tests', () {
    testWidgets('Initial State - renders academic fields, checkboxes, progress bar and button', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(const ProfileSetupScreen()));
      await tester.pumpAndSettle();

      // Header and progress bar capsules (4 progress capsules)
      expect(find.text("Let's Set Up Your Academic Profile"), findsOneWidget);
      
      // Fields & dropdowns
      expect(find.widgetWithText(TextFormField, '[Display Name]'), findsOneWidget);
      expect(find.text('Semester'), findsOneWidget);
      expect(find.text('Branch'), findsOneWidget);
      expect(find.text('Batch'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Introduce yourself in a few words.'), findsOneWidget);

      // Checkbox for terms
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains('I confirm that I have read and agree to the'),
        ),
        findsOneWidget,
      );
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);

      // Optional promotional checkbox
      expect(
        find.text('Get promotional content and updates about Attendrix via email. (Optional)'),
        findsOneWidget,
      );

      // Continue button
      expect(find.widgetWithText(ElevatedButton, 'Continue'), findsOneWidget);
    });

    testWidgets('Validation - fails when inputs are empty or terms not agreed', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(const ProfileSetupScreen()));
      await tester.pumpAndSettle();

      final continueBtn = find.widgetWithText(ElevatedButton, 'Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Form should validate and fail on display name
      expect(find.text('Please enter your name'), findsOneWidget);

      // Enter name
      await tester.enterText(find.widgetWithText(TextFormField, '[Display Name]'), 'Alice');
      await tester.pumpAndSettle();

      // Fill dropdowns so that form validation succeeds
      // Select Semester
      final semesterDropdown = find.text('Semester');
      await tester.ensureVisible(semesterDropdown);
      await tester.tap(semesterDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Semester 1').last);
      await tester.pumpAndSettle();

      // Select Branch
      final branchDropdown = find.text('Branch');
      await tester.ensureVisible(branchDropdown);
      await tester.tap(branchDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Computer Science').last);
      await tester.pumpAndSettle();

      // Select Batch
      final batchDropdown = find.text('Batch');
      await tester.ensureVisible(batchDropdown);
      await tester.tap(batchDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batch 2026').last);
      await tester.pumpAndSettle();

      // Try submitting again (terms not agreed yet)
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Fails on terms agreement snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please agree to the Terms of Service to continue.'), findsOneWidget);
    });

    testWidgets('Validation - dropdowns are mandatory', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(const ProfileSetupScreen()));
      await tester.pumpAndSettle();

      // Fill name
      await tester.enterText(find.widgetWithText(TextFormField, '[Display Name]'), 'Alice');
      // Agree to terms
      final termsCheckbox = find.byType(Checkbox).first;
      await tester.ensureVisible(termsCheckbox);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();

      final continueBtn = find.widgetWithText(ElevatedButton, 'Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      // Dropdown validator messages should trigger
      expect(find.text('Please select a semester'), findsOneWidget);
      expect(find.text('Please select a branch'), findsOneWidget);
      expect(find.text('Please select a batch'), findsOneWidget);
    });

    testWidgets('Complete Form - navigates to dashboard on success', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(buildTestWidget(const ProfileSetupScreen()));
      await tester.pumpAndSettle();

      // Fill display name
      await tester.enterText(find.widgetWithText(TextFormField, '[Display Name]'), 'Alice Smith');
      
      // Select Semester (tap dropdown, then select value)
      final semesterDropdown = find.text('Semester');
      await tester.ensureVisible(semesterDropdown);
      await tester.tap(semesterDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Semester 1').last);
      await tester.pumpAndSettle();

      // Select Branch
      final branchDropdown = find.text('Branch');
      await tester.ensureVisible(branchDropdown);
      await tester.tap(branchDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Computer Science').last);
      await tester.pumpAndSettle();

      // Select Batch
      final batchDropdown = find.text('Batch');
      await tester.ensureVisible(batchDropdown);
      await tester.tap(batchDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batch 2026').last);
      await tester.pumpAndSettle();

      // Enter optional bio
      final bioField = find.widgetWithText(TextFormField, 'Introduce yourself in a few words.');
      await tester.ensureVisible(bioField);
      await tester.enterText(bioField, 'Hello World!');

      // Agree to terms
      final termsCheckbox = find.byType(Checkbox).first;
      await tester.ensureVisible(termsCheckbox);
      await tester.tap(termsCheckbox);
      await tester.pumpAndSettle();

      // Submit
      final continueBtn = find.widgetWithText(ElevatedButton, 'Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      
      // Wait for delayed validation (600ms)
      await tester.pump(const Duration(milliseconds: 650));
      await tester.pumpAndSettle();

      // Should be redirected to Dashboard Screen
      expect(find.text('Dashboard Screen'), findsOneWidget);
    });

    testWidgets('Responsive check - renders wide layout if width > 600', (tester) async {
      // Set screen size to wide
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(buildTestWidget(const ProfileSetupScreen()));
      await tester.pumpAndSettle();

      // Find the card container
      final cardFinder = find.byType(Container);
      // Verify wide screen container width is applied in layout (there will be a Container with width 480)
      final wideContainer = tester.widgetList<Container>(cardFinder).firstWhere(
        (c) => c.constraints?.maxWidth == 480,
        orElse: () => throw Exception('Wide container not found'),
      );
      expect(wideContainer, isNotNull);

      // Reset view size
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
