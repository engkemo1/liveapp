import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stars_live/screens/settings_screen/settings_sub_screens/blocked_screen.dart';
import 'package:stars_live/screens/settings_screen/settings_sub_screens/languages.dart';
import 'package:stars_live/screens/settings_screen/settings_sub_screens/security/security.dart';

import '../../global/constants.dart';

class SettingsScreen extends StatelessWidget {
  static String id = '/settingsScreen';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'settings'.tr,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.toNamed(Security.id);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: DECORATION.copyWith(color: Colors.grey[300]),
                    margin: EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text('security'.tr),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context, builder: (context) => Languages());
                  },
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: DECORATION.copyWith(color: Colors.grey[300]),
                    margin: EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text('language'.tr),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed(BlockedScreen.id),
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: DECORATION.copyWith(color: Colors.grey[300]),
                    margin: EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text('blocked'.tr),
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
        ],
      ),
    );
  }
}
