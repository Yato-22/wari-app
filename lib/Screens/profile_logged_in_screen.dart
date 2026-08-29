import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/custom_button.dart';
import '../navigation/app_routes.dart';

class ProfileLoggedInScreen extends StatelessWidget {
  const ProfileLoggedInScreen({super.key});

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
              // User Profile Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
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
                                  color: AppColors.primaryContainer.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  'Dindi #12 • Alandi Route',
                                  style: AppTypography.labelBold.copyWith(
                                    color: AppColors.primary,
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
                            icon: const Icon(Icons.qr_code_scanner, size: 16),
                            label: const Text('Scan QR'),
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

              const SizedBox(height: 24),

              // Activity & Organiser Menu Group
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
                      subtitle: 'View your reports, volunteering & donations',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.activityTracker);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.add_business,
                      title: 'Become a Camp Organiser',
                      subtitle: 'Register & manage pilgrimage camps along the route',
                      trailingWidget: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Apply',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.secondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.becomeCampOrganiser);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.payments_outlined,
                      title: 'Donate to Camps',
                      subtitle: 'Support Anna Chhatra and medical camps',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.donateMoney);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Organiser View Switcher Card (Convenient access to organiser screens)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTile(
                      icon: Icons.roofing,
                      title: 'Organiser Management Dashboard',
                      subtitle: 'Manage camp status, capacity & volunteers',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.profileOrgManagement);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.volunteer_activism,
                      title: 'Organiser Donations Dashboard',
                      subtitle: 'Track donations & financial support',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.profileOrgDonation);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Support & About Menu Group
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
                      icon: Icons.support_agent,
                      title: 'Help & Support',
                      subtitle: 'Helpline, FAQs & emergency assistance',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.helpAndSupport);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.info_outline,
                      title: 'About WariConnect',
                      subtitle: 'Learn more about the pilgrimage initiative',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.about);
                      },
                    ),
                    const Divider(height: 1),
                    _buildTile(
                      icon: Icons.language,
                      title: 'Language / भाषा',
                      subtitle: 'Change preferred language',
                      onTap: () {
                        Navigator.of(context).pushNamed(AppRoutes.language);
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
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.profileGuest);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailingWidget,
    required VoidCallback onTap,
  }) {
    return ListTile(
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
      trailing: trailingWidget ??
          const Icon(
            Icons.chevron_right,
            color: AppColors.outline,
          ),
      onTap: onTap,
    );
  }
}

