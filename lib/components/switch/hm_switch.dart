import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_switch_size.dart';
import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../utils/sizes.dart';
import '../../widget_theme.dart';

class HMSwitch extends HookWidget {
  // final SwitchProps customProps;
  const HMSwitch({
    this.disabled = false,
    this.hidden = false,
    this.duration,
    this.onLabel,
    this.offLabel,
    this.label,
    this.borderColor,
    this.iconOn,
    this.iconOff,
    this.reversed = false,
    this.color,
    this.labelTextStyle,
    this.size,
    this.radius,
    required this.value,
    required this.onChange,
    super.key,
  });
  final bool disabled;
  final bool hidden;
  final bool reversed;
  final Duration? duration;
  final String? onLabel;
  final String? offLabel;
  final String? label;
  final TextStyle? labelTextStyle;
  final Widget? iconOn;
  final Widget? iconOff;
  final Color? color;
  final Color? borderColor;
  final HMSwitchSize? size;
  final HMRadius? radius;
  final bool value;
  final void Function(bool) onChange;

  // void handleChange(bool value, AnimationController controller) {
  //   onChange(!value);
  //   value ? controller.forward() : controller.reverse();
  // }

  Widget _styledBox({
    required Widget child,
    required AnimationController controller,
    required HMSwitchSize switchSize,
  }) {
    final List<Widget> children = [
      child,
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: reversed ? 0 : 8.0),
          child: Text(
            label ?? '',
            // overflow: TextOverflow.ellipsis,
            // maxLines: 1,
            style: labelTextStyle ??
                TextStyle(
                    color: disabled
                        ? const Color.fromARGB(255, 181, 183, 186)
                        : Colors.black,
                    fontSize: getLabelSize(size)),
          ),
        ),
      )
    ];
    return Visibility(
        visible: !hidden,
        child: Container(
          // color: Colors.red,
          // height: getTrackSize(switchSize),
          child: Row(
            mainAxisAlignment: reversed
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: reversed ? children.reversed.toList() : children,
          ),
        ));
  }

  Widget _styledTrack({
    required Widget child,
    required AnimationController controller,
    required HMRadius switchRadius,
    required Color switchColor,
    required HMSwitchSize switchSize,
    required Duration animDuration,
  }) {
    return SizedBox(
      width: getTrackSize(switchSize),
      height: (getTrackSize(switchSize) * 60) / 100,
      child: Container(
        decoration: BoxDecoration(
            color: value ? switchColor : const Color.fromRGBO(228, 229, 230, 1),
            border: Border.all(
                color: borderColor ?? Colors.transparent,
                strokeAlign: BorderSide.strokeAlignOutside,
                style:
                    borderColor != null ? BorderStyle.solid : BorderStyle.none),
            borderRadius:
                BorderRadius.all(Radius.circular(switchRadius.value))),
        child: Stack(
          alignment: Alignment.center,
          // fit: StackFit.loose,
          // clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: switchSize.value * 10 / 100),
              child: Align(
                alignment: Alignment.centerLeft,
                child: child,
              ),
            ),
            Align(
                alignment: value ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: switchSize.value * 30 / 100),
                  child: Text(
                    value ? onLabel ?? '' : offLabel ?? '',
                    style: TextStyle(
                        color: disabled
                            ? const Color.fromARGB(255, 181, 183, 186)
                            : value
                                ? Colors.white
                                : Colors.black,
                        fontSize: getSwitchTextSize(switchSize),
                        textBaseline: TextBaseline.ideographic,
                        fontWeight: FontWeight.w600),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _styledThumb({
    required Animation<AlignmentGeometry> alignment,
    required AnimationController controller,
    required HMRadius switchRadius,
    required Color switchColor,
    required HMSwitchSize switchSize,
    required Duration animDuration,
  }) {
    return AlignTransition(
      alignment: alignment,
      child: Container(
          height: switchSize.value * 1.10,
          width: switchSize.value * 1.10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(switchRadius.value),
            color: disabled
                ? const Color.fromRGBO(228, 229, 230, 1)
                : Colors.white,
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                color: disabled
                    ? const Color.fromARGB(255, 181, 183, 186)
                    : value
                        ? switchColor
                        : Colors.grey[400],
                size: (switchSize.value * 60) / 100,
              ),
              child: value ? iconOn ?? Container() : iconOff ?? Container(),
            ),
            // color: disabled
            //     ? const Color.fromARGB(255, 181, 183, 186)
            //     : isOn.value
            //         ? color ?? const Color.fromARGB(255, 121, 80, 242)
            //         : Colors.grey[400],
            // size: (size.value * 60) / 100,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final switchTheme = Theme.of(context).extension<HMSwitchTheme>();
    final Color switchColor = color ?? switchTheme?.color ?? defaultColor;
    final HMRadius switchRadius = radius ?? switchTheme?.radius ?? HMRadius.xl;
    final HMSwitchSize switchSize =
        size ?? switchTheme?.size ?? HMSwitchSize.md;
    final Duration animDuration =
        duration ?? switchTheme?.duration ?? const Duration(milliseconds: 200);
    final animationController = useAnimationController(
        duration: animDuration, reverseDuration: animDuration);
    final Animation<AlignmentGeometry> alignment = Tween<AlignmentGeometry>(
            begin: Alignment.centerLeft, end: Alignment.centerRight)
        .animate(animationController);
    if (value) {
      animationController.forward();
    } else {
      animationController.reverse();
    }

    return AbsorbPointer(
      absorbing: disabled,
      child: _styledThumb(
        alignment: alignment,
        controller: animationController,
        switchRadius: switchRadius,
        switchColor: switchColor,
        switchSize: switchSize,
        animDuration: animDuration,
      )
          .parent(({required Widget child}) => _styledTrack(
                child: child,
                controller: animationController,
                switchRadius: switchRadius,
                switchColor: switchColor,
                switchSize: switchSize,
                animDuration: animDuration,
              ))
          .parent(({required child}) => _styledBox(
                child: child,
                controller: animationController,
                switchSize: switchSize,
              ))
          .gestures(
        onTap: () {
          if (value) {
            onChange(!value);
            // print('here ${!value}');
            animationController.forward();
          } else {
            onChange(!value);
            animationController.reverse();
          }
        },
      ),
    );
  }
}
