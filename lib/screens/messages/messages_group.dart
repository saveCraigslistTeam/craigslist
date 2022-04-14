import 'package:flutter/material.dart';
import 'dart:collection';

class MessagesGroup extends StatelessWidget{
  final String title;

  const MessagesGroup({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      Scaffold(
        appBar: AppBar(
          title: appBarTitle(title),
          backgroundColor: Colors.white,
          centerTitle: true,
          )
      )
    );
  }
}

Widget appBarTitle(String title) {
  return Text(
    title, 
    style: const TextStyle(
      color: Color(0xffA682FF),
      backgroundColor: Colors.white,
      fontSize: 30),
      );
}