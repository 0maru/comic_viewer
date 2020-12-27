import 'package:flutter/material.dart';

class FlexibleListViewPage extends StatefulWidget {
  @override
  _FlexibleListViewPageState createState() => _FlexibleListViewPageState();
}

class _FlexibleListViewPageState extends State<FlexibleListViewPage> {
  Axis _scrollDirection = Axis.horizontal;
  ScrollPhysics _physics = PageScrollPhysics();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            scrollDirection: _scrollDirection,
            physics: _physics,
            reverse: _scrollDirection == Axis.horizontal,
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
                // changeDirection(context);
                disposeDirection(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void changeDirection(BuildContext context) {
    int currentPage = 0;
    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = MediaQuery.of(context).size.height;

    if (_scrollDirection == Axis.horizontal) {
      currentPage = (_scrollController.offset / imageWidth).round();
    } else {
      currentPage = (_scrollController.offset / imageHeight).round();
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
    _scrollController.jumpTo(0);

    if (_scrollDirection == Axis.horizontal) {
      print('imageWidth: ${imageWidth}');
      print('currentPage * imageWidth = ${3 * imageWidth}');
      print('${3 * imageWidth / imageWidth}');
      _scrollController.jumpTo(1300);
    } else {
      print('imageHeight: ${imageHeight}');
      print('currentPage * imageHeight = ${3 * imageHeight}');
      print('${3 * imageHeight / imageHeight}');
      _scrollController.jumpTo(3 * imageHeight);
    }

    setState(() {
      if (_scrollDirection == Axis.horizontal) {
        _physics = PageScrollPhysics();
      } else {
        _physics = AlwaysScrollableScrollPhysics();
      }
    });
  }

  void disposeDirection(BuildContext context) {
    int currentPage = 0;
    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = MediaQuery.of(context).size.height;

    if (_scrollDirection == Axis.horizontal) {
      currentPage = (_scrollController.offset / imageWidth).round();
    } else {
      currentPage = (_scrollController.offset / imageHeight).round();
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
    _scrollController.jumpTo(0);
    _scrollController.dispose();
    if (_scrollDirection == Axis.horizontal) {
      print('imageWidth: ${imageWidth}');
      print('currentPage * imageWidth = ${currentPage * imageWidth}');
      print('${currentPage * imageWidth / imageWidth}');
      _scrollController = ScrollController(initialScrollOffset: currentPage * imageWidth);
    } else {
      print('imageHeight: ${imageHeight}');
      print('currentPage * imageHeight = ${currentPage * imageHeight}');
      print('${currentPage * imageHeight / imageHeight}');
      _scrollController = ScrollController(initialScrollOffset: currentPage * imageHeight);
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
