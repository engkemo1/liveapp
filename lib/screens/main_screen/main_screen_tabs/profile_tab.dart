import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stars_live/models/singl_user_model.dart';
import 'package:stars_live/screens/settings_screen/settings_sub_screens/blocked_screen.dart';
import 'package:stars_live/utils/Cache_Helper.dart';
import 'package:stars_live/models/user_model.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/fans_screen/fans_screen.dart';
import 'package:stars_live/screens/income_screen/user_income_screen/user_income_screen.dart';
import 'package:stars_live/screens/level_screen/level_screen.dart';
import 'package:stars_live/screens/login/main_login_screen.dart';
import 'package:stars_live/screens/settings_screen/settings_screen.dart';
import 'package:stars_live/widgets/profile_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Mall.dart';
import '../../../global/constants.dart';
import '../../../global/functions.dart';
import '../../coins_screen/coins_screen.dart';
import '../../edit_screen/edit_screen.dart';
import '../../games_screen/games_screen.dart';
import '../../income_screen/host_income_screen/host_income_screen.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({Key? key}) : super(key: key);
  List icons = [
    'assets/images/agent.png',
    'assets/images/dollar.png',
    'assets/images/shild.png',
    'assets/images/check=mark.png',
  ];

  @override
  Widget build(BuildContext context) {
    Functions.updateUserData(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: GRADIENT,
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, value, child) {
            UserModel? user = value.userData;
            //print(user?.followeds?.first.name);
            return Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  height: Get.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'assets/images/profile_background.png',
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    width: Get.width,
                    height: Get.height,
                    child: Stack(
                      children: [
                        //edit
                        Positioned(
                            top: 50,
                            right: 30,
                            child: IconButton(
                              onPressed: () {
                                Get.to(EditScreen());
                              },
                              icon: Icon(
                                FontAwesomeIcons.userEdit,
                                color: Colors.white,
                              ),
                            )),

                        //data
                        Positioned(
                          top: 150,
                          left: Get.width * 0.1,
                          right: Get.width * 0.1,
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 65, bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(1.0, 4.0),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        alignment: Alignment.center,
                                        width: double.maxFinite,
                                        child: Text(
                                          user?.data?.first.name ??
                                              'username'.tr,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'id: '.tr +
                                      (user?.data?.first.id.toString() ??
                                          '123456'),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 70,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 0,
                                  ),
                                  decoration: levelsColor[
                                      (user?.data?.first.levelUser?.level / 20)
                                                  .floor() >
                                              15
                                          ? 15
                                          : (user?.data?.first.levelUser
                                                      ?.level /
                                                  20)
                                              .floor()],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.solidStar,
                                        color: Color.fromARGB(255, 255, 230, 0),
                                        size: 10,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        user?.data?.first.levelUser!.level!
                                                .toString() ??
                                            '0',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          FansScreen.id,
                                          arguments: ['follower'.tr, false],
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            'follower'.tr,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          Text(
                                            user?.data?.first.followers?.length
                                                    .toString() ??
                                                '0',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(FansScreen.id,
                                            arguments: ['following'.tr, true]);
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            'following'.tr,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          Text(
                                            user?.data?.first.followeds?.length
                                                    .toString() ??
                                                '0',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          FansScreen.id,
                                          arguments: ['friends'.tr, false],
                                        );
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            'friends'.tr,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          Text(
                                            user?.data?.first.friends?.length
                                                    .toString() ??
                                                '0',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        //image
                        Positioned(
                            top: 100,
                            left: Get.width * 0.34,
                            right: Get.width * 0.35,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      user?.data?.first.image ?? ''),
                                  backgroundColor: Colors.grey[200],
                                  radius: 60,
                                ),
                                user?.data![0].types!.management == true
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/images/shield.png'),
                                        ))
                                    : user?.data![0].types!.forwarder == true
                                        ? CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/dollar.png'))
                                        : user?.data![0].types!.agent == true
                                            ? CircleAvatar(
                                                backgroundColor: Colors.white,
                                                backgroundImage: AssetImage(
                                                    'assets/images/agent.png'))
                                            : user?.data![0].types!
                                                        .broadcaster ==
                                                    true
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/check-mark.png'))
                                                : Container(),
                              ],
                            )),

                        // Positioned(
                        //   top: 180,
                        //   //left: Get.width * 0.34,
                        //   right: Get.width * 0.35,
                        //   child: Container(
                        //     width: 30.0,
                        //     height: 30.0,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //       ),
                        //       child: Image.asset('assets/images/v.png'),
                        //     ),
                        //   ),
                        // ),

                        //settings
                        Positioned(
                          top: 450,
                          left: Get.width * 0.1,
                          right: Get.width * 0.1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5,
                                  offset: Offset(1.0, 4.0),
                                )
                              ],
                            ),
                            width: Get.width * 0.8,
                            height: Get.height * 0.35,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(CoinsScreen.id);
                                    },
                                    child: ProfileItem(
                                      title: 'coins'.tr,
                                      iconColor: Colors.yellow[700],
                                      icon: FontAwesomeIcons.coins,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Mall()));
                                    },
                                    child: ProfileItem(
                                      title: 'mall'.tr,
                                      iconColor: Colors.green[700],
                                      icon: FontAwesomeIcons.shopify,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(GamesScreen.id);
                                    },
                                    child: ProfileItem(
                                        title: 'games'.tr,
                                        iconColor: Colors.purple,
                                        icon: FontAwesomeIcons.gamepad),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(LevelScreen.id);
                                    },
                                    child: ProfileItem(
                                        title: 'level'.tr,
                                        iconColor: Colors.blue[800],
                                        icon: FontAwesomeIcons.chartLine),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (user?.data?.first.type == 'user')
                                        Get.toNamed(UserIncomeScreen.id);
                                      else
                                        Get.toNamed(HostIncomeScreen.id);
                                    },
                                    child: ProfileItem(
                                      title: 'income'.tr,
                                      iconColor: Colors.blue[300],
                                      icon: FontAwesomeIcons.solidGem,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      openWhatsApp(context, "+201008331852");
                                    },
                                    child: ProfileItem(
                                      title: 'customer service'.tr,
                                      iconColor: Colors.red[300],
                                      icon: FontAwesomeIcons.headset,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(SettingsScreen.id);
                                    },
                                    child: ProfileItem(
                                      title: 'settings'.tr,
                                      iconColor: Colors.grey[800],
                                      icon: FontAwesomeIcons.cog,
                                    ),
                                  ),
                                  Consumer<UserProvider>(
                                    builder: (context, value, child) {
                                      return InkWell(
                                        onTap: () {
                                          Cache_Helper.removeData('email');
                                          Cache_Helper.removeData('password');
                                          Cache_Helper.removeData(
                                              'googleEmail');
                                          Cache_Helper.removeData('googleName');
                                          Cache_Helper.removeData('googleId');
                                          GetStorage().remove('api');

                                          GoogleSignIn().signOut();
                                          value.userData = null;
                                          Get.offAndToNamed(MainLoginScreen.id);
                                        },
                                        child: ProfileItem(
                                          title: 'logout'.tr,
                                          iconColor: Colors.red[900],
                                          icon: FontAwesomeIcons.signOutAlt,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  openWhatsApp(BuildContext context, String number) async {
    var whatsapp = number;
    var whatsappURl_android = "whatsapp://send?phone=$whatsapp";
    var whatappURL_ios = "https://wa.me/$whatsapp";
    if (Platform.isIOS) {
      // for iOS phone only
      try {
        await launch(whatappURL_ios, forceSafariVC: false);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text(e.toString())));
      }
    } else {
      // android , web
      try {
        await launch(whatsappURl_android);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text(e.toString())));
      }
    }
  }
}
