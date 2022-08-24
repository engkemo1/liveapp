import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stars_live/models/singl_user_model.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/audiance_screen/audiance.dart';
import 'package:stars_live/widgets/gifts_dialog.dart';
import 'package:stars_live/screens/chat%20screen/chat_screen.dart';

import '../global/constants.dart';
import '../global/functions.dart';
import '../models/user_model.dart';

class UserInfoBottomSheet extends StatefulWidget {
  final User user;
  final String recieverID;
  final bool isHost;
  // final onBlockHost;
  const UserInfoBottomSheet({
    Key? key,
    required this.user,
    required this.recieverID,
    this.isHost = false,
    // this.onBlockHost,
  }) : super(key: key);

  @override
  State<UserInfoBottomSheet> createState() => _UserInfoBottomSheetState();
}

class _UserInfoBottomSheetState extends State<UserInfoBottomSheet> {
  late TextEditingController _dialogTextController;

  @override
  void initState() {
    super.initState();
    _dialogTextController = TextEditingController();
  }

  @override
  void dispose() {
    _dialogTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SizedBox(
      height: 380,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 310,
            child: Container(
              padding: const EdgeInsets.only(
                top: 60,
                left: 10,
                right: 10,
              ),
              height: Get.height * 0.5,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.user.name.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'id: '.tr + widget.user.id.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        height: 70,
                        width: Get.width * 0.4,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 241, 49, 49),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidStar,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'host level'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.user.levelHost!.level.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(5),
                        height: 70,
                        width: Get.width * 0.4,
                        decoration: levelsColor[
                            (widget.user.levelUser?.level / 20).floor() > 15
                                ? 15
                                : (widget.user.levelUser?.level / 20).floor()],
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.solidMoon,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'user level'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.user.levelUser!.level.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            if (myFollowingsIdss.contains(widget.user.id)) {
                              userProvider.unFollowUser(widget.user.id);
                              setState(() {
                                Functions.updateUserData(context);
                              });
                            } else {
                              userProvider.followUser(widget.user.id);
                              setState(() {
                                Functions.updateUserData(context);
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Icon(
                                myFollowingsIdss.contains(widget.user.id)
                                    ? FontAwesomeIcons.minus
                                    : FontAwesomeIcons.plus,
                                color: Colors.cyan[600],
                                size: 12,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                myFollowingsIdss.contains(widget.user.id)
                                    ? 'un follow'.tr
                                    : 'follow'.tr,
                                style: TextStyle(
                                  color: Colors.cyan[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RawMaterialButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/chat.svg',
                                height: 18,
                                width: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(ChatScreen(
                                    id: widget.user.id,
                                    imgurl: widget.user.image,
                                    name: widget.user.name,
                                  ));
                                },
                                child: Text(
                                  'chat'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //send gift button
                        /* Expanded(
                          child: RawMaterialButton(
                            onPressed: () {
                              Get.bottomSheet(GiftsDialog(
                                toWhome: widget.user.name ?? 'username',
                                user: widget.user,
                                recieverID: widget.recieverID,
                                show: false,
                              ));
                            },

                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.gift,
                                  color: Color.fromARGB(255, 152, 0, 240),
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'send gift'.tr,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 152, 0, 240),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ), */
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Consumer<UserProvider>(builder: (context, value, child) {
              UserModel? user = value.userData;
              //print(user?.followeds?.first.name);
              return Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.user.image!),
                    backgroundColor: Colors.white,
                  ),
                  Positioned(
                    bottom: 0,
                    child: user?.data![0].types!.management == true
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image(
                              image: AssetImage('assets/images/shield.png'),
                            ))
                        : user?.data![0].types!.forwarder == true
                            ? CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/dollar.png'))
                            : user?.data![0].types!.agent == true
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        AssetImage('assets/images/agent.png'))
                                : user?.data![0].types!.broadcaster == true
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage: AssetImage(
                                            'assets/images/check-mark.png'))
                                    : Container(),
                  )
                ],
              );
            }),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 90,
                ),
                child: PopupMenuButton<_MenuValues>(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: Text('block'.tr), value: _MenuValues.BLOCK),
                    PopupMenuItem(
                        child: Text('report'.tr), value: _MenuValues.REPORT),
                    PopupMenuItem(
                        child: Text('request'.tr), value: _MenuValues.REQUEST,),
                  ],
                  onSelected: (value) {
                    try {
                      switch (value) {
                        case  _MenuValues.REQUEST:
                          Timer _timer;
                          showDialog(
                            barrierColor: Colors.white.withOpacity(0.1),
                              context: context,
                              builder: (BuildContext builderContext) {
                                _timer = Timer(Duration(seconds: 1), () {
                                  Navigator.of(context).pop();    // == First dialog closed
                                });

                                return Container(
                                  child: Center(child: Text('waiting for approval'.tr,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),)
                                );
                              });
                          break;
                        case _MenuValues.BLOCK:
                          print('block user with id ${widget.user.id}');
                          userProvider.blockUser(widget.user.id!);
                          //IMPROVEMENT: Go back after block

                          // if (widget.isHost) {
                          //   print(widget.isHost);
                          //   widget.onBlockHost;
                          // }
                          Get.back();
                          // Get.back();
                          break;
                        case _MenuValues.REPORT:
                          //IMPROVEMENT: {status: error, data: [], msg: user you try to report is not a host, errors: []}
                          print('report user ${widget.user.id}');
                          // userProvider.reportUser(
                          //   widget.user.id!,
                          //   'test reason',
                          // );
                          var errorMessage;

                          Get.defaultDialog(
                            title: 'report'.tr,
                            textConfirm: 'Send',
                            textCancel: 'Cancel',
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              if (_dialogTextController.text.isNotEmpty) {
                                userProvider.reportUser(
                                  widget.user.id!,
                                  _dialogTextController.text,
                                );
                                Get.back();
                                _dialogTextController.clear();

                                Get.snackbar(
                                    'success', 'Report send successully',
                                    margin: EdgeInsets.only(
                                      bottom: 20,
                                      left: 20,
                                      right: 20,
                                    ),
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    isDismissible: true,
                                    dismissDirection:
                                        DismissDirection.horizontal,
                                    snackPosition: SnackPosition.BOTTOM);
                              } else {
                                //TODO: Handel on empty text filed
                              }
                            },
                            content: TextField(
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              controller: _dialogTextController,
                              decoration: InputDecoration(
                                labelText: 'Enter Reason',
                                errorText:
                                    errorMessage != null ? errorMessage : null,
                                hintMaxLines: 1,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 4.0),
                                ),
                              ),
                            ),
                          ).then((value) {
                            _dialogTextController.clear();
                          });
                          break;
                      }
                    } catch (err) {
                      print('error message:  $err');
                    }
                  },
                ),
              ))
        ],
      ),
    );
  }
}

enum _MenuValues {
  BLOCK,
  REPORT,
  REQUEST
}
