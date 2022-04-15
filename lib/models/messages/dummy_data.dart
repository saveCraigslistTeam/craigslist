class MessageNode {
  final String userId;
  final String receiverId;
  final String messageText;
  final DateTime date;

  MessageNode({required this.userId, 
               required this.receiverId, 
               required this.messageText, 
               required this.date});

  String get messageData {
    return messageText;
  }

  String get userIdData {
    return userId;
  }

  String get receiverIdData {
    return receiverId;
  }

  String get dateData {
    return date.toString();
  }
}

class DummyData {
   final List<String> userIds = ['12345', '43214','47463','10092','32461',
                                 '12345', '43214','47463','10092','32461',
                                 '12345', '43214','47463','10092','32461'];
   final List<String> receiverIds = ['hank123', 'iCWeiner','potato','gary', 'craig', 
                                     'hank123', 'iCWeiner','potato','gary', 'craig',
                                     'hank123', 'iCWeiner','potato','gary', 'craig',
                                     ];
   final List<String> messages = ['Hello World', 'Hi there', 'What up', 'for sale?', 'This is a really reall long message like really reall really long', 'Hello World', 'Hi there', 'What up', 'for sale?', 'This is a really reall long message like really reall really long',
                                  'Hello World', 'Hi there', 'What up', 'for sale?', 'This is a really reall long message like really reall really long', 'Hello World', 'Hi there', 'What up', 'for sale?', 'This is a really reall long message like really reall really long',
                                  'Hello World', 'Hi there', 'What up', 'for sale?', 'This is a really reall long message like really reall really long', 'Hello World', 'Hi there', 'What up', 'for sale?', 'This is a really reall long message like really reall really long',];

   List<MessageNode> get messageData {
     List<MessageNode> message = [];

     for(int i = 0; i < userIds.length; i++){
       message.add(MessageNode(
         userId: userIds[i], 
         receiverId: receiverIds[i], 
         messageText: messages[i], 
         date: DateTime.now()));
     }

     return message;
   }

   int get messageLength {
     return messageData.length;
   }
}