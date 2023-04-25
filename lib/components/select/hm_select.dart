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
    this.selectedItemIcon,
    this.rightIcon,
    this.isModalView = true,
    this.hasDivider = true,
    this.overlayColor,
    required this.selectList,
    this.selectedValueTextStyle,
    this.size,
    this.selectedItemStyle,
    required this.selectionPageTitle,
    this.selectIconColor,
    this.selectedBgColor,
    this.modalRadius,
    this.closeIcon,
    this.hintText,
    this.selectPanelDecoration,
    this.selectIconAtLeft,
    required this.onChanged,
    super.key,
  });

  final bool disabled;
  final bool hidden;
  final HMSelectSize? size;
  final String? hintText;
  final HMRadius? radius;
  final Widget? selectedItemIcon;
  final TextStyle? selectedItemStyle;
  final BoxDecoration? selectPanelDecoration;
  final TextStyle? selectedValueTextStyle;
  final bool isModalView;
  final bool hasDivider;
  final Widget? closeIcon;
  final Color? selectIconColor;
  final Color? overlayColor;
  final double? modalRadius;
  final Color? selectedBgColor;
  final Widget selectionPageTitle;
  final Widget? rightIcon;
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
    Widget? closeIcon,
    required bool isModal,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Expanded(child: Center(child: selectionPageTitle)),
              if (isModalView)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: closeIcon ??
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                              BorderRadius.circular(selectBoxRadius.value),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.grey.shade700,
                        ),
                      ),
                ),
            ],
          ),
        ),
        if (hasDivider)
          Divider(color: outlineColor.withOpacity(0.5), height: 1),
        Container(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            // controller: scrollController,
            itemCount: selectList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final bool isSelected = value == selectList[index];
              final List<Widget> children = [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.only(left: iconAtLeft ? 0.0 : 20),
                      child: Text(
                        '${selectList[index]}',
                        overflow: TextOverflow.ellipsis,
                        style: selectedItemStyle ??
                            TextStyle(
                              // color: isSelected ? selectColor,
                              fontSize: _getTextSize(selectSize),
                            ),
                      ),
                    ),
                  ),
                ),
                if (isSelected)
                  SizedBox(
                    width: 50.0,
                    child: selectedItemIcon ??
                        Icon(
                          Icons.check,
                          color: disabled ? Colors.grey : selectColor,
                          size: _getTextSize(selectSize) * 1.3,
                        ),
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
        radius: modalRadius,
        overlayColor: overlayColor ?? selectTheme?.overlayColor,
        destinationPage: _styledSelectPannel(
          selectSize: selectSize,
          selectBoxRadius: selectBoxRadius,
          context: context,
          selectColor: selectColor,
          closeIcon: closeIcon,
          isModal: isModalView,
          iconAtLeft: iconAtLeft,
        ).parent(({required child}) => _styledBox(
              child: child,
            )),
        isModal: isModalView,
        child: Container(
          // padding: const EdgeInsets.only(right: 12),
          decoration: selectPanelDecoration ??
              BoxDecoration(
                  color: selectedBgColor ?? Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(selectBoxRadius.value)),
          height: selectSize.value,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: value.toString().isEmpty
                        ? Text(
                            '$hintText',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: _getTextSize(selectSize)),
                          )
                        : Text(
                            '$value',
                            style: selectedValueTextStyle ??
                                TextStyle(
                                    fontSize: _getTextSize(selectSize),
                                    height: 1.5),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: rightIcon ??
                    selectTheme?.inputIcon ??
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: selectSize.value * 0.8,
                      color: Colors.grey.shade500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
