import 'package:comic_viewer/src/bottom_menu_bar.dart';
import 'package:comic_viewer/src/page_scroll_progress_indicator.dart';
import 'package:comic_viewer/src/page_slider.dart';
import 'package:comic_viewer/src/page_view.dart';
import 'package:comic_viewer/src/scrolling_app_bar.dart';
import 'package:comic_viewer/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
const animationDuration = Duration(milliseconds: 300);

///
const tapAreaThreshold = 0.25;

///
const animation = Curves.easeInOut;

///
class ComicViewer extends StatefulWidget {
  ///
  const ComicViewer({
    required this.title,
    required this.theme,
    required this.itemBuilder,
    required this.pageCount,
    this.leadingButton,
    this.actionButton = const SizedBox.shrink(),
    this.bottomBar,
    this.scrollDirection = Axis.horizontal,
    super.key,
  });

  ///
  final String title;

  ///
  final ComicViewerTheme theme;

  ///
  final Widget Function(BuildContext context, int index) itemBuilder;

  ///
  final int pageCount;

  ///
  final Widget? leadingButton;

  ///
  final Widget actionButton;

  ///
  final Widget? bottomBar;

  ///
  final Axis scrollDirection;

  @override
  State<ComicViewer> createState() => _ComicViewerState();
}

class _ComicViewerState extends State<ComicViewer> with SingleTickerProviderStateMixin {
  ///
  late AnimationController controller;

  ///
  late PageController pageController;

  ///
  late ScrollController scrollController;

  ///
  bool visibleMenuBar = true;

  ///
  double sliderPosition = 1;

  ///
  bool showPagePreview = false;

  ///
  bool visiblePageScrollProgressIndicator = false;

  ///
  final pageCountNotifier = PageCount();

  Axis _scrollDirection = Axis.horizontal;

  @override
  void initState() {
    super.initState();
    _scrollDirection = widget.scrollDirection;
    controller = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    pageController = PageController();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final leadingButton = widget.leadingButton ??
        CloseButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        );

    return Scaffold(
      backgroundColor: widget.theme.backgroundColor,
      appBar: ScrollingAppBar(
        controller: controller,
        visible: visibleMenuBar,
        child: AppBar(
          backgroundColor: widget.theme.toolBarBackgroundColor,
          leading: leadingButton,
          actions: [
            widget.actionButton,
          ],
          title: Text(
            widget.title,
            style: widget.theme.toolBarTextStyle,
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) {
              final width = MediaQuery.sizeOf(context).width;
              final x = details.localPosition.dx;
              if (x < width * tapAreaThreshold) {
                pageController.nextPage(
                  duration: animationDuration,
                  curve: animation,
                );
              } else if (width * (1 - tapAreaThreshold) < x) {
                if (pageController.page!.toInt() < 1) {
                  return;
                }

                pageController.previousPage(
                  duration: animationDuration,
                  curve: animation,
                );
              } else {
                if (visibleMenuBar) {
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                } else {
                  SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.manual,
                    overlays: SystemUiOverlay.values,
                  );
                }
                setState(() {
                  visibleMenuBar = !visibleMenuBar;
                });
              }
            },
            child: CustomPageView(
              controller: pageController,
              scrollDirection: _scrollDirection,
              builder: (BuildContext context, int index) {
                return widget.itemBuilder(context, index);
              },
              onPageChanged: (index) {
                pageCountNotifier.update(index.toDouble());
              },
            ),
          ),
          ListenableBuilder(
            listenable: pageCountNotifier,
            builder: (context, child) {
              return PageScrollProgressIndicator(
                visible: visiblePageScrollProgressIndicator,
                currentPage: pageCountNotifier.count.toInt(),
                totalPage: widget.pageCount,
              );
            },
          ),
          if (_scrollDirection == Axis.vertical)
            Align(
              alignment: Alignment.centerRight,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
                  CurvedAnimation(
                    parent: controller,
                    curve: Curves.fastOutSlowIn,
                  ),
                ),
                child: Container(
                  height: double.infinity,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: RotatedBox(
                    quarterTurns: -1,
                    child: PageSlider(
                      theme: widget.theme,
                      pageCount: widget.pageCount,
                      pageCountNotifier: pageCountNotifier,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: widget.bottomBar ??
          BottomMenuBar(
            controller: controller,
            theme: widget.theme,
            visible: visibleMenuBar,
            pageCountNotifier: pageCountNotifier,
            onChangeStart: () {
              setState(() {
                visiblePageScrollProgressIndicator = true;
              });
            },
            onChangeEnd: () {
              setState(() {
                visiblePageScrollProgressIndicator = false;
              });
            },
            pageCount: widget.pageCount.toDouble(),
            scrollDirection: _scrollDirection,
            onChangeAxis: (axis) {
              setState(() {
                _scrollDirection = axis;
              });
            },
          ),
    );
  }
}
