import 'package:flutter/material.dart';

/// Root [Navigator] key for imperative navigation and overlays when no
/// widget [BuildContext] is available (e.g. from HTTP interceptors).
abstract final class RootNavigatorKey {
  RootNavigatorKey._();

  static final GlobalKey<NavigatorState> instance = GlobalKey<NavigatorState>();
}
