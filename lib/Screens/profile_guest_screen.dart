import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/custom_button.dart';
import '../navigation/app_routes.dart';

class ProfileGuestScreen extends StatelessWidget {
  const ProfileGuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        showBackButton: false,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Guest Avatar Header
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.outlineVariant,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    size: 80,
                    color: AppColors.outline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome to WariConnect',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: 6),
              Text(
                'Login to save your Dindi location, track reported issues, apply for volunteer seva, or manage pilgrimage camps.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Login / Sign Up Action Button
              CustomButton(
                label: 'Login / Sign Up',
                icon: Icons.arrow_forward,
                iconTrailing: true,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.loginOtp);
                },
              ),

              const SizedBox(height: 32),
              Text(
                'MORE OPTIONS',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              // Options Menu Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  boxShadow: const [AppColors.tactileSaffronShadow],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      subtitle: 'Helpline numbers, FAQs & guide',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.helpAndSupport);
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'About WariConnect',
                      subtitle: 'Mission, tradition & version v1.2.0',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.about);
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.language,
                      title: 'Select Language',
                      subtitle: 'Change app language (मराठी / हिन्दी / English)',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.language);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: AppTypography.labelBold.copyWith(
            fontSize: 15,
            color: AppColors.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySm.copyWith(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppColors.outline,
        ),
        onTap: onTap,
      ),
    );
  }
}

