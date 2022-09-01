import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hmwidget/utils/hm_raduis.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/constant.dart';
import '../../size/hm_textfield_size.dart';
import '../../type/hm_textfield_type.dart';

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
    this.textInputAction = TextInputAction.done,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.minLines = 2,
    this.maxLines = 4,
    this.onChange,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.fillColor,
    this.isRequired = false,
    this.variant = HMTextVariant.outlined,
    this.size = HMTextFieldSize.md,
    this.radius = HMRadius.sm,
    Key? key,
  }) : super(key: key);
  final bool disabled;
  final bool hidden;
  final String? hintText;
  final String? value;
  final int? maxLength;
  final bool isRequired;
  final HMTextVariant variant;
  final HMTextFieldSize size;
  final HMRadius radius;
  final Color? fillColor;
  final Color? iconColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final void Function()? onTap;
  final void Function(String value)? onChange;
  final void Function(String value)? onSubmitted;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final HMTextFieldType textFieldType;
  final int minLines;
  final int maxLines;

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
  }) {
    return buildTextField(textFieldType, controller);
  }

  @override
  Widget build(BuildContext context) {
    final controller = useState(TextEditingController(text: value));

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledTextField(
          controller: controller,
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
      HMTextFieldType type, ValueNotifier<TextEditingController> controller) {
    final textSize = _getTextSize(size);
    final showPassword = useState(true);
    switch (type) {
      case HMTextFieldType.text:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: variant == HMTextVariant.filled
                  ? fillColor ?? const Color.fromRGBO(236, 238, 239, 1)
                  : null,
              border: Border.all(
                  color: outlineColor,
                  width: 1.0,
                  style: variant == HMTextVariant.filled
                      ? BorderStyle.none
                      : BorderStyle.solid),
              borderRadius: BorderRadius.circular(radius.value),
            ),
            child: Row(
              children: <Widget>[
                prefixIcon != null
                    ? _buildPrefixIcon(_getTextSize(size))
                    : const SizedBox(),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: textInputAction,
                    controller: controller.value,
                    style: TextStyle(fontSize: textSize),
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: keyboardType == TextInputType.emailAddress
                        ? false
                        : true,
                    maxLength: maxLength,
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
                    onChanged: (value) {
                      onChange!(value);
                    },
                    onSubmitted: onSubmitted,
                  ),
                ),
                suffixIcon != null
                    ? _buildSuffixIcon(_getTextSize(size))
                    : const SizedBox(),
              ],
            ),
          ),
        );

      case HMTextFieldType.password:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: variant == HMTextVariant.filled
                  ? fillColor ?? const Color.fromRGBO(236, 238, 239, 1)
                  : null,
              border: Border.all(
                  color: outlineColor,
                  width: 1.0,
                  style: variant == HMTextVariant.filled
                      ? BorderStyle.none
                      : BorderStyle.solid),
              borderRadius: BorderRadius.circular(radius.value),
            ),
            child: Row(
              children: <Widget>[
                prefixIcon != null
                    ? _buildPrefixIcon(_getTextSize(size))
                    : const SizedBox(),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: controller.value,
                    style: TextStyle(fontSize: textSize),
                    textCapitalization: TextCapitalization.none,
                    obscureText: showPassword.value,
                    textInputAction: textInputAction,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabled: !disabled,
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      isDense: true,
                    ),
                    onTap: onTap,
                    onChanged: (value) {
                      onChange!(value);
                    },
                    onSubmitted: (value) {
                      onSubmitted!(value);
                    },
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                        constraints: BoxConstraints(minHeight: textSize * 2),
                        child: Icon(
                          showPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
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
              color: variant == HMTextVariant.filled
                  ? fillColor ?? const Color.fromRGBO(236, 238, 239, 1)
                  : null,
              border: Border.all(
                  color: outlineColor,
                  width: 1.0,
                  style: variant == HMTextVariant.filled
                      ? BorderStyle.none
                      : BorderStyle.solid),
              borderRadius: BorderRadius.circular(radius.value),
            ),
            child: Row(
              children: <Widget>[
                prefixIcon != null
                    ? _buildPrefixIcon(_getTextSize(size))
                    : const SizedBox(),
                Expanded(
                  child: TextField(
                    controller: controller.value,
                    style: TextStyle(fontSize: textSize),
                    textCapitalization: TextCapitalization.none,
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
                    ],
                    onTap: onTap,
                    onChanged: (value) {
                      onChange!(value);
                    },
                    onSubmitted: (value) {
                      onSubmitted!(value);
                    },
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
              color: variant == HMTextVariant.filled
                  ? fillColor ?? const Color.fromRGBO(236, 238, 239, 1)
                  : null,
              border: Border.all(
                  color: outlineColor,
                  width: 1.0,
                  style: variant == HMTextVariant.filled
                      ? BorderStyle.none
                      : BorderStyle.solid),
              borderRadius: BorderRadius.circular(radius.value),
            ),
            child: Row(
              children: <Widget>[
                prefixIcon != null
                    ? _buildPrefixIcon(_getTextSize(size))
                    : const SizedBox(),
                Expanded(
                  child: TextField(
                    controller: controller.value,
                    style: TextStyle(fontSize: textSize),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: textInputAction,
                    minLines: 2,
                    maxLines: 4,
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 5),
                      isDense: true,
                    ),
                    onTap: onTap,
                    onChanged: (value) {
                      onChange!(value);
                    },
                    onSubmitted: (value) {
                      onSubmitted!(value);
                    },
                  ),
                ),
                suffixIcon != null
                    ? _buildSuffixIcon(_getTextSize(size))
                    : const SizedBox(),
              ],
            ),
          ),
        );
    }
  }
}
