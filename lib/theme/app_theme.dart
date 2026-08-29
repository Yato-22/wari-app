import 'package:flutter/material.dart';

class AppTheme {
  static const Color maroonLight = Color(0xFF8F1D2C);
  static const Color maroonSecondary = Color(0xFF7A1F2A);
  static const Color saffronPrimary = Color(0xFFFFB347);
  static const Color saffronDark = Color(0xFFB96B00);
  static const Color creamBackground = Color(0xFFF8F3EE);
  static const Color surface = Color(0xFFFDF9F6);
  static const Color surfaceContainer = Color(0xFFF2EAE3);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1F1A17);
  static const Color onSurfaceVariant = Color(0xFF5E534F);
  static const Color outlineVariant = Color(0xFFDFCFC3);
  static const Color error = Color(0xFFBA1A1A);
  static const Color inverseSurface = Color(0xFF2B1F1D);
  static const Color inverseOnSurface = Color(0xFFFFFFFF);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color statusOpenBg = Color(0xFFE8F5E9);
  static const Color statusOpenText = Color(0xFF1B5E20);
  static const Color surfaceVariant = Color(0xFFF1E7D8);

  static const List<BoxShadow> tactileSaffronShadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 3)),
  ];

  static TextStyle headlineLgMobile({required Color color}) => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: color,
    letterSpacing: -0.3,
  );

  static TextStyle bodyMd({required Color color}) =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color);

  static TextStyle bodySm({required Color color}) =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle labelBold({required Color color}) =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color);

  static TextStyle statusPill({required Color color}) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: color,
    letterSpacing: 0.6,
  );
}
