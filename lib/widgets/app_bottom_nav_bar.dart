import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../models/app_state.dart';
import '../models/user_profile.dart';
import '../navigation/app_routes.dart';

class _NavTab {
  final String id;
  final IconData icon;
  final String label;
  final String route;

  const _NavTab({
    required this.id,
    required this.icon,
    required this.label,
    required this.route,
  });
}

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final String? currentTab;
  final ValueChanged<int>? onTap;

  const AppBottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.currentTab,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final tabs = _getTabsForRole(appState);

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
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _isTabSelected(tab, index, appState);

            return Expanded(
              child: _buildNavItem(
                context: context,
                index: index,
                tab: tab,
                isSelected: isSelected,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<_NavTab> _getTabsForRole(AppState appState) {
    if (appState.isGuest) {
      // 1. Guest: Map | Profile
      return [
        _NavTab(
          id: 'map',
          icon: Icons.map,
          label: appState.translate('map'),
          route: AppRoutes.homeMap,
        ),
        _NavTab(
          id: 'profile',
          icon: Icons.person_outline,
          label: appState.translate('profile'),
          route: AppRoutes.profileGuest,
        ),
      ];
    }

    final role = appState.user.role;
    if (role == UserRole.volunteer) {
      // 3. Volunteer: Map | Volunteer | Profile
      return [
        _NavTab(
          id: 'map',
          icon: Icons.map,
          label: appState.translate('map'),
          route: AppRoutes.homeMap,
        ),
        _NavTab(
          id: 'volunteer',
          icon: Icons.volunteer_activism,
          label: appState.translate('volunteer'),
          route: AppRoutes.volunteerOpportunities,
        ),
        _NavTab(
          id: 'profile',
          icon: Icons.person_outline,
          label: appState.translate('profile'),
          route: AppRoutes.profileLoggedIn,
        ),
      ];
    } else if (role == UserRole.organiser) {
      // Organiser: Map | Reports | Profile
      return [
        _NavTab(
          id: 'map',
          icon: Icons.map,
          label: appState.translate('map'),
          route: AppRoutes.homeMap,
        ),
        _NavTab(
          id: 'report',
          icon: Icons.report_problem_outlined,
          label: appState.translate('reports'),
          route: AppRoutes.activityTracker,
        ),
        _NavTab(
          id: 'profile',
          icon: Icons.person_outline,
          label: appState.translate('profile'),
          route: AppRoutes.profileOrgManagement,
        ),
      ];
    } else {
      // 2. Warkari: Map | Report | Profile
      return [
        _NavTab(
          id: 'map',
          icon: Icons.map,
          label: appState.translate('map'),
          route: AppRoutes.homeMap,
        ),
        _NavTab(
          id: 'report',
          icon: Icons.report_problem_outlined,
          label: appState.translate('reports'),
          route: AppRoutes.activityTracker,
        ),
        _NavTab(
          id: 'profile',
          icon: Icons.person_outline,
          label: appState.translate('profile'),
          route: AppRoutes.profileLoggedIn,
        ),
      ];
    }
  }

  bool _isTabSelected(_NavTab tab, int index, AppState appState) {
    if (currentTab != null) {
      return tab.id == currentTab;
    }
    // Fallback based on currentIndex mapping
    if (currentIndex == 0) return tab.id == 'map';
    if (currentIndex == 1) {
      if (appState.isGuest) return tab.id == 'profile';
      if (appState.user.role == UserRole.volunteer) return tab.id == 'volunteer';
      return tab.id == 'report';
    }
    if (currentIndex == 2) {
      if (appState.isGuest) return false;
      return tab.id == 'profile' || tab.id == 'report';
    }
    if (currentIndex == 3) return tab.id == 'profile';
    return false;
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required _NavTab tab,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(index);
        } else {
          if (!isSelected) {
            Navigator.of(context).pushReplacementNamed(tab.route);
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
              tab.icon,
              size: 20,
              color: isSelected
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                tab.label,
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

