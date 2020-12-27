import 'package:flutter/material.dart';

class FlexibleListViewPage extends StatefulWidget {
  @override
  _FlexibleListViewPageState createState() => _FlexibleListViewPageState();
}

class _FlexibleListViewPageState extends State<FlexibleListViewPage> {
  Axis _scrollDirection = Axis.horizontal;
  ScrollPhysics _physics = PageScrollPhysics();
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = _scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            itemExtent: itemSize,
            controller: _scrollController,
            scrollDirection: _scrollDirection,
            physics: _physics,
            reverse: _scrollDirection == Axis.horizontal,
            cacheExtent: itemSize * 10,
            children: [
              for (var i in [1, 2, 3, 4, 5, 6, 7, 8, 9])
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: i % 2 == 0 ? Colors.blue : Colors.lightGreen,
                  ),
                  child: Center(
                    child: Text('${i}'),
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              color: Colors.red,
              icon: Icon(Icons.swap_horizontal_circle),
              onPressed: () {
                changeDirection(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  double get itemSize {
    return _scrollDirection == Axis.horizontal
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.height;
  }

  void changeDirection(BuildContext context) {
    int currentPage = 0;
    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = MediaQuery.of(context).size.height;

    if (_scrollDirection == Axis.horizontal) {
      currentPage = (_scrollController.position.pixels / imageWidth).round();
    } else {
      currentPage = (_scrollController.position.pixels / imageHeight).round();
    }
    print('currentPage: ${currentPage}');

    setState(() {
      _physics = AlwaysScrollableScrollPhysics();
      if (_scrollDirection == Axis.horizontal) {
        _scrollDirection = Axis.vertical;
      } else {
        _scrollDirection = Axis.horizontal;
      }
    });

    if (_scrollDirection == Axis.horizontal) {
      print('imageWidth: ${imageWidth}');
      print('currentPage * imageWidth = ${currentPage * imageWidth}');
      print('${currentPage * imageWidth / imageWidth}');
      _scrollController.position.jumpTo(currentPage * imageWidth);
      print('offset: ${_scrollController.position.pixels}');
    } else {
      print('imageHeight: ${imageHeight}');
      print('currentPage * imageHeight = ${currentPage * imageHeight}');
      print('${currentPage * imageHeight / imageHeight}');
      _scrollController.position.jumpTo(currentPage * imageHeight);
      print('offset: ${_scrollController.position.pixels}');
    }

    setState(() {
      if (_scrollDirection == Axis.horizontal) {
        _physics = PageScrollPhysics();
      } else {
        _physics = AlwaysScrollableScrollPhysics();
      }
    });
  }
}
