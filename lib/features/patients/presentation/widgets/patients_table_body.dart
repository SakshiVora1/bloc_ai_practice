import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_pagination_bar.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_data_row.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patients_table_header_row.dart';

class PatientsTableBody extends StatelessWidget {
  const PatientsTableBody({required this.state, super.key});

  final PatientsScreenReady state;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double minWidth = math.max(640, constraints.maxWidth);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth),
            child: SizedBox(
              width: minWidth,
              height: constraints.maxHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  if (state.isListLoading)
                    const LinearProgressIndicator(
                      minHeight: 2,
                      color: AppColors.drawerItemSelected,
                    ),
                  const PatientsTableHeaderRow(),
                  Expanded(
                    child: state.rows.isEmpty
                        ? Center(
                            child: Text(
                              AppStrings.homeNoVisitsFound,
                              style: AppFonts.regular(14, AppColors.blueGray),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: state.rows.length,
                            itemBuilder: (BuildContext context, int index) {
                              return PatientsTableDataRow(
                                row: state.rows[index],
                              );
                            },
                          ),
                  ),
                  const PatientsPaginationBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
