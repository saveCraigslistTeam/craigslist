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
              leading: getMessageUsername(index),
              title: Text(
                getDummyData().messageData[index].messageText.length > 30 ? 
                  getDummyData().messageData[index].messageText.substring(0,30): 
                  getDummyData().messageData[index].messageText),
              trailing: const Text(">"),
              selectedColor: Colors.blue,),
              
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

Widget getMessageUsername(int index) {
  return (
    Text(getDummyData().messageData[index].receiverId)
  );
}

DummyData getDummyData() {
  return DummyData();
}