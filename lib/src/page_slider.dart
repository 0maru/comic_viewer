import 'package:comic_viewer/comic_viewer.dart';
import 'package:comic_viewer/src/bottom_menu_bar.dart';
import 'package:flutter/material.dart';

///
class PageSlider extends StatelessWidget {
  ///
  const PageSlider({
    required this.theme,
    required this.pageCountNotifier,
    required this.pageCount,
    super.key,
  });

  ///
  final ComicViewerTheme theme;

  ///
  final int pageCount;

  ///
  final PageCount pageCountNotifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: pageCountNotifier,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 1,
              thumbColor: theme.sliderThumbColor,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 6,
                disabledThumbRadius: 6,
              ),
            ),
            child: Slider(
              min: 1,
              max: pageCount.toDouble(),
              activeColor: theme.sliderActiveColor,
              inactiveColor: theme.sliderInactiveColor,
              value: pageCountNotifier.count,
              onChanged: pageCountNotifier.update,
            ),
          ),
        );
      },
    );
  }
}
