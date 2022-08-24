import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../global/constants.dart';
import '../utils/Cache_Helper.dart';
import '../widgets/custom_widgets.dart';

class LoginProvider extends ChangeNotifier {
  Future<void> loginButton({
    required GlobalKey<FormState> globalKey,
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    if (globalKey.currentState!.validate()) {
      try {
        final http.Response _response = await http.post(
            Uri.parse('$baseUrl/api/login'),
            body: {'login': email, "password": password});

        final SharedPreferences _prefs = await SharedPreferences.getInstance();
        final Map<String, dynamic> _data = jsonDecode(_response.body);

        if (_response.statusCode == 200) {
          await Cache_Helper.setData('email', email);
          await Cache_Helper.setData('password', password);
          print(email + ' ' + password);
        } else {
          customSnackBar(
              text: 'Check your Email or Password', context: context);
        }
      } catch (e) {
        print(e.toString());
        customSnackBar(text: 'Something went wrong', context: context);
      }
    }
  }
}
