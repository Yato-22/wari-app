import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';

class ApplicationStatusScreen extends StatelessWidget {
  const ApplicationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Application Status',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary Header Card
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '#WARI-ORG-2026-7891',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.statusBusyBg,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'IN VERIFICATION',
                            style: AppTypography.labelBold.copyWith(
                              fontSize: 10,
                              color: AppColors.statusBusyText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vitthal Rukmini Anna Chhatra',
                      style: AppTypography.headlineLg,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saswad Ghat Stop, Pune Route • Capacity: 1200 / day',
                      style: AppTypography.bodySm,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'VERIFICATION PROGRESS TIMELINE',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),

              // Timeline Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    _buildTimelineStep(
                      stepNumber: 1,
                      title: 'Application Submitted',
                      subtitle: 'Completed on July 02, 2026 at 10:30 AM',
                      isCompleted: true,
                      isActive: false,
                    ),
                    _buildTimelineStep(
                      stepNumber: 2,
                      title: 'Document & Trust Verification',
                      subtitle: 'Under review by District Charity Commissioner desk',
                      isCompleted: false,
                      isActive: true,
                    ),
                    _buildTimelineStep(
                      stepNumber: 3,
                      title: 'Field Inspection & GPS Tagging',
                      subtitle: 'On-site health & hygiene check by route officer',
                      isCompleted: false,
                      isActive: false,
                    ),
                    _buildTimelineStep(
                      stepNumber: 4,
                      title: 'Approved & Live on Palkhi Map',
                      subtitle: 'Public pilgrims can find, navigate & donate to your camp',
                      isCompleted: false,
                      isActive: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Officer Assistance Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 20,
                      child: Icon(Icons.person, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Suresh Patil (Field Officer)',
                            style: AppTypography.labelBold.copyWith(fontSize: 13),
                          ),
                          Text(
                            'Saswad - Jejuri Route Sector',
                            style: AppTypography.bodySm.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: AppColors.secondary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling Field Officer at +91 94220 12345...')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              CustomButton(
                label: 'Contact Support',
                icon: Icons.support_agent,
                variant: ButtonVariant.secondary,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connecting to Organiser Helpline...')),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required int stepNumber,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    bool isLast = false,
  }) {
    Color iconBg;
    Widget iconChild;

    if (isCompleted) {
      iconBg = AppColors.statusOpenBg;
      iconChild = const Icon(Icons.check, color: AppColors.statusOpenText, size: 16);
    } else if (isActive) {
      iconBg = AppColors.primaryContainer;
      iconChild = const Text(
        '2',
        style: TextStyle(color: AppColors.onPrimaryContainer, fontWeight: FontWeight.bold, fontSize: 13),
      );
    } else {
      iconBg = AppColors.surfaceContainerHigh;
      iconChild = Text(
        '$stepNumber',
        style: const TextStyle(color: AppColors.outline, fontWeight: FontWeight.bold, fontSize: 13),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(child: iconChild),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? AppColors.statusOpenText : AppColors.outlineVariant,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelBold.copyWith(
                      fontSize: 14,
                      color: isActive
                          ? AppColors.primary
                          : isCompleted
                              ? AppColors.onSurface
                              : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySm.copyWith(
                      fontSize: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

