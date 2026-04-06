import 'package:flutter/material.dart';

class SettingsInfoGrid extends StatelessWidget {
  const SettingsInfoGrid({
    super.key,
    required this.children,
    required this.maxColumns,
  });

  final List<Widget> children;
  final int maxColumns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int columns = _resolveColumns(maxColumns);

        if (columns <= 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                children
                    .expand(
                      (Widget w) => <Widget>[w, const SizedBox(height: 14)],
                    )
                    .toList()
                  ..removeLast(),
          );
        }

        const double spacing = 18;
        final double itemWidth = (width - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 14,
          children: children
              .map((Widget child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }
}

int _resolveColumns(int maxColumns) {
  if (maxColumns <= 1) {
    return 1;
  }
  // Settings layout: always use the requested column count (up to 3).
  return maxColumns.clamp(1, 3);
}
