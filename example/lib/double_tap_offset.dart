import 'package:comic_viewer/comic_viewer.dart';
import 'package:flutter/material.dart';

class DoubleTapOffset extends StatelessWidget {
  const DoubleTapOffset({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InteractiveView(
        child: Image.asset('assets/images/image.jpg'),
      ),
    );
  }
}
