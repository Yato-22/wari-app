import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../models/camp_facility.dart';
import 'status_chip.dart';

class FacilityCard extends StatelessWidget {
  final CampFacility facility;
  final VoidCallback? onClose;
  final VoidCallback? onNavigate;
  final VoidCallback? onReportIssue;
  final VoidCallback? onDonate;

  const FacilityCard({
    super.key,
    required this.facility,
    this.onClose,
    this.onNavigate,
    this.onReportIssue,
    this.onDonate,
  });

  IconData _getIconForType(FacilityType type) {
    switch (type) {
      case FacilityType.food:
        return Icons.restaurant;
      case FacilityType.water:
        return Icons.water_drop;
      case FacilityType.medical:
        return Icons.medical_services;
      case FacilityType.toilet:
        return Icons.wc;
      case FacilityType.shelter:
      case FacilityType.all:
        return Icons.campaign;
    }
  }

  Color _getColorForType(FacilityType type) {
    switch (type) {
      case FacilityType.food:
        return AppColors.tertiary;
      case FacilityType.water:
        return Colors.blue.shade700;
      case FacilityType.medical:
        return AppColors.secondary;
      case FacilityType.toilet:
        return Colors.teal.shade700;
      case FacilityType.shelter:
      case FacilityType.all:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getColorForType(facility.type);
    final typeIcon = _getIconForType(facility.type);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryContainer.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: const [AppColors.tactileSaffronShadow],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with Icon, Title, and Close
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(typeIcon, color: typeColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      style: AppTypography.headlineLgMobile.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      facility.description,
                      style: AppTypography.bodySm,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppColors.onSurfaceVariant),
                  onPressed: onClose,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          // Status, Distance and Navigate button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  StatusChip(status: facility.status),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Icon(Icons.route, size: 14, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Text(
                        '${facility.distanceKm} km away',
                        style: AppTypography.labelBold.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onNavigate,
                icon: const Icon(Icons.directions, size: 16),
                label: const Text('Navigate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  minimumSize: const Size(100, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          if (onReportIssue != null || onDonate != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onReportIssue != null)
                  TextButton.icon(
                    onPressed: onReportIssue,
                    icon: const Icon(Icons.report_problem, size: 14, color: AppColors.error),
                    label: Text(
                      'Report Issue',
                      style: AppTypography.labelBold.copyWith(color: AppColors.error, fontSize: 11),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                    ),
                  ),
                if (onDonate != null) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: onDonate,
                    icon: const Icon(Icons.favorite, size: 14, color: AppColors.secondary),
                    label: Text(
                      'Donate',
                      style: AppTypography.labelBold.copyWith(color: AppColors.secondary, fontSize: 11),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

