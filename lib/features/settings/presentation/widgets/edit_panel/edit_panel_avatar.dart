import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subqdocs_bloc/core/constants/app_colors.dart';
import 'package:subqdocs_bloc/core/constants/app_fonts.dart';
import 'package:subqdocs_bloc/core/constants/app_strings.dart';
import 'package:subqdocs_bloc/core/routing/app_router.dart';
import 'package:subqdocs_bloc/core/services/app_toast.dart';

class EditPanelAvatar extends StatefulWidget {
  const EditPanelAvatar({
    super.key,
    required this.initialImageUrl,
    required this.onImageChanged,
  });

  final String? initialImageUrl;

  /// Callback when the image is either chosen or removed.
  /// [imagePath] will be the local path of the new image, if picked.
  /// [isRemoved] is true when the user explicitly removes their profile image.
  final void Function(String? imagePath, bool isRemoved) onImageChanged;

  @override
  State<EditPanelAvatar> createState() => _EditPanelAvatarState();
}

class _EditPanelAvatarState extends State<EditPanelAvatar> {
  final ImagePicker _imagePicker = ImagePicker();

  String? _localAvatarFilePath;
  bool _pendingRemoveProfileImage = false;

  bool get _effectiveHasProfileImage {
    if (_pendingRemoveProfileImage) {
      return false;
    }
    if (_localAvatarFilePath != null) {
      return true;
    }
    return (widget.initialImageUrl ?? '').trim().isNotEmpty;
  }

  void _onPickedImage(String path) {
    setState(() {
      _pendingRemoveProfileImage = false;
      _localAvatarFilePath = path;
    });
    widget.onImageChanged(path, false);
  }

  void _onRemoveProfileImageTap() {
    setState(() {
      _pendingRemoveProfileImage = true;
      _localAvatarFilePath = null;
    });
    widget.onImageChanged(null, true);
  }

  Future<void> _pickFromCamera() async {
    if (!mounted) {
      return;
    }
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 88,
      );
      if (file == null || !mounted) {
        return;
      }
      _onPickedImage(file.path);
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, AppStrings.settingsImagePickFailed);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    if (!mounted) {
      return;
    }
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 88,
      );
      if (file == null || !mounted) {
        return;
      }
      _onPickedImage(file.path);
    } catch (_) {
      if (mounted) {
        AppToast.showError(context, AppStrings.settingsImagePickFailed);
      }
    }
  }

  void _showProfilePhotoDialog() {
    final bool showRemove = _effectiveHasProfileImage;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            AppStrings.settingsProfilePhotoSheetTitle,
            style: AppFonts.medium(16, AppColors.primaryText),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(
                  AppStrings.settingsPickFromCamera,
                  style: AppFonts.regular(15, AppColors.primaryText),
                ),
                onTap: () async {
                  AppRouter.pop(dialogContext);
                  await _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(
                  AppStrings.settingsPickFromGallery,
                  style: AppFonts.regular(15, AppColors.primaryText),
                ),
                onTap: () async {
                  AppRouter.pop(dialogContext);
                  await _pickFromGallery();
                },
              ),
              if (showRemove)
                ListTile(
                  leading: Icon(Icons.delete_outline, color: AppColors.error),
                  title: Text(
                    AppStrings.settingsRemoveProfileImage,
                    style: AppFonts.regular(15, AppColors.error),
                  ),
                  onTap: () {
                    AppRouter.pop(dialogContext);
                    _onRemoveProfileImageTap();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _avatarPlaceholder() {
    return CircleAvatar(
      radius: 48,
      backgroundColor: AppColors.textFieldBorder.withValues(alpha: 0.35),
      child: Icon(
        Icons.person,
        size: 44,
        color: AppColors.drawerItemUnselected,
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (_pendingRemoveProfileImage) {
      return _avatarPlaceholder();
    }
    final String? localPath = _localAvatarFilePath;
    if (localPath != null) {
      return CircleAvatar(
        radius: 48,
        backgroundColor: AppColors.textFieldBorder,
        backgroundImage: FileImage(File(localPath)),
      );
    }
    final String? rawUrl = widget.initialImageUrl?.trim();
    if (rawUrl == null || rawUrl.isEmpty) {
      return _avatarPlaceholder();
    }
    final String lower = rawUrl.toLowerCase();
    final bool isHttp =
        lower.startsWith('http://') || lower.startsWith('https://');
    if (isHttp) {
      return CircleAvatar(
        radius: 48,
        backgroundColor: AppColors.textFieldBorder,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: rawUrl,
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            placeholder: (BuildContext _, String __) => const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (BuildContext _, String __, Object ___) {
              return _avatarPlaceholder();
            },
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: 48,
      backgroundColor: AppColors.textFieldBorder,
      backgroundImage: NetworkImage(rawUrl),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 108,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          _buildAvatarImage(),
          Positioned(
            right: 0,
            bottom: 0,
            child: Material(
              elevation: 2,
              color: AppColors.drawerItemSelected,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _showProfilePhotoDialog,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.add, color: AppColors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
