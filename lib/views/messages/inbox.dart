import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// dart async library for setting up real time updates
import 'dart:async';
// amplify packages
import 'package:amplify_datastore/amplify_datastore.dart';
// amplify configuration and models
import '../../models/ModelProvider.dart';
import '../../models/Messages.dart';

class InboxPage extends StatefulWidget {
  final AmplifyDataStore dataStore;

  const InboxPage({Key? key, required this.dataStore}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final String userName = 'sender';

  late StreamSubscription<QuerySnapshot<Messages>> messageStream;

  List<Messages> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    getMessageStream();
    super.initState();
  }

  Future<void> getMessageStream() async {
    messageStream = widget.dataStore.observeQuery(Messages.classType,
        where: Messages.HOST.beginsWith(userName) |
            Messages.CUSTOMER.beginsWith(userName),
        sortBy: [
          Messages.DATE.descending()
        ]).listen((QuerySnapshot<Messages> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _messages = snapshot.items;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Inbox'),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _messages.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: InboxList(
                            messages: filterRecentMessagesByGroup(_messages),
                            dataStore: widget.dataStore,
                            userName: userName),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            color: Theme.of(context).primaryColor,
                          ))
                    ],
                  )
                : const Center(child: Text('No messages'))));
  }
}

class InboxList extends StatelessWidget {
  List<Messages> messages = [];
  final AmplifyDataStore dataStore;
  final String userName;

  InboxList(
      {Key? key,
      required this.messages,
      required this.dataStore,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (messages.isNotEmpty
        ? ListView.builder(
            itemCount: messages.length,
            itemBuilder: (_, index) => InboxItem(
                messages: messages,
                message: messages[index],
                dataStore: dataStore,
                userName: userName))
        : const Center(child: Text('No Messages')));
  }
}

class InboxItem extends StatelessWidget {
  final List<Messages> messages;
  final Messages message;
  final AmplifyDataStore dataStore;
  final String userName;

  InboxItem(
      {Key? key,
      required this.messages,
      required this.message,
      required this.dataStore,
      required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Material(
        elevation: 3.0,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: (ListTile(
            title: leadingContent(message.customer, message.text),
            trailing: trailingContent(message.date),
            onTap: () => {
                  Navigator.pushNamed(context, '/msgDetail',
                      arguments: [userName, message.sale])
                })),
      ),
    );
  }
}

Widget leadingContent(String? customer, String? message) {
  return (Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(customer!.length > 12 ? customer.substring(0, 12) : customer,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(message!.length > 30 ? message.substring(0, 30) + "..." : message,
            style: const TextStyle(fontSize: 14))
      ]));
}

Widget trailingContent(TemporalDateTime? date) {
  DateTime parsedDate = DateTime.parse(date.toString());
  String formattedDate;

  if (withinCurrentDay(date!)) {
    formattedDate = DateFormat.jm().format(parsedDate);
  } else {
    formattedDate = DateFormat.yMd().format(parsedDate);
  }

  return Text(formattedDate.length > 25
      ? formattedDate.substring(0, 25)
      : formattedDate);
}

List<Messages> filterRecentMessagesByGroup(List<Messages> messages) {
  List<Messages> formattedMessages = [];
  List<String> visited = [];
  bool flag = true;

  for (int i = 0; i < messages.length; i++) {
    String combined = '${messages[i].sale}${messages[i].customer}';
    for (int j = 0; j < visited.length; j++) {
      if (combined == visited[j]) {
        for (int k = 0; k < formattedMessages.length; k++) {
          if (formattedMessages[k].sale == messages[i].sale) {
            DateTime currMessageDate =
                DateTime.parse(messages[i].date.toString());
            DateTime oldDate =
                DateTime.parse(formattedMessages[k].date.toString());
            formattedMessages[k] = currMessageDate.isAfter(oldDate)
                ? messages[i]
                : formattedMessages[k];
          }
        }
        flag = false;
      }
    }
    if (flag) {
      formattedMessages.add(messages[i]);
      visited.add(combined);
      flag = true;
    }
    flag = true;
  }

  return formattedMessages;
}

bool withinCurrentDay(TemporalDateTime messageDate) {
  DateTime currDate = DateTime.now();
  DateTime parseMessageDate = DateTime.parse(messageDate.toString());

  if (currDate.day < parseMessageDate.day) {
    return false;
  }
  return true;
}
