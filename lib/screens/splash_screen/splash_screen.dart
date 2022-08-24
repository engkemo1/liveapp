import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/login/main_login_screen.dart';
import 'package:stars_live/screens/main_screen/main_screen.dart';

import '../../global/functions.dart';

class SplashScreen extends StatefulWidget {
  static String id = '/splashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? route ;
  bool firstTime = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
       await Future.delayed(Duration(milliseconds: 1500));
       Get.offAndToNamed(route!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<UserProvider>(
        builder: (context, value, child) {


          if (myApiToken!=null) {
            Functions.updateUserData(context);
              route = MainScreen.id;
          }
            else {
            route = MainLoginScreen.id;
          }
          return  Center(
            child: Image.asset(
              'assets/images/livestars.png',
              width: Get.width / 2,
              height: Get.width / 2,
            ),
          );
        },

      ),
    );
  }

}
