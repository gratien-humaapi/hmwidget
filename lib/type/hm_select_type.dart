//

import 'package:flutter/cupertino.dart';

enum HMSelectType { simple, multiSelect }

enum HMSelectVariant { filled, outlined }

class HMSelectedItem {
  HMSelectedItem({required this.avatar, required this.label});
  final Widget avatar;
  final String label;
}
