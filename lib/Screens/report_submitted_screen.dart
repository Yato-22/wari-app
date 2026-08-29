import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/custom_button.dart';
import '../navigation/app_routes.dart';

class ReportSubmittedScreen extends StatelessWidget {
  final String reportId;
  final String campName;

  const ReportSubmittedScreen({
    super.key,
    required this.reportId,
    required this.campName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Report Confirmation',
        showBackButton: false,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Success Icon Animation / Container
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.statusOpenBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.statusOpenText, width: 2),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 54,
                    color: AppColors.statusOpenText,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Report Submitted Successfully!',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: 8),
              Text(
                'Thank you for looking out for fellow pilgrims. The nearest camp volunteers and route officers have been notified.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),

              // Reference ID & Summary Details Card
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'REFERENCE ID',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.statusBusyBg,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'UNDER REVIEW',
                            style: AppTypography.labelBold.copyWith(
                              color: AppColors.statusBusyText,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          reportId,
                          style: AppTypography.headlineLgMobile.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 18, color: AppColors.primary),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Report ID copied to clipboard')),
                            );
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    _buildRow(Icons.location_on, 'Location', campName),
                    const SizedBox(height: 12),
                    _buildRow(Icons.access_time, 'Reported At', 'Just now'),
                    const SizedBox(height: 12),
                    _buildRow(Icons.shield_outlined, 'Assigned Unit', 'Saswad Mobile Response Team #3'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Action Buttons
              CustomButton(
                label: 'Back to Map',
                icon: Icons.map,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.homeMap);
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'View My Activity & Reports',
                icon: Icons.history,
                variant: ButtonVariant.secondary,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.activityTracker,
                    arguments: {'tabIndex': 0},
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMd.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

