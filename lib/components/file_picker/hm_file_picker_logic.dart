//

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../custom_icons_icons.dart';

class FilePickerLogic {
  static Widget buildIcon(PlatformFile file, String extension) {
    final List extensionList = ['jpg', 'jpeg', 'png', 'gif'];
    return extensionList.contains(extension)
        ? Image.file(File(file.path!))
        : Icon(getIcon(extension), size: 20, color: getColor(extension));
  }

  static Future<void> pickFile(
      ValueNotifier selectedFile, FileType fileType) async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);
    if (result == null) return;
    final PlatformFile file = result.files.first;
    selectedFile.value = file;
  }

  static Future<void> pickMultipleFiles(
      ValueNotifier multipleFiles, FileType fileType) async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: fileType);
    if (result == null) return;
    final List<PlatformFile> files = result.files;
    print(files);

    multipleFiles.value = files;
  }

  static Color? getColor(String extension) {
    switch (extension) {
      case 'mp3':
        {
          return Colors.teal;
        }

      case 'pdf':
        {
          return Colors.red;
        }
      case 'apk':
        {
          return Colors.green;
        }
      case 'jpg':
      case 'jpeg':
      case 'png':
        {
          return Colors.blue[300];
        }
      case 'mp4':
      case 'webm':
        {
          return Colors.deepOrangeAccent[700];
        }

      default:
        {
          return Colors.grey;
        }
    }
  }

  static IconData getIcon(String extension) {
    switch (extension) {
      case 'mp3':
        {
          return CustomIcons.music_icon;
        }
      case 'pdf':
        {
          return Icons.picture_as_pdf;
        }

      case 'apk':
        {
          return CustomIcons.android_icon;
        }
      case 'jpg':
      case 'jpeg':
      case 'png':
        {
          return CustomIcons.image_icon;
        }
      case 'mp4':
      case 'webm':
        {
          return CustomIcons.video_icon;
        }

      default:
        {
          return CustomIcons.document_icon;
        }
    }
  }
}
