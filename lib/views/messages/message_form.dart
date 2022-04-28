import 'package:flutter/material.dart';
import '../../models/messages/messages_models.dart';
// dart async library for setting up real time updates
import 'dart:async';
// amplify packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
// amplify configuration and models
import '../../models/ModelProvider.dart';
import '../../models/Messages.dart';

class MessageForm extends StatefulWidget {
  
  final Message messageData;
  final AmplifyDataStore dataStore;

  const MessageForm({Key? key, 
    required this.messageData,
    required this.dataStore,
    }) : super(key: key);

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
            child: SizedBox(
              width: 300,
              child: textEntry(widget.messageData),
            ),
          ),
          send(widget.messageData, formKey)])
      ));
    }
}


Widget textEntry(Message data) {

  return (TextFormField(
      decoration: const InputDecoration(
          labelText: 'New Message', border: OutlineInputBorder()),
      maxLines: 2,
      minLines: 1,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      onSaved: (value) {
         data.text = value!;
      },
      validator: (value) {
        if (value == null || value.isEmpty || value == '') {
          return 'Please enter a message';
        } else {
          return null;
        }
      })
  );
}

Widget send(Message data, GlobalKey<FormState> formKey) {
  return (ElevatedButton(
    style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
    onPressed: () async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        await saveNewMessage(data);
        formKey.currentState?.reset();
      }
    },
    child: const Icon(Icons.send),
  ));
}

Future<void> saveNewMessage(Message oldMessage) async {
  final TemporalDateTime currDate = TemporalDateTime.now();

  Messages newMessage = Messages(
    sale: oldMessage.sale,
    host: oldMessage.host,
    customer: oldMessage.customer,
    sender: oldMessage.receiver,
    receiver: oldMessage.sender,
    senderSeen: true,
    receiverSeen: false,
    text: oldMessage.text,
    date: currDate);
  
  try{
    await Amplify.DataStore.save(newMessage);
    print('Message sent successfully');
  } catch (e) {
    print("An error occurred saving new message: $e");
  }
}

double paddingSides(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.01;
}
