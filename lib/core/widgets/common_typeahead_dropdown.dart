import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';

class CommonTypeAheadDropdown<T> extends StatelessWidget {
  const CommonTypeAheadDropdown({
    super.key,
    required this.controller,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSelected,
    this.focusNode,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onClear,
    this.header,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.debounceDuration = const Duration(milliseconds: 400),
    this.borderRadius = 6,
    this.scrollController,
    this.suggestionsController,
  });

  final TextEditingController controller;
  final SuggestionsCallback<T> suggestionsCallback;
  final SuggestionsItemBuilder<T> itemBuilder;
  final SuggestionSelectionCallback<T> onSelected;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? header;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final SuggestionsErrorBuilder? errorBuilder;
  final Duration debounceDuration;
  final double borderRadius;
  final ScrollController? scrollController;
  final SuggestionsController<T>? suggestionsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? child) {
        return TypeAheadField<T>(
          controller: controller,
          focusNode: focusNode,
          suggestionsController: suggestionsController,
          debounceDuration: debounceDuration,
          suggestionsCallback: suggestionsCallback,
          onSelected: (T value) {
            suggestionsController?.close(retainFocus: false);
            focusNode?.unfocus();
            onSelected(value);
            // Reset selection and scroll to start for long text visibility
            controller.selection = const TextSelection.collapsed(offset: 0);
          },
          hideOnEmpty: false,
          hideOnError: false,
          hideOnLoading: false,
          constraints: const BoxConstraints(maxHeight: 250),
          scrollController: scrollController,
          builder:
              (
                BuildContext context,
                TextEditingController fieldController,
                FocusNode fieldFocusNode,
              ) {
                return TextField(
                  controller: fieldController,
                  focusNode: fieldFocusNode,
                  onChanged: onChanged,
                  style: AppFonts.regular(14, AppColors.primaryText),
                  cursorColor: AppColors.primaryAction,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    hintText: hintText,
                    hintStyle: AppFonts.regular(14, AppColors.blueGray),
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon ??
                        (controller.text.isNotEmpty && onClear != null
                            ? IconButton(
                              onPressed: onClear,
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.blueGray,
                              ),
                            )
                            : null),
                    contentPadding: const EdgeInsets.only(
                      left: 10,
                      top: 4,
                      bottom: 4,
                      right: 10,
                    ),
                    border: _border(AppColors.textFieldBorder),
                    enabledBorder: _border(AppColors.textFieldBorder),
                    focusedBorder: _border(AppColors.primaryAction),
                  ),
                  onTap: () {
                    // Open suggestions immediately on tap
                    suggestionsController?.open();
                  },
                );
              },
          decorationBuilder: (BuildContext context, Widget child) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: child,
            );
          },
          loadingBuilder: (BuildContext context) {
            return _dropdownContent(
              context: context,
              child:
                  loadingBuilder?.call(context) ??
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
            );
          },
          emptyBuilder: (BuildContext context) {
            return _dropdownContent(
              context: context,
              child: emptyBuilder?.call(context) ?? const SizedBox.shrink(),
            );
          },
          errorBuilder: (BuildContext context, Object error) {
            return _dropdownContent(
              context: context,
              child:
                  errorBuilder?.call(context, error) ??
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      error.toString(),
                      style: AppFonts.regular(14, AppColors.red),
                    ),
                  ),
            );
          },
          itemBuilder: itemBuilder,
          listBuilder: (BuildContext context, List<Widget> children) {
            final bool reverse =
                SuggestionsController.of<T>(context).effectiveDirection ==
                VerticalDirection.up;
            return ListView(
              controller: scrollController,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              reverse: reverse,
              children: <Widget>[if (header != null) header!, ...children],
            );
          },
        );
      },
    );
  }

  Widget _dropdownContent({
    required BuildContext context,
    required Widget child,
  }) {
    if (header == null) {
      return child;
    }

    final bool reverse =
        SuggestionsController.of<T>(context).effectiveDirection ==
        VerticalDirection.up;
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      reverse: reverse,
      children: <Widget>[header!, child],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(width: 1, color: color),
    );
  }
}
