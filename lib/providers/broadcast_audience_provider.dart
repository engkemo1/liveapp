import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../models/singl_user_model.dart';

class BroadCastAudienceProvider extends ChangeNotifier
{

  void uploadCurrentDiamonds(String channel,String diamonds)
  {
    FirebaseFirestore.instance
        .collection('userDiamonds')
        .doc(channel)
        .set({
      'diamond': diamonds
    });

    notifyListeners();
  }
  List<Map<dynamic, dynamic>> comments = [];
  void getAllComments()
  {
      final  ref = FirebaseDatabase.instance.ref(id);
      ref.child('comments').onValue.listen((DatabaseEvent event) {
      try {
        comments.clear();
        for (final child in event.snapshot.children) {
          final jsonMap = json.decode(child.value.toString());
          comments.add(jsonMap);
        }
        comments = comments.reversed.toList();
        notifyListeners();
      } catch (e) {
        print(e);
      }
    });
  }

  List<User> users = [];
  void getAllChannelUsers()
  {
    final  ref = FirebaseDatabase.instance.ref(id);
      ref.child('channelusers').onValue.listen((DatabaseEvent event) {
        try {
          users.clear();
          for (final child in event.snapshot.children) {
            final jsonMap = json.decode(child.value.toString());
            users.add(User.fromJson(jsonMap));
          }
          users = users.reversed.toList();
          notifyListeners();
        } catch (e) {
          print(e);
        }
      });
  }

  String imageLink='';
  String videoKey='';
  VideoPlayerController? videoPlayerController;
  bool showVideo = false;
  bool showImage = false;
  String? id;

  void checkVideo() async{

   // Fluttertoast.showToast(msg: 'from check video');
    if (!videoPlayerController!.value.isPlaying&&videoPlayerController!.value.duration.compareTo(videoPlayerController!.value.position)!=1) {
        try {
          showVideo = false;
          videoPlayerController!.removeListener(checkVideo);
          await videoPlayerController!.pause();
          await videoPlayerController!.dispose();
          videoPlayerController=null;
          await removeFullScreenGiftChild();
          notifyListeners();
        } catch (e) {
          print(e.toString());
        };

    }

  }

  void setId(String iid)
  {
    id = iid;
  }

  Future removeFullScreenGiftChild() async
  {
   // Fluttertoast.showToast(msg: 'from remove full screen child ');
    final  ref = FirebaseDatabase.instance.ref(id);
    final removeingKey = videoKey;
    videoKey = '';
    await ref.child('fullscreenvideo').child(removeingKey).remove();
    notifyListeners();
  }


  Future<bool> started() async {

   // Fluttertoast.showToast(msg: 'video started ');
    if(!videoPlayerController!.value.isInitialized)
    {
      await videoPlayerController!.initialize();
      await videoPlayerController!.play();
      notifyListeners();
     // Fluttertoast.showToast(msg: 'video started ');
    }

    return true;
  }



  Future removeVideoController()async
  {
    videoPlayerController!.removeListener(checkVideo);
    await videoPlayerController!.pause();
    await videoPlayerController!.dispose();
    videoPlayerController=null;
   // Fluttertoast.showToast(msg: 'video controller removed');
    notifyListeners();
  }



  void getAllFullScreenGifts(DateTime joinTime)
  {
    final  ref = FirebaseDatabase.instance.ref(id);
    ref.child('fullscreenvideo').onValue.listen((DatabaseEvent event)   async {
      try {
        final jsonMap = jsonDecode(event.snapshot.children.first.value.toString());
          // Fluttertoast.showToast(msg: jsonMap['video'].toString());
        if(videoKey=='')
        {
         // Fluttertoast.showToast(msg: 'video key not == '' ');
          if(jsonMap['video']!=null)
          {
            if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 || DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0)
            {


                videoPlayerController = VideoPlayerController.network(
                    jsonMap['video'].toString(),
                    videoPlayerOptions: VideoPlayerOptions(
                      mixWithOthers: true,
                    )
                );

                showVideo=true;
               // Fluttertoast.showToast(msg: 'show video true ');
                videoKey = event.snapshot.children.first.key??'';
                videoPlayerController!.addListener(checkVideo);
                notifyListeners();

            }

          }else {
            if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 ||
                DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0)
            {
              imageLink = jsonMap['image'];
                showImage = true;
                videoKey = event.snapshot.children.first.key??'';
              notifyListeners();

              final removingKey = videoKey;

              Future.delayed(Duration(seconds: 10)).then((value) {
                showImage = false;
                ref.child('fullscreenvideo').child(removingKey).remove();
                videoKey = '';
                notifyListeners();
              });


            }
          }

        }


      } catch (e) {
        print(e);
      }
    });

  }
  String textToShow = '';
  String? srcImage;
  List<Map<dynamic, dynamic>> globalText = [];

  void getGlobalText(DateTime joinTime)
  {

    FirebaseDatabase.instance
        .ref('globalText')
        .onValue
        .listen((DatabaseEvent event) {
      try {
        for (final child in event.snapshot.children) {
          // convert text we recieve to json
          final jsonMap = json.decode(child.value.toString());

          if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 ||
              DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0) {
            // save data to text
            var text = {
              'sender': jsonMap['sender'],
              'reciever': jsonMap['reciever'],
              'key': child.key.toString(),
            };

            // check if our new map is in our list
            if (!globalText.contains(text)) {
              // add text to our list
              globalText.add(text);

              // show the message
                srcImage = jsonMap['image'];
                textToShow = '${globalText.last['sender']} ' + 'has sent a gift to '.tr + '${globalText.last['reciever']}';
                notifyListeners();
              // hide message after we done
              Timer(Duration(seconds: 20), () {
                  textToShow = '';
                  FirebaseDatabase.instance.ref('globalText').child(child.key.toString()).remove();
                  notifyListeners();
              });
            }
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

}