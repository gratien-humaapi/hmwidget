//

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
class FilePickerLogic {
  static Widget buildIcon(PlatformFile file, String extension,
      [double size = 50]) {
    final List extensionList = ['jpg', 'jpeg', 'png', 'gif'];
    return extensionList.contains(extension)
        ? Image.file(File(file.path!))
        : Icon(getIcon(extension), size: size, color: getColor(extension));
  }

  static Future<void> pickFile(
      ValueNotifier<List<PlatformFile>> selectedFile, FileType fileType) async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: fileType);
    if (result == null) {
      return;
    }
    final PlatformFile file = result.files.first;
    selectedFile.value = [file];
  }

  static Future<void> pickMultipleFiles(
      ValueNotifier<List<PlatformFile>> multipleFiles,
      FileType fileType) async {
    final FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: fileType);
    if (result == null) {
      return;
    }
    List<PlatformFile> files = List.from(multipleFiles.value);
    files.addAll(result.files);
    final valueSet = files.toSet();
    files = valueSet.toList();
    // final List<PlatformFile> files = result.files;
    // print(files.length);

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
      case 'wav':
        {
          return Icons.audio_file;
        }
      case 'pdf':
        {
          return Icons.picture_as_pdf;
        }

      case 'apk':
        {
          return Icons.android_rounded;
        }
      case 'jpg':
      case 'jpeg':
      case 'png':
        {
          return Icons.photo_rounded;
        }
      case 'mp4':
      case 'webm':
      case 'avi':
      case 'mkv':
        {
          return Icons.video_file;
        }

      default:
        {
          return Icons.insert_drive_file_rounded;
        }
    }
  }
}
