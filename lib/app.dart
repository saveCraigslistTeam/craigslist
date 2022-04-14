import 'package:craigslist/views/start.dart';
import 'package:flutter/material.dart';
import 'screens/messages/messages_group.dart';

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

    return const MaterialApp(
          title: 'Craigslist',
          home: MessagesGroup(title: title)
      );

  }
}
