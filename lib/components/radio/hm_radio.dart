//

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/constant.dart';
import '../../size/hm_radio_size.dart';

class HMRadio extends HookWidget {
  // final RadioCustomProps customProps;
  const HMRadio(
      {this.disabled = false,
      this.hidden = false,
      required this.radioList,
      this.size = HMRadioSize.md,
      this.value,
      this.isLeft = true,
      this.boxRadius = 4,
      this.border,
      this.textColor,
      this.separatorLineColor,
      this.separatorLineHeight = 1,
      this.radioColor,
      required this.onChanged,
      Key? key})
      : super(key: key);
  final bool disabled;
  final bool hidden;
  final HMRadioSize size;
  final Color? radioColor;
  final Color? textColor;
  final Color? separatorLineColor;
  final double separatorLineHeight;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool isLeft;
  final dynamic value;
  final List radioList;
  final double boxRadius;
  final Border? border;
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
  }) =>
      Visibility(
          visible: !hidden,
          child: Container(
              decoration: BoxDecoration(
                  border: border ?? Border.all(color: outlineColor),
                  borderRadius: BorderRadius.circular(boxRadius)),
              child: child));

  Widget _styledRadioPannel({
    required ValueNotifier<dynamic> selection,
  }) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: radioList.length,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, sIndex) {
        return Divider(
          height: separatorLineHeight,
          indent: 0.0,
          endIndent: 0.0,
          thickness: separatorLineHeight,
          // color: Colors.black,
        );
      },
      itemBuilder: (context, index) {
        bool isSelected = selection.value == radioList[index];
        List<Widget> children = [
          Text(
            '${radioList[index]}',
            style: TextStyle(
              fontSize: _getTextSize(size),
              color: disabled ? Colors.grey : textColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: SizedBox.square(
              dimension: _getTextSize(size),
              child: RadioIcon(
                  isChecked: isSelected, color: radioColor ?? defaultColor),
            ),
          ),
        ];
        return GestureDetector(
          onTap: () {
            if (radioList[index] != selection.value) {
              selection.value = radioList[index];
              // print('$index, ${selection.value}');
              onChanged(selection.value);
            }
          },
          child: Container(
            height: _getTextSize(size) * 3,
            padding: const EdgeInsets.only(left: 20.0),
            decoration: BoxDecoration(
                color: disabled ? outlineColor.withOpacity(0.2) : null),
            child: Row(
              mainAxisAlignment: isLeft
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.spaceBetween,
              children: isLeft ? children.reversed.toList() : children,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final radioSelection = useState(value);

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledRadioPannel(
          selection: radioSelection,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }
}

class RadioIcon extends StatelessWidget {
  final bool isChecked;
  final Color color;
  const RadioIcon({required this.isChecked, required this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: isChecked ? Check() : UnCheck(),
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
  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.height, size.width) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius,
        Paint()..color = const Color.fromARGB(255, 121, 80, 242));
    canvas.drawCircle(center, radius / 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(Check oldDelegate) => false;
}
