import 'package:comic_viewer_example/basic.dart';
import 'package:comic_viewer_example/custom_bottom_widget.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: const Text('Basic example'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const BasicViewer(),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Custom Bottom Bar example'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CustomBottomWidgetViewer(),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
