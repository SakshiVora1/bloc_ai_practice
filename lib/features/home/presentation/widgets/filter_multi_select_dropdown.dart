import 'package:flutter/material.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/features/home/domain/status_mapping.dart';

class FilterMultiSelectDropdown<T> extends StatefulWidget {
  const FilterMultiSelectDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    this.itemLabelBuilder,
    this.showSearch = false,
    this.isStatus = false,
  });

  final String label;
  final List<T> items;
  final List<T> selectedItems;
  final ValueChanged<List<T>> onChanged;
  final String Function(T)? itemLabelBuilder;
  final bool showSearch;
  final bool isStatus;

  @override
  State<FilterMultiSelectDropdown<T>> createState() =>
      _FilterMultiSelectDropdownState<T>();
}

class _FilterMultiSelectDropdownState<T>
    extends State<FilterMultiSelectDropdown<T>> {
  bool _isExpanded = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          style: AppFonts.medium(14, AppColors.primaryText),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.fieldBorder),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: widget.selectedItems.isEmpty
                      ? Text(
                          'Select ${widget.label}',
                          style: AppFonts.regular(14, AppColors.secondaryText),
                        )
                      : Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: widget.selectedItems.map((item) {
                            final label = widget.itemLabelBuilder?.call(item) ??
                                item.toString();
                            final Color color = widget.isStatus
                                ? StatusMapping.getColor(label)
                                : const Color(0xFF4A4ADE);

                            return InkWell(
                              onTap: () {
                                final newList = List<T>.from(
                                  widget.selectedItems,
                                )..remove(item);
                                widget.onChanged(newList);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withAlpha((0.2 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      label,
                                      style: AppFonts.medium(12, color),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.close,
                                      size: 14,
                                      color: color,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 250),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.fieldBorder),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showSearch)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(
                      builder: (context) {
                        return TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                          onTap: () {
                            // Ensure the search field is visible when keyboard opens
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (!context.mounted) return;
                              Scrollable.ensureVisible(
                                context,
                                duration: const Duration(milliseconds: 200),
                                alignment: 0.5, // Centered alignment
                              );
                            });
                          },
                        );
                      },
                    ),
                  ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _filterItems().map((item) {
                      final label = widget.itemLabelBuilder?.call(item) ??
                          item.toString();
                      final isSelected = widget.selectedItems.contains(item);

                      return InkWell(
                        onTap: () => _toggleItem(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: isSelected,
                                  onChanged: (val) => _toggleItem(item),
                                  activeColor: const Color(0xFF4A4ADE),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (widget.isStatus) ...[
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: StatusMapping.getColor(label),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Text(
                                  label,
                                  style: AppFonts.medium(
                                    14,
                                    AppColors.primaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<T> _filterItems() {
    if (_searchQuery.isEmpty) return widget.items;
    return widget.items.where((item) {
      final label = widget.itemLabelBuilder?.call(item) ?? item.toString();
      return label.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _toggleItem(T item) {
    final newList = List<T>.from(widget.selectedItems);
    if (newList.contains(item)) {
      newList.remove(item);
    } else {
      newList.add(item);
    }
    widget.onChanged(newList);
  }
}
