import 'package:flutter/material.dart';

class RangeThumbShape extends RangeSliderThumbShape {

  const RangeThumbShape({
    required this.thumbRadius,
  });
  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius / 1.5);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;
    final double radius = thumbRadius / 2;
    final double radius2 = sliderTheme.trackHeight! > 3 ? radius / 2 : 0;
    final Color color = sliderTheme.thumbColor!;
    const Color color2 = Colors.white;
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );
    canvas.drawCircle(
      center,
      radius2,
      Paint()..color = color2,
    );
  }
}
