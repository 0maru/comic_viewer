import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class ComicViewer extends StatefulWidget {
  /// タイトル
  final String title;

  /// 最終ページ後に1ページ挟む場合は true
  final bool hasLastPage;

  /// ページ
  final List<Widget> children;

  void Function(int page) onPageChange;

  final Color toolbarColor;

  final TextStyle titleStyle;

  final Color iconColor;

  final Color sliderForegroundColor;

  final Color sliderBackgroundColor;

  ComicViewer({
    Key key,
    this.title,
    this.hasLastPage = false,
    this.children,
    this.onPageChange,
    this.toolbarColor = Colors.blue,
    this.titleStyle,
    this.iconColor = Colors.white,
    this.sliderBackgroundColor,
    this.sliderForegroundColor,
  })  : assert(children != null),
        super(key: key);

  @override
  _ComicViewerState createState() => _ComicViewerState();
}

class _ComicViewerState extends State<ComicViewer> {
  bool _showController = true;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  Axis direction = Axis.horizontal;

  @override
  void initState() {
    super.initState();
    _scrollController = _scrollController ?? ScrollController();
    _scrollController
      ..addListener(() {
        if (direction == Axis.horizontal) {
          horizontalScrollListener();
        } else if (direction == Axis.vertical) {
          verticalScrollListener();
        }
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void horizontalScrollListener() {
    final imageWidth = MediaQuery.of(context).size.width;
    final scrollDirection = _scrollController.position.userScrollDirection;
    final virtualWidth = page * imageWidth;
    if (scrollDirection == ScrollDirection.reverse) {
      if (page == maxPage) {
        return;
      }
      if (virtualWidth * 0.9 < _scrollController.position.pixels) {
        setState(() {
          page += 1;
        });
        widget.onPageChange(page);
      }
    }
    if (scrollDirection == ScrollDirection.forward) {
      if (page == 1) {
        return;
      }
      if (virtualWidth - imageWidth > _scrollController.position.pixels) {
        setState(() {
          page -= 1;
        });
        widget.onPageChange(page);
      }
    }
  }

  void verticalScrollListener() {
    //
    final imageHeight = MediaQuery.of(context).size.height;
    final virtualHeight = page * imageHeight;
    final scrollDirection = _scrollController.position.userScrollDirection;
    if (scrollDirection == ScrollDirection.reverse) {
      if (page == maxPage) {
        return;
      }
      if (virtualHeight - (imageHeight / 2) < _scrollController.position.pixels) {
        setState(() {
          page += 1;
        });
        widget.onPageChange(page);
      }
    }
    if (scrollDirection == ScrollDirection.forward) {
      if (page == 1) {
        return;
      }
      if (virtualHeight - (imageHeight / 2) > _scrollController.position.pixels) {
        setState(() {
          page -= 1;
        });
        widget.onPageChange(page);
      }
    }
  }

  int get maxPage => (widget.children.length + (widget.hasLastPage ? 1 : 0)).toInt();
  double get itemSize {
    return direction == Axis.horizontal
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
            _showController = !_showController;
          });
        },
        child: Stack(
          children: [
            _buildCustomScrollView(context),
            if (_showController) _buildTitleAppBar(context),
            if (_showController) _buildBottomController(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomScrollView(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ListView.builder(
        itemExtent: itemSize,
        scrollDirection: direction,
        reverse: direction == Axis.horizontal,
        controller: _scrollController,
        physics:
            direction == Axis.horizontal ? PageScrollPhysics() : AlwaysScrollableScrollPhysics(),
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: index % 2 == 0 ? Colors.black45 : Colors.amberAccent,
              ),
            ),
            key: ValueKey(index),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text('${index + 1}'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomController(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ColoredBox(
        color: widget.toolbarColor,
        child: SizedBox(
          height: 60,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('${page} / ${maxPage}'),
              ),
              RotatedBox(
                quarterTurns: 2,
                child: Slider(
                  value: 0,
                  min: 0,
                  max: maxPage.toDouble(),
                  activeColor: Colors.black45,
                  inactiveColor: Colors.amber,
                  label: '${page}',
                  onChanged: (double value) {
                    print(value);
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(direction == Axis.horizontal ? Icons.height : Icons.swap_horiz,
                      color: widget.iconColor),
                  onPressed: () {
                    // 読む向きを切り替える
                    setState(() {
                      if (direction == Axis.horizontal) {
                        direction = Axis.vertical;
                      } else {
                        direction = Axis.horizontal;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAppBar(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ColoredBox(
        color: widget.toolbarColor,
        child: SizedBox(
          height: 64,
          child: SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: widget.iconColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 94,
                    child: Center(
                      child: Text(
                        widget.title,
                        style: widget.titleStyle ?? TextStyle(color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
