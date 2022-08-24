import 'package:stars_live/models/user_model.dart';

class UserChatModel {
  String? id;
  String? name;
  String? image;
  String? lastMessage;
  String? dateTime;
  bool? read;



  UserChatModel({
    this.id,
    this.name,
    this.image,
    this.lastMessage,
    this.dateTime,
    this.read
  });

  UserChatModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    lastMessage=json['lastMessage'];
    dateTime = json['dateTime'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image']= this.image;
    data['lastMessage']=this.lastMessage;
    data['dateTime']=this.dateTime;
    data['read']= this.read;
    return data;
  }
}
