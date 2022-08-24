import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/models/user_model.dart';

import '../global/constants.dart' as cons;
import '../models/blockedUser_model.dart' as blocked;
import '../utils/Cache_Helper.dart';
import '../utils/diohelper.dart';
import '../models/follower_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userData;
  blocked.BlockedUserModel? blockedUser;
  Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
      },
    ),
  );

  Future getUserData(String? email, String? password) async {
    try {
      var response = await DioHelper.setData(
          path: 'login', data: {'login': email, 'password': password});
      if (response.statusCode == 200) {
        // await Cache_Helper.setData('email', email);
        // await Cache_Helper.setData('password', password);
        print('messgage ' + response.data['msg']);
        userData = UserModel.fromJson(response.data);

        // final storage = GetStorage();
        await GetStorage().remove('api');
        await GetStorage()
            .write('api', userData?.data?.first.apiToken.toString());

        // await Cache_Helper.setData('api', userData?.data?.first.apiToken);
        print(userData?.data?.elementAt(0).email);
        myFollowingsIds(userData?.data?.first.followeds);
        notifyListeners();
      }
    } catch (error) {
      Cache_Helper.removeData('email');
      Cache_Helper.removeData('password');
      Cache_Helper.removeData('googleEmail');
      GoogleSignIn().signOut();
      GetStorage().remove('api');
      userData = null;
      print('error from userprovider' + error.toString());
      notifyListeners();
    }
  }

  Future getMyData() async {
    try {
      var response = await DioHelper.getData(
        path: 'user/my-data',
        auth: 'Bearer ' + GetStorage().read('api'),
      );
      if (response.statusCode == 200) {
        userData = UserModel.fromJson(response.data);
        myFollowingsIds(userData?.data?.first.followeds);
        print('from get my data');
        notifyListeners();
      }
    } catch (error) {
      print('error from my data' + error.toString());
      notifyListeners();
    }
  }

  Future getGoogleUserData() async {
    int random1 = Random().nextInt(99999999);
    int random2 = Random().nextInt(88888888);
    int random3 = Random().nextInt(77777777);
    var googleEmail = Cache_Helper.getData('googleEmail');
    var googleName = Cache_Helper.getData('googleName');
    var googleId = Cache_Helper.getData('googleId');
    print('hello google sign in');
    try {
      var response = await DioHelper.setData(path: 'social/login', data: {
        'google_id': googleId,
        'name': googleName,
        'email': googleEmail,
        'device_token': '$random3$random1$random2$random3$random1$random2'
      });
      if (response.statusCode == 200) {
        print('messgage ' + response.data['msg']);
        print(userData?.data?.first.email);
        userData = UserModel.fromJson(response.data);
        print(userData?.data?.first.email);
        final storage = GetStorage();
        storage.write('api', userData?.data?.first.apiToken.toString());
        myFollowingsIds(userData?.data?.first.followeds);
        print(googleId);
        print(googleName);
        print('$random3$random1$random2$random3$random1$random2');
        print(userData?.data?.first.email);

        notifyListeners();
      }
    } catch (error) {
      Cache_Helper.removeData('email');
      Cache_Helper.removeData('password');
      Cache_Helper.removeData('googleEmail');
      GoogleSignIn().signOut();
      GetStorage().remove('api');
      userData = null;
      print('error from userProvider ' + error.toString());
      notifyListeners();
    }
  }

  void followUser(userID) async {
    try {
      final dio = Dio();
      dio.options = BaseOptions(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
        },
      );
      await dio.post(
        cons.followingURL,
        data: {
          'follow_id': userID,
        },
      );
      cons.myFollowingsIdss.add(userID);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void unFollowUser(userID) async {
    try {
      final dio = Dio();
      dio.options = BaseOptions(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
        },
      );
      await dio.post(
        cons.unFollowURL,
        data: {
          'follow_id': userID,
        },
      );
      cons.myFollowingsIdss.remove(userID);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void myFollowingsIds(List<Follower>? myFollowings) {
    if (myFollowings != null) {
      cons.myFollowingsIdss = {};
      myFollowings.forEach((element) {
        cons.myFollowingsIdss.add(element.id ?? -1);
      });
    }
  }

  void blockUser(int userId) async {
    // final response = await DioHelper.setData(
    //     path: cons.blockUserUrl, data: {'user_id': userId});
    _dio.options = BaseOptions(headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
    });

    final respond =
        await _dio.post(cons.blockUserUrl, data: {'user_id': userId});
    print(respond.data);
    notifyListeners();
    _dio.clear();
  }

  void unBlockUser(int userId) async {
    // // final response = await DioHelper.setData(
    // //     path: cons.blockUserUrl, data: {'user_id': userId});
    // _dio.options = BaseOptions(headers: {
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
    // });

    final respond =
        await _dio.post(cons.unBlockUserUrl, data: {'user_id': userId});
    print(respond.data);
    notifyListeners();
    _dio.clear();
  }

  Future<List<blocked.Data>> getBlockedUserList() async {
    _dio.options = BaseOptions(headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
    });
    try {
      final respond = await _dio.post(cons.blockUserListUrl);
      blockedUser = blocked.BlockedUserModel.fromJson(respond.data);
      if (blockedUser!.status!.contains('ok') && blockedUser?.data != null) {
        var blocked_list = blockedUser?.data;
        // print(blocked_list?[1].email);

        return blocked_list!;
      }
    } catch (err) {
      print('blocked user from user provider err : $err');
    }
    return List.empty();
  }

  void reportUser(int reportedId, String reason) async {
    final respond = await _dio.post(
      cons.reportUserUrl,
      data: {
        'reported_id': reportedId,
        'reason': reason,
      },
    );

    print(respond.data);
    _dio.clear();
  }
}
