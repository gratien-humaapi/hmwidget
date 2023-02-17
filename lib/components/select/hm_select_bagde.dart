
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../type/hm_select_type.dart';
import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';

class HMSelectBadge extends HookWidget {
  // final SelectBadgesCustomProps customProps;
  const HMSelectBadge({
    super.key,
    this.disabled = false,
    this.hidden = false,
    this.radius,
    this.chipColor,
    this.isFilled,
    this.deleteIcon,
    this.textColor,
    this.deleteIconColor,
    required this.selectedList,
    required this.onDeleted,
    this.showDeleteIcon = true,
  });

  final bool disabled;
  final bool hidden;
  final List<HMSelectedItem> selectedList;
  final HMRadius? radius;
  final bool showDeleteIcon;
  final Color? chipColor;
  final void Function(String deletedValue) onDeleted;
  final bool? isFilled;
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
    required HMRadius badgeRadius,
    required Color delIconColor,
  }) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: selectedList.map((item) {
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
              ),
            );
          }).toList(),
        ));
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
          badgeTextColor: badgeTextColor,
          isFilledBagde: isFilledBagde,
          delIconColor: delIconColor,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }
}
