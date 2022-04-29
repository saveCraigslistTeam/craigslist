import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import '../../models/Messages.dart';
import './message_form.dart';
// dart async library for setting up real time updates
import 'dart:async';
// amplify packages
import 'package:amplify_datastore/amplify_datastore.dart';
// amplify configuration and models
import '../../models/ModelProvider.dart';
import '../../models/Messages.dart';

class MessageDetail extends StatefulWidget {

  final String title;
  final AmplifyDataStore dataStore;
  final String userName;
  final String sale;

  const MessageDetail({Key? key, 
    required this.title,
    required this.dataStore,
    required this.userName,
    required this.sale}) : super(key: key);

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {

  late StreamSubscription<QuerySnapshot<Messages>> messageStream;

  List<Messages> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getMessageStream(String userName, String sale) async {
    messageStream = widget.dataStore
        .observeQuery(Messages.classType,
        where: (Messages.SENDER.beginsWith(userName) | Messages.RECEIVER.beginsWith(userName)) & Messages.SALE.beginsWith(sale),
        sortBy: [Messages.DATE.ascending()])
        .listen((QuerySnapshot<Messages> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _messages = snapshot.items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<String?> args = ModalRoute.of(context)!.settings.arguments as List<String?>;
    final String? userName = args[0];
    final String? sale = args[1];

    if(_isLoading) {
      getMessageStream(userName.toString(), sale.toString());
    }
    return (
      _isLoading ? Center(child: Text("loading messages")) :
      Scaffold(
      appBar: AppBar(
        title: Text(
          "To: " + _messages[0].customer.toString()),
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
      body: ScrollingMessagesSliver(data: _messages, 
        dataStore: widget.dataStore, 
        userName: userName.toString()),
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

class ScrollingMessagesSliver extends StatelessWidget{
  final List<Messages> data;
  final AmplifyDataStore dataStore;
  final String userName;

  const ScrollingMessagesSliver({Key? key, 
    required this.data,
    required this.dataStore,
    required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _sc = ScrollController();
    
    return SafeArea(
        child: Column(
          children: [
            Expanded(flex: 8,
                  child:CustomScrollView(
      controller: ScrollController(initialScrollOffset: 300), 
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
                      (context, int index) {
                        return getListTile(index, data, context, userName);
                      },
                      childCount: data.length,
                      semanticIndexOffset: data.length
                    )
        ),]
    )),
    Expanded(flex: 2, child: MessageForm(
              messageData: data[0],
              dataStore: dataStore,
              userName: userName
              ),
            )
          ]
        )
      );
  }
}