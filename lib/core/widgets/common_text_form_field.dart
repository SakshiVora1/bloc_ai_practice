import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:subqdocs_bloc/core/constants/app_colors.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.onTap,
    this.onChanged,
    this.readOnly,
    this.maxLines,
    this.maxColor,
    this.fillColor,
    this.validator,
    this.obscureText,
    this.textCapitalization,
    this.hintText,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool? readOnly;
  final int? maxLines;
  final Color? maxColor;
  final Color? fillColor;
  final FormFieldValidator<String>? validator;
  final bool? obscureText;
  final TextCapitalization? textCapitalization;
  final String? hintText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final TextCapitalization resolvedTextCapitalization =
        textCapitalization ??
        (keyboardType == TextInputType.emailAddress
            ? TextCapitalization.none
            : TextCapitalization.sentences);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly ?? false,
      maxLines: obscureText == true ? 1 : (maxLines ?? 1),
      style: TextStyle(color: maxColor),
      cursorColor: maxColor,
      validator: validator,
      obscureText: obscureText ?? false,
      textCapitalization: resolvedTextCapitalization,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.only(
          left: 10,
          top: 4,
          bottom: 4,
          right: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.textFieldBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.textFieldBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.textFieldBorder,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(width: 1, color: AppColors.error),
        ),
      ),
    );
  }
}
