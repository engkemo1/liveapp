class MessageModel {
  String? dateTime;
  String? receiverUid;
  String? senderUid;
  String? text;

  MessageModel(this.dateTime, this.text, this.receiverUid, this.senderUid);

  MessageModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    text = json['text'];
    receiverUid = json['receiverUid'];
    senderUid = json['senderUid'];
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'text': text,
      'dateTime': dateTime,
    };
  }
}
