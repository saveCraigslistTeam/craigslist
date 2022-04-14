import 'package:flutter/material.dart';
import '../../models/messages/dummy_data.dart';

class MessagesGroup extends StatelessWidget{
  /* 
   * Message group shows all available chat logs for the user.
   */
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
          itemCount: getDummyData().messageLength,
          itemBuilder: (_, index) => getListTile(index))
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
    Text(
      getDummyData().messageData[index].receiverId.length > 10 ?
      getDummyData().messageData[index].receiverId.substring(0,10):
      getDummyData().messageData[index].receiverId,
      style: const TextStyle(color: Color(0xff5887FF),
                      fontSize: 20))
  );
}

Widget getMessageText(int index) {
  return (
    Row(children: [Text(
      getDummyData().messageData[index].messageText.length > 30 ? 
      getDummyData().messageData[index].messageText.substring(0,30): 
      getDummyData().messageData[index].messageText),
      ],)
  );
}

Widget getListTile(int index) {
  return (
    ListTile(
              leading: getMessageUsername(index),
              title: getMessageText(index),
              trailing: const Text(">"),
              selectedColor: Colors.blue,
              onTap: () => null)
  );
}

DummyData getDummyData() {
  return DummyData();
}