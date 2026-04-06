import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/domain/patients_row_menu_action.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patient_cell_formatters.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_action_menu_button.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_patient_name_cell.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_cell_style.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_metrics.dart';

class PatientsTableDataRow extends StatelessWidget {
  const PatientsTableDataRow({
    required this.row,
    required this.onNameTap,
    required this.onMenuAction,
    super.key,
  });

  final PatientListRow row;
  final VoidCallback onNameTap;
  final ValueChanged<PatientsRowMenuAction> onMenuAction;

  @override
  Widget build(BuildContext context) {
    final TextStyle cellStyle = PatientsTableCellStyle.body;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: PatientsTableMetrics.flexPatientName,
          child: InkWell(
            onTap: onNameTap,
            child: Align(
              alignment: Alignment.centerLeft,
              child: PatientsPatientNameCell(row: row),
            ),
          ),
        ),
        Expanded(
          flex: PatientsTableMetrics.flexAge,
          child: _CenteredCell(
            text: PatientCellFormatters.ageOrNa(row.age),
            style: cellStyle,
            padding: PatientsTableMetrics.dataAgeColumnPadding,
          ),
        ),
        Expanded(
          flex: PatientsTableMetrics.flexGender,
          child: _CenteredCell(
            text: PatientCellFormatters.genderInitial(row.genderRaw),
            style: cellStyle,
            padding: PatientsTableMetrics.dataCompactColumnPadding,
          ),
        ),
        Expanded(
          flex: PatientsTableMetrics.flexLastVisit,
          child: _CenteredCell(
            text: PatientCellFormatters.lastVisitOrNa(row.lastVisitDate),
            style: cellStyle,
            padding: PatientsTableMetrics.dataCompactColumnPadding,
            scaleToFit: true,
          ),
        ),
        Expanded(
          flex: PatientsTableMetrics.flexPreviousVisits,
          child: _CenteredCell(
            text: '${row.previousVisitCount}',
            style: cellStyle,
            padding: PatientsTableMetrics.dataCompactColumnPadding,
          ),
        ),
        Expanded(
          flex: PatientsTableMetrics.flexAction,
          child: Padding(
            padding: const EdgeInsets.only(
              right: PatientsTableMetrics.actionTrailingInset,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: PatientsActionMenuButton(onSelected: onMenuAction),
            ),
          ),
        ),
      ],
    );
  }
}

class _CenteredCell extends StatelessWidget {
  const _CenteredCell({
    required this.text,
    required this.style,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    this.scaleToFit = false,
  });

  final String text;
  final TextStyle style;
  final EdgeInsets padding;
  final bool scaleToFit;

  @override
  Widget build(BuildContext context) {
    final Text textWidget = Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      softWrap: false,
      overflow: scaleToFit ? TextOverflow.visible : TextOverflow.ellipsis,
      style: style,
    );

    return Padding(
      padding: padding,
      child: Center(
        child: scaleToFit
            ? FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: textWidget,
              )
            : textWidget,
      ),
    );
  }
}
