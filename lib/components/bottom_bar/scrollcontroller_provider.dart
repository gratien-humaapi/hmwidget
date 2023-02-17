import 'package:flutter/material.dart';

class InheritedDataProvider extends InheritedWidget {
  const InheritedDataProvider({
    super.key,
    required super.child,
    required this.scrollController,
  });
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
