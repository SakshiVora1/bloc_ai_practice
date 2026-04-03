import 'package:flutter/material.dart';

/// Scrolls the focused login field into view after the keyboard opens.
///
/// Used with [resizeToAvoidBottomInset] false and manual [viewInsets] padding.
void scheduleLoginFieldVisibleIfFocused({
  required FocusNode emailFocus,
  required FocusNode passwordFocus,
}) {
  if (!emailFocus.hasFocus && !passwordFocus.hasFocus) {
    return;
  }
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final FocusNode? node = emailFocus.hasFocus
        ? emailFocus
        : passwordFocus.hasFocus
        ? passwordFocus
        : null;
    final BuildContext? ctx = node?.context;
    if (ctx == null || node == null || !node.hasFocus) {
      return;
    }
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: 0.15,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    );
  });
}
