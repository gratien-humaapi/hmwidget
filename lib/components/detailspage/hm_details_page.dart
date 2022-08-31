import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DetailsPage<T> extends HookWidget {
  const DetailsPage(
      {super.key,
      required this.child,
      required this.onChange,
      required this.onTap,
      required this.onClose,
      required this.defaultValue,
      required this.destinationPage,
      required this.isModal});
  final Widget child;
  final T defaultValue;
  final void Function(T value) onChange;
  final void Function() onTap;
  final void Function(T value) onClose;
  final bool isModal;
  final Widget Function(ValueNotifier<T> value) destinationPage;

  buildPage(BuildContext context, ValueNotifier<T> selection) async {
    await Navigator.of(context).push(
      MaterialPageRoute<T>(
        builder: (BuildContext context) => Material(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
                // backgroundColor: Colors.grey[300],
                body: destinationPage(selection)),
          ),
        ),
      ),
    );

    onClose(selection.value);
  }

  Future<void> buildmodal(
      BuildContext context, ValueNotifier<T> selection) async {
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
          return WillPopScope(
            onWillPop: () {
              return Future<bool>.value(true);
            },
            child: GestureDetector(
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
                    child: destinationPage(selection),
                  );
                },
              ),
            ),
          );
        });

    onClose(selection.value);
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<T> selection = useState<T>(defaultValue);
    final ValueNotifier<bool> bottomsheetIsOpen = useState(false);
    useEffect(() {
      onChange(selection.value);
      print('first print: ${selection.value}');
      return null;
    }, [selection.value]);

    return GestureDetector(
      onTap: () async {
        bottomsheetIsOpen.value = true;
        onTap();
        timeDilation = 2;
        isModal
            ? await buildmodal(context, selection)
            : await buildPage(context, selection);
      },
      child: Material(
        color: Colors.transparent,
        child: AbsorbPointer(
          child: child,
        ),
      ),
    );
  }
}
