import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_fonts.dart';

/// Shared text field with consistent borders and optional focus/submit wiring.
class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.readOnly,
    this.maxLines,
    this.maxColor,
    this.fillColor,
    this.validator,
    this.obscureText,
    this.hintText,
    this.enabled = true,
    this.style,
    this.borderRadius = 6,
    this.focusedBorderColor,
    this.contentPadding = const EdgeInsets.only(
      left: 10,
      top: 4,
      bottom: 4,
      right: 10,
    ),
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool? readOnly;
  final int? maxLines;
  final Color? maxColor;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final String? hintText;
  final bool enabled;
  final TextStyle? style;
  final double borderRadius;
  final Color? focusedBorderColor;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(width: 1, color: AppColors.textFieldBorder),
    );
    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(width: 1, color: AppColors.red),
    );
    final Color focusSideColor =
        focusedBorderColor ?? AppColors.textFieldBorder;
    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(width: 1, color: focusSideColor),
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      enabled: enabled,
      cursorColor: maxColor,
      style: style,
      validator: validator,
      obscureText: obscureText ?? false,
      textCapitalization: keyboardType == TextInputType.emailAddress
          ? TextCapitalization.none
          : TextCapitalization.sentences,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? AppColors.white,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: AppFonts.regular(14, AppColors.blueGray),
        errorStyle: AppFonts.regular(14, AppColors.red),
        contentPadding: contentPadding,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
