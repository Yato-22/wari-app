import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wari_connect_app/models/app_state.dart';
import 'package:wari_connect_app/models/user_profile.dart';
import 'package:wari_connect_app/Screens/home_map_screen.dart';
import 'package:wari_connect_app/Screens/login_otp_screen.dart';
import 'package:wari_connect_app/Screens/application_submitted_screen.dart';
import 'package:wari_connect_app/Screens/report_submitted_screen.dart';
import 'package:wari_connect_app/Screens/profile_guest_screen.dart';
import 'package:wari_connect_app/Screens/profile_logged_in_screen.dart';
import 'package:wari_connect_app/theme/app_theme.dart';

void main() {
  testWidgets('AppState starts initially in logged-out Guest state',
      (WidgetTester tester) async {
    final appState = AppState();
    expect(appState.isLoggedIn, false);
    expect(appState.user.role, UserRole.guest);
    expect(appState.user.name, 'Guest Pilgrim');
  });

  testWidgets('ProfileGuestScreen renders for logged-out users with Login/Sign Up button',
      (WidgetTester tester) async {
    final appState = AppState();

    await tester.pumpWidget(
      AppStateScope(
        appState: appState,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileGuestScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Welcome to WariConnect'), findsOneWidget);
    expect(find.text('Login / Sign Up'), findsOneWidget);
    expect(find.text('Help & Support'), findsOneWidget);
  });

  testWidgets('ProfileLoggedInScreen renders dynamic user profile and logout action',
      (WidgetTester tester) async {
    final appState = AppState();
    await appState.login('9876543210');
    expect(appState.isLoggedIn, true);

    await tester.pumpWidget(
      AppStateScope(
        appState: appState,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const ProfileLoggedInScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Vitthal Bhakt'), findsOneWidget);
    expect(find.text('+91 9876543210'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('LoginOtpScreen renders with digits-only phone input and no +91 badge',
      (WidgetTester tester) async {
    final appState = AppState();

    await tester.pumpWidget(
      AppStateScope(
        appState: appState,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const LoginOtpScreen(),
        ),
      ),
    );
    await tester.pump();

    // Verify +91 text badge is removed
    expect(find.text('+91'), findsNothing);
    // Verify phone input field and action button
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Get OTP'), findsOneWidget);
    expect(find.text('Namaste Pilgrim'), findsOneWidget);
  });

  testWidgets('HomeMapScreen renders OpenStreetMap view and controls',
      (WidgetTester tester) async {
    final appState = AppState();

    await tester.pumpWidget(
      AppStateScope(
        appState: appState,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const HomeMapScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(HomeMapScreen), findsOneWidget);
    expect(find.text('SOS'), findsOneWidget);
    expect(find.text('Live Palkhi'), findsOneWidget);
  });

  testWidgets('ApplicationSubmittedScreen renders tracking ID properly without overflow on small screens',
      (WidgetTester tester) async {
    // Test on a narrow screen size (320px width)
    tester.view.physicalSize = const Size(320 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ApplicationSubmittedScreen(appId: '#WARI-ORG-2026-7891'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('#WARI-ORG-2026-7891'), findsOneWidget);
    expect(find.text('APPLICATION TRACKING ID'), findsOneWidget);
    expect(find.text('COPY'), findsOneWidget);
    expect(find.text('Application Received!'), findsOneWidget);
  });

  testWidgets('ReportSubmittedScreen renders reference ID without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320 * 3, 640 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ReportSubmittedScreen(
          reportId: '#REP-2026-9812',
          campName: 'Saswad Food Camp',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('#REP-2026-9812'), findsOneWidget);
    expect(find.text('REFERENCE ID'), findsOneWidget);
  });
}




