import 'package:meta/meta.dart';

@immutable
final class PatientAttachment {
  const PatientAttachment({
    required this.path,
    required this.name,
    required this.size,
    required this.date,
    required this.extension,
  });

  final String path;
  final String name;
  final String size;
  final String date;
  final String extension;

  bool get isImage =>
      ['jpg', 'jpeg', 'png', 'webp'].contains(extension.toLowerCase());
  bool get isPdf => extension.toLowerCase() == 'pdf';
  bool get isDoc => ['doc', 'docx'].contains(extension.toLowerCase());
  bool get isAudio => ['mp3', 'wav'].contains(extension.toLowerCase());
  bool get isVideo => ['mp4'].contains(extension.toLowerCase());
}
