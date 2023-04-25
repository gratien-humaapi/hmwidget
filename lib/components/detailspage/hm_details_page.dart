import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DetailsPage<T> extends HookWidget {
  const DetailsPage(
      {super.key,
      required this.child,
      // required this.onChange,
      // required this.onTap,
      this.onClose,
      this.overlayColor,
      this.radius,
      required this.destinationPage,
      required this.isModal});
  final Widget child;
  // final T defaultValue;
  // final void Function(T value) onChange;
  // final void Function(T value) onTap;
  final void Function()? onClose;
  final bool isModal;
  final Color? overlayColor;
  final double? radius;
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
    await showCupertinoModalPopup(
      barrierColor: overlayColor ?? const Color(0xFFE0E0E0).withOpacity(0.3),
      context: context,
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      // isScrollControlled: true,
      useRootNavigator: true,
      barrierDismissible: true,
      semanticsDismissible: true,
      // backgroundColor: Colors.yellow.shade200,
      // elevation: 0.0,
      // enableDrag: true,

      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Dismissible(
            key: const Key('dismiss_modal_key'),
            direction: DismissDirection
                .down, // autoriser le défilement vers le bas pour fermer le popup
            onDismissed: (DismissDirection direction) {
              Navigator.pop(context);
            },
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(radius ?? 8)),
              ),
              child: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: destinationPage,
              ),
            ),
          ),
        );
      },
    );
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
