import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';

class PatientsSearchBar extends StatelessWidget {
  const PatientsSearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  static const double _width = 180;
  static const double _height = 40;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        final bool showClear = controller.text.isNotEmpty;
        return SizedBox(
          width: _width,
          height: _height,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            style: AppFonts.regular(14, AppColors.primaryText),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: AppStrings.patientsSearchHint,
              hintStyle: AppFonts.regular(14, AppColors.blueGray),
              isDense: true,
              contentPadding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: 10,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 20,
                color: AppColors.blueGray,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 36,
                minHeight: _height,
              ),
              suffixIcon: showClear
                  ? IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.close, size: 18),
                      color: AppColors.blueGray,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: _height,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.textFieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.textFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryAction),
              ),
            ),
          ),
        );
      },
    );
  }
}
