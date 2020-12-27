import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollablePositionedListPage extends StatefulWidget {
  @override
  _ScrollablePositionedListPageState createState() => _ScrollablePositionedListPageState();
}

class _ScrollablePositionedListPageState extends State<ScrollablePositionedListPage> {
  Axis _scrollDirection = Axis.horizontal;
  ScrollPhysics _physics = PageScrollPhysics();
  ScrollController _scrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScrollablePositionedList.builder(
            scrollDirection: _scrollDirection,
            physics: _physics,
            itemCount: 50,
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (context, index) => SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: Text('Item $index')),
            ),
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

  void changeDirection(BuildContext context) {
    setState(() {
      _physics = AlwaysScrollableScrollPhysics();
      if (_scrollDirection == Axis.horizontal) {
        _scrollDirection = Axis.vertical;
      } else {
        _scrollDirection = Axis.horizontal;
      }
    });
    itemScrollController.jumpTo(index: 3);
    setState(() {
      if (_scrollDirection == Axis.horizontal) {
        _physics = PageScrollPhysics();
      } else {
        _physics = AlwaysScrollableScrollPhysics();
      }
    });
  }
}
