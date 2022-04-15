import 'package:craigslist/views/start.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static const String title = "craigslist";
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const Start(),
      },
    );
  }
}
