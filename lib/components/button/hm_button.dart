import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hmwidget/size/hm_button_size.dart';
import 'package:hmwidget/utils/hm_raduis.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../type/hm_button_type.dart';
import '../../utils/sizes.dart';

class HMButton extends HookWidget {
  const HMButton({
    super.key,
    required this.content,
    this.fillColor,
    this.textColor,
    this.radius = HMRadius.sm,
    this.size = HMButtonSize.md,
    this.fullWidth,
    this.buttonVariant,
    this.icon,
    this.iconAtLeft,
    required this.onPressed,
    this.disabled = false,
    this.hidden = false,
  }) : assert(icon != null && iconAtLeft != null);
  final bool disabled;
  final bool hidden;
  final String content;
  final Color? fillColor;
  final Color? textColor;
  final HMRadius radius;
  final HMButtonSize size;
  final bool? fullWidth;
  final HMButtonVariant? buttonVariant;
  final IconData? icon;
  final bool? iconAtLeft;

  final void Function() onPressed;
  // final ButtonCustomProps customProps;
  Widget _styledBox(
      {required Widget child,
      required bool isPressed,
      required double radius}) {
    return child
        .padding(horizontal: 2.0)
        .constrained(
            maxWidth: fullWidth! ? double.infinity : (size.value * 1.0) + 10,
            maxHeight: getRatio(size.value))
        .decorated(
          color: disabled
              ? const Color.fromRGBO(228, 229, 230, 1)
              : Color.alphaBlend(
                  buttonVariant == HMButtonVariant.filled
                      ? Colors.black.withOpacity(isPressed ? 0.05 : 0.0)
                      : textColor!.withOpacity(isPressed ? 0.1 : 0.0),
                  buttonVariant == HMButtonVariant.filled
                      ? fillColor!
                      : Colors.transparent),
          border: buttonVariant == HMButtonVariant.outlined
              ? Border.all(
                  color: textColor!,
                  style: disabled ? BorderStyle.none : BorderStyle.solid)
              : null,
          borderRadius: BorderRadius.circular(radius),
        );
  }

  Widget _outlinedBorder(
          {required Widget child,
          required bool isPressed,
          required double radius}) =>
      buttonVariant == HMButtonVariant.filled
          ? child.padding(all: 3).decorated(
              border: isPressed
                  ? Border.all(color: fillColor ?? Colors.transparent, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(radius * 1.2))
          : child;
  Widget _styledInnerContent(
      {required String text,
      required IconData? icon,
      required bool isPressed}) {
    final List<Widget> children1 = <Widget>[
      if (icon != null)
        Container(
          margin: EdgeInsets.symmetric(horizontal: getIconSize(size) / 14),
          child: Icon(icon,
              size: getIconSize(size),
              color: disabled
                  ? const Color.fromRGBO(173, 181, 189, 1.0)
                  : textColor!.withOpacity(isPressed ? 0.5 : 1.0)),
        )
      else
        Container(),
      Container(
        margin: EdgeInsets.symmetric(horizontal: getIconSize(size) / 5),
        child: Text(text)
            .fontSize(getTextSize(size))
            .textColor(disabled
                ? const Color.fromRGBO(173, 181, 189, 1.0)
                : textColor!.withOpacity(isPressed ? 0.5 : 1.0))
            .alignment(Alignment.center),
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.max,
      children: iconAtLeft ?? true ? children1 : children1.reversed.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double myradius = (radius.value * size.value) / 80;
    final ValueNotifier<bool> isPressed = useState(false);
    return AbsorbPointer(
      absorbing: disabled,
      child: _styledInnerContent(
              text: content, isPressed: isPressed.value, icon: icon)
          .parent(({required Widget child}) => _styledBox(
              child: child, isPressed: isPressed.value, radius: myradius))
          .parent(({required Widget child}) => _outlinedBorder(
              child: child, isPressed: isPressed.value, radius: myradius))
          .gestures(
            onTap: onPressed,
            onTapDown: (TapDownDetails details) => isPressed.value = true,
            onTapUp: (TapUpDetails details) => isPressed.value = false,
            onTapCancel: () => isPressed.value = false,
          ),
    );
  }
}
