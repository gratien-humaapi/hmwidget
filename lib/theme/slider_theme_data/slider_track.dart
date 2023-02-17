import 'dart:math' as math;

import 'package:flutter/material.dart';

class SliderTrack extends SliderTrackShape {
  SliderTrack({required this.radius});
  double radius;
  double extraSpace = 0.0;
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    final double thumbWidth =
        sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft =
        offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight =
        trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);
    final double trackBottom = trackTop + trackHeight;
    // If the parentBox'size less than slider's size the trackRight will be less than trackLeft, so switch them.
    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
        math.max(trackLeft, trackRight), trackBottom);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    Offset? secondaryOffset,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    sliderTheme.trackHeight! > 3 ? extraSpace = 4 : extraSpace = 2;

    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final Radius trackRadius = Radius.circular(radius);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left - extraSpace,
        trackRect.top,
        thumbCenter.dx + extraSpace,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      activePaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        trackRect.top,
        trackRect.right + extraSpace,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactivePaint,
    );
  }
}
