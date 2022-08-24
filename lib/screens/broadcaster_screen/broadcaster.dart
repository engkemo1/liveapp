import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:async/async.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:get_storage/get_storage.dart' as storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/providers/broadcast_audience_provider.dart';
import 'package:stars_live/utils/diohelper.dart';
import 'package:stars_live/widgets/camera_off_screen.dart';
import 'package:stars_live/widgets/comments_list.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import '../../models/user_model.dart';
import '../../providers/lives_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/gredient_send_icon.dart';
import '../../widgets/text_form_field.dart';
import '../../widgets/top_bar_widget.dart';
import 'widgets/live_choices_bottom_sheet.dart';

class BroadCaster extends StatefulWidget {
  static String id = '/broadcasterScreen';

  const BroadCaster({Key? key}) : super(key: key);

  @override
  _BroadCasterState createState() => _BroadCasterState();
}

class _BroadCasterState extends State<BroadCaster>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  AgoraClient? client;
  RtcEngine? _engine;
  var ref;
  Data? user;
  bool showComments = true;
  final arguments = Get.arguments;
  TextEditingController controller = TextEditingController();
  DateTime joinTime = DateTime.now();
  AnimationController? _animationController;
  Animation<Offset>? _animation;
  Timer? _timer;

  bool inActiveFlag = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state.name);

    if (state == AppLifecycleState.paused) {
      setState(() {
        _timer = Timer(Duration(seconds: 3), () {
          resetData();
        });
      });
    }

    if (state == AppLifecycleState.detached) {
      setState(() {
        _timer = Timer(Duration(seconds: 3), () {
          resetData();
        });
      });
    }
    if (state == AppLifecycleState.resumed) _timer?.cancel();

    super.didChangeAppLifecycleState(state);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(agoraAppID);
    await _engine?.enableVideo();
    await _engine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine?.setClientRole(ClientRole.Broadcaster);
  }

  @override
  void initState() {
    super.initState();
    _initAgoraRtcEngine();
    WidgetsBinding.instance!.addObserver(this);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
    _animation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(.5, 0))
        .animate(CurvedAnimation(
            parent: _animationController!.view, curve: Curves.easeIn));
    user = context.read<UserProvider>().userData?.data?.first;
    context.read<BroadCastAudienceProvider>().setId(user?.id.toString() ?? '');

    // set user data to arguments
    arguments['user'] = user!.toJson();
    arguments['image'] = user!.image;
    arguments['name'] = user!.name;
    arguments['gifts'] = user!.totalReceivedGifts;
    arguments['level'] = user!.levelHost!.level;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Wakelock.enable();
      generateTokenAndInitAgora();
      Data? user = context.read<UserProvider>().userData?.data?.first;
      ref = FirebaseDatabase.instance.ref(user?.id.toString());
      context.read<BroadCastAudienceProvider>().uploadCurrentDiamonds(
          arguments['channel'],
          arguments['user']['total_received_gifts'].toString());
      context.read<BroadCastAudienceProvider>().getAllComments();
      context.read<BroadCastAudienceProvider>().getAllChannelUsers();
      context.read<BroadCastAudienceProvider>().getAllFullScreenGifts(joinTime);
      context.read<BroadCastAudienceProvider>().getGlobalText(joinTime);
    });
  }

  resetData() async {
    var token = storage.GetStorage().read('api');
    log('user token  ${token}');
    try {
      if (context.read<BroadCastAudienceProvider>().videoPlayerController !=
              null &&
          context
              .read<BroadCastAudienceProvider>()
              .videoPlayerController!
              .value
              .isInitialized)
        await context.read<BroadCastAudienceProvider>().removeVideoController();

      WidgetsBinding.instance!.removeObserver(this);
      Wakelock.disable();
      _animationController!..stop();
      await Provider.of<LivesProvider>(context, listen: false).setUserUnLive();
      await ref.remove();
      await client?.sessionController.endCall();
      await DioHelper.setData(
        path: 'agora/delete_token',
        data: null,
        auth: 'Bearer ' + token!,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: 'error from reset ' + e.toString());
      print('error from reset ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

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

      // init agora client
      setState(() {
        client = AgoraClient(
          agoraEventHandlers: AgoraEventHandlers(
            connectionLost: () {
              resetData();
            },
            leaveChannel: (state) {},
            userOffline: (id, reason) {},
          ),
          agoraChannelData: AgoraChannelData(
            clientRole: ClientRole.Broadcaster,
            channelProfile: ChannelProfile.LiveBroadcasting,
          ),
          agoraConnectionData: AgoraConnectionData(
            uid: int.parse(Get.arguments['channel'].toString()),
            appId: agoraAppID,
            channelName: Get.arguments['channel'].toString(),
            tempToken: res.data['data']['live_token'],
          ),
          enabledPermission: [Permission.camera, Permission.microphone],
        );
      });

      await client?.initialize();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool result = false;
        Get.defaultDialog(
          middleText: 'Are You Sure To Exit From Live ?'.tr,
          title: 'Exit'.tr,
          confirm: TextButton(
            onPressed: () async {
              resetData();
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
        body: SafeArea(
          child: client == null || ref == null
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
                      AgoraVideoViewer(
                        disabledVideoWidget: CameraOff(),
                        client: client!,
                        showAVState: true,
                        videoRenderMode: VideoRenderMode.FILL,
                      ),
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
                              fromWhere: BroadCaster.id,
                              recieverID: user!.id,
                              type: user!.type,
                              users: context
                                  .watch<BroadCastAudienceProvider>()
                                  .users,
                              arguments: arguments,
                              onIconPressed: () {
                                Get.defaultDialog(
                                  middleText:
                                      'Are You Sure To Exit From Live ?'.tr,
                                  title: 'Exit'.tr,
                                  confirm: TextButton(
                                    onPressed: () async {
                                      resetData();
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
                                /*   resetData();
                                Get.back(); */
                              },
                            ),
                            Spacer(),
                            // comments List
                            CommentsList(
                              comments: context
                                  .watch<BroadCastAudienceProvider>()
                                  .comments,
                              recieverID: user!.id,
                            ),

                            // comments and gifts area
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  child: Row(children: [
                                    IconButton(
                                      onPressed: () {
                                        Get.bottomSheet(
                                          LiveChoicesBottomSheet(
                                            client: client,
                                            ref: ref,
                                            engine: _engine!,
                                          ),
                                        );
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.ellipsisV,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ]),
                                ),
                                Expanded(
                                  child: CustomContainer(
                                    width: double.maxFinite,
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
                                                'name': user!.name,
                                                'email': user!.email,
                                                'level': user!.levelUser?.level,
                                                'time':
                                                    DateTime.now().toString(),
                                                'user': user!.toJson(),
                                              }));
                                              controller.clear();
                                            }
                                          }
                                        }),
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
                                            'name': user!.name,
                                            'email': user!.email,
                                            'level': user!.levelUser?.level,
                                            'time': DateTime.now().toString(),
                                            'user': user!.toJson(),
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
                              ],
                            )
                          ],
                        ),
                      ),
                      if (context.watch<BroadCastAudienceProvider>().showImage)
                        Center(
                          child: Image.network(
                            context
                                .watch<BroadCastAudienceProvider>()
                                .imageLink,
                            width: double.maxFinite,
                            height: Get.height,
                          ),
                        ),
                      if (context.watch<BroadCastAudienceProvider>().showVideo)
                        Center(
                          child: FutureBuilder<bool>(
                            future: context
                                .watch<BroadCastAudienceProvider>()
                                .started(),
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshot) {
                              if (snapshot.data == true) {
                                //   Fluttertoast.showToast(msg: ' video was shown');
                                return AspectRatio(
                                  aspectRatio: 9 / 12,
                                  child: VideoPlayer(context
                                      .watch<BroadCastAudienceProvider>()
                                      .videoPlayerController!),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      if (context
                          .watch<BroadCastAudienceProvider>()
                          .textToShow
                          .isNotEmpty)
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
                                    context
                                        .watch<BroadCastAudienceProvider>()
                                        .textToShow,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  if (context
                                          .watch<BroadCastAudienceProvider>()
                                          .srcImage !=
                                      null)
                                    Image.network(
                                      context
                                              .watch<
                                                  BroadCastAudienceProvider>()
                                              .srcImage ??
                                          '',
                                      width: 20,
                                      height: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child:
                          Center(
                            child: Icon(Icons.person,size: 50,),
                          ),


                        ),
                        top: Get.height * 0.2,
                        right: 10,
                        height: 150,
                        width: 130,
                      ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child:
                          Center(
                            child: Icon(Icons.person,size: 50,),
                          ),


                        ),
                        top: Get.height * 0.40,
                        right: 10,
                        height: 150,
                        width: 130,
                      ),
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child:
                          Center(
                            child: Icon(Icons.person,size: 50,),
                          ),


                        ),
                        top: Get.height * 0.60,
                        right: 10,
                        height: 150,
                        width: 130,
                      )

                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
