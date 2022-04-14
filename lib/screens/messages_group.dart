import 'package:flutter/material.dart';

class MessagesGroup extends StatelessWidget{

  const MessagesGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String title = "craigslist";

    return (
      Scaffold(
        appBar: AppBar(
          title: const Text(title, 
            style: TextStyle(
              color: Color(0xffA682FF),
              backgroundColor: Colors.white)),
          backgroundColor: Colors.white,
          ),
      )
    );
  }
}