import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';

/// Scrim + panel aligned to the trailing edge of the screen.
class RightSidePanel extends StatelessWidget {
  const RightSidePanel({
    super.key,
    required this.child,
    required this.onDismiss,
    this.widthFactor = 0.42,
  });

  final Widget child;
  final VoidCallback onDismiss;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    final double panelWidth = (w * widthFactor).clamp(280.0, 420.0);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onDismiss,
            child: const ColoredBox(color: AppColors.panelScrim),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Material(
            elevation: 8,
            color: AppColors.panelBackground,
            child: SizedBox(
              width: panelWidth,
              height: double.infinity,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
