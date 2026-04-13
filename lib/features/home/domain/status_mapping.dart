import 'package:flutter/material.dart';

class StatusMapping {
  static const Map<String, Color> statusColors = {
    'Scheduled': Color(0xFF4A4ADE),
    'Recording': Color(0xFFB80712),
    'Paused': Color(0xFFFDA324),
    'Generating Notes': Color(0xFF5B5BE1),
    'Notes Generated': Color(0xFF146F54),
    'Finalized': Color(0xFF39A58C),
    'Insufficient Information': Color(0xFFD9534F),
    'Cancelled': Color(0xFF364182),
    'Notes Deleted': Color(0xFFEB4335),
  };

  static List<String> get statuses => statusColors.keys.toList();

  static Color getColor(String status) {
    return statusColors[status] ?? Colors.grey;
  }
}
