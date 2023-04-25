import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_textfield_size.dart';
import '../../type/hm_textfield_type.dart';
import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';

class HMTextField extends HookWidget {
  // final TextFieldProps customProps;
  const HMTextField({
    this.disabled = false,
    this.hidden = false,
    this.hintText,
    this.controller,
    this.value,
    this.showPasswordIcon,
    this.hidePasswordIcon,
    this.focusNode,
    this.iconColor,
    this.disabledColor,
    this.maxLength,
    this.textFieldType,
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.minLines,
    this.maxLines,
    this.onEditingComplete,
    this.onChange,
    this.onSubmitted,
    this.inputFormatters,
    this.onTap,
    this.prefixIcon,
    this.contentPadding,
    this.borderColor,
    this.disabledTextColor,
    this.fillColor,
    this.variant,
    this.size,
    this.radius,
    super.key,
  });
  final bool disabled;
  final bool hidden;
  final String? hintText;
  final String? value;
  final int? maxLength;
  final TextEditingController? controller;
  final HMTextVariant? variant;
  final HMTextFieldSize? size;
  final HMRadius? radius;
  final EdgeInsets? contentPadding;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? hidePasswordIcon;
  final Widget? showPasswordIcon;

  final void Function()? onTap;
  final void Function(String value)? onChange;
  final void Function()? onEditingComplete;
  final void Function(String value)? onSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final HMTextFieldType? textFieldType;
  final int? minLines;
  final int? maxLines;

