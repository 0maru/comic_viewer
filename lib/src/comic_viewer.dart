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

  ComicViewer({
    Key key,
    this.title,
    this.hasLastPage = false,
    this.children,
    this.onPageChange,
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
    //
    final imageWidth = MediaQuery.of(context).size.width;
    final virtualWidth = page * imageWidth;
    final scrollDirection = _scrollController.position.userScrollDirection;
    if (scrollDirection == ScrollDirection.reverse) {
      if (page == maxPage) {
        return;
      }
      if (virtualWidth <= _scrollController.position.pixels) {
        setState(() {
          page += 1;
        });
      }
    }
    if (scrollDirection == ScrollDirection.forward) {
      if (page == 1) {
        return;
      }

      if (virtualWidth >= _scrollController.position.pixels) {
        setState(() {
          page -= 1;
        });
      }
    }
  }

  void verticalScrollListener() {
    //
    final imageHeight = MediaQuery.of(context).size.height;
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
            if (_showController) TitleAppBar(title: widget.title),
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
          return SizedBox(
            key: ValueKey(index),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text('${index}'),
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
        color: Colors.red,
        child: SizedBox(
          height: 60,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('${page} / ${maxPage}'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(direction == Axis.horizontal ? Icons.height : Icons.swap_horiz),
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
}

class TitleAppBar extends StatelessWidget {
  final String title;

  TitleAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ColoredBox(
        color: Colors.blueAccent,
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
                    icon: Icon(Icons.close),
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
                        title,
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
