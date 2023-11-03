import 'package:comic_viewer/comic_viewer.dart';
import 'package:flutter/material.dart';

///
class BottomMenuBar extends StatefulWidget {
  ///
  const BottomMenuBar({
    required this.controller,
    required this.theme,
    super.key,
  });

  ///
  final AnimationController controller;

  ///
  final ComicViewerTheme theme;

  @override
  State<BottomMenuBar> createState() => _BottomMenuBarState();
}

class _BottomMenuBarState extends State<BottomMenuBar> {
  ///
  double sliderPosition = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: widget.theme.bottomBarBackgroundColor,
      ),
      child: SafeArea(
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
    );
  }
}
