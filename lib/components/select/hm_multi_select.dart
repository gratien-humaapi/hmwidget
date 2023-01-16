import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../size/hm_button_size.dart';
import '../../size/hm_select_size.dart';
import '../../type/hm_button_type.dart';
import '../../type/hm_select_type.dart';
import '../../utils/constant.dart';
import '../../utils/hm_radius.dart';
import '../../widget_theme.dart';
import '../button/hm_button.dart';
import '../detailspage/hm_details_page.dart';
import 'hm_select_bagde.dart';

class HMMultiSelect extends HookWidget {
  const HMMultiSelect(
      {this.disabled = false,
      this.hidden = false,
      this.radius,
      this.selectIconAtLeft,
      required this.selectedValueList,
      this.selectIcon,
      this.selectPanelDecoration,
      this.selectedValueTextStyle,
      this.selectedBgColor,
      this.isModalView = true,
      required this.selectListItem,
      this.size,
      this.selectIconColor,
      required this.selectionPageTitle,
      required this.onChanged,
      super.key});

  final bool disabled;
  final bool hidden;
  final HMSelectSize? size;
  final Widget selectionPageTitle;
  final BoxDecoration? selectPanelDecoration;
  final TextStyle? selectedValueTextStyle;
  final Color? selectedBgColor;
  final HMRadius? radius;
  final Widget? selectIcon;
  final Color? selectIconColor;
  final bool isModalView;
  final List selectedValueList;
  final List selectListItem;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? selectIconAtLeft;
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

  @override
  Widget build(BuildContext context) {
    final multiSelectTheme = Theme.of(context).extension<HMMultiSelectTheme>();
    final HMSelectSize selectSize =
        size ?? multiSelectTheme?.size ?? HMSelectSize.md;
    final HMRadius selectBoxRadius =
        radius ?? multiSelectTheme?.radius ?? HMRadius.md;
    final iconAtLeft =
        selectIconAtLeft ?? multiSelectTheme?.selectIconAtLeft ?? false;
    final Color selectColor =
        selectIconColor ?? multiSelectTheme?.selectIconColor ?? defaultColor;
    final valueList = useState(selectedValueList);
    useEffect(() {
      print('change');
    }, [valueList.value]);

    return AbsorbPointer(
      absorbing: disabled,
      child: DetailsPage(
        destinationPage: () {
          return SelectPannel(
            selectSize: selectSize,
            selectBoxRadius: selectBoxRadius,
            selectColor: selectColor,
            selectionPageTitle: selectionPageTitle,
            disabled: disabled,
            textSize: _getTextSize(selectSize),
            onChanged: (value) {
              valueList.value = value;
              onChanged(valueList.value);
            },
            selectListItem: selectListItem,
            iconAtLeft: iconAtLeft,
            valueList: valueList.value,
          );
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: HMSelectBadge(
                    selectedList: valueList.value
                        .map((element) => HMSelectedItem(
                            avatar: Text(element.toString()[0]),
                            value: element.toString(),
                            label: Text(element.toString())))
                        .toList(),
                    onDeleted: (deletedValue) {
                      List a = List.from(valueList.value);
                      a.remove(deletedValue);
                      valueList.value = a;
                    },
                  ),
                  // Text('${valueList.value.join(', ')}'),
                ),
              ),
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

class SelectPannel extends HookWidget {
  const SelectPannel(
      {super.key,
      required this.selectSize,
      required this.selectBoxRadius,
      required this.selectColor,
      required this.selectionPageTitle,
      this.selectIcon,
      required this.disabled,
      required this.textSize,
      required this.onChanged,
      required this.selectListItem,
      required this.iconAtLeft,
      required this.valueList});
  final HMSelectSize selectSize;
  final HMRadius selectBoxRadius;
  final Color selectColor;
  final Widget selectionPageTitle;
  final Widget? selectIcon;
  final bool disabled;
  final void Function(List value) onChanged;
  final List selectListItem;
  final double textSize;
  final bool iconAtLeft;
  final List<dynamic> valueList;
  @override
  Widget build(BuildContext context) {
    final list = useState(valueList);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              selectionPageTitle,
              HMButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  size: HMButtonSize.md,
                  buttonVariant: HMButtonVariant.transparent,
                  textColor: Colors.black,
                  content: 'Done'),
            ],
          ),
        ),
        Divider(color: outlineColor, height: 1),
        Container(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: selectListItem.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final bool isSelected =
                  list.value.contains(selectListItem[index]);

              final List<Widget> children = [
                Padding(
                  padding: EdgeInsets.only(left: iconAtLeft ? 0.0 : 20),
                  child: Text(
                    '${selectListItem[index]}',
                    style: TextStyle(
                      fontSize: textSize,
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
                            size: textSize * 1.3,
                          )
                      : Container(),
                ),
              ];
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    final List myList = List.from(list.value);
                    myList.remove(selectListItem[index]);
                    list.value = myList;
                    onChanged(list.value);
                  } else {
                    list.value = [...list.value, selectListItem[index]];
                    onChanged(list.value);
                  }
                },
                child: Container(
                  height: textSize * 3,
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
}
