import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionSheetItem {
  const ActionSheetItem(
      {required this.title, required this.onPressed, this.icon});
  final Widget? icon;
  final Widget title;
  final void Function() onPressed;
}

Future<dynamic> showActionSheet(
    {required BuildContext context,
    required List<ActionSheetItem> actions,
    Widget? cancelButton,
    bool hasCancelButton = true}) {
  // print(actions);
  return showCupertinoModalPopup(
      barrierColor: Color(0xFFE0E0E0).withOpacity(0.3),
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
                      action.icon ?? SizedBox(),
                      const SizedBox(width: 20),
                      action.title,
                    ],
                  ),
                ),
              )
              .toList(),
          cancelButton: hasCancelButton
              ? cancelButton ??
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
              : null,
        );
      });
}
