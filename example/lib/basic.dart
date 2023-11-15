import 'package:comic_viewer/comic_viewer.dart';
import 'package:comic_viewer_example/main.dart';
import 'package:flutter/material.dart';

class BasicViewer extends StatefulWidget {
  const BasicViewer({super.key});

  @override
  State<BasicViewer> createState() => _BasicViewerState();
}

class _BasicViewerState extends State<BasicViewer> {
  @override
  Widget build(BuildContext context) {
    return ComicViewer(
      title: 'Hello world!',
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
