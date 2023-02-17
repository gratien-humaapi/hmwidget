//

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';

class HMChoiceChips extends HookWidget {
  const HMChoiceChips(
      {this.disabled = false,
      this.hidden = false,
      this.radius,
      this.selectedColor,
      this.isFilled,
      this.avatar,
      required this.label,
      this.borderSide,
      this.textColor,
      this.backgroundColor,
      required this.onSelected,
      super.key});

  final bool disabled;
  final bool hidden;
  final HMRadius? radius;
  final Widget? avatar;
  final Widget label;
  final bool? isFilled;
  final BorderSide? borderSide;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final void Function(bool value) onSelected;

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSelectPannel(
      {required ValueNotifier<bool> selected,
      required bool isfilledChip,
      required Color chipBackgroundColor,
      required Color selectedChipColor,
      required BorderSide chipBorderSide,
      required Color chipTextColor,
      required HMRadius chipRadius}) {
    return ChoiceChip(
        visualDensity: VisualDensity.compact,
        avatar: avatar,
        label: label,
        selected: selected.value,
        disabledColor: const Color(0x16000000),
        backgroundColor:
            isfilledChip ? chipBackgroundColor : Colors.transparent,
        selectedColor: isfilledChip
            ? selectedChipColor
            : selectedChipColor.withOpacity(0.1),
        side: BorderSide(
            color: selected.value ? selectedChipColor : Colors.grey,
            style: isfilledChip ? BorderStyle.none : BorderStyle.solid),
        elevation: 0.0,
        pressElevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(chipRadius.value)),
        onSelected: disabled
            ? null
            : (bool value) {
                selected.value = value;
                onSelected(value);
              });
  }

  @override
  Widget build(BuildContext context) {
    final chipTheme = Theme.of(context).extension<HMChipTheme>();
    final isfilledChip = isFilled ?? chipTheme?.isFilled ?? false;
    final chipRadius = radius ?? chipTheme?.radius ?? HMRadius.xl;
    final Color chipBackgroundColor =
        backgroundColor ?? chipTheme?.backgroundColor ?? Colors.black26;
    final Color selectedChipColor =
        selectedColor ?? chipTheme?.selectedColor ?? defaultColor;
    final Color chipTextColor =
        textColor ?? chipTheme?.textColor ?? Colors.black;
    final selected = useState(false);
    final BorderSide chipBorderSide = borderSide ??
        chipTheme?.borderSide ??
        BorderSide(color: selected.value ? defaultColor : outlineColor);

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          selected: selected,
          isfilledChip: isfilledChip,
          chipRadius: chipRadius,
          chipBackgroundColor: chipBackgroundColor,
          selectedChipColor: selectedChipColor,
          chipTextColor: chipTextColor,
          chipBorderSide: chipBorderSide,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }
}
