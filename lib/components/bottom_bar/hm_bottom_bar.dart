import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'scrollcontroller_provider.dart';

class HMBottomNavBar extends HookWidget {
  HMBottomNavBar({
    this.principalButtonSize,
    required List<Widget> tabItems,
    required this.child,
    required this.onTap,
    this.currentPage = 0,
    this.bottomBarColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.width,
    this.height,
    this.radius,
    this.boxShadow,
    this.alignment,
    this.onBottomBarShown,
    this.principalButton,
    this.principalButtonIndex,
    this.onBottomBarHidden,
    super.key,
  }) {
    principalButtonIndex ??= tabItems.length ~/ 2;
    items = List.from(tabItems)
      ..insert(
          principalButtonIndex!,
          Tab(
            icon: Container(),
          ));
  }
  // final ScrollController scrollController;
  final int currentPage;
  final Color? bottomBarColor;
  final Color? selectedItemColor;
  final Widget child;
  final Color? unselectedItemColor;
  final Duration duration;
  final void Function(int index) onTap;
  final Curve curve;
  final double? width;
  final BoxShadow? boxShadow;
  final double? height;
  final BorderRadius? radius;
  final Widget? principalButton;
  final Alignment? alignment;
  final Function()? onBottomBarShown;
  final Function()? onBottomBarHidden;
  final double? principalButtonSize;
  int? principalButtonIndex;

  List<Widget> items = [];

  void showBottomBar(AnimationController controller) {
    controller.forward();

    if (onBottomBarShown != null) {
      onBottomBarShown!();
    }
  }

  int? _getIndex(int index) {
    if (index == principalButtonIndex) {
      return null;
    }

    final newIndex = index > principalButtonIndex! ? index - 1 : index;
    return newIndex;
  }

  void hideBottomBar(AnimationController controller) {
    controller.reverse();

    if (onBottomBarHidden != null) {
      onBottomBarHidden!();
    }
  }

  // void changePage(ValueNotifier<int> currentPage, int newPage) {
  //   currentPage.value = newPage;
  // }

  @override
  Widget build(BuildContext context) {
    final scrollController = useState(ScrollController());

    // useAutomaticKeepAlive();

    // final tabController = useTabController(
    //     initialLength: items.length, initialIndex: currentPage);

    final controller = useAnimationController(duration: duration);
    final offsetAnimation = useState(Tween<Offset>(
      begin: const Offset(0, 10),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    )));

    final isScrollingDown = useState(false);

    // scrollController.value.addListener(() {
    //   // if (scrollController.value.position.userScrollDirection ==
    //   //     ScrollDirection.reverse) {
    //   //   // if (!isScrollingDown.value) {
    //   //   isScrollingDown.value = true;
    //   //   hideBottomBar(controller);
    //   //   // }
    //   // }
    //   // if (scrollController.value.position.userScrollDirection ==
    //   //     ScrollDirection.forward) {
    //   //   if (isScrollingDown.value) {
    //   //     isScrollingDown.value = false;
    //   //     showBottomBar(controller);
    //   //   }
    //   // }
    // });

    controller.forward();

    final double tabWidth = width ?? MediaQuery.of(context).size.width * 0.9;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          // Check the direction of the scroll
          if (scrollNotification.scrollDelta! < 0 &&
              scrollNotification.metrics.axis == Axis.vertical) {
            // User is scrolling down
            print('scrolling down...');
            isScrollingDown.value = false;
            showBottomBar(controller);
          } else if (scrollNotification.scrollDelta! > 0 &&
              scrollNotification.metrics.axis == Axis.vertical) {
            // User is scrolling up
            print('scrolling up...');
            isScrollingDown.value = true;
            hideBottomBar(controller);
          }
        }
        return true;
      },
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          InheritedDataProvider(
            scrollController: scrollController.value,
            child: child,
          ),
          // Positioned(
          //     bottom: start,
          //     child: AnimatedContainer(
          //       duration: const Duration(milliseconds: 300),
          //       curve: Curves.easeIn,
          //       width: isOnTop.value == true ? 0 : 40,
          //       height: isOnTop.value == true ? 0 : 40,
          //       decoration: BoxDecoration(
          //         color: bottomBarColor,
          //         shape: BoxShape.circle,
          //       ),
          //       padding: EdgeInsets.zero,
          //       margin: EdgeInsets.zero,
          //       child: ClipOval(
          //         child: Material(
          //           color: Colors.transparent,
          //           child: SizedBox(
          //             height: 40,
          //             width: 40,
          //             child: Center(
          //               child: IconButton(
          //                 padding: EdgeInsets.zero,
          //                 onPressed: () {
          //                   isOnTop.value = true;
          //                   isScrollingDown.value = false;
          //                   showBottomBar(controller);
          //                 },
          //                 icon: Icon(
          //                   Icons.arrow_upward_rounded,
          //                   color: unselectedItemColor,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     )),
          Align(
            alignment: alignment ?? const Alignment(0, 0.95),
            child: SlideTransition(
              position: offsetAnimation.value,
              child: Container(
                width: tabWidth,
                height: height ?? 59,
                decoration: BoxDecoration(
                  color: bottomBarColor ?? Colors.white,
                  borderRadius: radius ?? BorderRadius.circular(50),
                  boxShadow: [
                    boxShadow ??
                        BoxShadow(
                          color: const Color(0xffA0A0A0).withOpacity(0.5),
                          offset: const Offset(0, 3),
                          blurRadius: 18,
                        ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 0; i < items.length; i++) ...[
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  final newIndex = _getIndex(i);
                                  if (newIndex == null) {
                                    return;
                                  }

                                  onTap(newIndex);
                                },
                                child: Container(
                                  color: Colors.white.withOpacity(0.005),
                                  child: items[i],
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                      Center(
                        widthFactor: 1.0,
                        child: principalButton,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
