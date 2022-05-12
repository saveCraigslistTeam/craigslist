import 'package:flutter/material.dart';
// dart async library for setting up real time updates
import 'dart:async';
// amplify packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
// amplify configuration and models
import '../../models/ModelProvider.dart';
import '../../models/Messages.dart';

class MessageForm extends StatefulWidget {
  /// Creates an input box for the user to send a [message].
  ///
  /// The [MessageForm] will be at the bottom 30% of the screeen
  /// it is a [TextFormField] with a [Icon.sent] button that will
  /// send the message to the AWS server.

  final Messages messageData;
  final String userName;
  final AmplifyDataStore dataStore;

  const MessageForm(
      {Key? key,
      required this.messageData,
      required this.dataStore,
      required this.userName})
      : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String newMessage = '';
    String userName = widget.userName;

    return Form(
      key: formKey,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingSides(context),
                  vertical: paddingTopAndBottom(context)),
              child: Container(
                color: Colors.white,
                width: 350,
                child: TextFormField(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                await saveNewMessage(
                                    widget.messageData, newMessage, userName);
                                formKey.currentState?.reset();
                              }
                            })),
                    maxLines: 3,
                    minLines: 2,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    onSaved: (value) {
                      newMessage = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '') {
                        return 'Please enter a message';
                      } else {
                        return null;
                      }
                    }),
              ),
            ),
          ]),
    );
  }
}

Future<void> saveNewMessage(
    Messages messageData, String newMessage, String userName) async {
  /// Sends the data of the new message to the AWS server.

  TemporalDateTime currDate = TemporalDateTime.now();

  Messages outMessage = Messages(
      sale: messageData.sale,
      host: messageData.host,
      customer: messageData.customer,
      hostSent: messageData.host == userName,
      seen: false,
      text: newMessage,
      date: currDate);

  try {
    await Amplify.DataStore.save(outMessage);
    debugPrint('Message sent successfully');
  } catch (e) {
    debugPrint("An error occurred saving new message: $e");
  }
}

double paddingSides(BuildContext context) {
  /// Adds padding to the sides of the field
  return MediaQuery.of(context).size.width * 0.03;
}

double paddingTopAndBottom(BuildContext context) {
  /// Adds padding to the top and bottom of the form field.
  return MediaQuery.of(context).size.height * 0.01;
}
