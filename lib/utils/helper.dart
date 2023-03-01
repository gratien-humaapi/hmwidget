import 'package:flutter/material.dart';

Color checkColor(Color color) {
  // final int red = color.red;
  // final int green = color.green;
  // final int blue = color.blue;

  // const int middle = 105;
  // int bg = ((red * 0.299) + (green * 0.587) + (blue * 0.114)).toInt();

  // Color textColor = (255 - bg < middle) ? Colors.black : Colors.white;
  final Color textColor =
      color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  return textColor;
}
