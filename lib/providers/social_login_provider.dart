import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stars_live/utils/Cache_Helper.dart';
import 'package:stars_live/utils/diohelper.dart';

class SocialLogin extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;
  Future<GoogleSignInAccount?> userGoogleLogin(context) async {
    //BUGME : error scoial login 400 status code , add sha-1 to console application
    try {
      user = await googleSignIn.signIn();

      Cache_Helper.setData('googleEmail', user?.email);
      Cache_Helper.setData('googleName', user?.displayName);
      Cache_Helper.setData('googleId', user?.id);
      print(user?.id);
      print(user?.displayName);
      print(
          'email from google social login provider ' + (user?.email ?? 'null'));
      return user;
    } catch (error) {
      print('error from social login provider ' + error.toString());
      return null;
    }
  }
}
