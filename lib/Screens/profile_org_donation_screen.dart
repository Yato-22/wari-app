import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/custom_button.dart';
import '../models/app_state.dart';
import '../navigation/app_routes.dart';

class ProfileOrgDonationScreen extends StatelessWidget {
  const ProfileOrgDonationScreen({super.key});

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Organiser Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryContainer.withValues(alpha: 0.4),
                  ),
                  boxShadow: const [AppColors.tactileSaffronShadow],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 2),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vitthal Bhakt',
                                style: AppTypography.headlineLgMobile.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '+91 98765 43210',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  'Camp Organiser & Patron',
                                  style: AppTypography.labelBold.copyWith(
                                    color: AppColors.secondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRoutes.editProfile);
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text('Edit Profile'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRoutes.qrScanner);
                            },
                            icon: const Icon(Icons.qr_code, size: 16),
                            label: const Text('Camp QR'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 40),
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu Options Including Donations
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
                    _buildTile(
                      icon: Icons.insights,
                      title: 'My Activity',
                      subtitle: 'View your reports & volunteering',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.activityTracker);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.roofing,
                      title: 'My Camp Management',
                      subtitle: 'Manage your camp, status, and volunteers',
                      iconBg: AppColors.primaryContainer.withValues(alpha: 0.2),
                      iconColor: AppColors.primary,
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.myCampManagement);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.add_location_alt,
                      title: 'Register New Camp',
                      subtitle: 'Add a new facility to the pilgrimage route',
                      iconBg: AppColors.secondary.withValues(alpha: 0.15),
                      iconColor: AppColors.secondary,
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.campRegistration);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.payments,
                      title: 'Donate Money',
                      subtitle: 'Financial support for pilgrimage causes',
                      iconBg: Colors.green.withValues(alpha: 0.15),
                      iconColor: Colors.green.shade700,
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.donateMoney);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.support_agent,
                      title: 'Help & Support',
                      subtitle: 'Direct helpline and FAQs',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.helpAndSupport);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.info_outline,
                      title: 'About Palkhi Saathi',
                      subtitle: 'App details & pilgrimage guidelines',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.about);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout Button
              CustomButton(
                label: 'Logout',
                icon: Icons.logout,
                variant: ButtonVariant.secondary,
                onPressed: () async {
                  await AppStateScope.of(context).logout();
                  if (context.mounted) {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.profileGuest);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentTab: 'profile'),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconBg,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: iconBg ?? AppColors.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
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
    );
  }
}

