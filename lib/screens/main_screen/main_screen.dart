import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stars_live/models/singl_user_model.dart';
import 'package:stars_live/providers/gifts_provider.dart';
import 'package:stars_live/providers/lives_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/broadcaster_screen/broadcaster.dart';
import 'package:stars_live/screens/main_screen/main_screen_tabs/chats_tab.dart';
import 'package:stars_live/screens/main_screen/main_screen_tabs/fav_tab.dart';
import 'package:stars_live/screens/main_screen/main_screen_tabs/home_tap.dart';
import 'package:stars_live/screens/main_screen/main_screen_tabs/profile_tab.dart';

import '../../widgets/custom_widgets.dart';

class MainScreen extends StatefulWidget {
  static String id = '/mainScreen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  alertDialog(BuildContext context) {
    // This is the ok button
    Widget ok = FlatButton(
      child: Text("Okay"),
      onPressed: () {
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
      print(notification.toString());
      alertDialog(context);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((notification) {
      print(notification.toString());
      alertDialog(context);
    });
  }

  List<Widget> bodyWidgets = [
    HomeTab(),
    FavTab(),
    ChatsTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    setupnotificaitons();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<LivesProvider>(context, listen: false).getLiveUsers();
      Provider.of<GiftsProvider>(context, listen: false).getAllGifts();
    });
  }

  @override
  Widget build(BuildContext context) {
    checkUserData();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(child: bodyWidgets[selectedIndex]),
          ConvexAppBar(
            height: 50,
            backgroundColor: Colors.white,
            activeColor: Colors.white,
            items: [
              TabItem(
                icon: FaIcon(
                  CupertinoIcons.home,
                  color: selectedIndex == 0
                      ? const Color(0xffB83AF3)
                      : Colors.black,
                ),
                title: '',
              ),
              TabItem(
                icon: FaIcon(
                  FontAwesomeIcons.heart,
                  color: selectedIndex == 1
                      ? const Color(0xffB83AF3)
                      : Colors.black,
                ),
                title: '',
              ),
              TabItem(
                icon: SvgPicture.asset(
                  'assets/images/logocamera.svg',
                  width: 50,
                  height: 50,
                ),
                title: '',
              ),
              TabItem(
                icon: FaIcon(
                  FontAwesomeIcons.comment,
                  color: selectedIndex == 2
                      ? const Color(0xffB83AF3)
                      : Colors.black,
                ),
                title: '',
              ),
              TabItem(
                icon: FaIcon(
                  FontAwesomeIcons.user,
                  color: selectedIndex == 3
                      ? const Color(0xffB83AF3)
                      : Colors.black,
                ),
                title: '',
              ),
            ],
            style: TabStyle.fixed,
            initialActiveIndex: 2,
            onTap: (int i) {
              switch (i) {
                case 0:
                  setState(() {
                    selectedIndex = 0;
                  });
                  break;
                case 1:
                  setState(() {
                    selectedIndex = 1;
                  });
                  break;
                case 2:
                  if (Provider.of<UserProvider>(context, listen: false)
                      .userData!
                      .data!
                      .first
                      .isLiveBaned!) {
                    customSnackBar(
                        context: context,
                        text: 'you are baned for'.tr +
                            ' ' +
                            Provider.of<UserProvider>(context, listen: false)
                                .userData!
                                .data!
                                .first
                                .liveBanDuration!
                                .toString() +
                            ' ' +
                            'hour'.tr);
                  } else {
                    Provider.of<LivesProvider>(context, listen: false)
                        .setUserLive(
                            context,
                            Provider.of<UserProvider>(context, listen: false)
                                .userData!
                                .data!
                                .first
                                .id);
                    Get.toNamed(BroadCaster.id, arguments: {
                      'channel':
                          Provider.of<UserProvider>(context, listen: false)
                              .userData!
                              .data!
                              .first
                              .id
                              .toString(),
                      'user': User.fromJson(
                        Provider.of<UserProvider>(context, listen: false)
                            .userData!
                            .data!
                            .first
                            .toJson(),
                      ),
                    });
                  }

                  break;
                case 3:
                  setState(() {
                    selectedIndex = 2;
                  });
                  break;
                case 4:
                  setState(() {
                    selectedIndex = 3;
                  });
                  break;
                default:
              }
            },
          )
        ],
      ),
    );
  }

  void checkUserData() {
    if (context.watch<UserProvider>().userData == null) {
      context.watch<UserProvider>().getMyData();
    }
  }
}
