import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/widgets/common_typeahead_dropdown.dart';
import 'package:subqdocs_bloc/data/models/office_location_model.dart';
import 'package:subqdocs_bloc/data/models/staff_model.dart';
import 'package:subqdocs_bloc/data/models/visit_type_model.dart';
import 'package:subqdocs_bloc/features/home/presentation/bloc/home_screen_bloc.dart';
import 'package:subqdocs_bloc/features/patients/data/patient_list_row.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/patient_avatar_palette.dart';
import 'package:subqdocs_bloc/widgets/common_text_form_field.dart';
import 'package:flutter/cupertino.dart';

class HomeScheduleVisitPanel extends StatefulWidget {
  const HomeScheduleVisitPanel({super.key});

  @override
  State<HomeScheduleVisitPanel> createState() => _HomeScheduleVisitPanelState();
}

class _HomeScheduleVisitPanelState extends State<HomeScheduleVisitPanel> {
  late final TextEditingController _searchController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final ScrollController _patientSuggestionsScrollController;
  late final FocusNode _patientSearchFocusNode;
  late final SuggestionsController<PatientListRow>
  _patientSuggestionsController;
  late final TextEditingController _officeController;
  late final TextEditingController _providerController;
  late final TextEditingController _visitTypeController;
  late final TextEditingController _noteController;

