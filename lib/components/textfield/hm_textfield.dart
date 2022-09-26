import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hmwidget/utils/hm_radius.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/constant.dart';
import '../../size/hm_textfield_size.dart';
import '../../type/hm_textfield_type.dart';
import '../../widget_theme.dart';

class HMTextField extends HookWidget {
  // final TextFieldCustomProps customProps;
  const HMTextField({
    this.disabled = false,
    this.hidden = false,
    this.hintText,
    this.value,
    this.iconColor,
    this.maxLength,
    this.textFieldType = HMTextFieldType.text,
    this.textInputAction,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.minLines,
    this.maxLines,
    this.onChange,
    this.onSubmitted,
    this.inputFormatters,
    this.onTap,
    this.prefixIcon,
    this.fillColor,
    this.variant,
    this.size,
    this.radius,
    Key? key,
  }) : super(key: key);
  final bool disabled;
  final bool hidden;
  final String? hintText;
  final String? value;
  final int? maxLength;
  final HMTextVariant? variant;
  final HMTextFieldSize? size;
  final HMRadius? radius;
  final Color? fillColor;
  final Color? iconColor;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final void Function()? onTap;
  final void Function(String value)? onChange;
  final void Function(String value)? onSubmitted;
  final TextInputAction? textInputAction;
  final TextInputType keyboardType;
  final HMTextFieldType textFieldType;
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
    required ValueNotifier<TextEditingController> controller,
    required HMTextFieldSize fieldSize,
    required HMRadius fieldRadius,
    required Color background,
    required HMTextVariant fieldVariant,
    required Color fieldIconColor,
  }) {
    return buildTextField(textFieldType, controller, fieldSize, fieldVariant,
        fieldRadius, fieldIconColor, background);
  }

  @override
  Widget build(BuildContext context) {
    final textFieldTheme = Theme.of(context).extension<HMTextFieldTheme>();
    final background =
        fillColor ?? textFieldTheme?.fillColor ?? const Color(0xFFE3E3E4);
    final fieldRadius = radius ?? textFieldTheme?.radius ?? HMRadius.sm;
    final fieldSize = size ?? textFieldTheme?.size ?? HMTextFieldSize.md;
    final fieldVariant =
        variant ?? textFieldTheme?.variant ?? HMTextVariant.filled;
    final fieldIconColor =
        iconColor ?? textFieldTheme?.iconColor ?? Colors.grey;
    final controller = useState(TextEditingController(text: value));

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledTextField(
          controller: controller,
          background: background,
          fieldRadius: fieldRadius,
          fieldSize: fieldSize,
          fieldVariant: fieldVariant,
          fieldIconColor: fieldIconColor,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }

  Widget _buildPrefixIcon(double size) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 40, minHeight: size * 2),
      child: Icon(
        prefixIcon,
        size: size * 1.5,
        color: iconColor ?? Colors.grey,
      ),
    );
  }

  Widget _buildSuffixIcon(double size) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 40, minHeight: size * 2),
      child: Icon(
        suffixIcon,
        size: size * 1.5,
        color: iconColor ?? Colors.grey,
      ),
    );
  }

  Widget buildTextField(
      HMTextFieldType type,
      ValueNotifier<TextEditingController> controller,
      HMTextFieldSize fieldSize,
      HMTextVariant fieldVariant,
      HMRadius fieldRadius,
      Color fieldIconColor,
      Color background) {
    final textSize = _getTextSize(fieldSize);
    final showPassword = useState(false);
    switch (type) {
      case HMTextFieldType.text:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: fieldVariant == HMTextVariant.filled ? background : null,
              border: Border.all(
                  color: outlineColor,
                  style: fieldVariant == HMTextVariant.filled
                      ? BorderStyle.none
                      : BorderStyle.solid),
              borderRadius: BorderRadius.circular(fieldRadius.value),
            ),
            child: Row(
              children: <Widget>[
                if (prefixIcon != null)
                  _buildPrefixIcon(_getTextSize(fieldSize))
                else
                  const SizedBox(),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: textInputAction,
                    controller: controller.value,
                    style: TextStyle(fontSize: textSize),
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: !(keyboardType == TextInputType.emailAddress),
                    maxLength: maxLength,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      isDense: true,
                    ),
                    onTap: onTap,
                    onChanged: onChange,
                    onSubmitted: onSubmitted,
                  ),
                ),
                if (suffixIcon != null)
                  _buildSuffixIcon(_getTextSize(fieldSize))
                else
                  const SizedBox(),
              ],
            ),
          ),
        );

      case HMTextFieldType.password:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: fieldVariant == HMTextVariant.filled ? background : null,
              border: Border.all(
                  color: outlineColor,
                  style: fieldVariant == HMTextVariant.filled
                      ? BorderStyle.none
                      : BorderStyle.solid),
              borderRadius: BorderRadius.circular(fieldRadius.value),
            ),
            child: Row(
              children: <Widget>[
                if (prefixIcon != null)
                  _buildPrefixIcon(_getTextSize(fieldSize))
                else
                  const SizedBox(),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: controller.value,
                    style: TextStyle(fontSize: textSize),
                    obscureText: !showPassword.value,
                    textInputAction: textInputAction,
                    autocorrect: false,
                    maxLength: maxLength,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabled: !disabled,
                      counterText: '',
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      isDense: true,
                    ),
                    onTap: onTap,
                    onChanged: onChange,
                    onSubmitted: onSubmitted,
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                        constraints: BoxConstraints(minHeight: textSize * 2),
                        child: Icon(
                          showPassword.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: textSize * 1.5,
                          color: Colors.grey,
                        )),
                  ),
                  onTap: () {
                    showPassword.value = !showPassword.value;
                  },
                ),
              ],
            ),
          ),
        );

      case HMTextFieldType.number:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: fieldVariant == HMTextVariant.filled ? background : null,
              border: Border.all(
                  color: outlineColor,
                  style: fieldVariant == HMTextVariant.filled
                      ? BorderStyle.none
                      : BorderStyle.solid),
              borderRadius: BorderRadius.circular(fieldRadius.value),
            ),
            child: Row(
              children: <Widget>[
                if (prefixIcon != null)
                  _buildPrefixIcon(_getTextSize(fieldSize))
                else
                  const SizedBox(),
                Expanded(
                  child: TextField(
                    controller: controller.value,
                    style: TextStyle(fontSize: textSize),
                    textInputAction: textInputAction,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    maxLength: maxLength,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabled: !disabled,
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      isDense: true,
                      counterText: '',
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
                  ),
                ),
              ],
            ),
          ),
        );

      case HMTextFieldType.multiline:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: fieldVariant == HMTextVariant.filled ? background : null,
              border: Border.all(
                  color: outlineColor,
                  style: fieldVariant == HMTextVariant.filled
                      ? BorderStyle.none
                      : BorderStyle.solid),
              borderRadius: BorderRadius.circular(fieldRadius.value),
            ),
            child: Row(
              children: <Widget>[
                if (prefixIcon != null)
                  _buildPrefixIcon(_getTextSize(fieldSize))
                else
                  const SizedBox(),
                Expanded(
                  child: TextField(
                    controller: controller.value,
                    style: TextStyle(fontSize: textSize),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: textInputAction,
                    minLines: minLines,
                    maxLines: maxLength,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      isDense: true,
                    ),
                    onTap: onTap,
                    onChanged: onChange,
                    onSubmitted: onSubmitted,
                  ),
                ),
                if (suffixIcon != null)
                  _buildSuffixIcon(_getTextSize(fieldSize))
                else
                  Container(),
              ],
            ),
          ),
        );
    }
  }
}
