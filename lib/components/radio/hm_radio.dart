//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../hmwidget.dart';
import '../../utils/constant.dart';

class HMRadio extends HookWidget {
  // final RadioProps customProps;
  const HMRadio(
      {this.disabled = false,
      this.hidden = false,
      required this.radioList,
      this.size,
      required this.value,
      this.isLeft,
      this.boxRadius,
      this.textColor,
      this.divider,
      this.radioColor,
      required this.onChanged,
      super.key});

  final bool disabled;
  final bool hidden;
  final HMRadioSize? size;
  final Color? radioColor;
  final Color? textColor;
  final Widget? divider;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? isLeft;
  final String value;
  final List radioList;
  final HMRadius? boxRadius;
  final void Function(dynamic value) onChanged;

  double _getTextSize(HMRadioSize size) {
    switch (size) {
      case HMRadioSize.xs:
        return 12.0;
      case HMRadioSize.sm:
        return 14.0;
      case HMRadioSize.md:
        return 16.0;
      case HMRadioSize.lg:
        return 18.0;
      case HMRadioSize.xl:
        return 20.0;
    }
  }

  Widget _styledBox({
    required Widget child,
    required double radioRadius,
  }) =>
      Visibility(
          visible: !hidden,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: outlineColor),
                  borderRadius: BorderRadius.circular(radioRadius)),
              child: child));

  Widget _styledRadioPannel({
    required double radioRadius,
    required HMRadioSize radioSize,
    required Color radioTextColor,
    required Color color,
    required bool iconAtLeft,
  }) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: radioList.length,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, sIndex) {
        return divider ??
            Divider(
              height: 1,
              indent: 0.0,
              endIndent: 0.0,
              thickness: 1,
              color: outlineColor,
            );
      },
      itemBuilder: (context, index) {
        final bool isSelected = value == radioList[index];
        List<Widget> children = [
          Padding(
            padding: EdgeInsets.only(left: iconAtLeft ? 0.0 : 20),
            child: Text(
              '${radioList[index]}',
              style: TextStyle(
                fontSize: _getTextSize(radioSize),
                color: disabled ? Colors.grey : radioTextColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SizedBox.square(
              dimension: _getTextSize(radioSize),
              child: RadioIcon(isChecked: isSelected, color: color),
            ),
          ),
        ];
        return GestureDetector(
          onTap: () {
            if (radioList[index] != value) {
              // print('$index, ${value}');
              onChanged(radioList[index]);
            }
          },
          child: Container(
            height: _getTextSize(radioSize) * 3,
            padding: const EdgeInsets.only(left: 20.0),
            decoration: BoxDecoration(
                color: disabled ? outlineColor.withOpacity(0.2) : null),
            child: Row(
              mainAxisAlignment: iconAtLeft
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: iconAtLeft ? children.reversed.toList() : children,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final radioTheme = Theme.of(context).extension<HMRadioTheme>();
    final radioSize = size ?? radioTheme?.size ?? HMRadioSize.md;
    final myRadius = boxRadius ?? radioTheme?.boxRadius ?? HMRadius.sm;
    final radioRadius = (myRadius.value * radioSize.value) / 80;
    final color = radioColor ??
        radioTheme?.radioColor ??
        const Color.fromRGBO(121, 80, 242, 1);
    final radioTextColor = textColor ?? radioTheme?.textColor ?? Colors.black;
    final iconAtLeft = isLeft ?? radioTheme?.isLeft ?? true;

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledRadioPannel(
          radioRadius: radioRadius,
          radioSize: radioSize,
          color: color,
          radioTextColor: radioTextColor,
          iconAtLeft: iconAtLeft,
        ).parent(({required child}) => _styledBox(
              child: child,
              radioRadius: radioRadius,
            )));
  }
}

class RadioIcon extends StatelessWidget {
  const RadioIcon({required this.isChecked, required this.color, super.key});
  final bool isChecked;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: isChecked ? Check(color) : UnCheck(),
    );
  }
}

class UnCheck extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.height, size.width) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = outlineColor
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke);
  }

  @override
  bool shouldRepaint(UnCheck oldDelegate) => false;
}

class Check extends CustomPainter {
  Check(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.height, size.width) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = color
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke);

    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(center, radius / 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(Check oldDelegate) => false;
}
