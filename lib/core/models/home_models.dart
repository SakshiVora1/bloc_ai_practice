/// Static schedule payloads for offline / stubbed home visits (same envelope shape
/// as the visit list API).
abstract final class HomeModels {
  HomeModels._();

  static Map<String, dynamic> get current =>
      _envelope(<Map<String, dynamic>>[]);

  static Map<String, dynamic> get upcoming =>
      _envelope(<Map<String, dynamic>>[]);

  static Map<String, dynamic> get completed =>
      _envelope(<Map<String, dynamic>>[]);

  /// Alias used by [loadHomeVisitsFromStaticJson].
  static Map<String, dynamic> get visitTable => current;

  static Map<String, dynamic> _envelope(List<Map<String, dynamic>> rows) {
    return <String, dynamic>{
      'responseData': <String, dynamic>{'data': rows},
    };
  }
}
