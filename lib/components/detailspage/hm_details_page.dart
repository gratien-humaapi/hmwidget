import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DetailsPage<T> extends HookWidget {
  const DetailsPage(
      {super.key,
      required this.child,
      // required this.onChange,
      // required this.onTap,
      this.onClose,
      // required this.defaultValue,
      required this.destinationPage,
      required this.isModal});
  final Widget child;
  // final T defaultValue;
  // final void Function(T value) onChange;
  // final void Function(T value) onTap;
  final void Function()? onClose;
  final bool isModal;
  final Widget destinationPage;

  Future<void> buildPage(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute<T>(
        builder: (BuildContext context) => Material(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                // backgroundColor: Colors.grey[300],
                body: destinationPage),
          ),
        ),
      ),
    );
    if (onClose != null) {
      onClose!();
    }
  }

  Future<void> buildmodal(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        isDismissible: true,
        // backgroundColor: Colors.yellow.shade200,
        elevation: 0.0,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder:
                  (BuildContext context2, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: destinationPage,
                );
              },
            ),
          );
        });
    if (onClose != null) {
      onClose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final ValueNotifier<T> selection = useState<T>(defaultValue);
    // final ValueNotifier<bool> bottomsheetIsOpen = useState(false);

    return GestureDetector(
      onTap: () async {
        // bottomsheetIsOpen.value = true;
        isModal ? await buildmodal(context) : await buildPage(context);
      },
      child: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
//
