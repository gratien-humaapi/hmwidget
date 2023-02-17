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
    this.radius,
    this.selectIcon,
    this.isModalView = true,
    required this.selectList,
    this.selectedValueTextStyle,
    this.size,
    this.selectItemStyle,
    required this.selectionPageTitle,
    this.selectIconColor,
    this.selectedBgColor,
    this.selectPanelDecoration,
    this.selectIconAtLeft,
    required this.onChanged,
    super.key,
  });

  final bool disabled;
  final bool hidden;
  final HMSelectSize? size;
  final HMRadius? radius;
  final Widget? selectIcon;
  final TextStyle? selectItemStyle;
  final BoxDecoration? selectPanelDecoration;
  final TextStyle? selectedValueTextStyle;
  final bool isModalView;
  final Color? selectIconColor;
  final Color? selectedBgColor;
  final Widget selectionPageTitle;
  final dynamic value;
  final List selectList;

  /// The position of the selectIcon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? selectIconAtLeft;
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
    required bool iconAtLeft,
  }) {
    return Column(
      children: [
        selectionPageTitle,
        Divider(color: outlineColor, height: 1),
        Container(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final bool isSelected = value == selectList[index];
              final List<Widget> children = [
                Padding(
                  padding: EdgeInsets.only(left: iconAtLeft ? 0.0 : 20),
                  child: Text(
                    '${selectList[index]}',
                    style: selectItemStyle ??
                        TextStyle(
                          fontSize: _getTextSize(selectSize),
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
                    print('$index, $value');
                    onChanged(selectList[index]);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: _getTextSize(selectSize) * 3,
                  // padding: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                      color: isSelected ? Colors.grey.shade200 : null),
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
        radius ?? selectTheme?.radius ?? HMRadius.md;
    final iconAtLeft =
        selectIconAtLeft ?? selectTheme?.selectIconAtLeft ?? false;
    final Color selectColor =
        selectIconColor ?? selectTheme?.selectIconColor ?? defaultColor;

    return AbsorbPointer(
      absorbing: disabled,
      child: DetailsPage(
        destinationPage: () {
          return _styledSelectPannel(
            selectSize: selectSize,
            selectBoxRadius: selectBoxRadius,
            selectColor: selectColor,
            iconAtLeft: iconAtLeft,
          ).parent(({required child}) => _styledBox(
                child: child,
              ));
        },
        isModal: isModalView,
        child: Container(
          decoration: selectPanelDecoration ??
              BoxDecoration(
                  color: selectedBgColor ?? Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(selectBoxRadius.value)),
          height: selectSize.value,
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  '$value',
                  style: selectedValueTextStyle,
                ),
              )),
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
