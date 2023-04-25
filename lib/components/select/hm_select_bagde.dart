import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../type/hm_select_type.dart';
import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';

class HMSelectBadge extends HookWidget {
  // final SelectBadgesProps customProps;
  const HMSelectBadge({
    super.key,
    this.disabled = false,
    this.hidden = false,
    this.radius,
    this.chipColor,
    this.isFilled,
    this.deleteIcon,
    this.textColor,
    required this.direction,
    this.deleteIconColor,
    required this.selectedList,
    required this.onDeleted,
    required this.onTap,
    this.showDeleteIcon = true,
  });

  final bool disabled;
  final bool hidden;
  final List<HMSelectedItem> selectedList;
  final HMRadius? radius;
  final bool showDeleteIcon;
  final Color? chipColor;
  final void Function(String deletedValue) onDeleted;
  final void Function(int index) onTap;
  final bool? isFilled;
  final Axis direction;
  final Color? textColor;
  final Color? deleteIconColor;
  final Widget? deleteIcon;

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSelectPannel({
    required bool isFilledBagde,
    required Color badgeColor,
    required Color badgeTextColor,
    required Axis direction,
    required HMRadius badgeRadius,
    required Color delIconColor,
  }) {
    return SizedBox(
      height: 150,
      child: SingleChildScrollView(
        scrollDirection: direction,
        // padding: const EdgeInsets.symmetric(vertical: 10),
        physics: const BouncingScrollPhysics(),
        child: Wrap(
          // spacing: 25,
          runSpacing: 10,
          children: List.generate(selectedList.length, (index) {
            final HMSelectedItem item = selectedList[index];
            final Widget label = item.label;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InputChip(
                visualDensity: VisualDensity.compact,
                avatar: item.avatar,
                labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                label: label,
                deleteIcon: disabled ? null : deleteIcon,
                deleteIconColor: delIconColor,
                disabledColor: const Color(0x16000000),
                backgroundColor:
                    isFilledBagde ? badgeColor : Colors.transparent,
                side: BorderSide(
                    color: outlineColor,
                    style:
                        isFilledBagde ? BorderStyle.none : BorderStyle.solid),
                elevation: 0.0,
                pressElevation: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(badgeRadius.value)),
                onDeleted: disabled ? null : () => onDeleted(item.value),
                onPressed: () => onTap(index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final selectedItems = useState(selectedList);
    final selectBagdeTheme = Theme.of(context).extension<HMSelectBagdeTheme>();
    final HMRadius badgeRadius =
        radius ?? selectBagdeTheme?.radius ?? HMRadius.xl;
    final Color badgeColor =
        chipColor ?? selectBagdeTheme?.chipColor ?? Colors.black26;
    final bool isFilledBagde = isFilled ?? selectBagdeTheme?.isFilled ?? true;
    final Color badgeTextColor =
        textColor ?? selectBagdeTheme?.textColor ?? Colors.black;
    final Color delIconColor = deleteIconColor ??
        selectBagdeTheme?.deleteIconColor ??
        Colors.grey.shade700;

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          badgeRadius: badgeRadius,
          badgeColor: badgeColor,
          direction: direction,
          badgeTextColor: badgeTextColor,
          isFilledBagde: isFilledBagde,
          delIconColor: delIconColor,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }
}
