import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/global/functions.dart';
import 'package:stars_live/providers/gifts_provider.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/coins_screen/coins_screen.dart';
import 'package:stars_live/widgets/custom_widgets.dart';
import '../models/singl_user_model.dart';

class GiftsDialog extends StatefulWidget {
  final User user;
  final bool show;
  final recieverID;
  final String toWhome;
  final bool fromLive;

  GiftsDialog({
    Key? key,
    required this.toWhome,
    required this.user,
    this.show = true,
    this.fromLive = false,
    required this.recieverID,
  }) : super(key: key);

  @override
  State<GiftsDialog> createState() => _GiftsDialogState();
}

class _GiftsDialogState extends State<GiftsDialog> {
  late DatabaseReference ref;
  int selectedIndex = -1;
  int currentDiamonds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      ref = FirebaseDatabase.instance.ref(widget.recieverID.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    print('myuser ' + widget.user.image.toString());
    final gifts = Provider.of<GiftsProvider>(context).gifts;
    final giftProvider = Provider.of<GiftsProvider>(context, listen: false);
    final sender = Provider.of<UserProvider>(context).userData?.data?.first;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: Get.width,
          height: Get.height * 0.5,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 43, 43, 43),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                child: Text(
                  'send gift to '.tr + (widget.toWhome),
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
/* 
              Expanded(
                //run future
                child: FutureBuilder<File?>(
                  future: giftProvider.downloadSingleFilewithDownload(),
                  builder: (ctx, pathSnapShot) {
                    if (pathSnapShot.connectionState == ConnectionState.done &&
                        pathSnapShot.hasData) {
                      // String path = '${pathSnapShot.dat  a}/gift/15';
                      // log(path);
                      return Image.file(pathSnapShot.data!);
                    } else {
                      if (pathSnapShot.data != null) {
                        log(pathSnapShot.data!.path + '/++++++++++++++++');
                      }

                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              Expanded(
                //get from app strogere
                child: FutureBuilder<Directory>(
                  future: getApplicationDocumentsDirectory(),
                  builder: (ctx, pathSnapShot) {
                    if (pathSnapShot.connectionState == ConnectionState.done &&
                        pathSnapShot.hasData) {
                      // String path = '${pathSnapShot.dat  a}/gift/15';
                      // log(path);
                      log(pathSnapShot.data!.path + '/++++++++++++++++');
                      return Image.file(
                          File('${pathSnapShot.data?.path}/pics/among.png'));
                    } else {
                      if (pathSnapShot.data != null) {
                        log(pathSnapShot.data!.path + '/++++++++++++++++');
                      }

                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              */
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: gifts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: selectedIndex == index
                                ? Color.fromARGB(255, 95, 66, 255)
                                : Colors.transparent,
                          ),
                          color: selectedIndex == index
                              ? Color(0xff6950FB)
                              : Colors.transparent,
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //FIXME :  fixed
                            FutureBuilder<Directory>(
                                future: getApplicationDocumentsDirectory(),
                                builder: (ctx, pathSnapShot) {
                                  if (pathSnapShot.connectionState ==
                                      ConnectionState.waiting)
                                    return Center(
                                        child: CircularProgressIndicator());
                                  if (pathSnapShot.connectionState !=
                                      ConnectionState.done) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    if (!pathSnapShot.hasData) {
                                      return Center(
                                        child: Text(
                                          gifts[index].title.toString(),
                                        ),
                                      );
                                    } else {
                                      return Consumer<GiftsProvider>(
                                          builder: (ctx, giftsProvider, _) {
                                        String appStorge =
                                            pathSnapShot.data!.path;
                                        String imgId =
                                            gifts[index].id.toString();
                                        String imgExt = giftProvider
                                            .getExt(gifts[index].image!);

                                        String fullPath =
                                            '$appStorge/gift/$imgId$imgExt';

                                        File file = File(fullPath);
                                        return Container(
                                          child: file.existsSync()
                                              ? Image.file(
                                                  file,
                                                  width: 50,
                                                  height: 50,
                                                  fit: BoxFit.fill,
                                                )
                                              : gifts[index].image != null
                                                  ? Image.network(
                                                      gifts[index].image!,
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Center(
                                                      child: Text(
                                                        gifts[index]
                                                            .title
                                                            .toString(),
                                                      ),
                                                    ),
                                        );
                                      });
                                    }
                                  }
                                }),

