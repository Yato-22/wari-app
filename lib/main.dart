import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'navigation/app_routes.dart';
import 'models/app_state.dart';
import 'Screens/language_selection_screen.dart';
import 'Screens/home_map_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://lnenyejgzoslrhdgnujk.supabase.co',
    // ignore: deprecated_member_use
    anonKey: 'sb_publishable__jB3aesQi7oEI9jL_H74yw_dYrCmyyB',
  );

  runApp(const WariConnectApp());
}

class WariConnectApp extends StatefulWidget {
  const WariConnectApp({super.key});

  @override
  State<WariConnectApp> createState() => _WariConnectAppState();
}

class _WariConnectAppState extends State<WariConnectApp> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _initializeAppState();
  }

  Future<void> _initializeAppState() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final profile = await _appState.supabaseService.getProfile(session.user.id);
      if (profile != null) {
        // Restore authenticated state and saved user role
        _appState.setAuthenticatedUser(profile);
      }
    }
    await _appState.loadInitialData();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      appState: _appState,
      child: MaterialApp(
        title: 'WariConnect - Vithala Guide',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) {
            final appState = AppStateScope.of(context);
            if (appState.isGuest) {
              return const LanguageSelectionScreen();
            }
            return const HomeMapScreen();
          },
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}

