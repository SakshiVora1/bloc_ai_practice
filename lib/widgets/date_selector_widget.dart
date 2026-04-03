import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_fonts.dart';
import 'icon_button_widget.dart';

/// Previous / date label / next strip. Opens [onCenterTap] for calendar popup.
class DateSelectorWidget extends StatelessWidget {
  const DateSelectorWidget({
    super.key,
    required this.displayLabel,
    required this.onPrevious,
    required this.onNext,
    required this.onCenterTap,
  });

  final String displayLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onCenterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButtonWidget(icon: Icons.chevron_left, onPressed: onPrevious),
        const SizedBox(width: 8),
        _DatePill(label: displayLabel, onTap: onCenterTap),
        const SizedBox(width: 8),
        IconButtonWidget(icon: Icons.chevron_right, onPressed: onNext),
      ],
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.fieldBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                label,
                style: AppFonts.medium(14, AppColors.primaryText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
