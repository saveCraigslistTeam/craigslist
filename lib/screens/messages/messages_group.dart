import 'package:flutter/material.dart';
import '../../models/messages/dummy_data.dart';

class MessagesGroup extends StatelessWidget{
  /* 
   * todo: Add date as subtitle to message box 
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
        body: Padding(padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          child: ListView.builder(
            itemCount: getDummyData().messageLength,
            itemBuilder: (_, index) => getListTile(index)
          )
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
    SizedBox(
      width: 90,
      child: Text(
        getDummyData().messageData[index].receiverId.length > 8 ?
        getDummyData().messageData[index].receiverId.substring(0,8):
        getDummyData().messageData[index].receiverId,
        style: const TextStyle(color: Color(0xff5887FF),
                        fontSize: 20)
        )
      )
  );
}

Widget getMessageText(int index) {
  return (
    Column(children: [Text(
        getDummyData().messageData[index].messageText.length > 25 ? 
        getDummyData().messageData[index].messageText.substring(0,25): 
        getDummyData().messageData[index].messageText),
      Text(
        getDummyData().messageData[index].dateData.length > 25 ? 
        getDummyData().messageData[index].dateData.substring(0,25): 
        getDummyData().messageData[index].dateData)
      ],)
  );
}

Widget getListTile(int index) {
  return (
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      child: ListTile(
          shape: RoundedRectangleBorder(side: 
            const BorderSide(color: Colors.blue, width: 1),
              borderRadius: BorderRadius.circular(5)
              ),
          leading: getMessageUsername(index),
          title: getMessageText(index),
          trailing: const Text(">"),
          focusColor: Colors.blue,
          onTap: () => {})
        )
    );
}

DummyData getDummyData() {
  return DummyData();
}