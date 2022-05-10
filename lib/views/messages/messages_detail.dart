import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import '../../models/Messages.dart';
import './message_form.dart';
// dart async library for setting up real time updates
import 'dart:async';
// amplify configuration and models
import '../../models/ModelProvider.dart';

class MessageDetail extends StatefulWidget {
  /// Provides the details of the [messages] each conversation.
  /// 
  /// Each conversation is a list of [Messages] linked together by
  /// the unique [sale], [host], and [customer]. The list is provided
  /// in ascending order and pupulated with a [SliverList].

  final AmplifyDataStore dataStore;

  const MessageDetail({Key? key, required this.dataStore}) : super(key: key);

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

  Future<void> getMessageStream(String userName, 
                                String sale, 
                                String customer) async {
    messageStream = widget.dataStore
        .observeQuery(Messages.classType,
        where: (Messages.HOST.eq(userName) 
                  | Messages.CUSTOMER.eq(userName))
                & (Messages.HOST.eq(customer) 
                  | Messages.CUSTOMER.eq(customer))  
                & Messages.SALE.eq(sale),
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
    final String? customer = args[2];

    if(_isLoading) {
      getMessageStream(userName.toString(), sale.toString(), customer.toString());
    }
    
    return (
      _isLoading 
      ? const Center(child: Text("loading messages")) 
      : Scaffold(
        appBar: AppBar(
          title: _messages.isNotEmpty 
                ? Text(
                  "To: " + (_messages[0].host == userName 
                              ? _messages[0].customer.toString()
                              : _messages[0].host.toString()))
                : Center(child: Text("To: $customer")),
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
        body: _messages.isNotEmpty 
        ? ScrollingMessagesSliver(data: _messages, 
          dataStore: widget.dataStore, 
          userName: userName.toString())
        : NewMessageToSeller(sender: userName.toString(),
                            saleId: sale.toString(),
                            seller: customer.toString(),
                            dataStore: widget.dataStore,))
      );
  }
}

class ColoredBox extends StatelessWidget {
  /// Formats a [ColoredBox] with the [Message] [text].
  /// 
  /// If the currently logged in [userName] is the [sender] of the
  /// message. The message will appear on the right hand side of the 
  /// screen as a purple [ColoredBox]. Otherwise the message will 
  /// appear on the right hand side of the screen as a grey [ColoredBox]
  
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

Widget getListTile(int index, List<Messages> data, BuildContext context, 
                  String userName) {
  /// Returns a [ListTile] of the properly formatted color depending
  /// on whether the current [userName] has sent the message.
  /// 
  /// [ColoredBox] will be purple if the user sent the message. 
  /// [Coloredbox] will be grey if the user who sent the message is
  /// not the currently logged in user.

  if (data[index].host == userName 
      ? data[index].hostSent! 
      : !data[index].hostSent!) {
    return ListTile(
      title: ColoredBox(
          color: Theme.of(context).primaryColor, 
          text: data[index].text.toString(),
          alignment: MainAxisAlignment.end,
          textAlignment: TextAlign.start)
    );
  } else {
    return ListTile(
      title: ColoredBox(
          color: Colors.grey.shade200, 
          text: data[index].text.toString(),
          alignment: MainAxisAlignment.start,
          textAlignment: TextAlign.start)
    );
  }
}

class ScrollingMessagesSliver extends StatelessWidget{
  /// Creates a [SliverList] of the conversation items in ascending order
  /// where the most recent message appears at the bottom.
  
  final List<Messages> data;
  final AmplifyDataStore dataStore;
  final String userName;

  const ScrollingMessagesSliver({Key? key, 
    required this.data,
    required this.dataStore,
    required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Column(children: [
      Expanded(flex: 7, 
        child: CustomScrollView(
          controller: ScrollController(initialScrollOffset: 300), 
          slivers: [SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, int index) {
                return getListTile(index, data, context, userName);
              },
              childCount: data.length,
              semanticIndexOffset: data.length
            )
          )]
        )
      ),
        Expanded(flex: 3, 
        child: Container(
          color: Theme.of(context).primaryColor,
          child: MessageForm(
              messageData: data[0],
              dataStore: dataStore,
              userName: userName
            )
          )
        )
      ]);
    }
  }


class NewMessageToSeller extends StatelessWidget {
  /// Used in the [AllSales] page to send a new message to a seller.
  /// 
  /// Using the [Messages] and [userName] data this will craft a 
  /// dummy message ready to be sent. The message text and the current
  /// date time will be added when the message is sent.
  
  final String sender;
  final String saleId;
  final String seller;
  final AmplifyDataStore dataStore;

  const NewMessageToSeller({Key? key,
    required this.sender,
    required this.saleId,
    required this.seller,
    required this.dataStore}) : super(key: key);

  Messages createMessageData() {

    Messages dummyMessage = Messages(sale: saleId,
      host: seller,
      customer: sender,
      hostSent: false,
      text: '',
      date: TemporalDateTime.now(),
      seen: false);

    return dummyMessage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(flex: 7,
              child: Center(child: Text('Message seller'))),
        Expanded(flex: 3, child: MessageForm(
                  messageData: createMessageData(),
                  dataStore: dataStore,
                  userName: sender)
                )
              ]
          );
  }
}