// global Platform
import 'package:flutter/material.dart';

import 'widgets/ChatScreen.dart';
import 'config/theme.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Exie",
        debugShowCheckedModeBanner: false,
        home: Theme(data: theme, child: Container(child: ChatScreen())));
  }
}
