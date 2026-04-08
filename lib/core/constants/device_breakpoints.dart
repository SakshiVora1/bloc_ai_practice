abstract final class DeviceBreakpoints {
  DeviceBreakpoints._();

  /// Standard breakpoint for mobile phones (shortest side < 600).
  static const double mobile = 600;

  /// Standard breakpoint for tablets (shortest side < 900).
  static const double tablet = 900;

  /// Standard breakpoint for desktop/large screens (shortest side < 1200).
  static const double desktop = 1200;
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}
