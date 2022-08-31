import 'package:flutter/material.dart';
import 'package:hmwidget/theme/slider_theme_data/path_painter.dart';
import 'package:hmwidget/utils/hm_raduis.dart';

class ValueIndicatorShape extends SliderComponentShape {
  final double sliderValue;
  final HMOrientation orientation;
  const ValueIndicatorShape(
      {required this.sliderValue, required this.orientation});
  static const PathPainter _pathPainter = PathPainter();
  @override
  Size getPreferredSize(
    bool isEnabled,
    bool isDiscrete, {
    TextPainter? labelPainter,
    double? textScaleFactor,
  }) {
    return Size(20, textScaleFactor!);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final double scale = activationAnimation.value;
    _pathPainter.paint(
      orientation: orientation,
      parentBox: parentBox,
      canvas: canvas,
      center: center,
      scale: scale,
      labelPainter: labelPainter,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
      backgroundPaintColor: sliderTheme.valueIndicatorColor!,
    );
  }
}
