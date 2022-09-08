import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/constant.dart';

class HMFilterChips extends HookWidget {
  const HMFilterChips(
      {this.disabled = false,
      this.hidden = false,
      this.radius = 10,
      this.selectedColor,
      this.isFilled = false,
      this.scale = 1.0,
      this.avatar,
      required this.label,
      this.borderSide,
      this.textColor,
      this.backgroundColor,
      this.showCheckmark = true,
      this.spacing = 10,
      this.onSelected,
      Key? key})
      : super(key: key);
  final bool disabled;
  final bool hidden;
  final double radius;
  final Widget? avatar;
  final Widget label;
  final bool showCheckmark;
  final double spacing;
  final double scale;
  final bool isFilled;
  final BorderSide? borderSide;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final void Function(dynamic value)? onSelected;

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSelectPannel({required ValueNotifier<bool> selected}) {
    return FilterChip(
        visualDensity: VisualDensity.compact,
        avatar: avatar,
        label: label,
        selected: selected.value,
        backgroundColor: disabled
            ? outlineColor.withOpacity(0.3)
            : isFilled
                ? backgroundColor ?? defaultColor
                : Colors.grey[100],
        selectedColor: isFilled
            ? selectedColor ??
                Color.alphaBlend(Colors.black.withOpacity(0.3),
                    backgroundColor ?? defaultColor)
            : Colors.grey[100],
        side: BorderSide(
            width: 1,
            color:
                selected.value ? selectedColor ?? defaultColor : outlineColor,
            style: isFilled ? BorderStyle.none : BorderStyle.solid),
        showCheckmark: showCheckmark,
        checkmarkColor: isFilled ? Colors.white : selectedColor,
        elevation: 0.0,
        pressElevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        onSelected: (bool value) {
          selected.value = value;
          onSelected!(value);
        });
  }

  @override
  Widget build(BuildContext context) {
    final selected = useState(false);

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          selected: selected,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }
}
