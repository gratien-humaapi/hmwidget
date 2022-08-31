import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hmwidget/size/hm_iconbutton_size.dart';
import 'package:hmwidget/utils/hm_raduis.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../type/hm_button_type.dart';

class HMIconButton extends HookWidget {
  // final IconButtonCustomProps customProps;
  const HMIconButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      this.fillColor,
      this.iconColor,
      this.radius,
      this.buttonVariant,
      this.disabled = false,
      this.hidden = false,
      this.size})
      : super(key: key);
  final bool disabled;
  final bool hidden;
  final IconData icon;
  final void Function() onPressed;
  final Color? fillColor;
  final Color? iconColor;
  final HMIconButtonSize? size;
  final HMRadius? radius;
  final HMButtonVariant? buttonVariant;

  Widget _styledBox(
          {required Widget child,
          required bool isPressed,
          required double size,
          required double radius}) =>
      Visibility(
        visible: hidden,
        child: child.constrained(width: size, height: size).decorated(
              color: disabled
                  ? const Color.fromRGBO(228, 229, 230, 1)
                  : Color.alphaBlend(
                      Colors.black.withOpacity(isPressed ? 0.05 : 0.0),
                      buttonVariant == HMButtonVariant.filled
                          ? fillColor!
                          : Colors.transparent),
              border: buttonVariant == HMButtonVariant.outlined
                  ? Border.all(
                      color: iconColor!,
                      width: 1,
                      style: disabled ? BorderStyle.none : BorderStyle.solid)
                  : null,
              borderRadius: BorderRadius.circular(radius),
            ),
      );

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
          {required IconData icon,
          required bool isPressed,
          required double size}) =>
      Icon(
        icon,
        color: disabled
            ? const Color.fromRGBO(169, 179, 187, 1)
            : iconColor!.withOpacity(isPressed ? 0.3 : 1.0),
        size: size - 5,
      );

  @override
  Widget build(BuildContext context) {
    final isPressed = useState(false);
    final myRadius = (radius!.value * size!.value) / 80;
    double mySize = size!.value;
    return AbsorbPointer(
      absorbing: disabled,
      child: _styledInnerContent(
              icon: icon, isPressed: isPressed.value, size: mySize)
          .parent(({required Widget child}) => _styledBox(
              child: child,
              size: mySize,
              isPressed: isPressed.value,
              radius: myRadius))
          .parent(({required child}) => _outlinedBorder(
              child: child, isPressed: isPressed.value, radius: myRadius))
          .gestures(
            onTap: disabled ? null : onPressed,
            onTapDown: (details) => isPressed.value = true,
            onTapUp: (details) => isPressed.value = false,
            onTapCancel: () => isPressed.value = false,
          )
          .alignment(Alignment.center),
    );
  }
}
