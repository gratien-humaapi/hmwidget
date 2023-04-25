import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
      required this.selectedValues,
      this.inputIcon,
      this.selectIcon,
      this.selectedBgColor,
      this.overlayColor,
      this.selectPanelDecoration,
      this.selectedValueTextStyle,
      this.fillColor,
      this.closeIcon,
      required this.onSelectedValuePressed,
      this.hintText,
      this.direction = Axis.horizontal,
      this.modalRadius,
      this.isModalView = true,
      this.hasDivider = true,
      required this.selectListItem,
      this.size,
      this.selectIconColor,
      this.chipColor,
      required this.selectionPageTitle,
      required this.onChanged,
      super.key});

  final bool disabled;
  final bool hidden;
  final String? hintText;
  final HMSelectSize? size;
  final Widget selectionPageTitle;
  final BoxDecoration? selectPanelDecoration;
  final TextStyle? selectedValueTextStyle;
  final Color? fillColor;
  final Color? selectedBgColor;
  final Color? overlayColor;
  final HMRadius? radius;
  final Widget? selectIcon;
  final Widget? closeIcon;
  final Axis direction;
  final double? modalRadius;
  final bool hasDivider;
  final void Function(int index) onSelectedValuePressed;
  final Widget? inputIcon;
  final Color? selectIconColor;
  final Color? chipColor;
  final bool isModalView;
  final List<dynamic> selectedValues;
  final List<dynamic> selectListItem;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool? selectIconAtLeft;
  final void Function(List<dynamic> value) onChanged;

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
    final Color inputColor =
        fillColor ?? multiSelectTheme?.fillColor ?? Colors.grey.shade200;
    final valueList = useState(selectedValues);

    useEffect(() {
      print('change');
      return null;
    }, [valueList.value]);

    return _styledBox(
      child: AbsorbPointer(
        absorbing: disabled,
        child: DetailsPage(
          overlayColor: overlayColor ?? multiSelectTheme?.overlayColor,
          radius: modalRadius,
          destinationPage: _SelectPannel(
            selectSize: selectSize,
            selectBoxRadius: selectBoxRadius,
            selectColor: selectColor,
            hasDivider: hasDivider,
            hintText: hintText,
            isModalView: isModalView,
            selectedBgColor: selectedBgColor,
            selectIcon: selectIcon,
            closeIcon: closeIcon,
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
          ),
          isModal: isModalView,
          child: Container(
            padding:
                const EdgeInsets.only(left: 20.0, right: 12, top: 8, bottom: 8),
            decoration: selectPanelDecoration ??
                BoxDecoration(
                    color: inputColor,
                    borderRadius: BorderRadius.circular(selectBoxRadius.value)),
            constraints:
                BoxConstraints(maxHeight: 200, minHeight: selectSize.value),
            // height: selectSize.value,
            child: Row(
              children: [
                Expanded(
                  child: valueList.value.isEmpty
                      ? Text(
                          '$hintText',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: _getTextSize(selectSize)),
                        )
                      : HMSelectBadge(
                          direction: direction,
                          chipColor: chipColor,
                          selectedList: valueList.value
                              .map((element) => HMSelectedItem(
                                  // avatar: Text(element.toString()[0]),
                                  value: element.toString(),
                                  label: Text(element.toString())))
                              .toList(),
                          onDeleted: (deletedValue) {
                            final List a = List.from(valueList.value);
                            a.remove(deletedValue);
                            valueList.value = a;
                          },
                          onTap: (int index) {
                            onSelectedValuePressed(index);
                          },
                        ),
                ),
                IconTheme(
                  data: Theme.of(context).iconTheme.copyWith(
                        size: selectSize.value * 0.8,
                        color: Colors.grey,
                      ),
                  child: inputIcon ??
                      multiSelectTheme?.inputIcon ??
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectPannel extends HookWidget {
  const _SelectPannel(
      {required this.selectSize,
      required this.selectBoxRadius,
      required this.selectColor,
      required this.selectionPageTitle,
      this.selectIcon,
      this.closeIcon,
      required this.disabled,
      this.hintText,
      required this.hasDivider,
      required this.isModalView,
      required this.textSize,
      this.selectedBgColor,
      required this.onChanged,
      required this.selectListItem,
      required this.iconAtLeft,
      required this.valueList});
  final HMSelectSize selectSize;
  final HMRadius selectBoxRadius;
  final String? hintText;
  final Color selectColor;
  final Widget selectionPageTitle;
  final Widget? selectIcon;
  final Widget? closeIcon;
  final bool hasDivider;
  final Color? selectedBgColor;
  final bool disabled;
  final bool isModalView;
  final void Function(List value) onChanged;
  final List<dynamic> selectListItem;
  final double textSize;
  final bool iconAtLeft;
  final List<dynamic> valueList;
  @override
  Widget build(BuildContext context) {
    final list = useState(valueList);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Expanded(child: Center(child: selectionPageTitle)),
              /* A Close button */
              // if (isModalView)
              //   GestureDetector(
              //     onTap: () => Navigator.pop(context),
              //     child: closeIcon ??
              //         Container(
              //           padding: const EdgeInsets.all(5.0),
              //           decoration: BoxDecoration(
              //             color: Colors.grey.shade200,
              //             borderRadius:
              //                 BorderRadius.circular(selectBoxRadius.value),
              //           ),
              //           child: Icon(
              //             Icons.close_rounded,
              //             color: Colors.grey.shade700,
              //           ),
              //         ),
              //   ),
              HMButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  size: HMButtonSize.md,
                  buttonVariant: HMButtonVariant.transparent,
                  textColor: Colors.black,
                  content: 'Save'),
            ],
          ),
        ),
        if (hasDivider)
          Divider(color: outlineColor.withOpacity(0.5), height: 1),
        Container(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectListItem.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final bool isSelected =
                  list.value.contains(selectListItem[index]);

              final List<Widget> children = [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: iconAtLeft ? 0.0 : 20),
                    child: Text(
                      '${selectListItem[index]}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                  ),
                ),
                if (isSelected)
                  SizedBox(
                      width: 50.0,
                      child: selectIcon ??
                          Icon(
                            Icons.check,
                            color: disabled ? Colors.grey : selectColor,
                            size: textSize * 1.3,
                          )),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      color: isSelected
                          ? selectedBgColor ?? Colors.grey.shade200
                          : null),
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
