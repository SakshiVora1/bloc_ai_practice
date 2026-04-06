import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_sort_column.dart';

class PatientsSortableHeaderCell extends StatelessWidget {
  const PatientsSortableHeaderCell({
    required this.label,
    required this.column,
    required this.textAlign,
    required this.onPressed,
    required this.isActive,
    required this.descending,
    this.padding,
    super.key,
  });

  final String label;
  final PatientSortColumn column;
  final TextAlign textAlign;
  final VoidCallback onPressed;
  final bool isActive;
  final bool descending;

  /// When null, [defaultPadding] is used.
  final EdgeInsetsGeometry? padding;

  static const EdgeInsetsGeometry defaultPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );

  static const double _iconReserve = 24;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = AppFonts.regular(14, AppColors.black);
    final EdgeInsetsGeometry resolvedPadding = padding ?? defaultPadding;
    final Alignment align = textAlign == TextAlign.start
        ? Alignment.centerLeft
        : Alignment.center;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: resolvedPadding,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double iconW = isActive ? _iconReserve : 0.0;
            final double maxLabel = (constraints.maxWidth - iconW).clamp(
              0.0,
              double.infinity,
            );
            return Align(
              alignment: align,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxLabel),
                    child: Text(
                      label,
                      textAlign: textAlign,
                      maxLines: 2,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: style,
                    ),
                  ),
                  if (isActive) ...<Widget>[
                    const SizedBox(width: 4),
                    Icon(
                      descending ? Icons.arrow_downward : Icons.arrow_upward,
                      size: 16,
                      color: AppColors.black,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
