import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/profile_provider.dart';

import '../../../../global/constants.dart';
import '../languages.dart';
import 'change_password_screen/change_password_screen.dart';

class Security extends StatelessWidget {
  static String id = '/securityScreen';

  const Security({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
       create: (context) => ProfileProvider(),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 30),
              height: Get.height * 0.13,
              decoration: const BoxDecoration(
                gradient: GRADIENT,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                    Expanded(
                      child: Center(
                        child: Text(
                          'security'.tr,
                          style: Get.theme.textTheme.headline5
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,

            ),
            InkWell(
              onTap: (){
                Get.toNamed(ChangePasswordScreen.id);
              },
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: DECORATION.copyWith(color: Colors.grey[300]),
                margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Text('change password'.tr),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
