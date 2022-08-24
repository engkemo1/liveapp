import 'package:flutter/material.dart';
import 'package:stars_live/screens/coins_screen/coins_screen.dart';
import 'package:stars_live/screens/splash_screen/splash_screen.dart';

import '../screens/audiance_screen/audiance.dart';
import '../screens/broadcaster_screen/broadcaster.dart';
import '../screens/fans_screen/fans_screen.dart';
import '../screens/games_screen/games/guess_screen.dart';
import '../screens/games_screen/games_screen.dart';
import '../screens/income_screen/host_income_screen/host_income_screen.dart';
import '../screens/income_screen/user_income_screen/user_income_screen.dart';
import '../screens/leader_board_screen/leader_board_screen.dart';
import '../screens/level_screen/level_screen.dart';
import '../screens/login/main_login_screen.dart';
import '../screens/main_screen/main_screen.dart';
import '../screens/search_screen/search_screen.dart';
import '../screens/settings_screen/settings_screen.dart';
import '../screens/settings_screen/settings_sub_screens/blocked_screen.dart';
import '../screens/settings_screen/settings_sub_screens/security/change_password_screen/change_password_screen.dart';
import '../screens/settings_screen/settings_sub_screens/security/security.dart';
import '../screens/signup_screen/main_signup_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> router = {
    GamesScreen.id: (context) => const GamesScreen(),
    GuessScreen.id: (context) => const GuessScreen(),
    MainLoginScreen.id: (context) => const MainLoginScreen(),
    MainSignUpScreen.id: (context) => const MainSignUpScreen(),
    SplashScreen.id: (context) => const SplashScreen(),
    MainScreen.id: (context) => const MainScreen(),
    Audiance.id: (context) => const Audiance(),
    BroadCaster.id: (context) => const BroadCaster(),
    LeaderBoard.id: (context) => const LeaderBoard(),
    FansScreen.id: (context) => FansScreen(),
    SearchScreen.id: (context) => SearchScreen(),
    CoinsScreen.id: (context) => const CoinsScreen(),
    UserIncomeScreen.id: (context) => const UserIncomeScreen(),
    SettingsScreen.id: (context) => const SettingsScreen(),
    Security.id: (context) => const Security(),
    BlockedScreen.id: (context) => const BlockedScreen(),
    ChangePasswordScreen.id: (context) => const ChangePasswordScreen(),
    LevelScreen.id: (context) => const LevelScreen(),
    HostIncomeScreen.id: (context) => const HostIncomeScreen(),
  };
}
