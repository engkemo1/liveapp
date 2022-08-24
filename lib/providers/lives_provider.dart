import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/models/user_model.dart';
import 'package:stars_live/providers/user_provider.dart';

class LivesProvider extends ChangeNotifier {
  UserModel liveUsers = UserModel();

  void createRoom(context, user_id) async {
    try {
      final dio = Dio();
      dio.options = BaseOptions(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
        },
      );
      final response = await dio
          .post(createRoomURL, data: {'room_id': user_id, 'user_id': user_id});
      print('roomCreated: $response ');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getLiveUsers() async {
    try {
      final dio = Dio();
      dio.options = BaseOptions(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
        },
      );
      final response = await dio.post(
        getLivesUsersURL,
      );
      liveUsers = UserModel.fromJson(response.data);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

//create live session
  void setUserLive(context, user_id) async {
    try {
      final dio = Dio();
      dio.options = BaseOptions(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
        },
      );
      final response = await dio.post(
        setUserLiveStatusURL,
        data: {
          'live': 1,
        },
      );

      if (response.statusCode == 200) {
        createRoom(context, user_id);
        getLiveUsers();
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future setUserUnLive() async {
    try {
      final dio = Dio();
      dio.options = BaseOptions(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
        },
      );
      final response = await dio.post(
        setUserLiveStatusURL,
        data: {
          'live': 0,
        },
      );
      if (response.statusCode == 200) {
        getLiveUsers();
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
