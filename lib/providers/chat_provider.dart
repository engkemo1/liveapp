import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stars_live/models/user_chat_model.dart';
import 'package:stars_live/models/user_model.dart';

import '../models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  var msgController = TextEditingController();

  void sendMessage({
    required message,
    required receiverId,
    required uId,
    required receiverName,
    required receiverImage,
    required senderName,
    required senderImage,
  }) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(uId)
          .collection('messages')
          .add(MessageModel(DateTime.now().toString(), message, receiverId, uId)
              .toMap())
          .then((value) => setDocData(receiverId,uId,senderName,senderImage,message,DateTime.now(),false));
      notifyListeners();

      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .add(MessageModel(DateTime.now().toString(), message, receiverId, uId)
              .toMap())
          .then((value) {
         setDocData(uId,receiverId,receiverName,receiverImage,message,DateTime.now(),true);
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  List<MessageModel> chat = [];

  void getMessages({
    @required receiverId,
    @required uId,
  }) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .orderBy('dateTime')
          .snapshots()
          .listen((event)  {
        chat = [];
        event.docs.forEach((element) {
          chat.add(MessageModel.fromJson(element.data()));

        });

        notifyListeners();
      });
    } catch (e) {
      print(e);
    }
  }

  void setDocData(senderId,receiverId, name,image,message,time,bool read) {

    FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .set(
        {
          'name':name,
          'image':image,
          'id':receiverId,
          'lastMessage':message,
          'dateTime':time.toString(),
          'read': read
        });


  }


  List<UserChatModel> userChats=[];
  
  void getAllChats(String id)
  {
    if(id == '')
      return ;

    print('hello from all chats ');
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('chats')
        .orderBy('dateTime',descending: true)
        .snapshots()
        .listen((value) {
          userChats=[];

          value.docs.forEach((element) {
            UserChatModel user = UserChatModel.fromJson(element.data());
            if(user.id!=id)
            userChats.add(user);
          });
          notifyListeners();
    });

  }
  

}



