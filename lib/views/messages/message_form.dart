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

class MessageForm extends StatefulWidget {
  
  final Message newMessage;

  const MessageForm({Key? key, required this.newMessage}) : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return (
      Form(
      key: formKey,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: paddingSides(context),
                vertical: paddingTopAndBottom(context)),
            child: Container(
              width: 300,
              child: textEntry(),
            ),
          ),
          send(widget.newMessage, formKey)
      ],
    ),
  ));
  }
}


Widget textEntry() {

  String message;
  DateTime date;

  return (TextFormField(
      decoration: const InputDecoration(
          labelText: 'New Message', border: OutlineInputBorder()),
      maxLines: 2,
      minLines: 1,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      onSaved: (value) {
         message = value!;
         date = DateTime.now();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a message';
        } else {
          return null;
        }
      }));
}

Widget send(Message data, GlobalKey<FormState> formKey) {
  return (ElevatedButton(
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
    onPressed: () async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        sendMessage(data);
      }
    },
    child: const Icon(Icons.send),
  ));
}

Future<void> saveNewMessage(String message, DateTime date) async {

  
}

void sendMessage(Message data) {
  print('${data.sale} ${data.host} ${data.customer}');
  print('${data.sender} ${data.receiver} ${data.text}');
  print('${data.hostShow} ${data.customerShow} ${data.receiverSeen}');
  print('${data.date}');
}

double paddingSides(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.01;
}
