import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
// dart async library for setting up real time updates
import 'dart:async';
// amplify configuration and models
import '../../models/ModelProvider.dart';
// Custom packages
import '../../models/Messages.dart';
import './message_form.dart';
import './widgets/widgets.dart';

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
    /// Pulls conversation data from AWS datastore.
    /// 
    /// The [Messages] are parsed with the unique sale ID, the userName
    /// of the currently logged in user, and the userName of the message
    /// recipient. The recipient and user can either be the host of the [Sale]
    /// or the potential customer. Data is sorted in ascending order so that the
    /// most recent message appears at the bottom and populates downward.

    messageStream = widget.dataStore
        .observeQuery(Messages.classType,
        where: (Messages.HOST.eq(userName) | Messages.CUSTOMER.eq(userName))
                & (Messages.HOST.eq(customer) | Messages.CUSTOMER.eq(customer))  
                & Messages.SALE.eq(sale),
        sortBy: [Messages.DATE.ascending()])
        .listen((QuerySnapshot<Messages> snapshot) {
          if(mounted) {
            setState(() {
              if (_isLoading) _isLoading = false;
              _messages = snapshot.items;
            });
          }
      });
  }

  Future<void> markSeen(Messages message, userName) async {
    /// When the user first enters the conversation, all visible
    /// [Messages] will be updated as seen. 
    /// 
    /// The seen message criteria is used to update the notification
    /// of 'New Message' for the user.
    
    try {
      // Create a message with all the original message data
      Messages updatedMessage = message.copyWith(
        id: message.id,
        sale: message.sale,
        host: message.host,
        customer: message.customer,
        hostSent: message.hostSent,
        text: message.text,
        date: message.date,
        seen: message.hostSent! ? message.host! != userName : message.customer! != userName
      );

      // Overwrite the current message with the new data.
      await Amplify.DataStore.save(updatedMessage);

    } catch (e) {
      debugPrint('An error occurred while saving Messages: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    final List<String?> args = ModalRoute.of(context)!.settings.arguments 
                               as List<String?>;
    final String userName = args[0]!;
    final String sale = args[1]!;
    final String customer = args[2]!;

    // Sets the appBar title to the correct recipient based on the message
    // and the user who is logged in.
    final String messageTitle = _messages.isNotEmpty 
                              ? "To: " + (_messages[0].host == userName 
                                            ? _messages[0].customer!
                                            : _messages[0].host!)
                              : "To: $customer";

    if(_isLoading) {
      getMessageStream(userName, sale, customer);
    } else {
      for(int i = 0; i < _messages.length; i++) {
        if(!_messages[i].seen!) markSeen(_messages[i], userName);
      }
    }

    return (
      Scaffold(
        appBar: appBar(messageTitle, context),
        body: _isLoading 
          ? const Center(child: Text("loading messages")) 
          : _messages.isNotEmpty 
            ? ScrollingMessagesSliver(data: _messages, 
                                      dataStore: widget.dataStore, 
                                      userName: userName)
            : userName != customer 
              ? NewMessageToSeller(sender: userName,
                                saleId: sale,
                                seller: customer,
                                dataStore: widget.dataStore,)
              : const Center(child: Text('Error: Cannot message yourself.')))
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
          Container(
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
        ]
      ));
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

  if ((data[index].host == userName && data[index].hostSent!)
      || (data[index].customer == userName && !data[index].hostSent!)) {
    return ListTile(
      title: ColoredBox(
          color: Theme.of(context).primaryColor, 
          text: data[index].text!,
          alignment: MainAxisAlignment.end,
          textAlignment: TextAlign.start)
    );
  } else {
    return ListTile(
      title: ColoredBox(
          color: Colors.grey.shade200, 
          text: data[index].text!,
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
    
    return Column(
      children: [
        Expanded(
          flex: 7, 
          child: Column(
            children: [
              Expanded(
                flex: 9,
                child: CustomScrollView(
                  reverse: false,
                  cacheExtent: 10,
                  controller: ScrollController(
                    initialScrollOffset: data.length * 100), 
                  slivers: [SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, int index) {
                        return getListTile(index, data, context, userName);
                      },
                      childCount: data.length,
                      semanticIndexOffset: 0
                    )
                  )]
                ),
              ),
            ]
          ),
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

    Messages dummyMessage = Messages(
      sale: saleId,
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
          Expanded(flex: 3, 
          child: Container(
              color: Theme.of(context).primaryColor,
              child: MessageForm(
              messageData: createMessageData(),
              dataStore: dataStore,
              userName: sender)
            )
          )
        ]);
    }
}