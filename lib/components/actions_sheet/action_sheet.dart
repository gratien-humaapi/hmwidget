import 'package:flutter/cupertino.dart';

class ActionSheetItem {
  const ActionSheetItem(
      {required this.title, required this.onPressed, this.icon});
  final Widget? icon;
  final String title;
  final void Function() onPressed;
}

Future<dynamic> showActionSheet(
    {required BuildContext context,
    required List<ActionSheetItem> actions,
    bool hasCancelButton = true}) {
  // print(actions);
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: actions
              .map(
                (action) => CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.pop(context);
                    action.onPressed();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      action.icon ?? Container(),
                      const SizedBox(width: 20),
                      Text(action.title),
                    ],
                  ),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      });
}
