import 'package:craigslist/theme/theme_manager.dart';
import 'package:craigslist/views/messages/messages_detail.dart';
import 'package:craigslist/views/start.dart';
import 'package:craigslist/views/my_sales.dart';
import 'package:provider/provider.dart';
import 'views/messages/inbox.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static const String title = "craigslist";

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = {
      Inbox.routeName: (context) => const Inbox(title: title),
      MessageDetail.routeName: (context) => MessageDetail(title: title),
      '/': (context) => const Start(),
      //'/': (context) => MySales(),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: context.read<ThemeManager>().themeMode,
      routes: routes,
      initialRoute: Inbox.routeName,
      //initialRoute: '/',
    );
  }
}
