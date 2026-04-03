import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Rounded icon-only control for toolbars (e.g. date arrows).
class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.borderRadius = 10,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final Color resolvedBg = backgroundColor ?? AppColors.white;
    final Color resolvedIcon = iconColor ?? AppColors.primaryText;
    final BorderSide side = borderColor != null
        ? BorderSide(color: borderColor!)
        : const BorderSide(color: AppColors.fieldBorder);

    return Material(
      color: resolvedBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: side,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: 22, color: resolvedIcon),
        ),
      ),
    );
  }
}
