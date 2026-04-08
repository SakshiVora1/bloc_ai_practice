import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';

class EditPanelFieldHelpers {
  static const double fieldGap = 12;
  static const double sectionGap = 16;
  static const double labelToFieldGap = 8;

  static Widget fieldLabel(String text) {
    return Text(text, style: AppFonts.regular(12, AppColors.primaryText));
  }

  static Widget twoColumnRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: left),
        const SizedBox(width: fieldGap),
        Expanded(child: right),
      ],
    );
  }

  static Widget fullWidthField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        fieldLabel(label),
        const SizedBox(height: labelToFieldGap),
        field,
      ],
    );
  }
}
