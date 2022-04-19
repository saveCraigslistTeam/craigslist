import 'package:flutter/material.dart';
import '../../models/messages/new_message.dart';

class MessageForm extends StatefulWidget {

  final String userId;
  final String receiverId;
  final NewMessage message = NewMessage();

  MessageForm({Key? key, 
    required this.userId, 
    required this.receiverId}) : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: (
        Form(
          key: formKey,
          child: 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'New Message',
                            border: OutlineInputBorder()),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onSaved: (value) {
                  String? text = value;
                },
                validator: (value){
                  if (value == null || value.isEmpty){
                    return 'Please enter a message';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          )
      ),
    );
  }
}

void sendMessage(NewMessage message, String userId, String receiverId, String text){
  final DateTime date = DateTime.now();
  message.setDateTime = date;
  message.setUserId = userId;
  message.setMessageText = text;
  message.setReceiverId = receiverId;
  
  print('${message.userId}, ${message.userId}, ${message.userId}, ${message.userId}');
}

