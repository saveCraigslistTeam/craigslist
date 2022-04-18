import 'package:craigslist/models/messages/dummy_conversation.dart';
import 'package:flutter/material.dart';
import '../../models/messages/dummy_conversation.dart';

class MessageDetail extends StatelessWidget {

  final String title;
  static const String routeName = 'messageDetail';

  Conversation data = Conversation();

  MessageDetail({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final userName = ModalRoute.of(context)?.settings.arguments as String;
    final String userName = "user1";

    return (
      Scaffold(
      appBar: AppBar(title: Text(title),
                    leading: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: GestureDetector(
                        onTap: () => {
                          Navigator.of(context).pop()
                        },
                        child: const Text("<",
                        style: TextStyle(fontSize: 30)))
                      )
                    ),
      body: ListView.builder(
        itemCount: data.listLength,
        itemBuilder: (_, index) => getListTile(index, data, context, userName))
      )
    );
  }
}

Widget getListTile(int index, Conversation data, BuildContext context, String userName) {
  if (data.messageData[index].userId == userName) {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: ColoredBox(
          color: Colors.lightBlue.shade200, 
          text: data.messageData[index].message,
          alignment: MainAxisAlignment.end)
      )
    );
  } else {
    return ListTile(
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ColoredBox(
          color: Colors.grey.shade200, 
          text: data.messageData[index].message,
          alignment: MainAxisAlignment.start)
      )
    );
  }
}

class ColoredBox extends StatelessWidget {
  final String text;
  final Color color;
  final MainAxisAlignment alignment;

  const ColoredBox({
    Key? key, 
    required this.text, 
    required this.color,
    required this.alignment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return(
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: alignment,
        children: <Widget>[
          SafeArea(
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 200, 
                maxWidth: 250,
                minHeight: 50,
                maxHeight: double.infinity),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(text)
            ),
          ),       
        ],)
    );
  }
}