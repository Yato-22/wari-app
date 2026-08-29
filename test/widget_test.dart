import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wari_connect_app/models/app_state.dart';
import 'package:wari_connect_app/models/user_profile.dart';
import 'package:wari_connect_app/screens/home_map_screen.dart';
import 'package:wari_connect_app/screens/login_otp_screen.dart';
import 'package:wari_connect_app/screens/role_selection_screen.dart';
import 'package:wari_connect_app/screens/application_submitted_screen.dart';
import 'package:wari_connect_app/screens/report_submitted_screen.dart';
import 'package:wari_connect_app/screens/profile_guest_screen.dart';
import 'package:wari_connect_app/screens/profile_logged_in_screen.dart';
import 'package:wari_connect_app/widgets/app_bottom_nav_bar.dart';
import 'package:wari_connect_app/navigation/app_routes.dart';
import 'package:wari_connect_app/theme/app_theme.dart';

void main() {
  group('1. Guest State (Default)', () {
    testWidgets('AppState starts initially in AuthenticationState.guest',
        (WidgetTester tester) async {
      final appState = AppState();
      expect(appState.isGuest, true);
      expect(appState.isLoggedIn, false);
      expect(appState.authState, AuthenticationState.guest);
    });

    testWidgets('Guest bottom navigation contains only Map and Profile (2 tabs)',
        (WidgetTester tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        AppStateScope(
          appState: appState,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              bottomNavigationBar: AppBottomNavBar(currentTab: 'map'),
            ),
          ),
        ),
      );
      await tester.pump();

      // Guest must see Map and Profile
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      // Report and Volunteer tabs must NOT be present
      expect(find.text('Report'), findsNothing);
      expect(find.text('Reports'), findsNothing);
      expect(find.text('Volunteer'), findsNothing);
    });

    testWidgets('Guest route protection redirects to Login on protected action',
        (WidgetTester tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        AppStateScope(
          appState: appState,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            initialRoute: AppRoutes.profileGuest,
          ),
        ),
      );
      await tester.pump();

      // Attempt navigating to protected route
      final navKey = tester.state<NavigatorState>(find.byType(Navigator));
      navKey.pushNamed(AppRoutes.reportIssue);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Smoothly redirected to Login page without crashing
      expect(find.byType(LoginOtpScreen), findsOneWidget);
      expect(find.text('Get OTP'), findsOneWidget);
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
  });

  group('2. Warkari State', () {
    testWidgets('Warkari navigation contains Map, Report, Profile (Volunteer hidden)',
        (WidgetTester tester) async {
      final appState = AppState();
      appState.setAuthenticatedUser(
        const UserProfile(
          id: 'usr-1',
          name: 'Vitthal Bhakt',
          phone: '+91 9876543210',
          role: UserRole.warkari,
        ),
      );

      expect(appState.isLoggedIn, true);
      expect(appState.user.role, UserRole.warkari);

      await tester.pumpWidget(
        AppStateScope(
          appState: appState,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              bottomNavigationBar: AppBottomNavBar(currentTab: 'map'),
            ),
          ),
        ),
      );
      await tester.pump();

      // Warkari must see Map, Report, Profile
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      // Volunteer tab must NOT be shown
      expect(find.text('Volunteer'), findsNothing);
    });

    testWidgets('Warkari profile displays details and Become a Camp Organiser action',
        (WidgetTester tester) async {
      final appState = AppState();
      appState.setAuthenticatedUser(
        const UserProfile(
          id: 'usr-1',
          name: 'Vitthal Bhakt',
          phone: '+91 9876543210',
          role: UserRole.warkari,
        ),
      );

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
      expect(find.text('Become a Camp Organiser'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });
  });

  group('3. Volunteer State', () {
    testWidgets('Volunteer navigation contains Map, Volunteer, Profile (Report hidden)',
        (WidgetTester tester) async {
      final appState = AppState();
      appState.setAuthenticatedUser(
        const UserProfile(
          id: 'usr-2',
          name: 'Dnyaneshwar Sevak',
          phone: '+91 9876543211',
          role: UserRole.volunteer,
        ),
      );

      expect(appState.isLoggedIn, true);
      expect(appState.user.role, UserRole.volunteer);

      await tester.pumpWidget(
        AppStateScope(
          appState: appState,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const Scaffold(
              bottomNavigationBar: AppBottomNavBar(currentTab: 'map'),
            ),
          ),
        ),
      );
      await tester.pump();

      // Volunteer must see Map, Volunteer, Profile
      expect(find.text('Map'), findsOneWidget);
      expect(find.text('Volunteer'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      // Report tab must NOT be shown
      expect(find.text('Reports'), findsNothing);
    });

    testWidgets('Volunteer profile displays details and Become a Camp Organiser action',
        (WidgetTester tester) async {
      final appState = AppState();
      appState.setAuthenticatedUser(
        const UserProfile(
          id: 'usr-2',
          name: 'Dnyaneshwar Sevak',
          phone: '+91 9876543211',
          role: UserRole.volunteer,
        ),
      );

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

      expect(find.text('Dnyaneshwar Sevak'), findsOneWidget);
      expect(find.text('Become a Camp Organiser'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });
  });

  group('4. Role Selection Screen', () {
    testWidgets('RoleSelectionScreen displays Warkari and Volunteer options and continues',
        (WidgetTester tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        AppStateScope(
          appState: appState,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const RoleSelectionScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Choose Your Role in Wari'), findsOneWidget);
      expect(find.text('Warkari / Pilgrim (वारकरी)'), findsOneWidget);
      expect(find.text('Volunteer / Sevak (स्वयंसेवक)'), findsOneWidget);
      expect(find.text('Continue as Warkari'), findsOneWidget);
    });
  });

  group('5. General Widget Tests', () {
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
  });
}





