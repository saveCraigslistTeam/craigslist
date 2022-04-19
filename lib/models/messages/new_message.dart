class NewMessage {
  String? userId;
  String? receiverId;
  String? text;
  DateTime? date;

  NewMessage();
  
  String? get user{
    return userId;
  }

  String? get receiver{
    return receiverId;
  }

  String? get messageText {
    return text;
  }

  DateTime? get currDate {
    return date;
  }

  set setUserId(String user) {
    userId = user;
  }

  set setReceiverId(String receiver){
    receiverId = receiver;
  }

  set setMessageText(String message){
    text = message;
  }

  set setDateTime(DateTime dateTime){
    date = dateTime;
  }
}