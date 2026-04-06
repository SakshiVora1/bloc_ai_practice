import 'package:flutter/material.dart';

/// Layout: six [Expanded] columns; flex = `(fraction * 1000).round()`.
abstract final class PatientsTableMetrics {
  PatientsTableMetrics._();

  static int _columnFlex(double fraction) => (fraction * 1000).round();

  /// Patient name — 0.25.
  static final int flexPatientName = _columnFlex(0.25);

  /// Age — 0.10.
  static final int flexAge = _columnFlex(0.10);

  /// Gender — 0.14.
  static final int flexGender = _columnFlex(0.11);

  /// Last visit — 0.21.
  static final int flexLastVisit = _columnFlex(0.19);

  /// Previous visits — 0.21.
  static final int flexPreviousVisits = _columnFlex(0.19);

  /// Action — 0.085.
  static final int flexAction = _columnFlex(0.095);

  static const EdgeInsets headerNamePadding = EdgeInsets.fromLTRB(
    16,
    10,
    0,
    10,
  );

  /// Age column: no left inset (flush after name column).
  static const EdgeInsets headerAgeColumnPadding = EdgeInsets.fromLTRB(
    0,
    10,
    16,
    10,
  );

  /// Shared tight padding inside sortable header cells (non-name).
  static const EdgeInsets headerCompactColumnPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );

  /// Shared tight padding for body cells (non-name, non-age tight).
  static const EdgeInsets dataCompactColumnPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 5,
  );

  static const EdgeInsets dataAgeColumnPadding = EdgeInsets.fromLTRB(
    0,
    5,
    16,
    5,
  );

  /// Breathing room past Action (header + rows).
  static const double actionTrailingInset = 16;
}
