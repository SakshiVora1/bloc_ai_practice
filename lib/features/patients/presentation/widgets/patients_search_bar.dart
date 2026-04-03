import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/features/patients/presentation/bloc/patients_screen_bloc.dart';

class PatientsSearchBar extends StatefulWidget {
  const PatientsSearchBar({super.key});

  @override
  State<PatientsSearchBar> createState() => _PatientsSearchBarState();
}

class _PatientsSearchBarState extends State<PatientsSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientsScreenBloc, PatientsScreenState>(
      buildWhen: (PatientsScreenState previous, PatientsScreenState current) {
        return previous is PatientsScreenReady &&
            current is PatientsScreenReady &&
            previous.searchQuery != current.searchQuery;
      },
      builder: (BuildContext context, PatientsScreenState state) {
        if (state is PatientsScreenReady) {
          if (state.searchQuery != _controller.text) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              _controller.value = TextEditingValue(
                text: state.searchQuery,
                selection: TextSelection.collapsed(
                  offset: state.searchQuery.length,
                ),
              );
            });
          }
        }
        final bool showClear = _controller.text.trim().isNotEmpty;
        return SizedBox(
          width: 180,
          height: 40,
          child: TextField(
            controller: _controller,
            onChanged: (String value) {
              setState(() {});
              context.read<PatientsScreenBloc>().add(
                PatientsSearchInputChanged(value),
              );
            },
            style: AppFonts.regular(14, AppColors.primaryText),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppStrings.patientsSearchHint,
              hintStyle: AppFonts.regular(14, AppColors.secondaryText),
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AppColors.textFieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AppColors.textFieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppColors.drawerItemSelected,
                ),
              ),
              suffixIcon: showClear
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      color: AppColors.blueGray,
                      onPressed: () {
                        _controller.clear();
                        setState(() {});
                        context.read<PatientsScreenBloc>().add(
                          const PatientsSearchClearRequested(),
                        );
                      },
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
