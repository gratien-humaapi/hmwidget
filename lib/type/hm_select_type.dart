//

import 'package:flutter/cupertino.dart';

enum HMSelectType { simple, multiSelect }

enum HMSelectVariant { filled, outlined }

class HMSelectedItem {
  HMSelectedItem({this.avatar, required this.label, required this.value});
  final Widget? avatar;
  final Widget label;
  final String value;
}
