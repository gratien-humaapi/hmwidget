//

import 'package:flutter/material.dart';

String colorToString(Color color) {
  return '#${color.value.toRadixString(16).substring(2, 8)}'.toUpperCase();
}

extension ColorExtension on String {
  Color toColor() {
    String hexColor = replaceAll('#', '');
    if (hexColor.length <= 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length > 6) {
      return Color(int.parse('0x$hexColor'));
    }
    return Colors.black;
  }
}
