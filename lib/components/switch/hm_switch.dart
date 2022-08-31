import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hmwidget/size/hm_switch_size.dart';
import 'package:hmwidget/utils/hm_raduis.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/sizes.dart';

class HMSwitch extends HookWidget {
  // final SwitchCustomProps customProps;
  const HMSwitch({
    this.disabled = false,
    this.hidden = false,
    this.duration = const Duration(milliseconds: 100),
    this.onLabel,
    this.offLabel,
    this.label,
    this.iconOn,
    this.iconOff,
    this.color,
    this.size = HMSwitchSize.md,
    this.radius = HMRadius.xl,
    required this.value,
    required this.onChange,
    Key? key,
  }) : super(key: key);
  final bool disabled;
  final bool hidden;
  final Duration duration;
  final String? onLabel;
  final String? offLabel;
  final String? label;
  final IconData? iconOn;
  final IconData? iconOff;
  final Color? color;
  final HMSwitchSize size;
  final HMRadius? radius;
  final bool value;
  final void Function(bool) onChange;

  void handleChange(bool value, AnimationController controller) {
    onChange(value);
    value ? controller.forward() : controller.reverse();
  }

  Widget _styledBox({
    required Widget child,
    required ValueNotifier<bool> isOn,
    required AnimationController controller,
  }) =>
      Visibility(
          visible: hidden,
          child: Container(
            color: Colors.transparent,
            height: getTrackSize(size),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                child,
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    label ?? "",
                    style: TextStyle(
                        color: disabled
                            ? const Color.fromARGB(255, 181, 183, 186)
                            : Colors.black,
                        fontSize: getLabelSize(size)),
                  ),
                )
              ],
            ),
          ));

  Widget _styledTrack({
    required ValueNotifier<bool> isOn,
    required Widget child,
    required AnimationController controller,
  }) {
    return SizedBox(
      width: getTrackSize(size),
      height: (getTrackSize(size) * 50) / 100,
      child: Container(
        decoration: BoxDecoration(
            color: isOn.value
                ? color ?? const Color.fromARGB(255, 121, 80, 242)
                : const Color.fromRGBO(228, 229, 230, 1),
            borderRadius: BorderRadius.all(Radius.circular(radius!.value))),
        child: Stack(
          alignment: Alignment.center,
          // fit: StackFit.loose,
          // clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.value * 10 / 100),
              child: Align(
                alignment: Alignment.centerLeft,
                child: child,
              ),
            ),
            Align(
                alignment:
                    isOn.value ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: size.value * 30 / 100),
                  child: Text(
                    isOn.value ? onLabel ?? "" : offLabel ?? "",
                    style: TextStyle(
                        color: disabled
                            ? const Color.fromARGB(255, 181, 183, 186)
                            : isOn.value
                                ? Colors.white
                                : Colors.black,
                        fontSize: getSwitchTextSize(size),
                        textBaseline: TextBaseline.ideographic,
                        fontWeight: FontWeight.w600),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _styledThumb(
      {required ValueNotifier<bool> isOn,
      required Animation<AlignmentGeometry> alignment,
      required AnimationController controller}) {
    return AlignTransition(
      alignment: alignment,
      child: Container(
          height: size.value,
          width: size.value,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius!.value)),
            color: disabled
                ? const Color.fromRGBO(228, 229, 230, 1)
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 6.0,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
              child: Icon(
            isOn.value ? iconOn : iconOff,
            color: disabled
                ? const Color.fromARGB(255, 181, 183, 186)
                : isOn.value
                    ? color ?? const Color.fromARGB(255, 121, 80, 242)
                    : Colors.grey[400],
            size: (size.value * 60) / 100,
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOn = useState(value);
    final animationController = useAnimationController(duration: duration);
    Animation<AlignmentGeometry> alignment = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(animationController);
    getLabelSize(size);

    return AbsorbPointer(
      absorbing: disabled,
      child: _styledThumb(
              isOn: isOn, alignment: alignment, controller: animationController)
          .parent(({required Widget child}) => _styledTrack(
              child: child, isOn: isOn, controller: animationController))
          .parent(({required child}) => _styledBox(
              child: child, controller: animationController, isOn: isOn))
          .gestures(
        onTap: () {
          isOn.value = !isOn.value;
          handleChange(isOn.value, animationController);
        },
      ).alignment(Alignment.center),
    );
  }
}
