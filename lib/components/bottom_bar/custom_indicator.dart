import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  const CustomTabIndicator({
    this.radius = 8,
    this.indicatorHeight = 4,
    this.color = Colors.blue,
  });
  final double radius;

  final Color color;

  final double indicatorHeight;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DotPainter(
      color: color,
      radius: radius,
    );
  }
}

class _DotPainter extends BoxPainter {
  _DotPainter({
    required this.color,
    required this.radius,
    VoidCallback? onChange,
  })  : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        super(onChange);
  final Paint _paint;
  final Color color;
  final double radius;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromCenter(
              center: Offset((offset.dx + configuration.size!.width / 2) + 1,
                  offset.dy + configuration.size!.height - 5 / 2),
              width: configuration.size!.width / 2,
              height: 5),
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
        _paint);

    // To add dot indicator
    // final Rect rect = offset & configuration.size!;
    // canvas.drawCircle(
    //   Offset(rect.bottomCenter.dx, rect.bottomCenter.dy - radius),
    //   radius,
    //   _paint,
    // );
  }
}
