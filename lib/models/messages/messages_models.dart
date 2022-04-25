import 'package:intl/intl.dart';

class Message {
  final String sale;
  final String host;
  final String customer;
  final String sender;
  final String receiver;
  final String text;
  final bool hostShow = true;
  final bool customerShow = true;
  final bool receiverSeen = false;
  final DateTime date = DateTime.now();

  Message(
    this.sale,
    this.host,
    this.customer,
    this.sender,
    this.receiver,
    this.text
  );

  String get formattedTime {
    return DateFormat.jm().format(date);
  }

  String get formattedDate {
    return DateFormat.yMMMd().format(date);
  }
}

class Conversation{
  List<Message> conversation;

  Conversation(): conversation = [];

  void addMessage(Message message){
    conversation.add(message);
  }

  List<Message> get conversations{
    return conversation;
  }

  int get listLength{
    return conversation.length;
  }

  Message messageAtIndex(int index){
    return conversation[index];
  }
  
}