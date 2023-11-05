import 'package:comic_viewer/comic_viewer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('open'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ViewerPage(),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ViewerPage extends StatelessWidget {
  const ViewerPage({super.key});

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
      pageCount: 300,
    );
  }
}
