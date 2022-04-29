import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import '../../models/Messages.dart';
import './message_form.dart';
import './inbox.dart';

class MessageDetail extends StatelessWidget {

  final String title;
  final AmplifyDataStore dataStore;
  final String userName;

  const MessageDetail({Key? key, 
    required this.title,
    required this.dataStore,
    required this.userName}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final DetailData detailData = ModalRoute.of(context)?.settings.arguments as DetailData;
    final List<Messages> data = detailData.messages;
    final AmplifyDataStore dataStore = detailData.dataStore;
    final Function rebuildFunction = detailData.rebuild;
    
    return (
      Scaffold(
      appBar: AppBar(
        title: Text(
          "To: " + data[0].customer.toString()),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: GestureDetector(
              onTap: () => {
                Navigator.of(context).pop()
              },
              child: const BackButton())
            ),
        backgroundColor: Theme.of(context).primaryColor,
          ),
      body: ScrollingMessages(data: data, 
        dataStore: dataStore, 
        userName: userName,
        rebuildFunction: rebuildFunction),
      )
    );
  }
}

class ScrollingMessages extends StatelessWidget{
  final List<Messages> data;
  final AmplifyDataStore dataStore;
  final String userName;
  final Function rebuildFunction;

  const ScrollingMessages({Key? key, 
    required this.data,
    required this.dataStore,
    required this.userName,
    required this.rebuildFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _sc = ScrollController();
    
    return SafeArea(
        child: Column(
          children: [
            Expanded(flex: 8,
                  child: ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: data.length,
                          itemBuilder: (_, index) => getListTile(index, data, context, userName),
                          addAutomaticKeepAlives: true,
                          shrinkWrap: true)),
            Expanded(flex: 2, child: MessageForm(
              messageData: data[0],
              dataStore: dataStore,
              userName: userName,
              rebuildFunction: rebuildFunction
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

Widget getListTile(int index, List<Messages> data, BuildContext context, String userName) {
  if (data[index].receiver == userName) {
    return ListTile(
      title: ColoredBox(
          color: Theme.of(context).primaryColor, 
          text: data[index].text ?? '',
          alignment: MainAxisAlignment.end,
          textAlignment: TextAlign.start)
    );
  } else {
    return ListTile(
      title: ColoredBox(
          color: Colors.grey.shade200, 
          text: data[index].text ?? '',
          alignment: MainAxisAlignment.start,
          textAlignment: TextAlign.start)
    );
  }
}

