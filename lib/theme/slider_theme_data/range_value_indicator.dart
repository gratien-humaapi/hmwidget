import 'package:flutter/material.dart';
import '../../utils/hm_radius.dart';

import 'path_painter.dart';

class RangeValueIndicatorShape extends RangeSliderValueIndicatorShape {
  RangeValueIndicatorShape(
      {required this.sliderValue, required this.orientation});
  final double sliderValue;
  final HMOrientation orientation;

  static const PathPainter _pathPainter = PathPainter();

  @override
  Size getPreferredSize(
    bool isEnabled,
    bool isDiscrete, {
    required TextPainter labelPainter,
    required double textScaleFactor,
  }) {
    return _pathPainter.getPreferredSize(labelPainter, textScaleFactor);
  }

  @override
  double getHorizontalShift({
    RenderBox? parentBox,
    Offset? center,
    TextPainter? labelPainter,
    Animation<double>? activationAnimation,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    return _pathPainter.getHorizontalShift(
      parentBox: parentBox!,
      center: center!,
      labelPainter: labelPainter!,
      textScaleFactor: textScaleFactor!,
      sizeWithOverflow: sizeWithOverflow!,
      scale: activationAnimation!.value,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    bool? isOnTop,
    TextPainter? labelPainter,
    double? textScaleFactor,
    Size? sizeWithOverflow,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation!.value;
    _pathPainter.paint(
      orientation: orientation,
      parentBox: parentBox!,
      canvas: canvas,
      center: center,
      scale: scale,
      labelPainter: labelPainter!,
      textScaleFactor: textScaleFactor!,
      sizeWithOverflow: sizeWithOverflow!,
      backgroundPaintColor: sliderTheme!.valueIndicatorColor!,
      strokePaintColor:
          isOnTop! ? sliderTheme.overlappingShapeStrokeColor : null,
    );
  }
}
