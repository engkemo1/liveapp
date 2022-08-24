import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../global/constants.dart';
import '../screens/login/main_login_screen.dart';
import '../widgets/custom_widgets.dart';
import 'package:firebase_core/firebase_core.dart';

class RegisterProvider extends ChangeNotifier {
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

  Future<void> registerButton({
    required GlobalKey<FormState> globalKey,
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    //
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
    //
    if (globalKey.currentState!.validate()) {
      int random1 = Random().nextInt(99999999);
      int random2 = Random().nextInt(88888888);
      int random3 = Random().nextInt(77777777);

      try {
        final http.Response _response =
            await http.post(Uri.parse('$baseUrl/api/register'), body: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'device_token': token.toString()
        });

        final Map<String, dynamic> _data = jsonDecode(_response.body);

        print(_data);
        if (_response.statusCode == 200) {
          Get.offAllNamed(MainLoginScreen.id);
        } else {
          customSnackBar(
            text: 'email or phone are already used',
            context: context,
            duration: Duration(seconds: 2),
          );
        }
      } catch (e) {
        customSnackBar(
            text: 'check your internet connection', context: context);
      }
    }
    // Get.offAllNamed(MainScreen.id)
  }
}