                            SizedBox(height: 5),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FontAwesomeIcons.coins,
                                    color: Colors.yellow[600],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    gifts[index].valueInCoins.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(CoinsScreen());
                      },
                      child: Container(
                        height: 40,
                        width: Get.width * 0.4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xff6950FB),
                          ),
                          color: Color(0xff6950FB),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/coin.svg'),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              sender?.balanceInCoins ?? '0',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: selectedIndex == -1
                          ? null
                          : () async {
                              //if he had balance
                              if (int.parse(sender?.balanceInCoins ?? '0') >=
                                  int.parse(
                                      gifts[selectedIndex].valueInCoins!)) {
                                await Provider.of<GiftsProvider>(context,
                                        listen: false)
                                    .sendGift(
                                  gifts[selectedIndex],
                                  widget.recieverID,
                                );
                                if (Provider.of<GiftsProvider>(context,
                                        listen: false)
                                    .sendSuccess) {
                                  //if gift added success in backend

                                  FirebaseFirestore.instance
                                      .collection('userDiamonds')
                                      .doc(widget.recieverID.toString())
                                      .get()
                                      .then((value) {
                                    int currentDiamonds =
                                        int.parse(value.data()!['diamond']);
                                    FirebaseFirestore.instance
                                        .collection('userDiamonds')
                                        .doc(widget.recieverID.toString())
                                        .set({
                                      'diamond': (currentDiamonds +
                                              int.parse(gifts[selectedIndex]
                                                      .valueInCoins ??
                                                  '0'))
                                          .toString()
                                    });
                                  });

                                  // if gift sent success and user have coins we then show this gift
                                  // but we check if the gift if more than 80 or not
                                  if (int.parse(gifts[selectedIndex]
                                          .valueInCoins
                                          .toString()) >=
                                      80) {
                                    // if value is bigger than 2000 we add it to global text to show it
                                    if (int.parse(gifts[selectedIndex]
                                            .valueInCoins
                                            .toString()) >=
                                        2000) {
                                      DatabaseReference globalTextRef =
                                          FirebaseDatabase.instance
                                              .ref('globalText');

                                      DatabaseReference newGlobalText =
                                          globalTextRef.push();

                                      await newGlobalText.set(json.encode({
                                        'sender': sender!.name,
                                        'reciever': widget.toWhome,
                                        'time': DateTime.now().toString(),
                                        'image': gifts[selectedIndex].image
                                      }));
                                    }

                                    Provider.of<GiftsProvider>(context,
                                            listen: false)
                                        .updateSendSuccuess(false);
                                    Get.back();
                                    DatabaseReference newCommentText =
                                        ref.child('comments').push();

                                    await newCommentText.set(json.encode({
                                      'id': sender?.id,
                                      'type': 'GIFT',
                                      if (gifts[selectedIndex].videoLink !=
                                          null)
                                        'video': gifts[selectedIndex].videoLink,
                                      if (gifts[selectedIndex].image != null)
                                        'image': gifts[selectedIndex].image,
                                      'title':
                                          gifts[selectedIndex].title ?? 'GIFT',
                                      'name': sender?.name ?? '',
                                      'email': sender?.email ?? '',
                                      'level': sender?.levelUser?.level ?? '',
                                      'time': DateTime.now().toString(),
                                      'user': sender,
                                      'giftID':
                                          gifts[selectedIndex].id.toString(),
                                    }));

                                    // add gift to full screen videos collection
                                    DatabaseReference newComment =
                                        ref.child('fullscreenvideo').push();

                                    await newComment.set(json.encode({
                                      'id': sender?.id,
                                      'type': 'GIFT',
                                      if (gifts[selectedIndex].videoLink !=
                                          null)
                                        'video': gifts[selectedIndex].videoLink,
                                      if (gifts[selectedIndex].image != null)
                                        'image': gifts[selectedIndex].image,
                                      'title':
                                          gifts[selectedIndex].title ?? 'GIFT',
                                      'name': sender?.name ?? '',
                                      'email': sender?.email ?? '',
                                      'level': sender?.levelUser?.level ?? '',
                                      'time': DateTime.now().toString(),
                                      'user': sender,
                                      'giftID':
                                          gifts[selectedIndex].id.toString(),
                                    }));

                                    // update user data
                                    Functions.updateUserData(context);
                                    Get.back();
                                  } else {
                                    DatabaseReference newComment =
                                        ref.child('comments').push();

                                    await newComment.set(json.encode({
                                      'id': sender?.id,
                                      'type': 'GIFT',
                                      // 'giftID':
                                      //     gifts[selectedIndex].id.toString(),
                                      if (gifts[selectedIndex].videoLink !=
                                          null)
                                        'video': gifts[selectedIndex].videoLink,
                                      if (gifts[selectedIndex].image != null)
                                        'image': gifts[selectedIndex].image,
                                      'title':
                                          gifts[selectedIndex].title ?? 'GIFT',
                                      'name': sender?.name ?? '',
                                      'email': sender?.email ?? '',
                                      'level': sender?.levelUser?.level ?? '',
                                      'time': DateTime.now().toString(),
                                      'user': sender
                                    }));

                                    Functions.updateUserData(context);
                                  }
                                }
                              } else {
                                //if not have enough balance
                                final AlertDialog alert = AlertDialog(
                                  title: Text(
                                    "sorry !".tr,
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  backgroundColor: Colors.white,
                                  content: Container(
                                    width: 100,
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          "your balance is not enough".tr,
                                          style: Get.textTheme.subtitle2!
                                              .copyWith(fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: GRADIENT,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: MaterialButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "ok",
                                              style: Get.textTheme.subtitle2!
                                                  .copyWith(
                                                      fontSize: 20,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return alert;
                                    });
                              }
                            },
                      child: Container(
                        height: 40,
                        width: Get.width * 0.4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Color(0xff6950FB),
                          ),
                          color: selectedIndex == -1
                              ? Colors.white
                              : Color(0xff6950FB),
                        ),
                        child: Text(
                          'send'.tr,
                          style: TextStyle(
                            color: selectedIndex == -1
                                ? Color(0xff6950FB)
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
