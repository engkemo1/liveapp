import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:stars_live/utils/Cache_Helper.dart';

import '../providers/user_provider.dart';
import 'constants.dart';
import '../screens/login/main_login_screen.dart';
import '../screens/main_screen/main_screen.dart';
import '../screens/signup_screen/main_signup_screen.dart';
import '../widgets/custom_widgets.dart';

class Functions {
  /// Validators \\\
  static String? validatorName(String? v) {
    return !v!.contains(langEnArRegExp) ? 'Enter your Name by right form'.tr : null ;
  }

  static String? validatorEmail(String? v) {
    return !v!.contains(regExpEmail) ? 'Enter your Email by right form'.tr : null ;
  }

  static String? validatorEmailAndPhone(String? v )
  {
    return !v!.contains(regExpEmail)&&!v.contains(regExpPhone)? 'Enter Email Or Phone Number'.tr :null;
  }

  static String? validatorPhone(String? v) {
    return !v!.contains(regExpPhone) ? 'Enter your Phone by right form'.tr : null;
  }

  static String? validatorPw(String? v) {
    return !v!.contains(regExpPw) ? '[UpperCase , LowerCase , \$ ,# ,%]'.tr : null;
  }
  /// Validators \\\

  /// Routers \\\

  static void goToMainPage(){
    return Get.back();
  }

  static Future<void> goToSignUpPage() async {
    return await Get.toNamed(MainSignUpScreen.id);
  }

  static void updateUserData(context) {
    Provider.of<UserProvider>(context, listen: false).getMyData();
    print('userprofile updated');
  }


}