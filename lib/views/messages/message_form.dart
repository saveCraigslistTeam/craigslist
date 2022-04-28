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
  
  final Message messageData;
  final AmplifyDataStore dataStore;
  // final AmplifyStorageS3 storage;
  // final AmplifyAuthCognito auth;

  const MessageForm({Key? key, 
    required this.messageData,
    required this.dataStore,
    // required this.storage,
    // required this.auth
    }) : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  
  @override
  void initState() {
    // kick off app initialization
    //_initializeApp();
    super.initState();
  }

  // Future<void> _initializeApp() async {
  //   // Query and Observe updates to Todo models. DataStore.observeQuery() will
  //   // emit an initial QuerySnapshot with a list of Todo models in the local store,
  //   // and will emit subsequent snapshots as updates are made
  //   //
  //   // each time a snapshot is received, the following will happen:
  //   // _isLoading is set to false if it is not already false
  //   // _todos is set to the value in the latest snapshot
  //   _subscription = widget.dataStore.observeQuery(Sale.classType)
  //       // _subscription = Amplify.DataStore.observeQuery(Sale.classType)
  //       .listen((QuerySnapshot<Sale> snapshot) {
  //     setState(() {
  //       if (_isLoading) _isLoading = false;
  //       _sales = snapshot.items;
  //     });
  //   });
  // }

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
              child: textEntry(widget.messageData),
            ),
          ),
          send(widget.messageData, formKey)
      ],
    ),
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
        saveNewMessage(data);
      }
    },
    child: const Icon(Icons.send),
  ));
}

Future<void> saveNewMessage(Message oldMessage) async {

  Messages newMessage = Messages(
    sale: oldMessage.sale,
    host: oldMessage.host,
    customer: oldMessage.customer,
    sender: oldMessage.receiver,
    receiver: oldMessage.sender,
    senderSeen: true,
    receiverSeen: false,
    text: oldMessage.text);
  
  try{
    
    await Amplify.DataStore.save(newMessage);

  } catch (e) {

    print("An error occurred saving new message: $e");
  }
  sendMessage(newMessage);
}

void sendMessage(Messages data) {
  print('${data.sale} ${data.host} ${data.customer}');
  print('${data.sender} ${data.receiver} ${data.text}');
}

double paddingSides(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context) {
  return MediaQuery.of(context).size.height * 0.01;
}
