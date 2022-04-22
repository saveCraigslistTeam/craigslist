class InboxData {
  final String? imgUrl;
  final String userId;
  final String incomingId;
  final String messageText;
  final DateTime dateTime;
  final String saleTitle;

  InboxData( this.userId,
             this.incomingId,
             this.messageText,
             this.dateTime,
             this.saleTitle,
             this.imgUrl);
  
  InboxData.noImg(this.userId,
                  this.incomingId,
                  this.messageText,
                  this.dateTime,
                  this.saleTitle): imgUrl = null;
  
  String? get img{
    return imgUrl ?? "default/img";
  }

  String get user{
    return userId;
  }

  String get incoming{
    return incomingId;
  }

  String get message{
    return messageText;
  }

  DateTime get date{
    return dateTime;
  }
}

class Inbox{
  List<InboxData> inboxList;

  Inbox(): inboxList = [];

  void addToInbox(InboxData inboxData) {
    inboxList.add(inboxData);
  }

  List<InboxData> get inbox{
    return inboxList;
  }
}