import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/utils/date_formatters.dart';
import 'package:subqdocs_bloc/features/patients/domain/patient_attachment.dart';
import 'package:subqdocs_bloc/features/patients/presentation/widgets/dotted_border.dart';
import 'package:subqdocs_bloc/widgets/common_button.dart';

class AddAttachmentsDialog extends StatefulWidget {
  const AddAttachmentsDialog({super.key});

  @override
  State<AddAttachmentsDialog> createState() => _AddAttachmentsDialogState();
}

class _AddAttachmentsDialogState extends State<AddAttachmentsDialog> {
  final List<PatientAttachment> _selectedAttachments = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'mp3',
        'wav',
        'mp4',
        'doc',
        'docx',
        'pdf'
      ],
    );

    if (result != null) {
      setState(() {
        for (final file in result.files) {
          if (file.path != null) {
            _selectedAttachments.add(
              PatientAttachment(
                path: file.path!,
                name: file.name,
                size: '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                date: formatDateMmDdYyyy(DateTime.now()),
                extension: file.extension ?? '',
              ),
            );
          }
        }
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera);

    if (file != null) {
      final stat = await File(file.path).stat();
      setState(() {
        _selectedAttachments.add(
          PatientAttachment(
            path: file.path,
            name: file.name,
            size: '${(stat.size / (1024 * 1024)).toStringAsFixed(1)} MB',
            date: formatDateMmDdYyyy(DateTime.now()),
            extension: file.path.split('.').last,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildUploadArea(),
                    const SizedBox(height: 12),
                    Text(
                      'Supported Formats: JPG, PNG, WEBP, MP3, WAV,MP4, DOC, PDF',
                      style: AppFonts.regular(12, AppColors.blueGray),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    _buildTakePhotoButton(),
                    if (_selectedAttachments.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _buildSelectedFilesList(),
                    ],
                  ],
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.primaryAction,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add Attachments',
            style: AppFonts.medium(16, AppColors.white),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: AppColors.white, size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadArea() {
    return DottedBorder(
      color: AppColors.textFieldBorder,
      dashWidth: 6,
      dashSpace: 4,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.file_upload_outlined,
              color: AppColors.primaryAction,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              'Upload and manage Photos',
              style: AppFonts.medium(16, AppColors.primaryText),
            ),
            const SizedBox(height: 16),
            CommonButton(
              label: 'Choose Files',
              onPressed: _pickFiles,
              backgroundColor: AppColors.primaryAction,
              textColor: AppColors.white,
              borderRadius: 8,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTakePhotoButton() {
    return CommonButton(
      label: 'Take a photo',
      onPressed: _takePhoto,
      backgroundColor: AppColors.white,
      textColor: AppColors.primaryAction,
      borderColor: AppColors.primaryAction,
      borderRadius: 8,
      height: 44,
    );
  }

  Widget _buildSelectedFilesList() {
    return Column(
      children: _selectedAttachments.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.textFieldBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.chipSelectedBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getIconForExtension(file.extension),
                  color: AppColors.primaryAction,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: AppFonts.medium(14, AppColors.blueGray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${file.date}  |  ${file.size}',
                      style: AppFonts.regular(12, AppColors.blueGray),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedAttachments.removeAt(index);
                  });
                },
                icon: const Icon(Icons.close, color: AppColors.blueGray, size: 24),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
          Expanded(
            child: CommonButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
              backgroundColor: AppColors.white,
              textColor: AppColors.primaryAction,
              borderColor: AppColors.primaryAction,
              borderRadius: 8,
              height: 44,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CommonButton(
              label: 'Add',
              onPressed: () => Navigator.of(context).pop(_selectedAttachments),
              backgroundColor: AppColors.primaryAction,
              textColor: AppColors.white,
              borderRadius: 8,
              height: 44,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'doc':
      case 'docx':
        return Icons.description_outlined;
      case 'mp3':
      case 'wav':
        return Icons.audiotrack_outlined;
      case 'mp4':
        return Icons.videocam_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}
