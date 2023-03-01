import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_iconbutton_size.dart';
import '../../type/hm_button_type.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';

class HMIconButton extends HookWidget {
  // final IconButtonProps customProps;
  const HMIconButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      this.fillColor,
      this.iconColor,
      this.radius,
      this.buttonVariant,
      this.disabled = false,
      this.hidden = false,
      this.size});
  final bool disabled;
  final bool hidden;
  final Widget icon;
  final void Function() onPressed;
  final Color? fillColor;
  final Color? iconColor;
  final HMIconButtonSize? size;
  final HMRadius? radius;
  final HMButtonVariant? buttonVariant;

  // double getIconSize(HMIconButtonSize size) {
  //   switch (size) {
  //     case HMIconButtonSize.xs:
  //       return 20.0;
  //     case HMIconButtonSize.sm:
  //       return 25.0;
  //     case HMIconButtonSize.md:
  //       return 30.0;
  //     case HMIconButtonSize.lg:
  //       return 40.0;
  //     case HMIconButtonSize.xl:
  //       return 45.0;
  //   }
  // }

  Widget _styledBox(
      {required Widget child,
      required bool isPressed,
      required double iconSize,
      required double buttonRadius,
      required HMButtonVariant variant,
      required Color buttonColor,
      required Color buttonIconColor}) {
    return Visibility(
      visible: !hidden,
      child: Container(
        alignment: Alignment.center,
        width: iconSize * 1.5,
        height: iconSize * 1.5,
        // padding: EdgeInsets.all(iconSize * 0.2),
        decoration: BoxDecoration(
          color: disabled
              ? const Color.fromRGBO(228, 229, 230, 1)
              : variant == HMButtonVariant.filled
                  ? buttonColor
                  : Colors.transparent,
          // Color.alphaBlend(
          //     variant == HMButtonVariant.filled
          //         ? Colors.black.withOpacity(isPressed ? 0.1 : 0.0)
          //         : buttonIconColor.withOpacity(isPressed ? 0.1 : 0.0),
          //     variant == HMButtonVariant.filled
          //         ? buttonColor
          //         : Colors.transparent),
          border: variant == HMButtonVariant.outlined
              ? Border.all(
                  color: buttonIconColor,
                  style: disabled ? BorderStyle.none : BorderStyle.solid)
              : null,
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _outlinedBorder(
          {required Widget child,
          required bool isPressed,
          required Color buttonColor,
          required HMButtonVariant variant,
          required Color buttonIconColor,
          required double buttonRadius}) =>
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: variant == HMButtonVariant.filled
            ? child.decorated(
                border: isPressed
                    ? Border.all(
                        color: variant == HMButtonVariant.filled
                            ? buttonColor
                            : Colors.transparent,
                        width: 2)
                    : null,
                borderRadius: BorderRadius.circular(buttonRadius * 1.2))
            : child,
      );

  Widget _styledInnerContent(
      {required Widget icon,
      required bool isPressed,
      required Color buttonColor,
      required Color buttonIconColor,
      required double iconSize,
      required HMButtonVariant variant}) {
    return IconTheme(
        data:
            IconThemeData(color: iconColor ?? buttonIconColor, size: iconSize),
        child: icon);
    // Icon(
    //   icon,
    //   color: disabled
    //       ? const Color.fromRGBO(169, 179, 187, 1)
    //       : variant == HMButtonVariant.filled
    //           ? iconColor ?? checkColor(fillColor ?? defaultColor)
    //           : buttonIconColor.withOpacity(isPressed ? 0.3 : 1.0),
    //   size: size - 5,
    // );
  }

  @override
  Widget build(BuildContext context) {
    final iconButtonTheme = Theme.of(context).extension<HMIconButtonTheme>();
    final buttonSize = size ?? iconButtonTheme?.size ?? HMIconButtonSize.md;
    final myRadius = radius ?? iconButtonTheme?.radius ?? HMRadius.md;
    final buttonRadius =
        myRadius.value; //(myRadius.value * buttonSize.value) / 80;
    final buttonColor = fillColor ??
        iconButtonTheme?.fillColor ??
        const Color.fromRGBO(121, 80, 242, 1);
    final buttonIconColor = iconColor ??
        iconButtonTheme?.iconColor ??
        const Color.fromRGBO(121, 80, 242, 1);
    final variant = buttonVariant ??
        iconButtonTheme?.buttonVariant ??
        HMButtonVariant.filled;
    final isPressed = useState(false);

    return AbsorbPointer(
      absorbing: disabled,
      child: _styledInnerContent(
              icon: icon,
              buttonColor: buttonColor,
              buttonIconColor: buttonIconColor,
              variant: variant,
              isPressed: isPressed.value,
              iconSize: buttonSize.value)
          .parent(({required Widget child}) => Opacity(
                opacity: isPressed.value ? 0.5 : 1.0,
                child: _styledBox(
                    child: child,
                    iconSize: buttonSize.value,
                    buttonColor: buttonColor,
                    variant: variant,
                    buttonIconColor: buttonIconColor,
                    isPressed: isPressed.value,
                    buttonRadius: buttonRadius),
              ))
          .parent(({required child}) => _outlinedBorder(
              child: child,
              isPressed: isPressed.value,
              buttonColor: buttonColor,
              variant: variant,
              buttonIconColor: buttonIconColor,
              buttonRadius: buttonRadius))
          .gestures(
            onTap: onPressed,
            onTapDown: (details) => isPressed.value = true,
            onTapUp: (details) => isPressed.value = false,
            onTapCancel: () => isPressed.value = false,
          ),
    );
  }
}
