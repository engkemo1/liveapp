import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart' as storage;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stars_live/models/singl_user_model.dart';
import 'package:stars_live/providers/gifts_provider.dart';
import 'package:stars_live/widgets/custom_widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import '../../global/constants.dart';
import '../../models/user_model.dart';
import '../../providers/lives_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/diohelper.dart';
import '../../widgets/camera_off_screen.dart';
import '../../widgets/comments_list.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/gifts_dialog.dart';
import '../../widgets/gredient_send_icon.dart';
import '../../widgets/text_form_field.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

import '../../widgets/top_bar_widget.dart';

class Audiance extends StatefulWidget {
  static String id = '/audianceScreen';

  const Audiance({Key? key}) : super(key: key);

  @override
  _AudianceState createState() => _AudianceState();
}

class _AudianceState extends State<Audiance>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  RtcEngine? _engine;
  TextEditingController controller = TextEditingController();
  DatabaseReference? ref;
  List<Map<dynamic, dynamic>> comments = [];
  List<User> users = [];
  bool showComments = true;
  final arguments = Get.arguments;
  bool firstTime = true;
  String? key;
  DateTime joinTime = DateTime.now();

  AnimationController? _animationController;
  Animation<Offset>? _animation;

  // show video or image flags
  bool showVideo = false;
  bool showImage = false;
  String videoKey = '';
  String? imageLink;

  // video and image links variables
  List<Map<dynamic, dynamic>> images = [];
  List<Map<dynamic, dynamic>> videos = [];
  List<Map<dynamic, dynamic>> globalText = [];

  // text to show
  String textToShow = '';
  String? srcImage;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state.name);
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) if (!resetBefor)
      resetData('from did change state');

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() async {
    if (!resetBefor) resetData('from dispose');
    Wakelock.disable();
    _engine?.destroy();
    super.dispose();
  }

  void checkVideo() async {
    // Fluttertoast.showToast(msg: 'is playing '+videoPlayerController!.value.isPlaying.toString());
    // Fluttertoast.showToast(msg: 'position  '+videoPlayerController!.value.position.toString());
    // Fluttertoast.showToast(msg: 'duration  '+videoPlayerController!.value.duration.toString());

    if (!videoPlayerController!.value.isPlaying &&
        videoPlayerController!.value.duration
                .compareTo(videoPlayerController!.value.position) !=
            1) {
      setState(() async {
        try {
          // Fluttertoast.showToast(msg: ' check video called');
          showVideo = false;
          videoPlayerController!.removeListener(checkVideo);
          await videoPlayerController!.pause();
          await videoPlayerController!.dispose();
          videoPlayerController = null;
          // Fluttertoast.showToast(msg: 'key is '+videoKey);
          final removeingKey = videoKey;
          videoKey = '';
          await ref?.child('fullscreenvideo').child(removeingKey).remove();
          //   Fluttertoast.showToast(msg: ' video was disposed from check video');
        } catch (e) {
          //     Fluttertoast.showToast(msg: e.toString());
        }
        // Fluttertoast.showToast(msg: 'from video is not playing');
        //firstTimeForVideo=false;
        //video = {};
      });
    }
  }

  bool resetBefor = false;
  VideoPlayerController? videoPlayerController;

  resetData(String fromWho) async {
    if (!resetBefor) {
      firstTime = true;
      if (videoPlayerController != null &&
          videoPlayerController!.value.isInitialized)
        await videoPlayerController!.dispose();
      resetBefor = true;
      _animationController!..stop();
      // Fluttertoast.showToast(msg: fromWho);
      // when user leaving we clear him from users
      await ref?.child('channelusers/${key.toString()}').remove();
    }
  }

  alertDialog(BuildContext context) {
    // This is the ok button
    Widget ok = InkWell(
      child: Text("Okay"),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
    // show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("I am Here!"),
          content: Text("I appeared because you pressed the button!"),
          actions: [
            ok,
          ],
          elevation: 5,
        );
      },
    );
  }

  setupnotificaitons() async {
    await Firebase.initializeApp();
    var token = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onMessage.listen((notification) {
      log(notification.toString());
      alertDialog(context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((notification) {
      log(notification.toString());
      alertDialog(context);
    });
  }

  // Initialize the Agora Engine
  @override
  void initState() {
    super.initState();
    setupnotificaitons();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
    _animation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(.5, 0))
        .animate(CurvedAnimation(
            parent: _animationController!.view, curve: Curves.easeIn));

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      ref = FirebaseDatabase.instance.ref(arguments['id'].toString());
      Wakelock.enable();

      generateTokenAndInitAgora();

      // get all comments
      if (ref != null)
        ref!.child('comments').onValue.listen((DatabaseEvent event) {
          try {
            comments.clear();
            for (final child in event.snapshot.children) {
              final jsonMap = json.decode(child.value.toString());
              if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 ||
                  DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0) {
                comments.add(jsonMap);
              }
            }
            setState(() {});
            comments = comments.reversed.toList();
          } catch (e) {
            log(e.toString());
          }
        });

      // get all users to show images
      if (ref != null)
        ref!.child('channelusers').onValue.listen((DatabaseEvent event) {
          try {
            users.clear();
            for (final child in event.snapshot.children) {
              final jsonMap = json.decode(child.value.toString());
              users.add(User.fromJson(jsonMap));
            }
            setState(() {});
            users = users.reversed.toList();
          } catch (e) {
            log(e.toString());
          }
        });

      // get all full screen videos to show images
      if (ref != null)
        ref!.child('fullscreenvideo').onValue.listen((DatabaseEvent event) {
          try {
            final jsonMap =
                jsonDecode(event.snapshot.children.first.value.toString());
            // Fluttertoast.showToast(msg: jsonMap['video'].toString());
            if (videoKey == '') {
              if (jsonMap['video'] != null) {
                if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 ||
                    DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0) {
                  //COMNT: here listen to firebase comments and full screen video

                  var giftProvider =
                      Provider.of<GiftsProvider>(context, listen: false);

                  var gift =
                      giftProvider.getGiftById(int.parse(jsonMap['giftID']));

                  if (gift.cachedVidPath != null &&
                      gift.cachedVidPath!.isNotEmpty) {
                    log('video come from cached file');

                    setState(() {
                      videoPlayerController =
                          VideoPlayerController.file(File(gift.cachedVidPath!),
                              videoPlayerOptions: VideoPlayerOptions(
                                mixWithOthers: true,
                              ));

                      showVideo = true;
                      firstTimeForVideo = true;
                      videoKey = event.snapshot.children.first.key ?? '';
                      //  Fluttertoast.showToast(msg: 'key from init is '+videoKey);
                      videoPlayerController!.addListener(checkVideo);
                    });
                  } else {
                    log('video come from api');

                    setState(() {
                      videoPlayerController = VideoPlayerController.network(
                          jsonMap['video'].toString(),
                          videoPlayerOptions: VideoPlayerOptions(
                            mixWithOthers: true,
                          ));

                      showVideo = true;
                      firstTimeForVideo = true;
                      videoKey = event.snapshot.children.first.key ?? '';
                      //  Fluttertoast.showToast(msg: 'key from init is '+videoKey);
                      videoPlayerController!.addListener(checkVideo);
                    });
                  }
                }
              } else {
                if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 ||
                    DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0) {
                  imageLink = jsonMap['image'];
                  setState(() {
                    showImage = true;
                    videoKey = event.snapshot.children.first.key ?? '';
                  });

                  final removingKey = videoKey;

                  Future.delayed(Duration(seconds: 10))
                      .then((value) => setState(() {
                            showImage = false;
                            ref
                                ?.child('fullscreenvideo')
                                .child(removingKey)
                                .remove();
                            videoKey = '';
                          }));
                }
              }
            }
          } catch (e) {
            log(e.toString());
          }
        });

      // get all global text videos to show images
      if (ref != null)
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
                  setState(() {
                    srcImage = jsonMap['image'];
                    textToShow = '${globalText.last['sender']} ' +
                        'has sent a gift to '.tr +
                        '${globalText.last['reciever']}';
                  });

                  // hide message after we done
                  Timer(Duration(seconds: 20), () {
                    setState(() {
                      textToShow = '';
                    });
                  });
                }
              }
            }
          } catch (e) {
            log(e.toString());
          }
        });
    });
  }

  bool firstTimeForVideo = false;

  Future<bool> started() async {
    if (!videoPlayerController!.value.isInitialized) {
      // Fluttertoast.showToast(msg: 'from started');
      await videoPlayerController!.initialize();
      await videoPlayerController!.play();

      //  Fluttertoast.showToast(msg: ' video was initialized');
      // firstTimeForVideo = false;
    }

    return true;
  }

  List<int> _users = [];
  bool cameraOff = false;

  void generateTokenAndInitAgora() async {
    var token = storage.GetStorage().read('api');
    log('user token  ${token}');
    try {
      await DioHelper.setData(
        path: 'agora/delete_token',
        data: null,
        auth: 'Bearer ' + token!,
      );

      final res = await DioHelper.setData(
        path: 'agora/create_token',
        data: {
          "channelName": Get.arguments['channel'].toString(),
        },
        auth: 'Bearer ' + token!,
      );

      log('channel name   ${Get.arguments['channel'].toString()}');
      log('token   ${token.toString()}');
      log('token data   ${res.data['data']['live_token']}');
      await _initAgoraRtcEngine();
      //print('uid '+res.data['uid'].toString());
      setState(() {
        Data? currentUser = context.read<UserProvider>().userData?.data?.first;
        _engine?.setEventHandler(RtcEngineEventHandler(
          connectionLost: () {
            Get.defaultDialog(
              title: 'connection lost',
              middleText: 'connection lost',
              confirm: TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: Text('Ok'),
              ),
            );
          },
          connectionStateChanged: (ConnectionStateType _connection,
              ConnectionChangedReason _reason) {
            log('state : ${_connection.name}');
            log('reason : ${_reason.name}');
          },
          remoteVideoStateChanged: (_, state, x, y) {
            // Fluttertoast.showToast(msg: state.name);
            setState(() {
              if (state.name != 'Stopped')
                cameraOff = false;
              else
                cameraOff = true;
            });
          },
          joinChannelSuccess: (channel, uid, elapsed) {
            setState(() {
              //  Fluttertoast.showToast(msg: 'joined');
              if (firstTime) {
                // Fluttertoast.showToast(msg: currentUser!.name??'no name');
                // create new user in channel users
                DatabaseReference addNewUser =
                    ref!.child('channelusers').push();

                // set the user to the channel users
                addNewUser.set(json.encode(currentUser!.toJson()));
                key = addNewUser.key;
                log('new user key ' + (key ?? 'not found '));

                firstTime = false;
                DatabaseReference newComment = ref!.child('comments').push();
                newComment.set(json.encode({
                  'id': currentUser.id,
                  'type': 'COMMENT',
                  'comment': 'joined live'.tr,
                  'name': currentUser.name,
                  'email': currentUser.email,
                  'level': currentUser.levelUser?.level,
                  'time': DateTime.now().toString(),
                  'user': currentUser.toJson(),
                }));
              }
            });
          },
          leaveChannel: (stats) {
            setState(() {
              // Fluttertoast.showToast(msg: 'leaved');
              print('onLeaveChannel');
              _users.clear();
            });
          },
          userJoined: (uid, elapsed) {
            log('user joined to stream ${uid} : ${elapsed} ');
            setState(() {
              log('userJoined: $uid');
              // Fluttertoast.showToast(msg: 'from user joined' + uid.toString());
              _users.add(uid);
            });
          },
          userOffline: (uid, elapsed) {
            setState(() {
              _users.remove(uid);
              //get all live users first
              Provider.of<LivesProvider>(context, listen: false).getLiveUsers();
              // show message that user is not live and get user back
              Navigator.pop(context);
              /*  Get.defaultDialog(
                title: 'Live Ended',
                middleText: 'User Has Ended Video You Will Left',
                confirm: TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text('Ok'),
                ),
              ); */
            });
          },
          streamMessage: (_, __, message) {
            final String info = "here is the message $message";
            log(info);
          },
          streamMessageError: (_, __, error, ___, ____) {
            final String info = "here is the error $error";
            log(info);
          },
        ));

        _engine?.joinChannel(res.data['data']['live_token'],
            arguments['channel'], null, currentUser!.id ?? 0, null);
      });
    } catch (e) {
      // Fluttertoast.showToast(msg: e.toString());

      log(e.toString());
      _engine.printError();
    }
  }

  Future<void> _initAgoraRtcEngine() async {
    log('engine before create' + _engine.toString());

    _engine = await RtcEngine.create(agoraAppID);
    log('engine after create' + _engine.toString());

    await _engine?.enableVideo();
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine?.setClientRole(ClientRole.Audience);
    log('engine after set role' + _engine.toString());
  }

  @override
  Widget build(BuildContext context) {
    Data? user = context.read<UserProvider>().userData?.data?.first;
    log('engine in build' + _engine.toString());
    log('users ' + _users.toString());
    // print(ref.toString());

    return WillPopScope(
      onWillPop: () async {
        bool result = false;
        Get.defaultDialog(
          middleText: 'Are You Sure To Exit From Live ?'.tr,
          title: 'Exit'.tr,
          confirm: TextButton(
            onPressed: () {
              if (!resetBefor) resetData('from will pop scope');
              Get.back();
              Get.back();
              result = true;
            },
            child: Text(
              'Leave'.tr,
            ),
          ),
          cancel: TextButton(
            onPressed: () {
              Get.back();
              result = false;
            },
            child: Text(
              'Stay'.tr,
            ),
          ),
        );
        return result;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _engine == null || ref == null
              ? Container(
                  color: Colors.transparent,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : KeyboardDismissOnTap(
                  dismissOnCapturedTaps: false,
                  child: Stack(
                    children: [
                      _users.length != 0
                          ? !cameraOff
                              ? RtcRemoteView.SurfaceView(
                                  uid: _users.first,
                                )
                              : CameraOff()
                          : CameraOff(),
                      Container(
                        color: Colors.transparent,
                        height: double.maxFinite,
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // top bar
                            TopBarWidget(
                                fromWhere: Audiance.id,
                                recieverID: arguments['id'],
                                users: users,
                                arguments: arguments,
                                onIconPressed: () {
                                  if (!resetBefor)
                                    Get.defaultDialog(
                                      middleText:
                                          'Are You Sure To Exit From Live ?'.tr,
                                      title: 'Exit'.tr,
                                      confirm: TextButton(
                                        onPressed: () {
                                          if (!resetBefor)
                                            resetData(
                                                'from back icon on top bar');
                                          Get.back();
                                          Get.back();
                                        },
                                        child: Text(
                                          'Leave'.tr,
                                        ),
                                      ),
                                      cancel: TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'Stay'.tr,
                                        ),
                                      ),
                                    );
                                  /*   resetData('from back icon on top bar');
                                  Get.back(); */
                                },
                                onBlockHost: () {
                                  if (!resetBefor)
                                    resetData('from back icon on top bar');
                                  Get.back();
                                  Get.back();
                                }),
                            Spacer(),
                            // comments List
                            CommentsList(
                              comments: comments,
                              recieverID: arguments['id'],
                            ),

                            // comments and gifts area
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.bottomSheet(
                                      GiftsDialog(
                                        toWhome: arguments['name'],
                                        user: User.fromJson(user!.toJson()),
                                        show: true,
                                        recieverID: arguments['id'],
                                      ),
                                    );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.gift,
                                    color: Colors.orange[300],
                                  ),
                                ),
                                Expanded(
                                  child: CustomContainer(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius:
                                          BorderRadiusDirectional.only(
                                        bottomStart: Radius.circular(13.0),
                                        topStart: Radius.circular(13.0),
                                      ),
                                    ),
                                    child: textField(
                                      hint: "type a comment".tr,
                                      maxCharacters: 90,
                                      controller: controller,
                                      textInputAction: TextInputAction.send,
                                      onSubmit: (String) async {
                                        if (Provider.of<UserProvider>(context,
                                                listen: false)
                                            .userData!
                                            .data!
                                            .first
                                            .isCommentBaned!) {
                                          customSnackBar(
                                              context: context,
                                              text: 'you are baned for'.tr +
                                                  ' ' +
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .userData!
                                                      .data!
                                                      .first
                                                      .commentBanDuration!
                                                      .toString() +
                                                  ' ' +
                                                  'hour'.tr +
                                                  ' ' +
                                                  'from sending comments'.tr);
                                        } else {
                                          if (controller.text.isNotEmpty) {
                                            DatabaseReference newComment =
                                                ref!.child('comments').push();
                                            await newComment.set(json.encode({
                                              'id': user!.id,
                                              'type': 'COMMENT',
                                              'comment': controller.text,
                                              'name': user.name,
                                              'email': user.email,
                                              'level': user.levelUser?.level,
                                              'time': DateTime.now().toString(),
                                              'user': user.toJson(),
                                            }));
                                            controller.clear();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                CustomContainer(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadiusDirectional.only(
                                      bottomEnd: Radius.circular(13.0),
                                      topEnd: Radius.circular(13.0),
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      if (Provider.of<UserProvider>(context,
                                              listen: false)
                                          .userData!
                                          .data!
                                          .first
                                          .isCommentBaned!) {
                                        customSnackBar(
                                            context: context,
                                            text: 'you are baned for'.tr +
                                                ' ' +
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .userData!
                                                    .data!
                                                    .first
                                                    .commentBanDuration!
                                                    .toString() +
                                                ' ' +
                                                'hour'.tr +
                                                ' ' +
                                                'from sending comments'.tr);
                                      } else {
                                        if (controller.text.isNotEmpty) {
                                          DatabaseReference newComment =
                                              ref!.child('comments').push();
                                          await newComment.set(json.encode({
                                            'id': user!.id,
                                            'type': 'COMMENT',
                                            'comment': controller.text,
                                            'name': user.name,
                                            'email': user.email,
                                            'level': user.levelUser?.level,
                                            'time': DateTime.now().toString(),
                                            'user': user.toJson(),
                                          }));
                                          controller.clear();
                                        }
                                      }
                                    },
                                    child: RadiantGradientMask(
                                      child: Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Timer _timer;
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext builderContext) {
                                          _timer = Timer(Duration(seconds: 10), () {
                                            Navigator.of(context).pop();    // == First dialog closed
                                          });

                                          return AlertDialog(
                                            content: SingleChildScrollView(
                                              child: Text('waiting for approval'.tr),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context,),
                                                child:  Text('Exit'.tr),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                 child: Icon(Icons.group_add,color: Colors.white,),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      if (showImage)
                        Center(
                            child: Image.network(
                          imageLink!,
                          width: double.maxFinite,
                          height: Get.height,
                        )),
                      if (showVideo)
                        Center(
                          child: FutureBuilder<bool>(
                            future: started(),
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (snapshot.data == true) {
                                return AspectRatio(
                                  aspectRatio: 9 / 12,
                                  child: VideoPlayer(videoPlayerController!),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      if (textToShow.isNotEmpty)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              gradient: GRADIENT,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            width: double.maxFinite,
                            height: 30,
                            // padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(top: 70),
                            child: SlideTransition(
                              position: _animation!,
                              child: Row(
                                children: [
                                  Text(
                                    textToShow,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (srcImage != null)
                                    Image.network(
                                      srcImage ?? '',
                                      width: 20,
                                      height: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:stars_live/models/singl_user_model.dart';
// import 'package:stars_live/providers/broadcast_audience_provider.dart';
// import 'package:stars_live/utils/diohelper.dart';
// import 'package:stars_live/widgets/camera_off_screen.dart';
// import 'package:stars_live/widgets/comments_list.dart';
// import 'package:stars_live/widgets/gifts_dialog.dart';
// import 'package:stars_live/widgets/top_bar_widget.dart';
// import 'package:video_player/video_player.dart';
// import 'package:wakelock/wakelock.dart';
// import '../../global/constants.dart';
// import '../../models/user_model.dart';
// import '../../providers/lives_provider.dart';
// import '../../providers/user_provider.dart';
// import '../../widgets/custom_container.dart';
// import '../../widgets/gredient_send_icon.dart';
// import '../../widgets/text_form_field.dart';
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
//
// class Audiance extends StatefulWidget {
//   static String id = '/audianceScreen';
//
//   const Audiance({Key? key}) : super(key: key);
//
//   @override
//   _AudianceState createState() => _AudianceState();
// }
//
// class _AudianceState extends State<Audiance> with WidgetsBindingObserver,SingleTickerProviderStateMixin {
//   RtcEngine? _engine;
//   TextEditingController controller = TextEditingController();
//   DatabaseReference? ref;
//   List<Map<dynamic, dynamic>> comments = [];
//   List<User> users = [];
//   bool showComments = true;
//   final arguments = Get.arguments;
//   bool firstTime = true;
//   String? key;
//   DateTime joinTime = DateTime.now();
//
//
//   AnimationController? _animationController;
//   Animation<Offset>? _animation;
//
//   // show video or image flags
//   bool showVideo = false;
//   bool showImage = false;
//   String videoKey = '';
//   String? imageLink;
//
//   // video and image links variables
//   List<Map<dynamic, dynamic>> images = [];
//   List<Map<dynamic, dynamic>> videos = [];
//   List<Map<dynamic, dynamic>> globalText = [];
//
//   // text to show
//   String textToShow = '';
//   String? srcImage;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     print(state.name);
//     if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive)
//       if(!resetBefor) resetData('from did change state');
//
//     super.didChangeAppLifecycleState(state);
//   }
//
//   @override
//   void dispose() async {
//     if(!resetBefor)resetData('from dispose');
//     Wakelock.disable();
//     _engine?.destroy();
//     super.dispose();
//   }
//
//   void checkVideo() async{
//
//     // Fluttertoast.showToast(msg: 'is playing '+videoPlayerController!.value.isPlaying.toString());
//     // Fluttertoast.showToast(msg: 'position  '+videoPlayerController!.value.position.toString());
//     // Fluttertoast.showToast(msg: 'duration  '+videoPlayerController!.value.duration.toString());
//
//     if (!videoPlayerController!.value.isPlaying&&videoPlayerController!.value.duration.compareTo(videoPlayerController!.value.position)!=1) {
//       setState(() async {
//         try {
//          // Fluttertoast.showToast(msg: ' check video called');
//           showVideo = false;
//           videoPlayerController!.removeListener(checkVideo);
//           await videoPlayerController!.pause();
//           await videoPlayerController!.dispose();
//           videoPlayerController=null;
//          // Fluttertoast.showToast(msg: 'key is '+videoKey);
//           final removeingKey = videoKey;
//           videoKey = '';
//           await ref?.child('fullscreenvideo').child(removeingKey).remove();
//        //   Fluttertoast.showToast(msg: ' video was disposed from check video');
//         } catch (e) {
//      //     Fluttertoast.showToast(msg: e.toString());
//         }
//        // Fluttertoast.showToast(msg: 'from video is not playing');
//         //firstTimeForVideo=false;
//         //video = {};
//       });
//     }
//
//   }
//
//
//
//   bool resetBefor = false ;
//   VideoPlayerController? videoPlayerController ;
//
//   resetData(String fromWho) async {
//
//     if(!resetBefor)
//       {
//         firstTime = true;
//         if(videoPlayerController!=null&&videoPlayerController!.value.isInitialized)
//           await videoPlayerController!.dispose();
//         resetBefor=true;
//         _animationController!..stop();
//        // Fluttertoast.showToast(msg: fromWho);
//         // when user leaving we clear him from users
//         await ref?.child('channelusers/${key.toString()}').remove();
//
//       }
//
//   }
//
//   // Initialize the Agora Engine
//   @override
//   void initState() {
//     super.initState();
//
//     _animationController = AnimationController(vsync: this,duration: Duration(seconds: 5),)..repeat();
//     _animation = Tween<Offset>(begin: Offset(-1,0),end: Offset(.5,0)).animate(CurvedAnimation(parent: _animationController!.view, curve:Curves.easeIn ));
//
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
//       ref = FirebaseDatabase.instance.ref(arguments['id'].toString());
//       Wakelock.enable();
//
//       generateTokenAndInitAgora();
//
//
//       // get all comments
//       if (ref != null)
//         ref!.child('comments').onValue.listen((DatabaseEvent event) {
//           try {
//             comments.clear();
//             for (final child in event.snapshot.children) {
//               final jsonMap = json.decode(child.value.toString());
//               if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 ||
//                   DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0) {
//                 comments.add(jsonMap);
//               }
//             }
//             setState(() {});
//             comments = comments.reversed.toList();
//           } catch (e) {
//             print(e);
//           }
//         });
//
//       // get all users to show images
//       if (ref != null)
//         ref!.child('channelusers').onValue.listen((DatabaseEvent event) {
//           try {
//             users.clear();
//             for (final child in event.snapshot.children) {
//               final jsonMap = json.decode(child.value.toString());
//               users.add(User.fromJson(jsonMap));
//             }
//             setState(() {});
//             users = users.reversed.toList();
//           } catch (e) {
//             print(e);
//           }
//         });
//
//       // get all full screen videos to show images
//       if (ref != null)
//         ref!.child('fullscreenvideo').onValue.listen((DatabaseEvent event)   {
//           try {
//             final jsonMap = jsonDecode(event.snapshot.children.first.value.toString());
//            // Fluttertoast.showToast(msg: jsonMap['video'].toString());
//             if(videoKey=='')
//             {
//               if(jsonMap['video']!=null)
//               {
//                 if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 || DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0)
//                 {
//
//                   setState(() {
//                     videoPlayerController = VideoPlayerController.network(
//                         jsonMap['video'].toString(),
//                         videoPlayerOptions: VideoPlayerOptions(
//                           mixWithOthers: true,
//                         )
//                     );
//
//                     showVideo=true;
//
//                     videoKey = event.snapshot.children.first.key??'';
//                   //  Fluttertoast.showToast(msg: 'key from init is '+videoKey);
//                     videoPlayerController!.addListener(checkVideo);
//                   });
//
//                 }
//
//               }else {
//                 if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 ||
//                     DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0)
//                 {
//                   imageLink = jsonMap['image'];
//                   setState(() {
//                     showImage = true;
//                     videoKey = event.snapshot.children.first.key??'';
//                   });
//
//                   final removingKey = videoKey;
//
//                   Future.delayed(Duration(seconds: 10)).then((value) => setState((){
//                     showImage = false;
//                     ref?.child('fullscreenvideo').child(removingKey).remove();
//                     videoKey='';}
//                   ));
//
//                 }
//               }
//
//             }
//
//
//           } catch (e) {
//             print(e);
//           }
//         });
//
//       // get all global text videos to show images
//       if (ref != null)
//         FirebaseDatabase.instance
//             .ref('globalText')
//             .onValue
//             .listen((DatabaseEvent event) {
//           try {
//             for (final child in event.snapshot.children) {
//               // convert text we recieve to json
//               final jsonMap = json.decode(child.value.toString());
//
//               if (DateTime.parse(jsonMap['time']).compareTo(joinTime) == 1 ||
//                   DateTime.parse(jsonMap['time']).compareTo(joinTime) == 0) {
//                 // save data to text
//                 var text = {
//                   'sender': jsonMap['sender'],
//                   'reciever': jsonMap['reciever'],
//                   'key': child.key.toString(),
//                 };
//
//                 // check if our new map is in our list
//                 if (!globalText.contains(text)) {
//                   // add text to our list
//                   globalText.add(text);
//
//                   // show the message
//                   setState(() {
//                     srcImage = jsonMap['image'];
//                     textToShow =
//                         '${globalText.last['sender']} ' + 'has sent a gift to '.tr + '${globalText.last['reciever']}'; });
//
//                   // hide message after we done
//                   Timer(Duration(seconds: 20), () {
//                     setState(() {
//                       textToShow = '';
//                     });
//                   });
//                 }
//               }
//             }
//           } catch (e) {
//             print(e);
//           }
//         });
//     });
//   }
//
//
//
//   List<int> _users=[];
//   bool cameraOff= false;
//
//   void generateTokenAndInitAgora() async {
//     try {
//       await DioHelper.setData(path: 'agora/delete_token', data: null,auth: 'Bearer '+ myApiToken!);
//
//       final res = await DioHelper.setData(path: 'agora/create_token', data:{
//         "channelName": Get.arguments['channel'].toString(),
//       },
//         auth: 'Bearer '+ myApiToken!,
//       );
//
//      await _initAgoraRtcEngine();
//       //print('uid '+res.data['uid'].toString());
//       setState(()   {
//         Data? currentUser =
//             context.read<UserProvider>().userData?.data?.first;
//         _engine?.setEventHandler(RtcEngineEventHandler(
//
//
//           remoteVideoStateChanged: (_,state,x,y){
//          // Fluttertoast.showToast(msg: state.name);
//             setState(() {
//               if(state.name!='Stopped')
//                 cameraOff=false;
//               else
//                 cameraOff =true;
//             });
//           },
//           joinChannelSuccess: (channel, uid, elapsed)  {
//                 setState(() {
//                 //  Fluttertoast.showToast(msg: 'joined');
//                   if (firstTime) {
//
//
//                     // Fluttertoast.showToast(msg: currentUser!.name??'no name');
//                     // create new user in channel users
//                     DatabaseReference addNewUser =
//                     ref!.child('channelusers').push();
//
//                     // set the user to the channel users
//                     addNewUser.set(json.encode(currentUser!.toJson()));
//
//                     key = addNewUser.key;
//                     print('new user key ' + (key ?? 'not found '));
//                     firstTime = false;
//                   }
//                 });
//           },
//
//           leaveChannel: (stats) {
//             setState(() {
//              // Fluttertoast.showToast(msg: 'leaved');
//               print('onLeaveChannel');
//               _users.clear();
//             });
//           },
//
//           userJoined: (uid, elapsed) {
//             setState(() {
//               print('userJoined: $uid');
//              // Fluttertoast.showToast(msg:'from user joined'+ uid.toString());
//               _users.add(uid);
//             });
//           },
//
//           userOffline: (uid, elapsed) {
//             setState(() {
//               _users.remove(uid);
//               //get all live users first
//                     Provider.of<LivesProvider>(context, listen: false).getLiveUsers();
//                     // show message that user is not live and get user back
//                     Get.defaultDialog(
//                       title: 'Live Ended',
//                       middleText: 'User Has Ended Video You Will Left',
//                       confirm: TextButton(
//                         onPressed: () {
//                           Get.back();
//                           Get.back();
//                         },
//                         child: Text('Ok'),
//                       ),
//                     );
//             });
//           },
//           streamMessage: (_, __, message) {
//             final String info = "here is the message $message";
//             print(info);
//           },
//           streamMessageError: (_, __, error, ___, ____) {
//             final String info = "here is the error $error";
//             print(info);
//           },
//         ));
//         _engine?.joinChannel(res.data['data']['live_token'], arguments['channel'],null, currentUser!.id??0,null);
//
//       });
//
//
//     } catch (e) {
//      // Fluttertoast.showToast(msg: e.toString());
//
//       print('errorrrrrrrrrrrrrrrrrrrrrrrrrr :'+e.toString());
//       _engine.printError();
//
//     }
//   }
//
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(agoraAppID);
//     await _engine?.enableVideo();
//     await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await _engine?.setClientRole(ClientRole.Audience);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     Data? user = context.read<UserProvider>().userData?.data?.first;
//     print('engine '+ _engine.toString());
//     print(ref.toString());
//     print('users '+_users.toString());
//
//    // Fluttertoast.showToast(msg: _users.length.toString());
//
//     return WillPopScope(
//       onWillPop: () async {
//         bool result = false;
//         Get.defaultDialog(
//           middleText: 'Are You Sure To Exit From Live ?'.tr,
//           title: 'Exit'.tr,
//           confirm: TextButton(
//             onPressed: () {
//               if(!resetBefor)resetData('from will pop scope');
//               Get.back();
//               Get.back();
//               result = true;
//             },
//             child: Text(
//               'Leave'.tr,
//             ),
//           ),
//           cancel: TextButton(
//             onPressed: () {
//               Get.back();
//               result = false;
//             },
//             child: Text(
//               'Stay'.tr,
//             ),
//           ),
//         );
//         return result;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: _engine == null || ref == null
//               ? Container(
//                   color: Colors.transparent,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 )
//               : KeyboardDismissOnTap(
//                   dismissOnCapturedTaps: true,
//                   child: Stack(
//                     children: [
//                       _users.length!=0?!cameraOff?RtcRemoteView.SurfaceView(uid:_users.first,):CameraOff():CameraOff(),
//                       Container(
//                         color: Colors.transparent,
//                         height: double.maxFinite,
//                         width: double.maxFinite,
//                         padding: const EdgeInsets.all(10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             // top bar
//                             TopBarWidget(
//                               fromWhere: Audiance.id,
//                               recieverID: arguments['id'],
//                               users: users,
//                               arguments: arguments,
//                               onIconPressed: () {
//                                 if(!resetBefor)resetData('from back icon on top bar');
//                                 Get.back();
//                               },
//                             ),
//                             Spacer(),
//                             // comments List
//                             CommentsList(
//                               comments: comments,
//                               recieverID: arguments['id'],
//                             ),
//
//                             // comments and gifts area
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   onPressed: () {
//                                     Get.bottomSheet(
//                                       GiftsDialog(
//                                         toWhome: arguments['name'],
//                                         user: User.fromJson(user!.toJson()),
//                                         show: true,
//                                         recieverID: arguments['id'],
//                                       ),
//                                     );
//                                   },
//                                   icon: FaIcon(
//                                     FontAwesomeIcons.gift,
//                                     color: Colors.orange[300],
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: CustomContainer(
//                                     height: 40,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                       borderRadius: BorderRadiusDirectional.only(
//                                         bottomStart: Radius.circular(13.0),
//                                         topStart: Radius.circular(13.0),
//                                       ),
//                                     ),
//                                     child: textField(
//                                       hint: "type a comment".tr,
//                                       controller: controller,
//                                     ),
//                                   ),
//                                 ),
//                                 CustomContainer(
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey[300],
//                                     borderRadius: BorderRadiusDirectional.only(
//                                       bottomEnd: Radius.circular(13.0),
//                                       topEnd: Radius.circular(13.0),
//                                     ),),
//                                   child: InkWell(
//                                     onTap: () async {
//                                       if (controller.text.isNotEmpty) {
//                                         DatabaseReference newComment =
//                                             ref!.child('comments').push();
//
//                                         await newComment.set(json.encode({
//                                           'id': user!.id,
//                                           'type': 'COMMENT',
//                                           'comment': controller.text,
//                                           'name': user.name,
//                                           'email': user.email,
//                                           'level': user.levelUser?.level,
//                                           'time': DateTime.now().toString(),
//                                           'user': user.toJson(),
//                                         }));
//
//                                         controller.clear();
//                                       }
//                                     },
//                                     child: RadiantGradientMask(
//                                       child: Icon(
//                                         Icons.send,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//
//                       if(context.watch<BroadCastAudienceProvider>().showImage)
//                         Center(child: Image.network(context.watch<BroadCastAudienceProvider>().imageLink,width: double.maxFinite,height: Get.height,)),
//
//                       if(context.watch<BroadCastAudienceProvider>().showVideo)
//                         Center(
//                           child: FutureBuilder<bool>(
//                             future: context.watch<BroadCastAudienceProvider>().started(),
//                             builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//                               if(snapshot.data == true)
//                               {
//                                 return AspectRatio(
//                                   aspectRatio: 9/12,
//                                   child: VideoPlayer(context.watch<BroadCastAudienceProvider>().videoPlayerController!),
//                                 );
//                               } else {
//                                 return  Container();
//                               }
//                             },
//                           ),
//                         ),
//
//                       if (context.watch<BroadCastAudienceProvider>().textToShow.isNotEmpty)
//                         Align(
//                           alignment: Alignment.topCenter,
//                           child: Container(
//                             alignment: Alignment.topLeft,
//                             decoration: BoxDecoration(
//                               gradient: GRADIENT,
//                               borderRadius: BorderRadius.circular(25),
//                             ),
//                             width: double.maxFinite,
//                             height: 30,
//                             // padding: const EdgeInsets.all(5),
//                             margin: const EdgeInsets.only(top: 70),
//                             child: SlideTransition(
//                               position: _animation!,
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     context.watch<BroadCastAudienceProvider>().textToShow,
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 14.sp,
//                                     ),
//                                   ),
//                                   SizedBox(width: 10,),
//                                   if(context.watch<BroadCastAudienceProvider>().srcImage!=null)
//                                     Image.network(context.watch<BroadCastAudienceProvider>().srcImage??'',width: 20,height: 20,),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }
