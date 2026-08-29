import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../navigation/app_routes.dart';

class ApplicationSubmittedScreen extends StatelessWidget {
  final String appId;

  const ApplicationSubmittedScreen({
    super.key,
    required this.appId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Application Submitted',
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
              // Success Graphic
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
                'Application Received!',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: 8),
              Text(
                'Your camp registration details have been submitted. Our field officers will verify your trust documents and inspect on-site facilities.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),

              // Application ID & Info Card
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
                    Text(
                      'APPLICATION TRACKING ID',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            appId,
                            style: AppTypography.headlineLgMobile.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Application ID copied to clipboard')),
                              );
                            },
                            icon: const Icon(Icons.content_copy, size: 16),
                            label: const Text('COPY'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    _buildRow(Icons.timer, 'Review Timeline', '24 - 48 Hours'),
                    const SizedBox(height: 10),
                    _buildRow(Icons.person_pin, 'Assigned Officer', 'Suresh Patil (Field Officer)'),
                    const SizedBox(height: 10),
                    _buildRow(Icons.phone, 'Officer Helpline', '+91 94220 12345'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              CustomButton(
                label: 'View Application Status',
                icon: Icons.assignment_turned_in,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.applicationStatus);
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Back to Profile',
                variant: ButtonVariant.secondary,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.profileOrgManagement);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: AppTypography.labelBold.copyWith(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodySm.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

