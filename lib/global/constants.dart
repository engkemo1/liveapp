import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const GRADIENT = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xffB83AF3),
    Color(0xff6950FB),
  ],
);

PreferredSize GradientAppBar(title, tab1title, tab2title) {
  return new PreferredSize(
    child: new Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: Get.width / 4,
              ),
              Container(
                child: Text(
                  title,
                  style: Get.theme.textTheme.headline5
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 100,
                width: Get.width,
                child: TabBar(indicatorColor: Colors.white, tabs: [
                  Text(tab1title),
                  Text(tab2title),
                ]),
              ),
            ],
          )
        ],
      ),
      decoration: new BoxDecoration(gradient: GRADIENT),
    ),
    preferredSize: new Size(Get.width, 150),
  );
}

String? myApiToken = GetStorage().read('api');

final DECORATION =
    BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.amber);

const Color lightFillColor = Color(0xffF5F5F5);
const Color basicColor = Color(0xffB83AF3);
const Color mainWhiteColor = Colors.white;
const Color mainBlackColor = Colors.black;
const MaterialColor colorGrey = Colors.grey;

// assets path
const String assetsPath = 'assets/images';

//base url
const String baseUrl = 'http://starslive.club/public';

//auth url
const String registerUrl = baseUrl + '/api/register';
const String loginUrl = baseUrl + '/api/login';
const String logOutUrl = baseUrl + '/api/logout';
const String loginWithSocialUrl = baseUrl + '/api/social/login';

// urls
const String getLivesUsersURL = baseUrl + '/api/user/on_live';

const String setUserLiveStatusURL = baseUrl + '/api/user/set_live_status';
const String followingURL = baseUrl + '/api/user/follow';
const String unFollowURL = baseUrl + '/api/user/un_follow';
const String blockUserListUrl = baseUrl + '/api/user/on_live_blocked';

//gifts url
const String getGiftsURL = baseUrl + '/api/gifts/all';
const String sendGiftURL = baseUrl + '/api/user/send_gift';


const String Frames = baseUrl + '/api/frames';

//user data
const String getUserData = baseUrl + '/api/user/my-data';

// room
const String createRoomURL = baseUrl + '/api/room/create';
const String blockUserUrl = baseUrl + '/api/room/block';
const String unBlockUserUrl = baseUrl + '/api/room/unblock';

//report
const String reportUserUrl = baseUrl + '/api/report_broadcast';

// token url
const String tokenURL = baseUrl + '/api/agora/create_token';

// agora app id
const String agoraAppID = 'a1f530f3b94547b795bac51ceaeadba4';

// games
const String getGameListUrl = baseUrl + '/api/game/list';
const String getMyBetsUrl = baseUrl + '/api/game/my-bets';
const String betOnGameUrl = baseUrl + '/api/game/bet';

/// REG EXP \\\

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
final RegExp regExpPw =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
final RegExp regexImage =
    RegExp(r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)");
final RegExp regExpPhone = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
final RegExp regExpName = RegExp(
  '[a-zA-Z]',
);
final RegExp conditionEegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
final RegExp numberRegExp = RegExp(r'\d');
final RegExp langEnRegExp = RegExp('[a-zA-Z]');
final RegExp langEnArRegExp = RegExp('[a-zA-Zء-ي]');
final RegExp langArRegExp = RegExp('[ء-ي]');
final RegExp arabicRegExp =
    RegExp("[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");

final Map<int, BoxDecoration> levelsColor = {
  0: BoxDecoration(
      color: Colors.green, borderRadius: BorderRadius.circular(25)),
  1: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(25)),
  2: BoxDecoration(
      color: Colors.orangeAccent, borderRadius: BorderRadius.circular(25)),
  3: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(25)),
  4: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffB83AF3),
          Color(0xff6950FB),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  5: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff7F3AA2),
          Color(0xfF50FF00),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  6: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff033FF0),
          Color(0xffA950FB),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  7: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff823253),
          Color(0xff0950FB),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  8: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffF83AF3),
          Color(0xffA950FB),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  9: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xff683AF3),
          Color(0xff900042),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  10: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffC83333),
          Color(0xff695000),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  11: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffB82222),
          Color(0xff696666),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  12: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffB84444),
          Color(0xffF950FB),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  13: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffA83AF3),
          Color(0xffF950FB),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  14: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffB82222),
          Color(0xffFF50FB),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
  15: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xffFF3A03),
          Color(0xffDD08A6),
        ],
      ),
      borderRadius: BorderRadius.circular(25)),
};

Set<int> myFollowingsIdss = {};
