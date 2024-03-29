import 'package:comic_viewer/comic_viewer.dart';
import 'package:comic_viewer_example/main.dart';
import 'package:flutter/material.dart';

class LeftToRightScrollViewer extends StatelessWidget {
  const LeftToRightScrollViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return ComicViewer(
      title: 'Hello world!',
      theme: ComicViewerTheme(
        toolBarTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        toolBarBackgroundColor: Colors.black,
        bottomBarBackgroundColor: Colors.black,
      ),
      readDirection: ReadDirection.rtl,
      verticalScrollEnabled: true,
      itemCount: imagePaths.length,
      itemBuilder: (ctx, idx) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.width,
          ),
          child: Image.asset(
            imagePaths[idx],
            fit: BoxFit.contain,
          ),
        );
      },
      actionButton: IconButton(
        icon: const Icon(
          Icons.favorite,
          color: Colors.white,
        ),
        onPressed: () {
          print('onPressed');
        },
      ),
    );
  }
}
