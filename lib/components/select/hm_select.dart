import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_select_size.dart';
import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';
import '../detailspage/hm_details_page.dart';

class HMSelect extends HookWidget {
  const HMSelect({
    this.disabled = false,
    this.hidden = false,
    required this.value,
    this.boxRadius,
    this.divider,
    this.textColor,
    this.selectIcon,
    required this.selectList,
    this.size,
    required this.selectionPageTitle,
    this.selectIconColor,
    this.isLeft,
    required this.onChanged,
    super.key,
  });

  final bool disabled;
  final bool hidden;
  final HMSelectSize? size;
  final HMRadius? boxRadius;
  final Widget? selectIcon;
  final Widget? divider;
  final Color? selectIconColor;
  final Widget selectionPageTitle;
  final Color? textColor;
  final dynamic value;
  final List selectList;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? isLeft;
  final void Function(dynamic value) onChanged;

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
  }) {
    return Column(
      children: [
        selectionPageTitle,
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: outlineColor),
              borderRadius: BorderRadius.circular(selectBoxRadius.value)),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: selectList.length,
            shrinkWrap: true,
            separatorBuilder: (BuildContext context, int sIndex) {
              return divider ??
                  Divider(
                      height: 1,
                      indent: 0.0,
                      endIndent: 0.0,
                      thickness: 1,
                      color: outlineColor);
            },
            itemBuilder: (BuildContext context, int index) {
              final bool isSelected = value == selectList[index];
              final List<Widget> children = [
                Padding(
                  padding: EdgeInsets.only(left: iconAtLeft ? 0.0 : 20),
                  child: Text(
                    '${selectList[index]}',
                    style: TextStyle(
                      fontSize: _getTextSize(selectSize),
                      color: disabled ? Colors.grey : textColor,
                    ),
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
                  if (selectList[index] != value) {
                    print('$index, ${value}');
                    onChanged(selectList[index]);
                    Navigator.pop(context);
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
                    children:
                        iconAtLeft ? children.reversed.toList() : children,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectTheme = Theme.of(context).extension<HMSelectTheme>();
    final HMSelectSize selectSize =
        size ?? selectTheme?.size ?? HMSelectSize.md;
    final HMRadius selectBoxRadius =
        boxRadius ?? selectTheme?.boxRadius ?? HMRadius.md;
    final iconAtLeft = isLeft ?? selectTheme?.isLeft ?? true;
    final Color selectColor =
        selectIconColor ?? selectTheme?.selectIconColor ?? defaultColor;
    final Color selectTextColor =
        textColor ?? selectTheme?.textColor ?? Colors.black;

    return AbsorbPointer(
      absorbing: disabled,
      child: DetailsPage(
        destinationPage: () {
          return _styledSelectPannel(
            selectSize: selectSize,
            selectBoxRadius: selectBoxRadius,
            selectColor: selectColor,
            selectTextColor: selectTextColor,
            iconAtLeft: iconAtLeft,
          ).parent(({required child}) => _styledBox(
                child: child,
              ));
        },
        isModal: true,
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.shade300),
          height: selectSize.value,
          child: Row(
            children: [
              Expanded(child: Text('${value}')),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: selectSize.value,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
