import 'package:comic_viewer/comic_viewer.dart';
import 'package:flutter/material.dart';

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
    required this.controller,
    required this.theme,
    required this.visible,
    required this.onChangeStart,
    required this.onChangeEnd,
    required this.counterNotifier,
    super.key,
  });

  ///
  final AnimationController controller;

  ///
  final ComicViewerTheme theme;

  ///
  final bool visible;

  ///
  final VoidCallback onChangeStart;

  ///
  final VoidCallback onChangeEnd;

  ///
  final PageCount counterNotifier;

  @override
  State<BottomMenuBar> createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  ///
  double sliderPosition = 1;

  @override
  Widget build(BuildContext context) {
    widget.visible ? widget.controller.forward() : widget.controller.reverse();
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(parent: widget.controller, curve: Curves.fastOutSlowIn),
      ),
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: widget.theme.bottomBarBackgroundColor,
        ),
        child: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SliderTheme(
              data: const SliderThemeData(
                trackHeight: 1,
                thumbColor: Colors.blueAccent,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                  disabledThumbRadius: 6,
                ),
              ),
              child: ListenableBuilder(
                listenable: widget.counterNotifier,
                builder: (BuildContext context, Widget? child) {
                  return Slider(
                    min: 1,
                    max: 100,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.blueGrey,
                    value: widget.counterNotifier.count,
                    onChanged: widget.counterNotifier.update,
                    onChangeStart: (_) {
                      widget.onChangeStart();
                    },
                    onChangeEnd: (_) {
                      widget.onChangeEnd();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
