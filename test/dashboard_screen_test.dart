import 'package:attendrix_app/screens/dashboard_screen.dart';
import 'package:attendrix_app/widgets/class_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget() {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) =>
            const Scaffold(body: Text('Login Screen')),
        DashboardScreen.routeName: (BuildContext context) =>
            const DashboardScreen(),
        '/apod-detail': (BuildContext context) =>
            const Scaffold(body: Text('Apod Detail Page')),
      },
      initialRoute: DashboardScreen.routeName,
    );
  }

  group('DashboardScreen Tests', () {
    testWidgets('Streak count - renders streak counter with correct value', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify streak count container exists and displays '0' and '🔥'
      expect(find.text('0'), findsOneWidget);
      expect(find.text('🔥'), findsOneWidget);
    });

    testWidgets(
      'Crystal rewards - renders the rewards gif or fallback star icon',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Find the Image widget or the fallback star icon
        final gifFinder = find.byType(Image);
        final fallbackIconFinder = find.byIcon(Icons.stars);

        expect(
          gifFinder.evaluate().isNotEmpty ||
              fallbackIconFinder.evaluate().isNotEmpty,
          isTrue,
        );
      },
    );

    testWidgets('Astronomy banner - renders banner and reacts to tap', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Find astronomy banner text
      final bannerTextFinder = find.text(
        "View Today's Astronomy Picture of the Day",
      );
      expect(bannerTextFinder, findsOneWidget);

      // Tap the banner
      await tester.tap(bannerTextFinder);
      await tester.pumpAndSettle();

      // Verify Dialog is shown
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Stellar Crystal Nebula'), findsOneWidget);
      expect(find.text('Explore More'), findsOneWidget);

      // Close the Dialog
      final closeButtonFinder = find.widgetWithText(
        ElevatedButton,
        'Explore More',
      );
      await tester.ensureVisible(closeButtonFinder);
      await tester.tap(closeButtonFinder);
      await tester.pumpAndSettle();

      // Verify Dialog is closed
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('Drawer trigger - opens drawer and handles links/logout', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify drawer is closed initially
      expect(find.text('shashank@attendrix.edu'), findsNothing);

      // Tap hamburger menu button
      final hamburgerBtn = find.byKey(const Key('hamburger_menu_btn'));
      expect(hamburgerBtn, findsOneWidget);
      await tester.tap(hamburgerBtn);
      await tester.pumpAndSettle();

      // Verify drawer is now open
      expect(find.text('shashank@attendrix.edu'), findsOneWidget);
      expect(find.text('Shashank'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Timetable'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);

      // Tap logout
      final logoutTile = find.widgetWithText(ListTile, 'Logout');
      expect(logoutTile, findsOneWidget);
      await tester.tap(logoutTile);
      await tester.pumpAndSettle();

      // Verify we are redirected to Login Screen (which has text 'Login Screen')
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('Today/upcoming tabs switcher - switches tabs correctly', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Initially on 'Today' tab
      expect(find.text("TODAY'S CLASSES (2)"), findsOneWidget);
      expect(
        find.byType(ClassBlock_primary),
        findsNWidgets(3),
      ); // 3 today's classes
      expect(find.byType(ClassBlock_upcoming), findsNothing);

      // Tap 'Upcoming' tab button
      final upcomingTabButton = find.text('Upcoming');
      expect(upcomingTabButton, findsOneWidget);
      await tester.ensureVisible(upcomingTabButton);
      await tester.tap(upcomingTabButton);
      await tester.pumpAndSettle();

      // Now on 'Upcoming' tab
      expect(find.text('UPCOMING CLASSES (3)'), findsOneWidget);
      expect(find.byType(ClassBlock_upcoming), findsNWidgets(3));
      expect(find.byType(ClassBlock_primary), findsNothing);

      // Tap 'Today' tab button to switch back
      final todayTabButton = find.text('Today');
      expect(todayTabButton, findsOneWidget);
      await tester.ensureVisible(todayTabButton);
      await tester.tap(todayTabButton);
      await tester.pumpAndSettle();

      // Switched back to 'Today'
      expect(find.text("TODAY'S CLASSES (2)"), findsOneWidget);
      expect(find.byType(ClassBlock_primary), findsNWidgets(3));
    });

    testWidgets(
      'Attendance checkmark toggle - toggles marked status on active today classes',
      (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        final primaryBlocks = tester.widgetList<ClassBlock_primary>(
          find.byType(ClassBlock_primary),
        );
        for (final block in primaryBlocks) {
          print('FOUND ClassBlock_primary with courseId: "${block.courseId}"');
        }

        // First class (Mathematics III) is c1, initially isMarked is false
        final firstClassFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ClassBlock_primary &&
              widget.courseId == 'Mathematics III',
        );
        expect(firstClassFinder, findsOneWidget);
        expect(
          find.descendant(
            of: firstClassFinder,
            matching: find.byIcon(Icons.check),
          ),
          findsNothing,
        );

        // Second class (Data Structures) is c2, initially isMarked is true
        final secondClassFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ClassBlock_primary &&
              widget.courseId == 'Data Structures',
        );
        expect(secondClassFinder, findsOneWidget);
        expect(
          find.descendant(
            of: secondClassFinder,
            matching: find.byIcon(Icons.check),
          ),
          findsOneWidget,
        );

        // Third class (Database Management) is c3, which is cancelled, so checkmark doesn't exist
        final thirdClassFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ClassBlock_primary &&
              widget.courseId == 'Database Management',
        );
        expect(thirdClassFinder, findsOneWidget);
        expect(
          find.descendant(
            of: thirdClassFinder,
            matching: find.byType(GestureDetector),
          ),
          findsNothing,
        );

        // Find first class checkmark detector and tap it to check
        final firstClassCheckmark = find.descendant(
          of: firstClassFinder,
          matching: find.byType(GestureDetector),
        );
        await tester.ensureVisible(firstClassCheckmark);
        await tester.tap(firstClassCheckmark);
        await tester.pumpAndSettle();

        // Mathematics III should now be checked
        expect(
          find.descendant(
            of: firstClassFinder,
            matching: find.byIcon(Icons.check),
          ),
          findsOneWidget,
        );

        // Tap first class checkmark again to uncheck
        await tester.ensureVisible(firstClassCheckmark);
        await tester.tap(firstClassCheckmark);
        await tester.pumpAndSettle();

        // Mathematics III should now be unchecked again
        expect(
          find.descendant(
            of: firstClassFinder,
            matching: find.byIcon(Icons.check),
          ),
          findsNothing,
        );
      },
    );
  });
}
