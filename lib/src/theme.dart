import 'package:flutter/material.dart';

///
class ComicViewerTheme {
  ///
  ComicViewerTheme({
    required this.toolBarTextStyle,
    required this.toolBarBackgroundColor,
    required this.bottomBarBackgroundColor,
    this.backgroundColor = Colors.white,
  });

  ///
  final Color backgroundColor;

  ///
  final TextStyle toolBarTextStyle;

  ///
  final Color toolBarBackgroundColor;

  ///
  final Color bottomBarBackgroundColor;
}
