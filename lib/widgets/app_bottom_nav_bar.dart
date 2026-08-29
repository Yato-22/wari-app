import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../models/app_state.dart';
import '../models/user_profile.dart';
import '../navigation/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [AppColors.bottomNavShadow],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.map,
                label: AppStateScope.of(context).translate('map'),
                route: AppRoutes.homeMap,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.volunteer_activism,
                label: AppStateScope.of(context).translate('volunteer'),
                route: AppRoutes.volunteerOpportunities,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.report_problem_outlined,
                label: AppStateScope.of(context).translate('reports'),
                route: AppRoutes.activityTracker,
              ),
            ),
            Expanded(
              child: _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.person_outline,
                label: AppStateScope.of(context).translate('profile'),
                route: AppRoutes.profileGuest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(index);
        } else {
          if (!isSelected) {
            if (index == 3) {
              final appState = AppStateScope.of(context);
              if (appState.isLoggedIn) {
                if (appState.user.role == UserRole.organiser) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.profileOrgManagement);
                } else {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.profileLoggedIn);
                }
              } else {
                Navigator.of(context).pushReplacementNamed(AppRoutes.profileGuest);
              }
            } else {
              Navigator.of(context).pushReplacementNamed(route);
            }
          }
        }
      },
      borderRadius: BorderRadius.circular(9999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: AppTypography.labelBold.copyWith(
                  fontSize: 11,
                  color: isSelected
                      ? AppColors.onPrimaryContainer
                      : AppColors.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

