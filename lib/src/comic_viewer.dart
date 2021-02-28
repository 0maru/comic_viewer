import 'dart:math';

import 'package:comic_viewer/comic_viewer.dart';
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

  /// ページ遷移時のイベント
  final void Function(int page) onPageChange;

  /// 初めて最終ページに到達した先に動く
  final void Function() onLastPage;

  /// ツールバーカラー
  final Color toolbarColor;

  /// タイトルのテキストスタイル
  final TextStyle titleStyle;

  /// アイコンカラー
  final Color iconColor;

  /// スライダーアクティブカラー
  final Color sliderForegroundColor;

  /// スライダーイナクティブカラ
  final Color sliderBackgroundColor;

  const ComicViewer({
    Key key,
    this.title,
    this.hasLastPage = false,
    this.children,
    this.onPageChange,
    this.onLastPage,
    this.toolbarColor = Colors.blue,
    this.titleStyle,
    this.iconColor = Colors.white,
    this.sliderBackgroundColor = Colors.white24,
    this.sliderForegroundColor = Colors.blue,
  })  : assert(children != null),
        super(key: key);

  @override
  _ComicViewerState createState() => _ComicViewerState();
}

class _ComicViewerState extends State<ComicViewer> {
  /// ツールバー表示フラグ
  bool _showController = true;

  /// スクロールコントローラー
  ScrollController _scrollController;

  /// 現在のページ数
  int page = 1;

  /// Viewerスクロール向き
  Axis direction = Axis.horizontal;

  bool _isScale = false;

  bool _canScale = false;

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

    for (var i in widget.children) {
      keys.add(GlobalKey<InteractiveViewState>(debugLabel: '${i.hashCode}'));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 横方向ページ移動管理
  ///
  /// スクロール位置が画面の横幅分進むと1ページ進んだ扱いにする
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
        if (widget.onPageChange != null) {
          widget.onPageChange(page);
        }
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
        if (widget.onPageChange != null) {
          widget.onPageChange(page);
        }
      }
    }
  }

  /// 縦方向ページ移動管理
  ///
  /// スクロール位置が画面の縦半分の位置を越えるとページが進んだ扱いにする
  void verticalScrollListener() {
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
        if (widget.onPageChange != null) {
          widget.onPageChange(page);
        }
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
        if (widget.onPageChange != null) {
          widget.onPageChange(page);
        }
      }
    }
  }

  /// 全ページ数
  int get maxPage => (widget.children.length + (widget.hasLastPage ? 1 : 0)).toInt();

  ///　画像サイズ
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

  List<GlobalKey<InteractiveViewState>> keys = [];

  Widget _buildCustomScrollView(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ListView.builder(
        itemExtent: itemSize,
        scrollDirection: direction,
        reverse: direction == Axis.horizontal,
        controller: _scrollController,
        physics: _isScale
            ? NeverScrollableScrollPhysics()
            : direction == Axis.horizontal
                ? PageScrollPhysics()
                : AlwaysScrollableScrollPhysics(),
        itemCount: widget.children.length,
        itemBuilder: (context, index) {
          return InteractiveView(
            constrained: false,
            key: keys[index],
            panEnabled: _isScale,
            scaleEnabled: _canScale,
            onDoubleTap: (val) {
              setState(() {
                _isScale = val;
              });
            },
            onInteractionUpdate: (details, scale) {
              // スケールした状態からスケールするとスケール値1.0からになる
              // 現在のスケール値に足すから？
              if (scale == 1.0) {
                return;
              }

              ///　拡大の遊びを1.2でもたせる
              if (scale > 1.2) {
                if (!_canScale) {
                  setState(() {
                    _canScale = true;
                  });
                }
                setState(() {
                  _isScale = true;
                });
              } else {
                if (_canScale) {
                  setState(() {
                    _canScale = false;
                  });
                }
                if (_isScale) {
                  keys[index].currentState.resetController();
                }
              }
            },
            child: Image.network(
              'https://www.pakutaso.com/shared/img/thumb/heriyakei419188_TP_V4.jpg',
              height: MediaQuery.of(context).size.height,
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
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  Text('${page} / ${maxPage}'),
                  _buildBottomControllerSlider(context),
                  _buildBottomControllerDirectionButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControllerSlider(BuildContext context) {
    return Expanded(
      child: RotatedBox(
        quarterTurns: 2,
        child: Slider(
          value: page.toDouble() - 1,
          min: 0,
          max: maxPage.toDouble() - 1,
          activeColor: widget.sliderForegroundColor,
          inactiveColor: widget.sliderBackgroundColor,
          label: '${page}',
          onChanged: (double value) {
            double offset;
            if (direction == Axis.horizontal) {
              final imageWidth = MediaQuery.of(context).size.width;
              offset = (value.toInt() + 1) * imageWidth;
            } else {
              final imageHeight = MediaQuery.of(context).size.height;
              offset = (value.toInt() + 1) * imageHeight;
            }
            print(offset);
            _scrollController.animateTo(
              offset,
              duration: const Duration(milliseconds: 100),
              curve: Curves.fastOutSlowIn,
            );
            setState(() {
              page = min(max(0, maxPage), value.toInt() + 1);
            });
          },
        ),
      ),
    );
  }

  Widget _buildBottomControllerDirectionButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        icon: Icon(
          direction == Axis.horizontal ? Icons.height : Icons.swap_horiz,
          color: widget.iconColor,
        ),
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
    );
  }

  Widget _buildTitleAppBar(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ColoredBox(
        color: widget.toolbarColor,
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: kToolbarHeight,
            child: SafeArea(
              bottom: false,
              left: false,
              right: false,
              child: Stack(
                children: [
                  _buildAppBarCloseButton(context),
                  _buildAppBarTitle(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBarCloseButton(BuildContext context) {
    return Align(
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
    );
  }

  Widget _buildAppBarTitle(BuildContext context) {
    return Align(
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
    );
  }
}
