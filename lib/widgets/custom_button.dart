import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum ButtonVariant {
  primary,
  secondary,
  saffronBright,
  danger,
  ghost,
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final IconData? icon;
  final bool iconTrailing;
  final bool isLoading;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.iconTrailing = false,
    this.isLoading = false,
    this.height = 48,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case ButtonVariant.primary:
        bg = AppColors.primary;
        fg = AppColors.onPrimary;
        break;
      case ButtonVariant.saffronBright:
        bg = AppColors.primaryContainer;
        fg = AppColors.onPrimaryContainer;
        break;
      case ButtonVariant.secondary:
        bg = Colors.transparent;
        fg = AppColors.secondary;
        borderSide = const BorderSide(color: AppColors.secondary, width: 1.5);
        break;
      case ButtonVariant.danger:
        bg = AppColors.error;
        fg = AppColors.onError;
        break;
      case ButtonVariant.ghost:
        bg = Colors.transparent;
        fg = AppColors.primary;
        break;
    }

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null && !iconTrailing) ...[
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: AppTypography.labelBold.copyWith(
            color: fg,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (icon != null && iconTrailing) ...[
          const SizedBox(width: 8),
          Icon(icon, size: 20, color: fg),
        ],
      ],
    );

    if (isLoading) {
      content = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fg),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: borderSide,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}

