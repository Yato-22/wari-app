import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../navigation/app_routes.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? customTitle;
  final bool showBackButton;
  final bool showSosButton;
  final VoidCallback? onBack;
  final List<Widget>? extraActions;

  const AppTopBar({
    super.key,
    this.customTitle,
    this.showBackButton = false,
    this.showSosButton = true,
    this.onBack,
    this.extraActions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0.5,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      titleSpacing: showBackButton ? 0 : 16,
      title: customTitle != null
          ? Text(
              customTitle!,
              style: AppTypography.headlineLgMobile.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 6),
                RichText(
                  text: const TextSpan(
                    style: AppTypography.headlineLgMobile,
                    children: [
                      TextSpan(
                        text: 'Wari',
                        style: TextStyle(
                          color: AppColors.deepMaroon,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: 'Connect',
                        style: TextStyle(
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      actions: [
        if (extraActions != null) ...extraActions!,
        if (showSosButton)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.emergencySos);
                },
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.emergency,
                        color: AppColors.onError,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'SOS',
                        style: AppTypography.labelBold.copyWith(
                          color: AppColors.onError,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

