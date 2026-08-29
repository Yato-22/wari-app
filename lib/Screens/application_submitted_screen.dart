import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: SelectableText(
                                appId,
                                style: AppTypography.titleLg.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: appId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Application ID copied to clipboard')),
                              );
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.content_copy, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'COPY',
                                    style: AppTypography.labelBold.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
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
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTypography.bodySm.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

