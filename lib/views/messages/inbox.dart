import 'package:flutter/material.dart';
import 'messages_detail.dart';
import '../../models/messages/messages_models.dart';

class Inbox extends StatelessWidget {
  /* 
   * Message group shows all available chat logs for the user.
   */
  final String title;
  static const String routeName = 'messagesGroup';

  Inbox({Key? key, required this.title}) : super(key: key);

  final Conversation data = Conversation();
  final Message message = Message("saleId", "sender", "customerId", "sender", "receiver", "Hello World");
  final Message message2 = Message("saleId", "sender", "customerId",  "receiver", "sender", "Goodbye World");
  final Message message3 = Message("saleId2", "sender", "customerId1", "sender", "receiver1", "Message two");
  final Message message4 = Message("saleId2", "sender", "customerId1",  "receiver1", "sender", "Super long message incoming let me break your flutter app aaaaaarggghhh!");

  @override
  Widget build(BuildContext context) {

    data.addMessage(message);
    data.addMessage(message2);
    data.addMessage(message3);
    data.addMessage(message4);

    Conversation formattedData = removeDuplicates(data);

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
                  itemCount: formattedData.listLength,
                  itemBuilder: (_, index) => getListTile(index, context, formattedData)),
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

Widget getMessageUsername(int index, Conversation data) {
  return (Text(
      data.conversations[index].customer.length > 8
          ? data.conversations[index].customer.substring(0, 8)
          : data.conversations[index].customer,
      style: const TextStyle(color: Color(0xff5887FF), fontSize: 20)));
}

Widget getMessageText(int index, Conversation data) {
  return (Column(
    children: [
      Text(data.conversations[index].text.length > 25
          ? data.conversations[index].text.substring(0, 25)
          : data.conversations[index].text),
      Text(data.conversations[index].formattedDate.length > 25
          ? data.conversations[index].formattedDate.substring(0, 25)
          : data.conversations[index].formattedDate),
    ],
  ));
}

Widget getListTile(int index, BuildContext context, Conversation data) {
  return (ListTile(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.blue, width: 1),
          borderRadius: BorderRadius.circular(5)),
      leading: getMessageUsername(index, data),
      title: getMessageText(index, data),
      trailing: const Text(">"),
      focusColor: Colors.blue,
      onTap: () => {
            Navigator.pushNamed(context, '/msgDetail',
                arguments: data)
          }));
}

Conversation removeDuplicates(Conversation data) {
  Conversation formattedConversation = Conversation();
  bool flag = false;

  for(int i = 0; i < data.listLength; i++){
    flag = false;
    for(int j = 0; j < formattedConversation.listLength; j++){
      if(data.conversations[i].customer == formattedConversation.conversations[j].customer){
        if(data.conversations[i].sale == formattedConversation.conversations[j].sale) {
          if(data.conversations[i].date.isAfter(formattedConversation.conversations[j].date)){
            formattedConversation.conversations[j] = data.conversations[i];
            flag = true;
          }
        }
      }
    }
    if(flag){
      flag = false;
    } else {
      formattedConversation.addMessage(data.conversations[i]);
    }
  }

  return formattedConversation;
}
