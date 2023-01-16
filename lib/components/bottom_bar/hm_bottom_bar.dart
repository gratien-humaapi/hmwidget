import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'custom_indicator.dart';
import 'scrollcontroller_provider.dart';

class HMBottomNavBar extends HookWidget {
  HMBottomNavBar({
    this.principalButtonSize,
    required List<Tab> tabItems,
    required this.child,
    required this.onTap,
    required this.currentPage,
    this.bottomBarColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.end = 2,
    this.start = 10,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.width,
    this.radius,
    this.alignment = Alignment.bottomCenter,
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
  final double end;
  final double start;
  final Duration duration;
  final void Function(int index) onTap;
  final Curve curve;
  final double? width;
  final BorderRadius? radius;
  final Widget? principalButton;
  final Alignment alignment;
  final Function()? onBottomBarShown;
  final Function()? onBottomBarHidden;
  final double? principalButtonSize;
  int? principalButtonIndex;

  List<Tab> items = [];

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

// Use with scrollNotification
  _onStartScroll(DragUpdateDetails? metrics) {
    print('${metrics}');
    print("Scroll Start");
  }

  _onUpdateScroll(DragUpdateDetails? metrics) {
    print('${metrics!}');
    print("Scroll Update");
  }

  // _onEndScroll(ScrollMetrics metrics) {
  //   print("Scroll End");
  // }

  // void changePage(ValueNotifier<int> currentPage, int newPage) {
  //   currentPage.value = newPage;
  // }

  @override
  Widget build(BuildContext context) {
    final scrollController = useState(ScrollController());

    useAutomaticKeepAlive();

    final tabController = useTabController(
        initialLength: items.length, initialIndex: currentPage);

    final controller = useAnimationController(duration: duration);
    final offsetAnimation = useState(Tween<Offset>(
      begin: Offset(0, end),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    )));

    final isScrollingDown = useState(false);
    final isOnTop = useState(true);

    scrollController.value.addListener(() {
      print('object');
      if (scrollController.value.position.userScrollDirection ==
          ScrollDirection.reverse) {
        // if (!isScrollingDown.value) {
        isScrollingDown.value = true;
        isOnTop.value = false;
        hideBottomBar(controller);
        // }
      }
      if (scrollController.value.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown.value) {
          isScrollingDown.value = false;
          isOnTop.value = true;
          showBottomBar(controller);
        }
      }
    });

    controller.forward();

    final double tabWidth = width ?? MediaQuery.of(context).size.width * 0.9;

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        // if (scrollNotification is ScrollStartNotification) {
        //   _onStartScroll(scrollNotification.metrics);
        // }
        // else
        // if (scrollNotification is ScrollUpdateNotification) {
        //   // _onUpdateScroll(scrollNotification.metrics);
        //   print(scrollNotification.scrollDelta);

        //   if (scrollNotification.metrics.axis == Axis.vertical &&
        //       !scrollNotification.metrics.outOfRange &&
        //       scrollNotification.scrollDelta! > 0) {
        //     hideBottomBar(controller);
        //   } else {
        //     showBottomBar(controller);
        //   }
        // }
        // else if (scrollNotification is ScrollEndNotification) {
        //   _onEndScroll(scrollNotification.metrics);
        // }
        return false;
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
          Positioned(
            bottom: start,
            child: SlideTransition(
              position: offsetAnimation.value,
              child: Container(
                width: tabWidth,
                height: 58,
                decoration: BoxDecoration(
                  color: bottomBarColor ?? Colors.white,
                  borderRadius: radius ?? BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffA0A0A0).withOpacity(0.5),
                      offset: const Offset(0, 3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      TabBar(
                        // isScrollable: true,
                        indicatorPadding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                        controller: tabController,
                        labelColor: selectedItemColor ?? Colors.blue,
                        unselectedLabelColor:
                            unselectedItemColor ?? Colors.grey,
                        indicator: CustomTabIndicator(
                            color: selectedItemColor ?? Colors.blue),
                        onTap: (value) {
                          final newIndex = _getIndex(value);
                          if (newIndex == null) {
                            return;
                          }

                          onTap(newIndex);
                        },

                        tabs: [
                          for (int i = 0; i < items.length; i++) ...[
                            items[i],
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
