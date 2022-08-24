import 'package:flutter/material.dart';
import '../../widgets/responisve_builder.dart';
import 'mobile_login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MainLoginScreen extends StatefulWidget {
  static const String id = '/MainLoginScreen';
  const MainLoginScreen({Key? key}) : super(key: key);

  @override
  State<MainLoginScreen> createState() => _MainLoginScreenState();
}

class _MainLoginScreenState extends State<MainLoginScreen> {
  gettoken() async {
    var token = await FirebaseMessaging.instance.getToken();
    print(token.toString());
  }

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(mobile: MobileLoginPage());
  }
}
