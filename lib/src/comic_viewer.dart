import 'package:comic_viewer/src/bottom_menu_bar.dart';
import 'package:comic_viewer/src/scrolling_app_bar.dart';
import 'package:comic_viewer/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///
const animationDuration = Duration(milliseconds: 300);

///
class ComicViewer extends StatefulWidget {
  ///
  const ComicViewer({
    required this.title,
    required this.theme,
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
          Visibility(
            visible: true,
            child: Align(
              child: Center(
                child: Container(
                  height: 104,
                  width: 104,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Stack(
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, top: 8),
                            child: Text(
                              '321',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          child: CustomPaint(
                            painter: Line(),
                            child: const SizedBox(
                              width: 104,
                              height: 104,
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 8, bottom: 8),
                            child: Text(
                              '321',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
            onChangeStart: () {},
            onChangeEnd: () {},
          ),
    );
  }
}

///
class Line extends CustomPainter {
  ///
  @override
  void paint(Canvas canvas, Size size) {
    const p1 = Offset(65, 25);
    const p2 = Offset(25, 65);
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
