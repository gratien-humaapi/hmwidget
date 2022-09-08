import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../type/hm_select_type.dart';
import '../../utils/constant.dart';
import '../../utils/hm_raduis.dart';

class HMSelectBadges extends HookWidget {
  // final SelectBadgesCustomProps customProps;
  const HMSelectBadges({
    Key? key,
    this.disabled = false,
    this.hidden = false,
    this.radius = HMRadius.sm,
    this.chipColor,
    this.borderSide,
    this.isFilled = false,
    this.spacing = 10,
    this.deleteIcon,
    this.textColor,
    this.deleteIconColor,
    required this.selectedList,
    required this.onDeleted,
    this.showDeleteIcon = true,
  }) : super(key: key);

  final bool disabled;
  final bool hidden;
  final List<HMSelectedItem> selectedList;
  final HMRadius radius;
  final bool showDeleteIcon;
  final Color? chipColor;
  final void Function(HMSelectedItem) onDeleted;
  final double spacing;
  final bool isFilled;
  final BorderSide? borderSide;
  final Color? textColor;
  final Color? deleteIconColor;
  final Icon? deleteIcon;

  List<Widget> buildChip(ValueNotifier<List<HMSelectedItem>> selectedItems) {
    return selectedItems.value.map((item) {
      final String label = item.label;
      final Widget avatar = item.avatar;
      return InputChip(
        visualDensity: VisualDensity.compact,
        avatar: avatar,
        labelPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        label: Text(
          label,
          overflow: TextOverflow.ellipsis,
        ),
        deleteIcon: deleteIcon,
        deleteIconColor: deleteIconColor ?? Colors.grey[700],
        backgroundColor: disabled
            ? outlineColor.withOpacity(0.3)
            : isFilled
                ? chipColor
                : Colors.grey[100],
        side: BorderSide(
            width: 1,
            color: outlineColor,
            style: isFilled ? BorderStyle.none : BorderStyle.solid),
        elevation: 0.0,
        pressElevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.value)),
        onDeleted: () {
          List<HMSelectedItem> copy = List.from(selectedItems.value);
          copy.remove(item);
          selectedItems.value = copy;
          onDeleted(item);
        },
      );
    }).toList();
  }

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSelectPannel({
    required ValueNotifier<List<HMSelectedItem>> selectedItems,
  }) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: spacing,
      runSpacing: spacing / 2,
      children: buildChip(selectedItems),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = useState(selectedList);

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          selectedItems: selectedItems,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }
}
