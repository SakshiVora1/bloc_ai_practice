import 'package:flutter/material.dart';

import '../core/constants/app_fonts.dart';

/// Horizontal placement of [CommonButton.icon] relative to the label.
enum CommonButtonIconPosition {
  /// Icon appears before the label (start / left in LTR).
  leading,

  /// Icon appears after the label (end / right in LTR).
  trailing,
}

/// Filled action button with optional leading/trailing icon, loading, and
/// disabled states. No business logic — presentation only.
class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.iconPosition = CommonButtonIconPosition.leading,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = defaultBorderRadius,
    this.height,
    this.width,
    this.padding,
    this.elevation,
    this.fontSize,
    this.fontWeight,
    this.iconSpacing = defaultIconSpacing,
    this.isLoading = false,
    this.isDisabled = false,
    this.disabledOpacity = 0.5,
    this.loaderStrokeWidth = 2,
    this.loaderSize = 22,
  });

  static const double defaultBorderRadius = 8;
  static const double defaultIconSpacing = 8;

  /// Visible label when not [isLoading].
  final String label;

  /// Called when the button is pressed. Ignored while [isLoading] or
  /// [isDisabled] is true.
  final VoidCallback? onPressed;

  /// Optional icon shown beside the label (hidden while [isLoading]).
  final Widget? icon;

  /// Whether [icon] is drawn before or after [label].
  final CommonButtonIconPosition iconPosition;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double iconSpacing;

  /// When true, shows a centered [CircularProgressIndicator] and ignores taps.
  final bool isLoading;

  /// When true, ignores taps and applies [disabledOpacity].
  final bool isDisabled;

  /// Opacity when not interactive ([isLoading] or [isDisabled]).
  final double disabledOpacity;

  final double loaderStrokeWidth;
  final double loaderSize;

  bool get _canInvoke => onPressed != null && !isLoading && !isDisabled;

  bool get _showReducedOpacity => isDisabled || isLoading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    final Color resolvedBackground = backgroundColor ?? scheme.primary;
    final Color resolvedForeground = textColor ?? scheme.onPrimary;
    final BorderSide? side = borderColor != null
        ? BorderSide(color: borderColor!, width: borderWidth)
        : null;

    final double resolvedFontSize = fontSize ?? 16;
    final FontWeight resolvedWeight = fontWeight ?? FontWeight.w600;

    final TextStyle labelStyle = AppFonts.getTextStyle(
      fontSize: resolvedFontSize,
      fontWeight: resolvedWeight,
      color: resolvedForeground,
    );

    final EdgeInsetsGeometry effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    final double minHeight = height ?? kMinInteractiveDimension;

    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: elevation,
      backgroundColor: resolvedBackground,
      foregroundColor: resolvedForeground,
      disabledForegroundColor: resolvedForeground,
      disabledBackgroundColor: resolvedBackground,
      padding: effectivePadding,
      minimumSize: Size(0, minHeight),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: side ?? BorderSide.none,
      ),
    );

    final Widget buttonChild = isLoading
        ? SizedBox(
            width: loaderSize,
            height: loaderSize,
            child: CircularProgressIndicator(
              strokeWidth: loaderStrokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(resolvedForeground),
            ),
          )
        : _LabelRow(
            iconSpacing: iconSpacing,
            icon: icon,
            label: label,
            labelStyle: labelStyle,
            iconPosition: iconPosition,
          );

    Widget button = ElevatedButton(
      onPressed: _canInvoke ? onPressed : null,
      style: style,
      child: buttonChild,
    );

    if (width != null || height != null) {
      button = SizedBox(width: width, height: height, child: button);
    }

    if (_showReducedOpacity) {
      button = Opacity(opacity: disabledOpacity, child: button);
    }

    return button;
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({
    required this.iconSpacing,
    required this.icon,
    required this.label,
    required this.labelStyle,
    required this.iconPosition,
  });

  final double iconSpacing;
  final Widget? icon;
  final String label;
  final TextStyle labelStyle;
  final CommonButtonIconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final Widget text = Text(
      label,
      style: labelStyle,
      textAlign: TextAlign.center,
    );

    if (icon == null) {
      return text;
    }

    final Widget gap = SizedBox(width: iconSpacing);

    switch (iconPosition) {
      case CommonButtonIconPosition.leading:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon!,
            gap,
            Flexible(child: text),
          ],
        );
      case CommonButtonIconPosition.trailing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: text),
            gap,
            icon!,
          ],
        );
    }
  }
}
