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
      maintainBottomViewPadding: true,
      child: 
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: 
                          const InputDecoration(labelText: 'New Message',
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
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))
                          )),
                        onPressed: () { },
                        child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
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

double padding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.3;
}