import 'package:comic_viewer/comic_viewer.dart';
import 'package:comic_viewer_example/main.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CustomBottomWidgetViewer extends StatefulWidget {
  const CustomBottomWidgetViewer({super.key});

  @override
  State<CustomBottomWidgetViewer> createState() => _BasicViewerState();
}

class _BasicViewerState extends State<CustomBottomWidgetViewer> {
  @override
  Widget build(BuildContext context) {
    return ComicViewer(
      title: 'Custom Bottom Widget Viewer',
      theme: ComicViewerTheme(
        toolBarTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        toolBarBackgroundColor: Colors.orangeAccent,
        bottomBarBackgroundColor: Colors.orangeAccent,
        sliderActiveColor: Colors.red,
        sliderInactiveColor: Colors.red,
        sliderThumbColor: Colors.redAccent,
        closeButtonColor: Colors.black,
        changeScrollDirectionButtonColor: Colors.black,
      ),
      itemCount: imagePaths.length,
      scaleEnabled: false,
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
          Icons.share,
          color: Colors.black,
        ),
        onPressed: () {
          Share.shareUri(
            Uri.parse('https://github.com/0maru/comic_viewer'),
          );
        },
      ),
    );
  }
}
