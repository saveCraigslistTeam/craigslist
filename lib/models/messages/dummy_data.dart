class MessageNode {
  final String userId;
  final String receiverId;
  final String messageText;

  MessageNode(this.userId, this.receiverId, this.messageText);

  String get messageData {
    return messageText;
  }

  String get userIdData {
    return userId;
  }

  String get receiverIdData {
    return receiverId;
  }
}

class DummyData {
   final List<String> userIds = ['12345', '43214','47463','10092','32461'];
   final List<String> receiverIds = ['hank123', 'iCWeiner','potato','gary', 'craig'];
   final List<String> messages = ['Hello World', 'Hi there', 'What up', 'for sale?', 'This is a really reall long message like really reall really long'];

   List<MessageNode> get messageData {
     List<MessageNode> message = [];

     for(int i = 0; i < 5; i++){
       message.add(MessageNode(userIds[i], receiverIds[i], messages[i]));
     }

     return message;
   }

   int get messageLength {
     return messageData.length;
   }
}