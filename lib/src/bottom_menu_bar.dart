import 'package:comic_viewer/comic_viewer.dart';
import 'package:comic_viewer/src/page_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

///
class PageCount with ChangeNotifier {
  ///
  double _count = 1;

  ///
  double get count => _count;

  ///
  void update(double count) {
    _count = count;
    notifyListeners();
  }
}

///
class BottomMenuBar extends StatefulWidget {
  ///
  const BottomMenuBar({
    required this.child,
    required this.controller,
    required this.theme,
    required this.visible,
    required this.onChangeStart,
    required this.onChangeEnd,
    required this.pageCountNotifier,
    required this.pageCount,
    required this.scrollDirection,
    required this.onChangeScrollDirection,
    super.key,
  });

  ///
  final Widget? child;

  ///
  final AnimationController controller;

  ///
  final ComicViewerTheme theme;

  ///
  final double pageCount;

  ///
  final bool visible;

  ///
  final PageCount pageCountNotifier;

  ///
  final Axis scrollDirection;

  ///
  final VoidCallback onChangeStart;

  ///
  final VoidCallback onChangeEnd;

  ///
  final ValueChanged<Axis> onChangeScrollDirection;

  @override
  State<BottomMenuBar> createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  @override
  Widget build(BuildContext context) {
    widget.visible ? widget.controller.forward() : widget.controller.reverse();

    final bottomWidget = widget.child ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  if (widget.scrollDirection == Axis.horizontal) {
                    widget.onChangeScrollDirection(Axis.vertical);
                  } else {
                    widget.onChangeScrollDirection(Axis.horizontal);
                  }
                },
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: SvgPicture.asset(
                    'assets/vertical.svg',
                    height: 20,
                    package: 'comic_viewer',
                    theme: const SvgTheme(
                      currentColor: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: widget.controller,
          curve: Curves.fastOutSlowIn,
        ),
      ),
      child: ColoredBox(
        color: widget.theme.bottomBarBackgroundColor,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              if (widget.scrollDirection == Axis.horizontal)
                PageSlider(
                  theme: widget.theme,
                  pageCountNotifier: widget.pageCountNotifier,
                  pageCount: widget.pageCount.toInt(),
                ),
              bottomWidget,
            ],
          ),
        ),
      ),
    );
  }
}
