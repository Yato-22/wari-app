import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/custom_button.dart';
import '../navigation/app_routes.dart';
import '../models/app_state.dart';

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
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStateScope.of(context).translate('welcome_guest'),
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: 6),
              Text(
                AppStateScope.of(context).translate('login_desc'),
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Login / Sign Up Action Button
              CustomButton(
                label: AppStateScope.of(context).translate('login_signup'),
                icon: Icons.arrow_forward,
                iconTrailing: true,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.loginOtp);
                },
              ),

              const SizedBox(height: 32),
              Text(
                AppStateScope.of(context).translate('more_options'),
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
                      title: AppStateScope.of(context).translate('help_support'),
                      subtitle: AppStateScope.of(context).translate('help_desc'),
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.helpAndSupport);
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: AppStateScope.of(context).translate('about'),
                      subtitle: AppStateScope.of(context).translate('about_desc'),
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.about);
                      },
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.language,
                      title: AppStateScope.of(context).translate('select_language'),
                      subtitle: AppStateScope.of(context).translate('change_lang_desc'),
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
      bottomNavigationBar: const AppBottomNavBar(currentTab: 'profile'),
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

