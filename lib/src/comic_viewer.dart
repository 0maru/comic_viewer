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
    required this.itemCount,
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
  final int itemCount;

  ///
  final Widget? leadingButton;

  ///
  final Widget actionButton;

  ///
  final Widget? bottomBar;

  ///
  final Axis scrollDirection;

  @override
  State<ComicViewer> createState() => ComicViewerState();
}

///
class ComicViewerState extends State<ComicViewer> with SingleTickerProviderStateMixin {
  ///
  late AnimationController controller;

  ///
  late PageController pageController;

  ///
  late ScrollController scrollController;

  ///
  late PageCount pageCountNotifier;

  ///
  late Axis _scrollDirection;

  ///
  bool visibleMenuBar = true;

  ///
  bool visiblePageScrollProgressIndicator = false;

  ///
  bool shuoldChangeVisibleMenuBar = false;

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
    pageCountNotifier = PageCount();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (shuoldChangeVisibleMenuBar) {
        return;
      }
      changeVisibleMenuBar();
    });
  }

  ///
  void changeVisibleMenuBar() {
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

  ///
  void changeScrollDirection(Axis axis) {
    setState(() {
      _scrollDirection = axis;
    });
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
              if (_scrollDirection == Axis.horizontal && x < width * tapAreaThreshold) {
                pageController.nextPage(
                  duration: animationDuration,
                  curve: animation,
                );
              } else if (_scrollDirection == Axis.horizontal &&
                  width * (1 - tapAreaThreshold) < x) {
                if (pageController.page!.toInt() < 1) {
                  return;
                }

                pageController.previousPage(
                  duration: animationDuration,
                  curve: animation,
                );
              } else {
                shuoldChangeVisibleMenuBar = true;
                changeVisibleMenuBar();
              }
            },
            child: CustomPageView(
              controller: pageController,
              scrollDirection: _scrollDirection,
              itemCount: widget.itemCount,
              builder: (context, index) {
                return widget.itemBuilder(context, index);
              },
              onPageChanged: (index) {
                pageCountNotifier.update(index.toDouble() + 1);
              },
            ),
          ),
          ListenableBuilder(
            listenable: pageCountNotifier,
            builder: (context, child) {
              return PageScrollProgressIndicator(
                visible: visiblePageScrollProgressIndicator,
                currentPage: pageCountNotifier.count.toInt(),
                totalPage: widget.itemCount,
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
                      pageCount: widget.itemCount,
                      pageCountNotifier: pageCountNotifier,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomMenuBar(
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
        pageCount: widget.itemCount.toDouble(),
        scrollDirection: _scrollDirection,
        onChangeScrollDirection: changeScrollDirection,
        child: widget.bottomBar,
      ),
    );
  }
}
