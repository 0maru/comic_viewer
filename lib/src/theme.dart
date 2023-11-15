import 'package:flutter/material.dart';

///
class ComicViewerTheme {
  ///
  ComicViewerTheme({
    required this.toolBarTextStyle,
    required this.toolBarBackgroundColor,
    required this.bottomBarBackgroundColor,
    this.backgroundColor = Colors.white,
    this.sliderActiveColor = Colors.pink,
    this.sliderInactiveColor = const Color(0xFFF48FB1),
    this.sliderThumbColor = Colors.pink,
    this.closeButtonColor = Colors.white,
    this.changeScrollDirectionButtonColor = Colors.white,
  });

  ///
  final Color backgroundColor;

  ///
  final TextStyle toolBarTextStyle;

  ///
  final Color toolBarBackgroundColor;

  ///
  final Color bottomBarBackgroundColor;

  ///
  final Color sliderActiveColor;

  ///
  final Color sliderInactiveColor;

  ///
  final Color sliderThumbColor;

  ///
  final Color closeButtonColor;

  ///
  final Color changeScrollDirectionButtonColor;
}
