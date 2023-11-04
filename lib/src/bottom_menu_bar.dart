import 'package:comic_viewer/comic_viewer.dart';
import 'package:flutter/material.dart';

///
class BottomMenuBar extends StatefulWidget {
  ///
  const BottomMenuBar({
    required this.controller,
    required this.theme,
    required this.visible,
    super.key,
  });

  ///
  final AnimationController controller;

  ///
  final ComicViewerTheme theme;

  ///
  final bool visible;

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
              child: Slider(
                min: 1,
                max: 100,
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.blueGrey,
                value: sliderPosition,
                onChanged: (val) {
                  setState(() {
                    sliderPosition = val;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
