import 'package:flutter/material.dart';
import '../../widgets/responisve_builder.dart';
import 'mobile_signup_page.dart';

class MainSignUpScreen extends StatelessWidget {
  static const String id = '/MainSignUpScreen';

  const MainSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ResponsiveBuilderScreen(
        mobile: MobileSignUpPage()
    );
  }
}
