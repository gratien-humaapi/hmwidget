import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/constant.dart';
import '../../size/hm_select_size.dart';

class HMSelect extends HookWidget {
  const HMSelect(
      {this.border,
      this.disabled = false,
      this.hidden = false,
      this.value,
      this.boxRadius = 4,
      this.textColor = Colors.black,
      this.separatorLineColor,
      this.separatorLineHeight = 1,
      this.selectIcon = Icons.check,
      required this.selectList,
      this.size = HMSelectSize.md,
      this.selectIconColor,
      this.isLeft = false,
      required this.onChanged,
      super.key});

  final bool disabled;
  final bool hidden;
  final HMSelectSize size;
  final double boxRadius;
  final IconData selectIcon;
  final Color? selectIconColor;
  final Color textColor;
  final Color? separatorLineColor;
  final double separatorLineHeight;
  final dynamic value;
  final List selectList;
  final Border? border;

  /// The position of the icon on the line
  ///`"true"` to put the icon before the title
  ///and `"false"`to put the icon to end.
  final bool isLeft;
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
    required ValueNotifier<dynamic> selection,
  }) {
    return buildSelectItems(selection);
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier selection = useState(value);

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          selection: selection,
        ).parent(({required child}) => _styledBox(
              child: child,
            )));
  }

  Widget buildSelectItems(ValueNotifier<dynamic> selection) {
    return Container(
      decoration: BoxDecoration(
          border: border ?? Border.all(color: Colors.black38),
          borderRadius: BorderRadius.circular(boxRadius)),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        // physics: BouncingScrollPhysics(),
        itemCount: selectList.length,
        shrinkWrap: true,
        separatorBuilder: (BuildContext context, int sIndex) {
          return Divider(
            height: separatorLineHeight,
            indent: 0.0,
            endIndent: 0.0,
            thickness: separatorLineHeight,
            // color: Colors.black,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          final bool isSelected = selection.value == selectList[index];
          final List<Widget> children = [
            Text(
              '${selectList[index]}',
              style: TextStyle(
                fontSize: _getTextSize(size),
                color: disabled ? Colors.grey : textColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(
                isSelected ? selectIcon : null,
                color: disabled ? Colors.grey : selectIconColor ?? defaultColor,
                size: _getTextSize(size) * 1.3,
              ),
            ),
          ];
          return GestureDetector(
            onTap: () {
              if (selectList[index] != selection.value) {
                selection.value = selectList[index];
                // print('$index, ${selection.value}');
                onChanged(selection.value);
              }
            },
            child: Container(
              height: _getTextSize(size) * 3,
              padding: const EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                  color: disabled ? outlineColor.withOpacity(0.2) : null),
              child: Row(
                mainAxisAlignment: isLeft
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                children: isLeft ? children.reversed.toList() : children,
              ),
            ),
          );
        },
      ),
    );
  }
}
