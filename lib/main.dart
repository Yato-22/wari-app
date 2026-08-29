import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'navigation/app_routes.dart';
import 'models/app_state.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://hoeayfrmlclbxmikwcyl.supabase.co',
    anonKey: 'sb_publishable_3a1m9eDPOma0HhLRFsu7sA_eW4WXAGG',
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
        // Safe to call since it notifies listeners
        _appState.updateUserProfile(profile);
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
        initialRoute: AppRoutes.language,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}