  final LayerLink _dateLayerLink = LayerLink();
  final LayerLink _timeLayerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _patientSuggestionsScrollController = ScrollController();
    _patientSearchFocusNode = FocusNode();
    _patientSuggestionsController = SuggestionsController<PatientListRow>();
    _officeController = TextEditingController();
    _providerController = TextEditingController();
    _visitTypeController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _patientSuggestionsScrollController.dispose();
    _patientSearchFocusNode.dispose();
    _patientSuggestionsController.dispose();
    _officeController.dispose();
    _providerController.dispose();
    _visitTypeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (BuildContext context, HomeScreenState state) {
        if (state is! HomeScreenReady) {
          return const SizedBox.shrink();
        }

        _syncController(
          _searchController,
          state.scheduleVisitPatientSearchQuery,
        );
        _syncController(_firstNameController, state.scheduleVisitFirstName);
        _syncController(_lastNameController, state.scheduleVisitLastName);
        _syncController(
          _officeController,
          state.scheduleVisitOfficeLocation?.name ?? '',
        );
        _syncController(_providerController, state.scheduleVisitProvider != null ? 'Dr. ${state.scheduleVisitProvider!.name}' : '');
        _syncController(
          _visitTypeController,
          state.scheduleVisitType?.name ?? '',
        );
        _syncController(_noteController, state.scheduleVisitNote);

        final bool isPatientValid =
            state.scheduleVisitSelectedPatient != null ||
            (state.scheduleVisitIsAddingPatient &&
                state.scheduleVisitFirstName.isNotEmpty &&
                state.scheduleVisitLastName.isNotEmpty);

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              _ScheduleVisitHeader(
                onClose: () => Scaffold.of(context).closeEndDrawer(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  children: <Widget>[
                    _SectionHeader(
                      isAddingPatient: state.scheduleVisitIsAddingPatient,
                    ),
                    if (!state.scheduleVisitIsAddingPatient) ...<Widget>[
                      _RequiredLabel(
                        text: AppStrings.scheduleVisitSelectOrCreatePatient,
                      ),
                      const SizedBox(height: 8),
                      CommonTypeAheadDropdown<PatientListRow>(
                        controller: _searchController,
                        focusNode: _patientSearchFocusNode,
                        scrollController: _patientSuggestionsScrollController,
                        suggestionsController: _patientSuggestionsController,
                        hintText: AppStrings.scheduleVisitPatientSearchHint,
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: AppColors.blueGray,
                        ),
                        onChanged: (String value) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitPatientSearchChanged(
                              value,
                            ),
                          );
                        },
                        onClear: () {
                          _patientSuggestionsController.close(
                            retainFocus: false,
                          );
                          _patientSearchFocusNode.unfocus();
                          context.read<HomeScreenBloc>().add(
                            const HomeScreenScheduleVisitPatientSearchChanged(
                              '',
                            ),
                          );
                        },
                        suggestionsCallback: (String pattern) async {
                          final Completer<List<PatientListRow>> completer =
                              Completer<List<PatientListRow>>();
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitPatientSuggestionsRequested(
                              query: pattern,
                              completer: completer,
                            ),
                          );
                          return completer.future;
                        },
                        onSelected: (PatientListRow patient) {
                          _patientSuggestionsController.close(
                            retainFocus: false,
                          );
                          _patientSearchFocusNode.unfocus();
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitPatientSelected(patient),
                          );
                        },
                        header: _AddPatientTile(
                          onTap: () {
                            context.read<HomeScreenBloc>().add(
                              const HomeScreenScheduleVisitAddPatientSelected(),
                            );
                          },
                        ),
                        emptyBuilder: (BuildContext context) =>
                            const SizedBox.shrink(),
                        itemBuilder:
                            (BuildContext context, PatientListRow patient) {
                                return _PatientDropdownRow(
                                  patient: patient,
                                  showDivider: true,
                                );
                              },
                      ),
                    ] else ...<Widget>[
                      _RequiredLabel(
                        text: AppStrings.scheduleVisitFirstNameLabel,
                      ),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                        controller: _firstNameController,
                        hintText: AppStrings.scheduleVisitFirstNameLabel,
                        onChanged: (String value) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitFirstNameChanged(value),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      _RequiredLabel(
                        text: AppStrings.scheduleVisitLastNameLabel,
                      ),
                      const SizedBox(height: 8),
                      CommonTextFormField(
                        controller: _lastNameController,
                        hintText: AppStrings.scheduleVisitLastNameLabel,
                        onChanged: (String value) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitLastNameChanged(value),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 8),
                    const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
                    const SizedBox(height: 8),

                    // Visit Info Section
                    _PurpleHeader(text: 'Visit Info'),
                    const SizedBox(height: 8),

                    _RequiredLabel(text: 'Office Location'),
                    const SizedBox(height: 4),
                    CommonTypeAheadDropdown<OfficeLocationModel>(
                      controller: _officeController,
                      hintText: 'Select office',
                      suffixIcon: const Icon(
                        CupertinoIcons.chevron_down,
                        size: 18,
                        color: AppColors.blueGray,
                      ),
                      suggestionsCallback: (pattern) {
                        final list = state.allOfficeLocations;
                        // Return full list on focus or if match
                        if (pattern.isEmpty ||
                            state.scheduleVisitOfficeLocation?.name ==
                                pattern) {
                          return list;
                        }
                        return list
                            .where(
                              (l) => l.name.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                            )
                            .toList();
                      },
                      itemBuilder: (context, location) => ListTile(
                        dense: true,
                        title: Text(
                          location.name,
                          style: AppFonts.regular(14, AppColors.primaryText),
                        ),
                      ),
                      onSelected: (location) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitOfficeLocationChanged(
                            location,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    _FieldLabel(text: 'Provider'),
                    const SizedBox(height: 5),
                    CommonTypeAheadDropdown<StaffModel>(
                      controller: _providerController,
                      hintText: 'Select provider',
                      suffixIcon: const Icon(
                        CupertinoIcons.chevron_down,
                        size: 18,
                        color: AppColors.blueGray,
                      ),
                      suggestionsCallback: (pattern) {
                        final list = state.allProviders;
                        final currentName =
                            state.scheduleVisitProvider != null
                                ? 'Dr. ${state.scheduleVisitProvider!.name}'
                                : '';
                        if (pattern.isEmpty || currentName == pattern) {
                          return list;
                        }
                        return list
                            .where(
                              (p) => p.name.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                            )
                            .toList();
                      },
                      itemBuilder: (context, provider) => ListTile(
                        dense: true,
                        leading: _ProviderAvatar(provider: provider),
                        title: Text(
                          provider.name,
                          style: AppFonts.regular(14, AppColors.primaryText),
                        ),
                      ),
                      onSelected: (provider) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitProviderChanged(provider),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    _RequiredLabel(text: 'Visit Date'),
                    const SizedBox(height: 5),
                    CompositedTransformTarget(
                      link: _dateLayerLink,
                      child: _DatePickerButton(
                        date: state.scheduleVisitDate,
                        link: _dateLayerLink,
                        onChanged: (date) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitDateChanged(date),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    _RequiredLabel(text: 'Visit Time'),
                    const SizedBox(height: 5),
                    CompositedTransformTarget(
                      link: _timeLayerLink,
                      child: _TimePickerButton(
                        time: state.scheduleVisitTime,
                        link: _timeLayerLink,
                        onChanged: (time) {
                          context.read<HomeScreenBloc>().add(
                            HomeScreenScheduleVisitTimeChanged(time),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    _RequiredLabel(text: 'Visit Type'),
                    const SizedBox(height: 5),
                    CommonTypeAheadDropdown<VisitTypeModel>(
                      controller: _visitTypeController,
                      hintText: 'Select visit type',
                      suffixIcon: const Icon(
                        CupertinoIcons.chevron_down,
                        size: 18,
                        color: AppColors.blueGray,
                      ),
                      suggestionsCallback: (pattern) {
                        final list = state.allVisitTypes;
                        if (pattern.isEmpty ||
                            state.scheduleVisitType?.name == pattern) {
                          return list;
                        }
                        return list
                            .where(
                              (v) => v.name.toLowerCase().contains(
                                pattern.toLowerCase(),
                              ),
                            )
                            .toList();
                      },
                      itemBuilder: (context, type) => ListTile(
                        dense: true,
                        title: Text(
                          type.name,
                          style: AppFonts.regular(14, AppColors.primaryText),
                        ),
                      ),
                      onSelected: (type) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitTypeChanged(type),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    _FieldLabel(text: 'Appointment Note'),
                    const SizedBox(height: 5),
                    CommonTextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      hintText: 'Enter appointment note (optional)',
                      onChanged: (value) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitNoteChanged(value),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Financial Responsibility Section
                    _PurpleHeader(text: 'Financial Responsibility'),
                    const SizedBox(height: 10),

                    _RequiredLabel(text: 'Payment Method'),
                    const SizedBox(height: 5),
                    _SimpleDropdown(
                      value: state.scheduleVisitPaymentMethod,
                      items: const [
                        'None/Self-Pay',
                        'Medical Insurance',
                        'Other',
                      ],
                      onChanged: (value) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitPaymentMethodChanged(value),
                        );
                      },
                      hintText: 'Select payment method',
                    ),
                    const SizedBox(height: 10),

                    _RequiredLabel(text: 'Reportable Reason for Visit'),
                    const SizedBox(height: 5),
                    _SimpleDropdown(
                      value: state.scheduleVisitReason,
                      items: const [
                        'Medical Non-Emergency',
                        'Cosmetic',
                        'Other',
                      ],
                      onChanged: (value) {
                        context.read<HomeScreenBloc>().add(
                          HomeScreenScheduleVisitReasonChanged(value),
                        );
                      },
                      hintText: 'Select reason',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _syncController(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }
    controller.value = controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }
}

class _ScheduleVisitHeader extends StatelessWidget {
  const _ScheduleVisitHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: AppColors.scheduleVisitAccent,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppStrings.homeScheduleVisit,
            style: AppFonts.medium(16, AppColors.white),
          ),
          InkWell(
            onTap: onClose,
            child: const Icon(Icons.close, color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.isAddingPatient});

  final bool isAddingPatient;

  @override
  Widget build(BuildContext context) {
    if (!isAddingPatient) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          AppStrings.scheduleVisitNewPatientInformation,
          style: AppFonts.medium(14, AppColors.primaryText),
        ),
        InkWell(
          onTap: () {
            context.read<HomeScreenBloc>().add(
              const HomeScreenScheduleVisitSearchExistingPatientSelected(),
            );
          },
          child: Text(
            AppStrings.scheduleVisitSearchExistingPatient,
            style: AppFonts.medium(14, AppColors.scheduleVisitAccent),
          ),
        ),
      ],
    );
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(text: text, style: AppFonts.regular(14, AppColors.black)),
          TextSpan(text: ' *', style: AppFonts.regular(14, AppColors.red)),
        ],
      ),
    );
  }
}

class _AddPatientTile extends StatelessWidget {
  const _AddPatientTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.chipSelectedBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person_add_alt_1,
                  color: AppColors.scheduleVisitAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.scheduleVisitAddNewPatient,
                      style: AppFonts.medium(16, AppColors.scheduleVisitAccent),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.scheduleVisitAddNewPatientSubtitle,
                      style: AppFonts.regular(14, AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientDropdownRow extends StatelessWidget {
  const _PatientDropdownRow({required this.patient, required this.showDivider});

  final PatientListRow patient;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: <Widget>[
              _PatientAvatar(patient: patient),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  patient.fullName,
                  style: AppFonts.regular(14, AppColors.primaryText),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.fieldBorder),
      ],
    );
  }
}

