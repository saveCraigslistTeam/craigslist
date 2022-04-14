import 'package:flutter/material.dart';
import '../../models/messages/dummy_data.dart';

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
          ),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (_, index) => 
            ListTile(
              title: Text(getDummyData().messageData[index].receiverId),
              trailing: Text(
                getDummyData().messageData[index].messageText.length > 40 ? 
                  getDummyData().messageData[index].messageText.substring(0,40): 
                  getDummyData().messageData[index].messageText)),
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

DummyData getDummyData() {
  return DummyData();
}