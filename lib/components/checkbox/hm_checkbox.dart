import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_checkbox_size.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../utils/hm_radius.dart';
import '../../utils/sizes.dart';
import '../../widget_theme.dart';

class HMCheckBox extends HookWidget {
  // final CheckBoxProps customProps;
  const HMCheckBox({
    super.key,
    this.label,
    this.disabled = false,
    this.hidden = false,
    this.radius,
    this.checkIconColor,
    this.labelTextColor,
    this.borderColor,
    this.size,
    required this.value,
    this.color,
    required this.onChange,
  });
  final bool disabled;
  final bool hidden;
  final String? label;
  final bool value;
  final Color? color;
  final Color? borderColor;
  final Color? labelTextColor;
  final Color? checkIconColor;
  final HMRadius? radius;
  final HMCheckBoxSize? size;
  final void Function(bool) onChange;

  Widget _styledBox({required Widget child}) =>
      Visibility(visible: !hidden, child: child.padding(horizontal: 4.0));

  Widget _styledInnerContent({
    required String? label,
    required Animation<double> animation,
    required Color checkBoxColor,
    required HMRadius checkBoxRadius,
    required HMCheckBoxSize checkBoxSize,
    required Color iconColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: checkBoxSize.value,
          width: checkBoxSize.value,
          decoration: BoxDecoration(
            color: disabled
                ? const Color.fromRGBO(228, 229, 230, 1)
                : value
                    ? checkBoxColor
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(checkBoxRadius.value),
            border: value
                ? null
                : Border.all(color: borderColor ?? outlineColor, width: 2),
          ),
          child: Center(
              child: ScaleTransition(
            scale: animation,
            child: Icon(
              Icons.check_rounded,
              color:
                  disabled ? const Color.fromRGBO(175, 177, 179, 1) : iconColor,
              size: checkBoxSize.value / 1.3,
            ),
          )),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            // height: getLabelSize(size) * 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                label ?? '',
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: disabled
                        ? const Color.fromRGBO(181, 183, 186, 1)
                        : labelTextColor ?? Colors.black,
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
    final HMCheckBoxTheme? checkBoxTheme =
        Theme.of(context).extension<HMCheckBoxTheme>();
    final Color checkBoxColor = color ?? checkBoxTheme?.color ?? defaultColor;
    final Color iconColor = checkIconColor ??
        checkBoxTheme?.checkIconColor ??
        checkColor(checkBoxColor);
    final HMRadius checkBoxRadius =
        radius ?? checkBoxTheme?.radius ?? HMRadius.xl;
    final HMCheckBoxSize checkBoxSize =
        size ?? checkBoxTheme?.size ?? HMCheckBoxSize.md;

    final controller = useAnimationController(
        duration: const Duration(milliseconds: 200),
        reverseDuration: const Duration(milliseconds: 200));
    final Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    value ? controller.forward() : controller.reverse();
    return AbsorbPointer(
      absorbing: disabled,
      child: _styledInnerContent(
        label: label,
        animation: animation,
        iconColor: iconColor,
        checkBoxColor: checkBoxColor,
        checkBoxRadius: checkBoxRadius,
        checkBoxSize: checkBoxSize,
      ).parent(({required Widget child}) => _styledBox(child: child)).gestures(
          onTap: () {
        // isChecked.value = !isChecked.value;
        onChange(!value);
      }),
    );
  }
}
