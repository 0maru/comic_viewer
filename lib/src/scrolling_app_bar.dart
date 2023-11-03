import 'package:flutter/material.dart';

///
class ScrollingAppBar extends StatelessWidget implements PreferredSizeWidget {
  ///
  const ScrollingAppBar({
    required this.child,
    required this.visible,
    required this.controller,
    super.key,
  });

  ///
  final PreferredSizeWidget child;

  ///
  final bool visible;

  ///
  final AnimationController controller;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.forward() : controller.reverse();
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}
