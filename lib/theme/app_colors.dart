import 'package:flutter/material.dart';

/// Design tokens and color palette for Vithala Guide / WariConnect.
/// Faithfully converted from DESIGN.md and HTML prototypes.
class AppColors {
  AppColors._();

  // Core Surface Colors
  static const Color surface = Color(0xFFFFF8F5);
  static const Color surfaceDim = Color(0xFFE1D8D4);
  static const Color surfaceBright = Color(0xFFFFF8F5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFFBF2ED);
  static const Color surfaceContainer = Color(0xFFF5ECE7);
  static const Color surfaceContainerHigh = Color(0xFFEFE6E2);
  static const Color surfaceContainerHighest = Color(0xFFE9E1DC);
  static const Color surfaceVariant = Color(0xFFE9E1DC);

  // Text & Outline on Surface
  static const Color onSurface = Color(0xFF1E1B18);
  static const Color onSurfaceVariant = Color(0xFF554336);
  static const Color inverseSurface = Color(0xFF34302C);
  static const Color inverseOnSurface = Color(0xFFF8EFEA);
  static const Color outline = Color(0xFF887364);
  static const Color outlineVariant = Color(0xFFDBC2B0);
  static const Color surfaceTint = Color(0xFF8F4E00);

  // Primary - Saffron & Warm Gold
  static const Color primary = Color(0xFF8F4E00);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFF9933);
  static const Color onPrimaryContainer = Color(0xFF693800);
  static const Color inversePrimary = Color(0xFFFFB77A);
  static const Color primaryFixed = Color(0xFFFFDCC2);
  static const Color primaryFixedDim = Color(0xFFFFB77A);
  static const Color onPrimaryFixed = Color(0xFF2E1500);
  static const Color onPrimaryFixedVariant = Color(0xFF6D3A00);

  // Secondary - Deep Sacred Maroon
  static const Color secondary = Color(0xFFB22B1D);
  static const Color deepMaroon = Color(0xFF800000);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFE624E);
  static const Color onSecondaryContainer = Color(0xFF650000);
  static const Color secondaryFixed = Color(0xFFFFDAD4);
  static const Color secondaryFixedDim = Color(0xFFFFB4A8);
  static const Color onSecondaryFixed = Color(0xFF410000);
  static const Color onSecondaryFixedVariant = Color(0xFF8F0F07);

  // Tertiary - Olive Ochre
  static const Color tertiary = Color(0xFF60603E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFB5B48B);
  static const Color onTertiaryContainer = Color(0xFF464626);
  static const Color tertiaryFixed = Color(0xFFE6E5B9);
  static const Color tertiaryFixedDim = Color(0xFFCAC99F);
  static const Color onTertiaryFixed = Color(0xFF1D1D03);
  static const Color onTertiaryFixedVariant = Color(0xFF484828);

  // Error & Emergency SOS
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Background
  static const Color background = Color(0xFFFFF8F5);
  static const Color onBackground = Color(0xFF1E1B18);

  // Real-time Traffic Light Status Colors
  static const Color statusOpenBg = Color(0xFFE6F4EA);
  static const Color statusOpenText = Color(0xFF137333);

  static const Color statusBusyBg = Color(0xFFFEF7E0);
  static const Color statusBusyText = Color(0xFFE37400);

  static const Color statusClosedBg = Color(0xFFFFDAD6);
  static const Color statusClosedText = Color(0xFFBA1A1A);

  // Custom Tactile Saffron Shadows
  static const BoxShadow tactileSaffronShadow = BoxShadow(
    color: Color(0x1FFF9933),
    blurRadius: 12,
    offset: Offset(0, 4),
  );

  static const BoxShadow tactileSaffronShadowElevated = BoxShadow(
    color: Color(0x26FF9933),
    blurRadius: 16,
    offset: Offset(0, 6),
  );

  static const BoxShadow bottomNavShadow = BoxShadow(
    color: Color(0x1FFF9933),
    blurRadius: 12,
    offset: Offset(0, -4),
  );
}

