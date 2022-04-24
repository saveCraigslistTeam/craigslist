import 'package:flutter/material.dart';
import 'messages_detail.dart';
import '../../models/messages/dummy_data.dart';

class Inbox extends StatelessWidget {
  /* 
   * Message group shows all available chat logs for the user.
   */
  final String title;
  static const String routeName = 'messagesGroup';

  const Inbox({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Color.fromARGB(255, 166, 130, 255)),
          title: appBarTitle(title),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 7,
              child: ListView.builder(
                  itemCount: getDummyData().messageLength,
                  itemBuilder: (_, index) => getListTile(index, context)),
            ),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                ))
          ],
        )));
  }
}

Widget appBarTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
        color: Color(0xffA682FF), backgroundColor: Colors.white, fontSize: 30),
  );
}

Widget getMessageUsername(int index) {
  return (Text(
      getDummyData().messageData[index].receiverId.length > 8
          ? getDummyData().messageData[index].receiverId.substring(0, 8)
          : getDummyData().messageData[index].receiverId,
      style: const TextStyle(color: Color(0xff5887FF), fontSize: 20)));
}

Widget getMessageText(int index) {
  return (Column(
    children: [
      Text(getDummyData().messageData[index].messageText.length > 25
          ? getDummyData().messageData[index].messageText.substring(0, 25)
          : getDummyData().messageData[index].messageText),
      Text(getDummyData().messageData[index].dateDataDate.length > 25
          ? getDummyData().messageData[index].dateDataDate.substring(0, 25)
          : getDummyData().messageData[index].dateDataDate),
    ],
  ));
}

Widget getListTile(int index, BuildContext context) {
  return (ListTile(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.blue, width: 1),
          borderRadius: BorderRadius.circular(5)),
      leading: getMessageUsername(index),
      title: getMessageText(index),
      trailing: const Text(">"),
      focusColor: Colors.blue,
      onTap: () => {
            Navigator.pushNamed(context, '/msgDetail',
                arguments: getDummyData().messageData[index].userId)
          }));
}

Messages getDummyData() {
  return Messages();
}
