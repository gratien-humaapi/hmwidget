import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_checkbox_size.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../utils/hm_raduis.dart';
import '../../utils/sizes.dart';

class HMCheckBox extends HookWidget {
  // final CheckBoxCustomProps customProps;
  const HMCheckBox({
    super.key,
    this.label,
    this.disabled = false,
    this.hidden = false,
    this.radius = HMRadius.sm,
    this.size = HMCheckBoxSize.md,
    required this.value,
    this.color,
    required this.onChange,
  });
  final bool disabled;
  final bool hidden;
  final String? label;
  final bool value;
  final Color? color;
  final HMRadius radius;
  final HMCheckBoxSize size;
  final void Function(bool) onChange;

  Widget _styledBox({required Widget child}) =>
      Visibility(visible: !hidden, child: child.padding(horizontal: 4.0));

  Widget _styledInnerContent({
    required String? label,
    required ValueNotifier<bool> isChecked,
    required Animation<double> animation,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: size.value,
          width: size.value,
          decoration: BoxDecoration(
            color: disabled
                ? const Color.fromRGBO(228, 229, 230, 1)
                : isChecked.value
                    ? color ?? defaultColor
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(radius.value),
            border: isChecked.value
                ? null
                : Border.all(
                    color: const Color.fromRGBO(177, 183, 189, 1),
                    width: 1,
                    style: BorderStyle.solid),
          ),
          child: Center(
              child: ScaleTransition(
            scale: animation,
            alignment: Alignment.center,
            child: Icon(
              isChecked.value ? Icons.check : null,
              color: disabled
                  ? const Color.fromRGBO(175, 177, 179, 1)
                  : checkColor(color ?? defaultColor),
              size: size.value / 1.3,
            ),
          )),
        ),
        Container(
          color: Colors.transparent,
          height: getLabelSize(size) * 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Center(
              child: Text(
                label ?? '',
                style: TextStyle(
                    color: disabled
                        ? const Color.fromRGBO(181, 183, 186, 1)
                        : Colors.black,
                    fontSize: getLabelSize(size)),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isChecked = useState(value);
    final controller =
        useAnimationController(duration: const Duration(milliseconds: 200));
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    isChecked.value ? controller.forward() : controller.reverse();
    return AbsorbPointer(
      absorbing: disabled,
      child: _styledInnerContent(
              label: label, isChecked: isChecked, animation: animation)
          .parent(({required Widget child}) => _styledBox(child: child))
          .gestures(onTap: () {
        isChecked.value = !isChecked.value;
        onChange(isChecked.value);
      }),
    );
  }
}