class _PatientAvatar extends StatelessWidget {
  const _PatientAvatar({required this.patient});

  final PatientListRow patient;

  @override
  Widget build(BuildContext context) {
    final Color background = PatientAvatarPalette.backgroundForPatientId(
      patient.id,
    );
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Text(
        patient.initials,
        style: AppFonts.medium(11, AppColors.white),
      ),
    );
  }
}

class _PurpleHeader extends StatelessWidget {
  const _PurpleHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppFonts.medium(16, const Color(0xFF5B5BE1)));
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppFonts.regular(14, AppColors.black));
  }
}

/// Helper to determine if an overlay should open above or below the target.
Positioned _buildSmartOverlay({
  required BuildContext context,
  required LayerLink link,
  required Widget child,
  required double overlayHeight,
}) {
  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;
  final offset = renderBox.localToGlobal(Offset.zero);
  final screenHeight = MediaQuery.of(context).size.height;

  // Check if there is enough space below (current height + 5px gap + overlay height)
  final bool showAbove = (offset.dy + size.height + overlayHeight + 20) > screenHeight;

  return Positioned(
    width: size.width,
    child: CompositedTransformFollower(
      link: link,
      showWhenUnlinked: false,
      offset: Offset(0, showAbove ? -overlayHeight - 5 : size.height + 5),
      child: Material(
        elevation: 8,
        shadowColor: AppColors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    ),
  );
}

class _DatePickerButton extends StatefulWidget {
  const _DatePickerButton({required this.date, required this.onChanged, required this.link});
  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  final LayerLink link;

  @override
  State<_DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<_DatePickerButton> {
  OverlayEntry? _overlayEntry;

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    const double h = 330;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildSmartOverlay(
            context: this.context,
            link: widget.link,
            overlayHeight: h,
            child: Container(
              height: h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.scheduleVisitAccent,
                    onPrimary: AppColors.white,
                    onSurface: AppColors.primaryText,
                  ),
                ),
                child: CalendarDatePicker(
                  initialDate: widget.date ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  onDateChanged: (DateTime d) {
                    widget.onChanged(d);
                    _toggleOverlay();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formatted =
        widget.date == null
            ? 'Select date'
            : '${widget.date!.month}/${widget.date!.day}/${widget.date!.year}';

    return InkWell(
      onTap: _toggleOverlay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatted, style: AppFonts.regular(14, AppColors.primaryText)),
            const Icon(
              Icons.calendar_today,
              size: 18,
              color: AppColors.blueGray,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePickerButton extends StatefulWidget {
  const _TimePickerButton({required this.time, required this.onChanged, required this.link});
  final DateTime? time;
  final ValueChanged<DateTime> onChanged;
  final LayerLink link;

  @override
  State<_TimePickerButton> createState() => _TimePickerButtonState();
}

class _TimePickerButtonState extends State<_TimePickerButton> {
  OverlayEntry? _overlayEntry;

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    const double h = 250;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildSmartOverlay(
            context: this.context,
            link: widget.link,
            overlayHeight: h,
            child: Container(
              height: h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: widget.time ?? DateTime.now(),
                minuteInterval: 1,
                use24hFormat: false,
                onDateTimeChanged: (DateTime d) {
                  widget.onChanged(d);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formatted = 'Select time';
    if (widget.time != null) {
      final hour =
          widget.time!.hour > 12
              ? widget.time!.hour - 12
              : (widget.time!.hour == 0 ? 12 : widget.time!.hour);
      final amPm = widget.time!.hour >= 12 ? 'PM' : 'AM';
      final min = widget.time!.minute.toString().padLeft(2, '0');
      formatted = '$hour:$min $amPm';
    }

    return InkWell(
      onTap: _toggleOverlay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textFieldBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formatted, style: AppFonts.regular(14, AppColors.primaryText)),
            const Icon(Icons.access_time, size: 18, color: AppColors.blueGray),
          ],
        ),
      ),
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.provider});
  final StaffModel provider;

  @override
  Widget build(BuildContext context) {
    if (provider.profileImage != null && provider.profileImage!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(provider.profileImage!),
      );
    }
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.chipSelectedBackground,
      child: Text(
        provider.name.substring(0, 1).toUpperCase(),
        style: AppFonts.medium(12, AppColors.scheduleVisitAccent),
      ),
    );
  }
}

class _SimpleDropdown extends StatefulWidget {
  const _SimpleDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
  });

  final String? value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final String? hintText;

  @override
  State<_SimpleDropdown> createState() => _SimpleDropdownState();
}

class _SimpleDropdownState extends State<_SimpleDropdown> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleOverlay() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    final double h = widget.items.length * 48.0 + 10;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildSmartOverlay(
            context: this.context,
            link: _link,
            overlayHeight: h,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.items.map((item) {
                  final bool isSelected = item == widget.value;
                  return InkWell(
                    onTap: () {
                      widget.onChanged(item);
                      _toggleOverlay();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: isSelected ? const Color(0xFFF3F4F6) : Colors.transparent,
                      child: Text(
                        item,
                        style: AppFonts.regular(14, AppColors.primaryText),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: InkWell(
        onTap: _toggleOverlay,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textFieldBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.value ?? widget.hintText ?? 'Select',
                style: AppFonts.regular(
                  14,
                  widget.value == null ? AppColors.blueGray : AppColors.primaryText,
                ),
              ),
              const Icon(
                CupertinoIcons.chevron_down,
                size: 18,
                color: AppColors.blueGray,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
