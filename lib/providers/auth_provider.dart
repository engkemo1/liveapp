import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stars_live/global/constants.dart' as cons;
import 'package:stars_live/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? userData;

  Future<Data?> loginWithAccount({
    required String email,
    required String pass,
  }) async {
    final url = Uri.parse(cons.loginUrl);

    final response = await http.post(url, body: {
      'login': email,
      'password': pass,
    });

    if (response.statusCode == 200) {
      userData = UserModel.fromJson(json.decode(response.body));
      if (userData != null &&
          userData!.status!.contains('ok') &&
          userData!.data!.isNotEmpty) {
        return userData!.data?.first;
      }
    }

    return null;
  }
}
