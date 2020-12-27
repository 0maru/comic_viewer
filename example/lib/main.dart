import 'package:example/custom_scroll_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'double_tap_offset.dart';
import 'flexible_listview.dart';
import 'scrollable_positioned_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('DoubleTapOffset'),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (_) => DoubleTapOffset()));
            },
          ),
          ListTile(
            title: Text('FlexibleListViewPage'),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (_) => FlexibleListViewPage()));
            },
          ),
          ListTile(
            title: Text('ScrollablePositionedListPage'),
            onTap: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (_) => ScrollablePositionedListPage()));
            },
          ),
          ListTile(
            title: Text('CustomScrollPage'),
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (_) => CustomScrollPage()));
            },
          ),
        ],
      ),
    );
  }
}
