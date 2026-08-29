import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wari_connect_app/models/app_state.dart';
import 'package:wari_connect_app/screens/home_map_screen.dart';
import 'package:wari_connect_app/screens/login_otp_screen.dart';
import 'package:wari_connect_app/theme/app_theme.dart';

void main() {
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
}



