import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'About WariConnect',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo & Mission Header
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryContainer, width: 2),
                    boxShadow: const [AppColors.tactileSaffronShadow],
                  ),
                  child: const Icon(
                    Icons.temple_hindu,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'About WariConnect',
                textAlign: TextAlign.center,
                style: AppTypography.headlineXl,
              ),
              const SizedBox(height: 8),
              Text(
                'Empowering the Warkari community through technology. We strive to provide real-time support, coordinate essential services, and foster a safer pilgrimage experience while deeply honoring the sanctity of the sacred Wari tradition.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),

              // Key Features Bento Grid
              Text(
                'KEY PLATFORM FEATURES',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildBentoCard(
                    icon: Icons.map,
                    title: 'Live Tracking',
                    desc: 'Real-time GPS tracking of Dindis & facilities.',
                    color: AppColors.primary,
                    bgColor: AppColors.primaryContainer.withValues(alpha: 0.15),
                  ),
                  _buildBentoCard(
                    icon: Icons.volunteer_activism,
                    title: 'Volunteer Seva',
                    desc: 'Coordinate seamless assistance on the route.',
                    color: AppColors.secondary,
                    bgColor: AppColors.secondaryFixed.withValues(alpha: 0.4),
                  ),
                  _buildBentoCard(
                    icon: Icons.report_problem,
                    title: 'Issue Reports',
                    desc: 'Quickly log and resolve route obstacles.',
                    color: AppColors.error,
                    bgColor: AppColors.errorContainer,
                  ),
                  _buildBentoCard(
                    icon: Icons.favorite,
                    title: 'Donations',
                    desc: 'Transparent support for Anna Chhatras.',
                    color: AppColors.tertiary,
                    bgColor: AppColors.tertiaryFixed.withValues(alpha: 0.5),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // The Tradition Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.history_edu, color: AppColors.primary, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'The Sacred Tradition',
                          style: AppTypography.headlineLgMobile.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'The Pandharpur Wari is an 800-year-old annual pilgrimage (yatra) to the holy town of Pandharpur in Maharashtra, India. It involves millions of devotees (Warkaris) walking over 250 kilometers on foot, accompanying the Padukas (sacred sandals) of revered saints like Sant Dnyaneshwar and Sant Tukaram.\n\nWariConnect is built with deep devotion to serve this incredible journey of faith, unity, and selfless service.',
                      style: AppTypography.bodyMd.copyWith(
                        fontSize: 13.5,
                        color: AppColors.onSurfaceVariant,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Version & Credits Footer
              Center(
                child: Column(
                  children: [
                    Text(
                      'v1.2.0 • Production Build',
                      style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Made with Faith',
                          style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.favorite, color: AppColors.secondary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'for the Warkari Community',
                          style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentTab: 'profile'),
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryContainer.withValues(alpha: 0.15),
        ),
        boxShadow: const [AppColors.tactileSaffronShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTypography.labelBold.copyWith(fontSize: 13, color: AppColors.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: AppTypography.bodySm.copyWith(fontSize: 11, color: AppColors.onSurfaceVariant),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

