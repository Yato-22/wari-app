import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_button.dart';
import '../navigation/app_routes.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'mr'; // 'mr', 'hi', 'en'

  final List<Map<String, String>> _languages = [
    {
      'code': 'mr',
      'title': 'मराठी',
      'subtitle': 'स्थानिक भाषा (Local Language)',
      'quote': 'जय हरी विठ्ठल, ज्ञानोबा माउली तुकाराम',
    },
    {
      'code': 'hi',
      'title': 'हिन्दी',
      'subtitle': 'राष्ट्रभाषा (National Language)',
      'quote': 'वारकरी संप्रदाय और पालखी मार्गदर्शिका',
    },
    {
      'code': 'en',
      'title': 'English',
      'subtitle': 'Global Language',
      'quote': 'Complete Pandharpur Palkhi Pilgrim Guide',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Brand Header
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryContainer,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Language\nभाषा निवडा',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your preferred language for the pilgrimage journey',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              // Language Cards
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = _languages[index];
                    final isSelected = _selectedLanguage == item['code'];

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedLanguage = item['code']!;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryContainer
                                : AppColors.outlineVariant.withValues(alpha: 0.6),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? const [AppColors.tactileSaffronShadow]
                              : [],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.outlineVariant,
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: AppTypography.headlineLgMobile.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['subtitle']!,
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['quote']!,
                                    style: AppTypography.labelBold.copyWith(
                                      color: AppColors.secondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Continue Button
              CustomButton(
                label: 'Continue / पुढे जा',
                icon: Icons.arrow_forward,
                iconTrailing: true,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.homeMap);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

