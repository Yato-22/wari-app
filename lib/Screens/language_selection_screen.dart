import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'home_map_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedLanguageCode;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onLanguageSelected(String langCode) async {
    setState(() {
      _selectedLanguageCode = langCode;
    });

    // Subtle scale feedback & fade out transition matching Stitch template
    await _fadeController.forward();
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            HomeMapScreen(initialLanguage: langCode),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: Stack(
        children: [
          // Subtle warm decorative gradient at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppTheme.maroonLight.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 16.0,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - 32,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(height: 12),

                                // Center Content
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Circular App Logo with Tactile Shadow
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.surfaceContainerLowest,
                                        boxShadow:
                                            AppTheme.tactileSaffronShadow,
                                        border: Border.all(
                                          color: AppTheme.saffronDark
                                              .withValues(alpha: 0.15),
                                          width: 1.5,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDysU6q85vZBwNFnWobA_LzbKvsijZkJ-qz09yQmnfas9LT-ObohTRk0mu1NMZegUvEva5ps5XRNULylCUx9xR9QZAZPcaT4KsgO5kvYnlYE7XitTFMk8b5gGQxTIF85b7VQfH1fYHhwrPP9oBaHIo1wTR8Pw9p3GzlA9UGstXdf0Tnd_iWxWr63IhW3M2oD1X8orhKAGsUkJwkIU-dD8rGO7SElr8mWvZzYDn06lqQQpCkd3cQHbY',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Center(
                                                  child: Icon(
                                                    Icons.temple_hindu_rounded,
                                                    size: 56,
                                                    color: AppTheme.saffronDark,
                                                  ),
                                                ),
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppTheme.saffronPrimary,
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 28),

                                    // Header Text
                                    Text(
                                      'Select Language / भाषा निवडा',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.headlineLgMobile(
                                        color: AppTheme.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Choose your preferred language for the journey',
                                      textAlign: TextAlign.center,
                                      style: AppTheme.bodySm(
                                        color: AppTheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 28),

                                    // Language Buttons List
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // 1. Marathi (Primary button)
                                        _buildLanguageButton(
                                          langCode: 'mr',
                                          title: 'मराठी',
                                          isPrimary: true,
                                        ),
                                        const SizedBox(height: 14),

                                        // 2. Hindi
                                        _buildLanguageButton(
                                          langCode: 'hi',
                                          title: 'हिन्दी',
                                          isPrimary: false,
                                        ),
                                        const SizedBox(height: 14),

                                        // 3. English
                                        _buildLanguageButton(
                                          langCode: 'en',
                                          title: 'English',
                                          isPrimary: false,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Footer
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8.0,
                                    top: 24.0,
                                  ),
                                  child: Text(
                                    '"Journey with Faith, Guided by WariConnect"',
                                    textAlign: TextAlign.center,
                                    style: AppTheme.bodySm(
                                      color: AppTheme.onSurfaceVariant,
                                    ).copyWith(fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton({
    required String langCode,
    required String title,
    required bool isPrimary,
  }) {
    final isSelected = _selectedLanguageCode == langCode;

    return AnimatedScale(
      scale: isSelected ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: isPrimary
            ? ElevatedButton(
                onPressed: () => _onLanguageSelected(langCode),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.saffronDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    color: AppTheme.saffronDark,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40FF9933),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: AppTheme.headlineLgMobile(color: Colors.white),
                    ),
                  ),
                ),
              )
            : OutlinedButton(
                onPressed: () => _onLanguageSelected(langCode),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppTheme.surfaceContainerLowest,
                  foregroundColor: AppTheme.maroonLight,
                  side: BorderSide(
                    color: AppTheme.maroonLight.withValues(alpha: 0.25),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  title,
                  style: AppTheme.headlineLgMobile(color: AppTheme.maroonLight),
                ),
              ),
      ),
    );
  }
}
