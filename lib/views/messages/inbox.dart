import 'package:flutter/material.dart';
import '../../models/messages/messages_models.dart';
// dart async library for setting up real time updates
import 'dart:async';
// amplify packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
// amplify configuration and models
import 'package:craigslist/amplifyconfiguration.dart';
import '../../models/ModelProvider.dart';
import '../../models/Messages.dart';

class InboxPage extends StatefulWidget {
  final AmplifyDataStore dataStore;

  const InboxPage({Key? key, required this.dataStore}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  // Amplify addition
  bool _isLoading = true;

  Conversation amplifyData = Conversation();

  Conversation data = Conversation();
  Conversation? formattedData;
  bool _loading = true;

  @override
  void initState(){
    // Amplify addition
    _initializeApp();
    //

    addMessageData();
    super.initState();
  }

  @override
  void dispose(){
    // To do fill this implementation
    super.dispose();
  }

  // Amplify addition
  Future<void> _initializeApp() async {
    
    // await _configureAmplify();

    setState(() {
      _isLoading = false;
    });

  }
  
  void addMessageData() {
    setState(() {
      final Message message = Message("saleId", "sender", "customerId", "sender", "receiver", "Hello World");
      final Message message2 = Message("saleId", "sender", "customerId",  "receiver", "sender", "Goodbye World");
      final Message message3 = Message("saleId2", "sender", "customerId1", "sender", "receiver1", "Message two");
      final Message message4 = Message("saleId2", "sender", "customerId1",  "receiver1", "sender", "Super long message incoming let me break your flutter app aaaaaarggghhh!");
      data.addMessage(message);
      data.addMessage(message2);
      data.addMessage(message3);
      data.addMessage(message4);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
      formattedData = removeDuplicates(data);
      return (
        Scaffold(
          appBar: AppBar(
            leading: const BackButton(color: Color.fromARGB(255, 166, 130, 255)),
            title: appBarTitle('Craigslist'),
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          body: _isLoading 
          ? Center(child: CircularProgressIndicator())
          : data.listLength > 0 ? Column(
            children: [
              Expanded(
                flex: 7,
                child: InboxList(
                  data: data, 
                  formattedData: formattedData!,
                  dataStore: widget.dataStore),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                  ))
            ],
          ) : Center(child: Text('No messages'))) 
          
      );
    }
  }

class InboxList extends StatelessWidget {

  final Conversation data;
  final Conversation formattedData;
  final AmplifyDataStore dataStore;

  const InboxList({Key? key, required this.formattedData, 
    required this.data,
    required this.dataStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      formattedData.listLength > 0 ?
      ListView.builder(
        itemCount: formattedData.listLength,
        itemBuilder: (_, index) => InboxItem(data: data, message: formattedData.conversations[index], formattedData: formattedData, dataStore: dataStore)):
      const Center(child: Text('No Messages'))
    );
  }
}

class InboxItem extends StatelessWidget {
  final Conversation data;
  final Message message;
  final Conversation formattedData;
  final AmplifyDataStore dataStore;
  
  const InboxItem({Key? key, 
    required this.data,
    required this.message,
    required this.formattedData,
    required this.dataStore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
      ListTile(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.blue, width: 1),
          borderRadius: BorderRadius.circular(5)),
      leading: getMessageUsername(message.customer),
      title: getMessageText(message.text ?? '', message.formattedDate),
      trailing: const Text(">"),
      focusColor: Colors.blue,
      onTap: () => {
            Navigator.pushNamed(context, '/msgDetail',
                arguments: DetailData(
                  dataStore,
                  groupByConversation(data, message.customer, message.sale)
            ))
        }
    ));
  }
  
}

Widget appBarTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
        color: Color(0xffA682FF), backgroundColor: Colors.white, fontSize: 30),
  );
}

Widget getMessageUsername(String customer) {
  return (Text(customer.length > 8 ? customer.substring(0, 8) : customer,
      style: const TextStyle(color: Color(0xff5887FF), fontSize: 20)));
}

Widget getMessageText(String text, String date) {
  return (Column(
    children: [
      Text(text.length > 25 ? text.substring(0, 25) : text),
      Text(date.length > 25 ? date.substring(0, 25) : date)
    ],
  ));
}

Conversation removeDuplicates(Conversation data) {
  Conversation formattedConversation = Conversation();
  List<String> visited = [];
  bool flag = true;

  for(int i = 0; i < data.listLength; i++){
    String combined = '${data.conversation[i].sale}${data.conversations[i].customer}';
    for(int j = 0; j < visited.length; j++) {
      if(combined == visited[j]){
        for(int k = 0; k < formattedConversation.listLength; k++) {
          if(identical(formattedConversation.conversations[k].sale, data.conversations[i].sale)){
            formattedConversation.conversations[k] = formattedConversation.conversations[k].date.isAfter(data.conversations[i].date) 
              ? formattedConversation.conversations[k]
              : data.conversations[i];
          }
        }
        flag = false;
      }
    }
    if(flag) {
      formattedConversation.addMessage(data.conversations[i]);
      visited.add(combined);
      flag = true;
    }
    flag = true;
  }
  return formattedConversation;
}

Conversation groupByConversation(Conversation data, String customer, String sale) {

  Conversation groupedConversation = Conversation();

  for(int i = 0; i < data.listLength; i++) {
    if(data.conversations[i].customer == customer && data.conversations[i].sale == sale){
      groupedConversation.addMessage(data.conversations[i]);
    }
  }

  return groupedConversation;
}

class DetailData {
  final AmplifyDataStore ds;
  final Conversation c;

  DetailData(
    this.ds,
    this.c
  );

  AmplifyDataStore get dataStore{
    return ds;
  }

  Conversation get conversation{
    return c;
  }


}