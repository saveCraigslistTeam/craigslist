import 'dart:async';
import 'dart:convert';

class Message {
  final String userId;
  final String receiverId;
  final String messageText;

  Message({
    required this.userId,
    required this.receiverId,
    required this.messageText
  });

  String get user{
    return userId;
  }

  String get receiver{
    return receiverId;
  }

  String get message{
    return messageText;
  }
}

class Conversation {

  final List<Message> stream = <Message>[];

  final Message message1 = Message(
    userId: "user1", 
    receiverId: "hank123", 
    messageText: "Hello");

  void addMessages() {
    stream.add(message1);
  }

  List<Message> get messageData {
    addMessages();
    return stream;
  }

}








