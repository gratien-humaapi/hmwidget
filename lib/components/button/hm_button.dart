import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_button_size.dart';
import '../../type/hm_button_type.dart';
import '../../utils/helper.dart';
import '../../utils/hm_radius.dart';
import '../../utils/sizes.dart';
import '../../widget_theme.dart';

/// child of  type [Widget] is alternative to title key. title will get priority over child

class HMButton extends HookWidget {
  const HMButton({
    super.key,
    required this.content,
    this.fillColor,
    this.textColor,
    this.radius,
    this.fontWeight,
    this.size,
    this.fullWidth = false,
    this.buttonVariant,
    this.boxShadow,
    this.isLoading = false,
    this.loader = HMLoader.oval,
    this.icon,
    this.borderColor,
    this.iconAtLeft = true,
    required this.onPressed,
    this.disabled = false,
    this.hidden = false,
  });
  //  :
  // assert(buttonVariant == HMButtonVariant.filled || textColor != null,
  //           'You must give a textColor if button is not filled');
  final bool disabled;
  final bool hidden;
  final String content;
  final Color? fillColor;
  final Color? textColor;
  final Color? borderColor;
  final HMRadius? radius;
  final FontWeight? fontWeight;
  final HMButtonSize? size;
  final bool isLoading;
  final HMLoader loader;
  final List<BoxShadow>? boxShadow;
  final bool fullWidth;
  final HMButtonVariant? buttonVariant;
  final Widget? icon;
  final bool? iconAtLeft;

  final void Function() onPressed;
  // final ButtonProps customProps;

  // The button Container
  Widget _styledBox({
    required Widget child,
    required bool isPressed,
    required HMButtonSize buttonSize,
    required double buttonRadius,
    required HMButtonVariant variant,
    required HMButtonTheme? buttonTheme,
    required Color buttonTextColor,
    required Color buttonColor,
  }) {
    return child
        .padding(
            horizontal: buttonSize.value * 0.1,
            vertical: buttonSize.value * 0.05)
        .constrained(
          minWidth: fullWidth ? double.infinity : 64,
          minHeight: buttonSize.value,
          // maxWidth: fullWidth ? double.infinity : (buttonSize.value * 1.0) + 10,
          // maxHeight: getRatio(buttonSize.value),
          // height: buttonSize.value,
        )
        .decorated(
          color: disabled
              ? const Color.fromRGBO(228, 229, 230, 1)
              : variant == HMButtonVariant.filled
                  ? buttonColor
                  : Colors.transparent,
          // Color.alphaBlend(
          //     variant == HMButtonVariant.filled
          //         ? Colors.black.withOpacity(isPressed ? 0.1 : 0.0)
          //         : buttonTextColor.withOpacity(isPressed ? 0.1 : 0.0),
          //     variant == HMButtonVariant.filled
          //         ? buttonColor
          //         : Colors.transparent),
          boxShadow: disabled ? null : boxShadow,
          border: variant == HMButtonVariant.outlined
              ? Border.all(
                  color: borderColor ?? buttonTextColor,
                  style: disabled ? BorderStyle.none : BorderStyle.solid)
              : Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(buttonRadius),
        );
  }

// The overlay border when button clicked
  Widget _outlinedBorder(
          {required Widget child,
          required bool isPressed,
          required HMButtonVariant variant,
          required HMButtonSize buttonSize,
          required Color buttonTextColor,
          required Color buttonColor,
          required double buttonRadius,
          required HMButtonTheme? buttonTheme}) =>
      Visibility(
        visible: !hidden,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: variant == HMButtonVariant.filled
              ? child.decorated(
                  border: isPressed
                      ? Border.all(color: buttonColor, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(buttonRadius * 1.2))
              : child,
        ),
      );

