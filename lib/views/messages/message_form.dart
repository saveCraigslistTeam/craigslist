import 'package:flutter/material.dart';

class MessageForm extends StatefulWidget {

  const MessageForm({Key? key}) : super(key: key);

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
                decoration: InputDecoration(labelText: 'New Message',
                            border: OutlineInputBorder()),
              ),
            ),
            )
      ),
    );
  }
}