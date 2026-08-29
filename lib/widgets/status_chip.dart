import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../models/camp_facility.dart';

class StatusChip extends StatelessWidget {
  final FacilityStatus status;
  final String? customLabel;

  const StatusChip({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case FacilityStatus.open:
        bg = AppColors.statusOpenBg;
        text = AppColors.statusOpenText;
        label = customLabel ?? 'Open Now';
        break;
      case FacilityStatus.busy:
        bg = AppColors.statusBusyBg;
        text = AppColors.statusBusyText;
        label = customLabel ?? 'Busy / High Crowd';
        break;
      case FacilityStatus.closed:
        bg = AppColors.statusClosedBg;
        text = AppColors.statusClosedText;
        label = customLabel ?? 'Closed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTypography.statusPill.copyWith(
          color: text,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

