import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'navigation/app_routes.dart';
import 'models/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    return scope?.notifier ?? AppState();
  }
}

