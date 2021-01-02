import 'package:comic_viewer/comic_viewer.dart';
import 'package:flutter/cupertino.dart';

class ComicViewerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ComicViewer(
      title: '鬼滅の刃鬼滅の刃鬼滅の刃鬼滅の刃鬼滅の刃鬼滅の刃鬼滅の刃鬼滅の刃',
      children: [
        Text('1'),
        Text('2'),
        Text('3'),
        Text('4'),
      ],
      onPageChange: (page) {
        print(page);
      },
    );
  }
}
