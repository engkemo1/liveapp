import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/game_provider.dart';

import '../../global/constants.dart';
import 'games/guess_screen.dart';

class GamesScreen extends StatelessWidget {
  static String id = '/gamesScreen';

  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: GRADIENT),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        title: Text(
          'games'.tr,
          style: Get.theme.textTheme.headline5?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: InkWell(
                onTap: () {
                  Get.toNamed(GuessScreen.id);
                },
                child: Container(
                  width: Get.width * 0.5,
                  height: Get.height * 0.2,
                  decoration: BoxDecoration(
                      // gradient: GRADIENT,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/football.svg',
                          width: Get.width * 0.25,
                        ),
                        Text(
                          'guess game'.tr,
                          style: Get.textTheme.headline5
                              ?.copyWith(color: Colors.black),
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
