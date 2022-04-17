import 'package:craigslist/views/start.dart';
import 'package:craigslist/views/my_sales.dart';
import './views/messages_detail.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static const String title = "craigslist";
  static const routes = {
    
  };


  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        // '/': (context) => const Start(),
        //'/': (context) => MySales(),
        '/' : (context) => const MessageDetail(title: title)
      },
    );
  }
}
