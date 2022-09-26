import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/constant.dart';
import '../../size/hm_select_size.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';

class HMMultiSelect extends HookWidget {
  const HMMultiSelect(
      {this.disabled = false,
      this.hidden = false,
      this.boxRadius,
      required this.selectedValueList,
      this.textColor,
      this.separatorLineColor,
      this.separatorLineHeight,
      this.selectIcon,
      required this.selectList,
      this.size,
      this.divider,
      this.selectIconColor,
      this.isLeft,
      required this.onChanged,
      super.key});

  final bool disabled;
  final bool hidden;
  final HMSelectSize? size;
  final HMRadius? boxRadius;
  final Widget? selectIcon;
  final Widget? divider;
  final Color? selectIconColor;
  final Color? textColor;
  final Color? separatorLineColor;
  final double? separatorLineHeight;
  final List selectedValueList;
  final List selectList;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? isLeft;
  final void Function(List value) onChanged;

  double _getTextSize(HMSelectSize size) {
    switch (size) {
      case HMSelectSize.xs:
        return 12.0;
      case HMSelectSize.sm:
        return 14.0;
      case HMSelectSize.md:
        return 16.0;
      case HMSelectSize.lg:
        return 18.0;
      case HMSelectSize.xl:
        return 20.0;
    }
  }

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSelectPannel({
    required HMSelectSize selectSize,
    required HMRadius selectBoxRadius,
    required Color selectColor,
    required Color selectTextColor,
    required bool iconAtLeft,
    required List valueList,
  }) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: outlineColor),
          borderRadius: BorderRadius.circular(selectBoxRadius.value)),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: selectList.length,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int sIndex) {
          return divider ??
              Divider(
                height: 1,
                indent: 0.0,
                endIndent: 0.0,
                thickness: 1,
                color: outlineColor,
              );
        },
        itemBuilder: (BuildContext context, int index) {
          final bool isSelected = valueList.contains(selectList[index]);

          final List<Widget> children = [
            Text(
              '${selectList[index]}',
              style: TextStyle(
                fontSize: _getTextSize(selectSize),
                color: disabled ? Colors.grey : selectTextColor,
              ),
            ),
            SizedBox(
              width: 50.0,
              child: isSelected
                  ? selectIcon ??
                      Icon(
                        Icons.check,
                        color: disabled ? Colors.grey : selectColor,
                        size: _getTextSize(selectSize) * 1.3,
                      )
                  : Container(),
            ),
          ];
          return GestureDetector(
            onTap: () {
              if (isSelected) {
                valueList.remove(selectList[index]);
                onChanged(valueList);
              } else {
                valueList.add(selectList[index]);
                onChanged(valueList);
              }
            },
            child: Container(
              height: _getTextSize(selectSize) * 3,
              // padding: const EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                  color: disabled ? outlineColor.withOpacity(0.2) : null),
              child: Row(
                mainAxisAlignment: iconAtLeft
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: iconAtLeft ? children.reversed.toList() : children,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final multiSelectTheme = Theme.of(context).extension<HMMultiSelectTheme>();
    final HMSelectSize selectSize =
        size ?? multiSelectTheme?.size ?? HMSelectSize.md;
    final HMRadius selectBoxRadius =
        boxRadius ?? multiSelectTheme?.boxRadius ?? HMRadius.md;
    final iconAtLeft = isLeft ?? multiSelectTheme?.isLeft ?? true;
    final Color selectColor =
        selectIconColor ?? multiSelectTheme?.selectIconColor ?? defaultColor;
    final Color selectTextColor =
        textColor ?? multiSelectTheme?.textColor ?? Colors.black;
    final valueList = selectedValueList;

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          selectSize: selectSize,
          selectBoxRadius: selectBoxRadius,
          selectColor: selectColor,
          selectTextColor: selectTextColor,
          valueList: valueList,
          iconAtLeft: iconAtLeft,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }
}
