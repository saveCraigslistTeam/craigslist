import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// dart async library for setting up real time updates
import 'dart:async';
// amplify packages
import 'package:amplify_datastore/amplify_datastore.dart';
// amplify configuration and models
import '../../models/ModelProvider.dart';
import '../../models/Messages.dart';
// Custom Widgets for app
import './widgets/widgets.dart';

class InboxPage extends StatefulWidget {
  /// Builds the inbox of most recent [messages] per unique conversation.
  /// 
  /// Messages are pulled from the [Messages] table in AWS [dataStore] they
  /// are filtered and formatted to show up as a unique conversation [listTile]
  /// for the user to interact with.

  final AmplifyDataStore dataStore;
  const InboxPage({Key? key, required this.dataStore}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {

  late StreamSubscription<QuerySnapshot<Messages>> messageStream;
  List<Messages> _messages = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
  }

  Future<void> getMessageStream(String userName) async {
    /// Gets the message stream of any messages where the host or the
    /// customer matches the userName.
    messageStream = widget.dataStore.observeQuery(Messages.classType,
        where: (Messages.HOST.eq(userName) 
             | Messages.CUSTOMER.eq(userName)),
        sortBy: [ Messages.DATE.descending()])
          .listen((QuerySnapshot<Messages> snapshot) {
            if(mounted) {
              setState(() {
                if (_isLoading) _isLoading = false;
                _messages = snapshot.items;
              });
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    
    List<String?> args = ModalRoute.of(context)!.settings.arguments as List<String?>;
    final String userName = args[0]!;

    if(_isLoading) getMessageStream(userName);
    
    return Scaffold(
      appBar: appBar('Inbox', context),
      body: _isLoading
        ? progressIndicator(context)
        : _messages.isNotEmpty
          ? Column(
            children: [
              Expanded(
                flex: 8,
                child: InboxList(
                    messages: filterRecentMessagesByGroup(_messages),
                    dataStore: widget.dataStore,
                    userName: userName)),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Theme.of(context).primaryColor,
                  ))
              ]
            )
          : const Center(child: Text('No messages')));
    }
  }

class InboxList extends StatelessWidget {
  /// Builds the inbox items into a [ListView] for browsing by the user.
  /// 
  /// [ListView.builder] passes down the [messages] and the [userName] for
  /// parsing and sorting. 

  final List<Messages> messages;
  final AmplifyDataStore dataStore;
  final String userName;

  const InboxList(
      {Key? key,
      required this.messages,
      required this.dataStore,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      ListView.builder(
        itemCount: messages.length,
        itemBuilder: (_, index) => 
        Semantics(
          child: InboxItem(
              messages: messages,
              message: messages[index],
              dataStore: dataStore,
              userName: userName),
          button: true,
          onTapHint: 'Click to go to detailed messages view'
        ))
    );
  }
}

class InboxItem extends StatelessWidget {
  /// Formats the messages into [ListTiles] surrounded by [ColordBoxes].
  /// 
  /// The [InboxItem] is formatted as a floating [ListTile] with the name
  /// of the recipient and a portion of the text on the left hand side. On
  /// the far right of the box the [date] or [time] of the last message is
  /// in a column with a text to indicate to the user that the box is tappable.

  final List<Messages> messages;
  final Messages message;
  final AmplifyDataStore dataStore;
  final String userName;

  const InboxItem(
      {Key? key,
      required this.messages,
      required this.message,
      required this.dataStore,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Material(
        type: MaterialType.card,
        elevation: 4.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: (
          ListTile(
            title: message.customer!= userName 
              ? userNameAndMessageText(message.customer, message.text, context)
              : userNameAndMessageText(message.host, message.text, context),
            trailing: formattedDate(message, userName, context),
            onTap: () => {
              Navigator.pushNamed(context, '/msgDetail',
                  arguments: [userName, message.sale, message.customer])
            }))
      )
    );
  }
}

Widget userNameAndMessageText(String? customer, 
                              String? message, 
                              BuildContext context) {
  /// Formats the username of the text recipient and a portion of
  /// the last text.
  /// 
  /// Returns a [Column] formatted with the [userName] as bold and on top
  /// with the [text] formatted below the name. Max [userName] limit is 
  /// 12 characters and max [text] limit is 30 characters. Will append
  /// text's that are too long with elipses.
  
  return (
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(customer!.length > 12 
            ? customer.substring(0, 12) 
            : customer,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(message!.length > 30 
            ? message.substring(0, 30) + "..." 
            : message,
            style: TextStyle(fontSize: 14,
                   color: Theme.of(context).primaryColor))
      ])
    );
}

Widget formattedDate(Messages message, String userName, BuildContext context) {
  /// Converts the date from TemporalDateTime to DateTime and formats it.
  /// 
  /// Returns [time] if the date is within the same [day] will return the
  /// [day-month-year] if older than the current day.
  bool newMessage = message.seen! 
                    ? false
                    : message.hostSent! 
                      ? message.customer! == userName 
                      : message.host! == userName;
  return (
    Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        withinCurrentDay(message.date!) 
        ? Text(DateFormat.jm().format(DateTime.parse(message.date.toString())))
        : Text(DateFormat.yMd().format(DateTime.parse(message.date.toString()))),
        newMessage
        ? const Text('New Message',
             style: TextStyle(color: Colors.red)
        )
        : Text('Tap to View',
             style: TextStyle(color: Theme.of(context).primaryColor)
        ) 
        ])
  );
}

List<Messages> filterRecentMessagesByGroup(List<Messages> messages) {
  /// Filters the list of messages to include the latest message from
  /// each unique conversation.
  /// 
  /// Parsed list of [messages] will be returned with only the latest
  /// unique [formattedMessages]

  List<Messages> formattedMessages = [];
  bool flag = true;

  for (int i = 0; i < messages.length; i++) {

    if(formattedMessages.isEmpty) formattedMessages.add(messages[i]);

    for (int j = 0; j < formattedMessages.length; j++) {
      if(formattedMessages[j].sale == messages[i].sale 
         && formattedMessages[j].customer == messages[i].customer)
        {
          formattedMessages[j] = 
            DateTime.parse(messages[i].date.toString())
              .isAfter(DateTime.parse(formattedMessages[j].date.toString()))
            ? messages[i]
            : formattedMessages[j];
            flag = false;
            break;
        }
    }
    
    if(flag) formattedMessages.add(messages[i]);
    flag = true;
  }

  return formattedMessages;
}

bool withinCurrentDay(TemporalDateTime messageDate) {
  /// Verifies if the date of the message is within the current day.
  /// 
  /// Returns [true] if the date is within the current day.
  /// Returns [false] if the date is older than the current day.
  
  final DateTime currDate = DateTime.now();
  final DateTime parseMessageDate = DateTime.parse(messageDate.toString());

  return currDate.day <= parseMessageDate.day;
}
