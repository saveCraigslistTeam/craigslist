import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import '../../models/messages/messages_models.dart';
import './message_form.dart';
import './inbox.dart';

class MessageDetail extends StatelessWidget {

  final String title;
  final AmplifyDataStore dataStore;
  static const String routeName = 'messageDetail';

  const MessageDetail({Key? key, 
    required this.title,
    required this.dataStore}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final DetailData detailData = ModalRoute.of(context)?.settings.arguments as DetailData;
    final Conversation data = detailData.conversation;
    final AmplifyDataStore dataStore = detailData.dataStore;
    
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
      body: ScrollingMessages(data: data, dataStore: dataStore),
      )
    );
  }
}

class ScrollingMessages extends StatelessWidget{
  final Conversation data;
  final AmplifyDataStore dataStore;

  const ScrollingMessages({Key? key, 
    required this.data,
    required this.dataStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: [
            Expanded(flex: 8,
                  child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: data.listLength,
                          itemBuilder: (_, index) => getListTile(index, data, context),
                          addAutomaticKeepAlives: true,
                          shrinkWrap: true)),
            Expanded(flex: 2, child: MessageForm(
              messageData: data.conversations[0],
              dataStore: dataStore,
              ),
            )
          ]
        )
      );
  }
}

class ColoredBox extends StatelessWidget {
  final String text;
  final Color color;
  final MainAxisAlignment alignment;
  final TextAlign textAlignment;

  const ColoredBox({
    Key? key, 
    required this.text, 
    required this.color,
    required this.alignment,
    required this.textAlignment}) : super(key: key);

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
                minWidth: 10, 
                maxWidth: 250,
                minHeight: 10,
                maxHeight: double.infinity),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(text, textAlign: textAlignment)
            ),
          ),       
        ],)
    );
  }
}

Widget getListTile(int index, Conversation data, BuildContext context) {
  if (data.conversations[index].host == data.conversations[index].receiver) {
    return ListTile(
      title: ColoredBox(
          color: Colors.lightBlue.shade200, 
          text: data.conversations[index].text,
          alignment: MainAxisAlignment.end,
          textAlignment: TextAlign.start)
    );
  } else {
    return ListTile(
      title: ColoredBox(
          color: Colors.grey.shade200, 
          text: data.conversations[index].text,
          alignment: MainAxisAlignment.start,
          textAlignment: TextAlign.start)
    );
  }
}

