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

  final Message message1 = Message(
    userId: "hank123", 
    receiverId: "user1", 
    messageText: "Hello, is the item for sale?");
  
  final Message message2 = Message(
    userId: "user1", 
    receiverId: "hank123", 
    messageText: "Hi, yes it is");

  final Message message3 = Message(
    userId: "hank123", 
    receiverId: "user1", 
    messageText: "Would you take x for it?");

  final Message message4 = Message(
    userId: "user1", 
    receiverId: "hank123", 
    messageText: "Sorry, x is too low.");
  
  final Message message5 = Message(
    userId: "hank123", 
    receiverId: "user1", 
    messageText: "But, my kid has cancer! You don't understand how much this Playstation 5 will mean to him!");
  
  final Message message6 = Message(
    userId: "user1", 
    receiverId: "hank123", 
    messageText: "What does that have to do with it?");
  
  final Message message7 = Message(
    userId: "hank123", 
    receiverId: "user1", 
    messageText: "Reported! For fraud!");
  
  final Message message8 = Message(
    userId: "user1", 
    receiverId: "hank123", 
    messageText: "What?");

  final List<Message> stream = <Message>[];
  
  void addMessages() {
      stream.add(message1);
      stream.add(message2);
      stream.add(message3);
      stream.add(message4);
      stream.add(message5);
      stream.add(message6);
      stream.add(message7);
      stream.add(message8);
  }

  List<Message> get messageData {
    return stream;
  }

  int get listLength {
    addMessages();
    return stream.length;
  }

}








