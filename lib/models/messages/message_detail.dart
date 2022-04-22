class Message{
  final String userId;
  final String incomingId;
  final String messageText;
  final String saleTitle;
  final DateTime dateTime;

  Message(this.userId,
          this.incomingId,
          this.messageText,
          this.saleTitle,
          this.dateTime);

  String get user{
    return userId;
  }

  String get incoming{
    return incomingId;
  }

  String get message{
    return messageText;
  }

  String get sale{
    return saleTitle;
  }

  DateTime get date{
    return dateTime;
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
}