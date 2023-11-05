import 'package:comic_viewer/src/bottom_menu_bar.dart';
import 'package:comic_viewer/src/page_scroll_progress_indicator.dart';
import 'package:comic_viewer/src/scrolling_app_bar.dart';
import 'package:comic_viewer/src/theme.dart';
import 'package:flutter/material.dart';

///
const animationDuration = Duration(milliseconds: 300);

///
class ComicViewer extends StatefulWidget {
  ///
  const ComicViewer({
    required this.title,
    required this.theme,
    required this.pageCount,
    this.leadingButton,
    this.actionButton = const SizedBox.shrink(),
    this.bottomBar,
    super.key,
  });

  ///
  final String title;

  ///
  final ComicViewerTheme theme;

  ///
  final int pageCount;

  ///
  final Widget? leadingButton;

  ///
  final Widget actionButton;

  ///
  final Widget? bottomBar;

  @override
  State<ComicViewer> createState() => _ComicViewerState();
}

class _ComicViewerState extends State<ComicViewer> with SingleTickerProviderStateMixin {
  ///
  late AnimationController controller;

  ///
  bool visibleMenuBar = true;

  ///
  double sliderPosition = 1;

  ///
  bool showPagePreview = false;

  ///
  bool visiblePageScrollProgressIndicator = false;

  ///
  final counterNotifier = PageCount();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
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
            onTap: () {
              setState(() {
                visibleMenuBar = !visibleMenuBar;
              });
            },
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          ListenableBuilder(
            listenable: counterNotifier,
            builder: (context, child) {
              return PageScrollProgressIndicator(
                visible: visiblePageScrollProgressIndicator,
                currentPage: counterNotifier.count.toInt(),
                totalPage: widget.pageCount,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: widget.bottomBar ??
          BottomMenuBar(
            controller: controller,
            theme: widget.theme,
            visible: visibleMenuBar,
            counterNotifier: counterNotifier,
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
          ),
    );
  }
}
