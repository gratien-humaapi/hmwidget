import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../utils/constant.dart';
import '../../utils/hm_raduis.dart';

Widget badge = Scaffold(
    body: HMSelectBadges(
  disabled: false,
  hidden: false,
  radius: HMRadius.xl,
  chipColor: Colors.lightBlue,
  showDeleteIcon: true,
  selectedList: const [
    {'label': 'React', 'avatar': Text('R')},
    {
      'label': 'Call',
      'avatar': Icon(Icons.phone, size: 20, color: Colors.blue)
    },
    {'label': 'Svelte', 'avatar': Text('S')},
    {'label': 'Flutter', 'avatar': Icon(Icons.flutter_dash, size: 20)},
    {'label': 'Vue', 'avatar': Text('V')},
    {'label': 'Angular', 'avatar': Text('A')},
  ],
  onDeleted: () => print('Deleted'),
  // deleteIcon: Icon(
  //   Icons.close,
  //   size: 18 ),
));

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
  final List selectedList;
  final HMRadius radius;
  final bool showDeleteIcon;
  final Color? chipColor;
  final void Function() onDeleted;
  final double spacing;
  final bool isFilled;
  final BorderSide? borderSide;
  final Color? textColor;
  final Color? deleteIconColor;
  final Icon? deleteIcon;

  List<Widget> buildChip(filters) {
    return selectedList.map((item) {
      final String label = item['label'] as String;
      final Widget avatar = item['avatar'] as Widget;
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
          onDeleted;
        },
      );
    }).toList();
  }

  Widget _styledBox({
    required Widget child,
  }) =>
      Visibility(visible: !hidden, child: child);

  Widget _styledSelectPannel({
    required ValueNotifier<dynamic> filters,
    required ValueNotifier<dynamic> choice,
  }) {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 5, // spacing,
      runSpacing: 5, //spacing / 2,
      children: buildChip(filters),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<List> filterItems = useState([]);
    final ValueNotifier<String> choice = useState('');

    return AbsorbPointer(
        absorbing: disabled,
        child: _styledSelectPannel(
          filters: filterItems,
          choice: choice,
        ).parent(({required child}) => _styledBox(
              child: child,
            ))).alignment(Alignment.center);
  }
}
