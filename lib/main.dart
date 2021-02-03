import 'package:awacs_flutter/pages/explore_page.dart';
import 'package:flutter/material.dart';

import 'pages/world_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(
          //primarySwatch: Colors.blue,
          //brightness:
          ),
      //home: WorldPage(),
      home: ExplorerPage(),
      routes: {
        '/world': (context) => WorldPage(),
      },
    );
  }
}
