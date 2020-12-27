import 'package:flutter/material.dart';

class CustomScrollPage extends StatefulWidget {
  @override
  _CustomScrollPageState createState() => _CustomScrollPageState();
}

class _CustomScrollPageState extends State<CustomScrollPage> {
  Axis _scrollDirection = Axis.horizontal;
  ScrollPhysics _physics = PageScrollPhysics();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
