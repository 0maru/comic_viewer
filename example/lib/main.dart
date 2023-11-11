import 'package:comic_viewer/comic_viewer.dart';
import 'package:flutter/material.dart';

const imagePaths = [
  'assets/image01.png',
  'assets/image02.png',
  'assets/image03.png',
  'assets/image01.png',
  'assets/image02.png',
  'assets/image03.png',
  'assets/image01.png',
  'assets/image02.png',
  'assets/image03.png',
  'assets/image01.png',
  'assets/image02.png',
  'assets/image03.png',
  'assets/image01.png',
  'assets/image02.png',
  'assets/image03.png',
];

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
      pageCount: imagePaths.length,
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
    );
  }
}
