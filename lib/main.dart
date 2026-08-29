import 'package:flutter/material.dart';

import 'Screens/language_selection_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const WariApp());
}

class WariApp extends StatelessWidget {
  const WariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WariConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.saffronPrimary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppTheme.creamBackground,
        useMaterial3: true,
      ),
      home: const LanguageSelectionScreen(),
    );
  }
}