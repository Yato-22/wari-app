import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../navigation/app_routes.dart';

class BecomeCampOrganiserScreen extends StatelessWidget {
  const BecomeCampOrganiserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Become a Camp Organiser',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Icon / Graphic
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryContainer, width: 2),
                  ),
                  child: const Icon(
                    Icons.add_business,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Organize Seva for Millions of Pilgrims',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: 8),
              Text(
                'Register your registered Trust or Mandali to set up an official Anna Chhatra, Medical Camp, or Water Point along the Palkhi route.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),

              // Benefits Card
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WHY REGISTER WITH WARICONNECT?',
                      style: AppTypography.labelBold.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    _buildBenefitItem(
                      icon: Icons.verified,
                      title: 'Official Route Map Listing',
                      desc: 'Pilgrims can locate your facility in real-time on the map.',
                    ),
                    const Divider(height: 20),
                    _buildBenefitItem(
                      icon: Icons.groups,
                      title: 'Volunteer Network Access',
                      desc: 'Recruit and approve dedicated volunteers easily.',
                    ),
                    const Divider(height: 20),
                    _buildBenefitItem(
                      icon: Icons.emergency,
                      title: 'Direct Emergency Link',
                      desc: 'Instant priority connection to police and medical ambulances.',
                    ),
                    const Divider(height: 20),
                    _buildBenefitItem(
                      icon: Icons.volunteer_activism,
                      title: 'Community Donations',
                      desc: 'Receive transparent digital donations directly from devotees.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3-Step Process
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APPLICATION PROCESS (2 STEPS)',
                      style: AppTypography.labelBold.copyWith(color: AppColors.secondary),
                    ),
                    const SizedBox(height: 12),
                    _buildStepRow('1', 'Trust & Organiser Info', 'Basic contact & registration details'),
                    const SizedBox(height: 10),
                    _buildStepRow('2', 'Facility & GPS Location', 'Services provided, capacity & route stop'),
                    const SizedBox(height: 10),
                    _buildStepRow('3', 'Quick Field Verification', 'Fast approval within 24-48 hours'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                label: 'Start Application',
                icon: Icons.arrow_forward,
                iconTrailing: true,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.organiserAppStep1);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelBold.copyWith(fontSize: 14, color: AppColors.onSurface),
              ),
              const SizedBox(height: 2),
              Text(desc, style: AppTypography.bodySm.copyWith(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepRow(String num, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              num,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelBold.copyWith(fontSize: 13, color: AppColors.onSurface),
              ),
              Text(
                subtitle,
                style: AppTypography.bodySm.copyWith(fontSize: 11, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

