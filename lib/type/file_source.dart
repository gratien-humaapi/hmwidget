import 'package:flutter/material.dart';

enum FileSource {
  camera('Camera'),
  gallery('Gallery'),
  document('Document');

  const FileSource(this.value);
  final String value;
}

class HMFileSource {
  HMFileSource({required this.icon, required this.source});
  final FileSource source;
  final Widget icon;
}