  // The content of the button
  Widget _styledInnerContent(
      {required String text,
      required Widget? icon,
      required bool isPressed,
      required Color buttonTextColor,
      required Color buttonColor,
      required HMButtonTheme? buttonTheme,
      required HMButtonSize buttonSize,
      required double buttonRadius,
      required HMButtonVariant variant}) {
    final List<Widget> children1 = <Widget>[
      if (icon != null)
        Container(
            margin: EdgeInsets.symmetric(horizontal: buttonSize.value * 0.05),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                  const Color(0xFFADB5BD).withOpacity(disabled ? 1 : 0.0),
                  BlendMode.srcATop),
              child: IconTheme(
                data: IconThemeData(
                  size: getTextSize(buttonSize) * 1.5,
                  color: disabled
                      ? const Color(0xFFADB5BD)
                      : variant == HMButtonVariant.filled
                          ? textColor ??
                              buttonTheme?.textColor ??
                              checkColor(buttonColor)
                          : buttonTextColor,
                ),
                child: icon,
              ),
            )
            // Icon(icon,
            //     buttonSize: getIconSize(buttonSize),
            // color: disabled
            //     ? const Color.fromRGBO(173, 181, 189, 1.0)
            //     : buttonTheme?.textColor
            //             ?.withOpacity(isPressed ? 0.5 : 1.0) ??
            //         textColor!.withOpacity(isPressed ? 0.5 : 1.0)),
            ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: buttonSize.value * 0.1),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
        )
            .fontSize(getTextSize(buttonSize))
            .letterSpacing(0.5)
            .fontWeight(fontWeight)
            .textColor(
              disabled
                  ? const Color(0xFFADB5BD)
                  : variant == HMButtonVariant.filled
                      ? textColor ??
                          buttonTheme?.textColor ??
                          checkColor(buttonColor)
                      : buttonTextColor,
            )
            .alignment(Alignment.center),
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: iconAtLeft ?? true ? children1 : children1.reversed.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonTheme = Theme.of(context).extension<HMButtonTheme>();
    final buttonSize = size ?? buttonTheme?.size ?? HMButtonSize.md;
    final myRadius = radius ?? buttonTheme?.radius ?? HMRadius.sm;
    final buttonRadius = (myRadius.value * buttonSize.value) / 80;
    final buttonColor = fillColor ??
        buttonTheme?.fillColor ??
        const Color.fromRGBO(121, 80, 242, 1);
    final buttonTextColor = textColor ??
        buttonTheme?.textColor ??
        const Color.fromRGBO(121, 80, 242, 1);
    final variant =
        buttonVariant ?? buttonTheme?.buttonVariant ?? HMButtonVariant.filled;

    final ValueNotifier<bool> isPressed = useState(false);
    return AbsorbPointer(
      absorbing: isLoading || disabled,
      child: Opacity(
        opacity: isLoading || isPressed.value ? 0.5 : 1.0,
        child: _styledInnerContent(
                text: content,
                isPressed: isPressed.value,
                icon: icon,
                buttonSize: buttonSize,
                buttonTextColor: buttonTextColor,
                buttonColor: buttonColor,
                variant: variant,
                buttonRadius: buttonRadius,
                buttonTheme: buttonTheme)
            .parent(({required Widget child}) => _styledBox(
                child: isLoading ? getLoader(loader, buttonTextColor) : child,
                isPressed: isPressed.value,
                variant: variant,
                buttonTextColor: buttonTextColor,
                buttonColor: buttonColor,
                buttonRadius: buttonRadius,
                buttonSize: buttonSize,
                buttonTheme: buttonTheme))
            .parent(({required Widget child}) => _outlinedBorder(
                child: child,
                buttonRadius: buttonRadius,
                buttonSize: buttonSize,
                variant: variant,
                buttonTextColor: buttonTextColor,
                buttonColor: buttonColor,
                isPressed: isPressed.value,
                buttonTheme: buttonTheme))
            .gestures(
              onTap: () {
                onPressed();
              },
              onTapDown: (TapDownDetails details) => isPressed.value = true,
              onTapUp: (TapUpDetails details) => isPressed.value = false,
              onTapCancel: () => isPressed.value = false,
            ),
      ),
    );
  }

  Widget getLoader(HMLoader loader, Color color) {
    switch (loader) {
      case HMLoader.bars:
        return Container();
      case HMLoader.dots:
        return Container();
      case HMLoader.oval:
        return Center(
          child: CircularProgressIndicator(color: color),
        );
    }
  }
}
