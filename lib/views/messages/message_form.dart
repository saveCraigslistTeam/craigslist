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
    return (
      form(formKey, context)
    );            
  }
}

Widget form(GlobalKey<FormState> formKey, BuildContext context) {
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
            send()
          ],
      ),
    )
  );
}

Widget textEntry(){
  return (
    TextFormField(
        decoration: 
          const InputDecoration(
            labelText: 'New Message',
            border: OutlineInputBorder()),
        maxLines: 2,
        minLines: 1,
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
    }));
  }

Widget send(){
  return (
    ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))
        )),
      onPressed: () { },
      child: Icon(Icons.send),
    )
  );
}

void sendMessage(NewMessage message, String userId, String receiverId, String text){
  final DateTime date = DateTime.now();
  message.setDateTime = date;
  message.setUserId = userId;
  message.setMessageText = text;
  message.setReceiverId = receiverId;
  
  print('${message.userId}, ${message.userId}, ${message.userId}, ${message.userId}');
}

double paddingSides(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context){
  return MediaQuery.of(context).size.height * 0.01;
}