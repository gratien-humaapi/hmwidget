import 'package:flutter/material.dart';

class InheritedDataProvider extends InheritedWidget {
  const InheritedDataProvider({
    super.key,
    required Widget child,
    required this.scrollController,
  }) : super(child: child);
  final ScrollController scrollController;

  static InheritedDataProvider of(BuildContext context) {
    final InheritedDataProvider? result =
        context.dependOnInheritedWidgetOfExactType<InheritedDataProvider>();
    assert(result != null, 'No ScrollController in context');
    return result!;
  }

  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) =>
      scrollController != oldWidget.scrollController;
}