  double _getTextSize(HMTextFieldSize size) {
    switch (size) {
      case HMTextFieldSize.xs:
        return 12.0;
      case HMTextFieldSize.sm:
        return 14.0;
      case HMTextFieldSize.md:
        return 16.0;
      case HMTextFieldSize.lg:
        return 18.0;
      case HMTextFieldSize.xl:
        return 20.0;
    }
  }

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledTextField({
    required TextEditingController controller,
    required HMTextFieldSize fieldSize,
    required HMRadius fieldRadius,
    required Color background,
    required HMTextVariant fieldVariant,
    required Color fieldIconColor,
    required HMTextFieldTheme? textFieldTheme,
    required EdgeInsets padding,
    required Color disableColor,
    required Color disableTextColor,
  }) {
    return Container(
      padding: padding,
      // height: minLines == null ? fieldSize.value : null,
      constraints: BoxConstraints(minHeight: fieldSize.value),
      decoration: BoxDecoration(
        color: disabled
            ? disableColor
            : fieldVariant == HMTextVariant.filled
                ? background
                : null,
        border: Border.all(
          color:
              disabled ? const Color(0x00000000) : borderColor ?? outlineColor,
          style: fieldVariant == HMTextVariant.filled
              ? BorderStyle.none
              : BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(fieldRadius.value),
      ),
      child: Center(
        child: buildTextField(
            textFieldType ?? HMTextFieldType.text,
            controller,
            fieldSize,
            fieldVariant,
            fieldRadius,
            disableTextColor: disableTextColor,
            fieldIconColor,
            background,
            textFieldTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textFieldTheme = Theme.of(context).extension<HMTextFieldTheme>();
    final background =
        fillColor ?? textFieldTheme?.fillColor ?? const Color(0xFFEEEEF0);
    final disableColor = disabledColor ??
        textFieldTheme?.disabledColor ??
        const Color(0x16000000);
    final disableTextColor =
        disabledTextColor ?? textFieldTheme?.disabledTextColor ?? Colors.grey;
    final fieldRadius = radius ?? textFieldTheme?.radius ?? HMRadius.md;
    final fieldSize = size ?? textFieldTheme?.size ?? HMTextFieldSize.md;
    final padding = contentPadding ??
        textFieldTheme?.contentPadding ??
        EdgeInsets.only(
            left: 20.0,
            right: 12,
            bottom: textFieldType == HMTextFieldType.multiline ? 10 : 0);
    final fieldVariant =
        variant ?? textFieldTheme?.variant ?? HMTextVariant.filled;
    final fieldIconColor =
        iconColor ?? textFieldTheme?.iconColor ?? Colors.grey;
    final textcontroller = useTextEditingController(text: value);
    final TextEditingController textEditingController =
        controller ?? textcontroller;
    if (value != null) {
      textEditingController.value.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value!.length),
        composing: TextRange.empty,
      );
    }
    return AbsorbPointer(
        absorbing: disabled,
        child: _styledTextField(
          controller: textEditingController,
          background: background,
          padding: padding,
          fieldRadius: fieldRadius,
          disableColor: disableColor,
          disableTextColor: disableTextColor,
          fieldSize: fieldSize,
          fieldVariant: fieldVariant,
          fieldIconColor: fieldIconColor,
          textFieldTheme: textFieldTheme,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }

  Widget _buildPrefixIcon(double size) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: size * 2),
      child: prefixIcon,
    );
  }

  Widget _buildSuffixIcon(double size) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: size * 2),
      child: suffixIcon,
    );
  }

  Widget buildTextField(
      HMTextFieldType type,
      TextEditingController controller,
      HMTextFieldSize fieldSize,
      HMTextVariant fieldVariant,
      HMRadius fieldRadius,
      Color fieldIconColor,
      Color background,
      HMTextFieldTheme? textFieldTheme,
      {required Color disableTextColor}) {
    final textSize = _getTextSize(fieldSize);
    final showPassword = useState(false);
    switch (type) {
      case HMTextFieldType.text:
        return SizedBox(
          child: Row(
            children: <Widget>[
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildPrefixIcon(_getTextSize(fieldSize)),
                ),
              // const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.text,
                  textInputAction: textInputAction,
                  controller: controller,
                  focusNode: focusNode,
                  style: TextStyle(
                    color: disabled ? disableTextColor : null,
                    fontSize: textSize,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: !(keyboardType == TextInputType.emailAddress),
                  maxLength: maxLength,
                  textAlignVertical: TextAlignVertical.center,
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: textSize,
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: onTap,
                  onChanged: onChange,
                  onSubmitted: onSubmitted,
                  onEditingComplete: onEditingComplete,
                ),
              ),
              // const SizedBox(width: 10),
              if (suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: _buildSuffixIcon(_getTextSize(fieldSize)),
                ),
            ],
          ),
        );

      case HMTextFieldType.password:
        return SizedBox(
          child: Row(
            children: <Widget>[
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildPrefixIcon(_getTextSize(fieldSize)),
                ),
              // const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: controller,
                  style: TextStyle(
                    color: disabled ? disableTextColor : null,
                    fontSize: textSize,
                  ),
                  obscureText: !showPassword.value,
                  textInputAction: textInputAction,
                  autocorrect: false,
                  focusNode: focusNode,
                  maxLength: maxLength,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: textSize,
                        fontWeight: FontWeight.normal),
                  ),
                  onTap: onTap,
                  onChanged: onChange,
                  onSubmitted: onSubmitted,
                  onEditingComplete: onEditingComplete,
                ),
              ),
              // const SizedBox(width: 10),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    constraints: BoxConstraints(minHeight: textSize * 2),
                    child: IconTheme(
                      data: IconThemeData(
                        size: textSize * 1.5,
                        color: Colors.grey,
                      ),
                      child: showPassword.value
                          ? hidePasswordIcon ??
                              textFieldTheme?.hidePasswordIcon ??
                              const Icon(Icons.visibility_off)
                          : showPasswordIcon ??
                              textFieldTheme?.showPasswordIcon ??
                              const Icon(Icons.visibility),
                    ),
                  ),
                ),
                onTap: () {
                  showPassword.value = !showPassword.value;
                },
              ),
            ],
          ),
        );

      case HMTextFieldType.number:
        return SizedBox(
          child: Row(
            children: <Widget>[
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildPrefixIcon(_getTextSize(fieldSize)),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(
                    color: disabled ? disableTextColor : null,
                    fontSize: textSize,
                  ),
                  textInputAction: textInputAction,
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  focusNode: focusNode,
                  maxLength: maxLength,
                  decoration: InputDecoration.collapsed(
                    hintText: hintText,
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: textSize,
                        fontWeight: FontWeight.normal),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll(',', '.'),
                      ),
                    ),
                    ...?inputFormatters,
                  ],
                  onTap: onTap,
                  onChanged: onChange,
                  onSubmitted: onSubmitted,
                  onEditingComplete: onEditingComplete,
                ),
              ),
            ],
          ),
        );

      case HMTextFieldType.multiline:
        return SizedBox(
          child: Row(
            children: <Widget>[
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildPrefixIcon(_getTextSize(fieldSize)),
                ),
              // const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: controller,
                    style: TextStyle(
                      color: disabled ? disableTextColor : null,
                      fontSize: textSize,
                    ),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    // textInputAction: textInputAction,
                    focusNode: focusNode,
                    minLines: minLines,
                    maxLines: maxLines,
                    maxLength: maxLength,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration.collapsed(
                      hintText: hintText,
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: textSize,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: onTap,
                    onChanged: onChange,
                    onSubmitted: onSubmitted,
                    onEditingComplete: onEditingComplete,
                  ),
                ),
              ),
              if (suffixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildSuffixIcon(_getTextSize(fieldSize)),
                ),
            ],
          ),
        );
    }
  }
}
