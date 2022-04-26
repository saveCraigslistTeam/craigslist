import 'package:flutter/material.dart';
import '../../models/messages/messages_models.dart';

class MessageForm extends StatefulWidget {

  final Message data;

  const MessageForm({Key? key, required this.data}) : super(key: key);

  @override
  State<MessageForm> createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return (form(formKey, context, widget.data));
  }
}

Widget form(GlobalKey<FormState> formKey, BuildContext context, Message data) {

  return (Form(
    key: formKey,
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: paddingSides(context),
              vertical: paddingTopAndBottom(context)),
          child: Container(
            width: 300,
            child: textEntry(data),
          ),
        ),
        send(data, formKey)
      ],
    ),
  ));
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
         data.changeMessage = value!;
         data.changeDate = DateTime.now();
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
