import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:stars_live/models/singl_user_model.dart';

import '../../../global/constants.dart';
import '../../../widgets/user_info_bottom_sheet.dart';

Widget topThree({
  String? imgUrl,
  String? topNum,
  String? userName,
  String? level,
  String? coins,
  Color? color,
  double? height,
  double? outRadius,
  double? innerRadius,
  double? stackWidth,
  double? stackHeight,
}) {
  return Column(
    children: [
      Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            height: height, //132,
            child: CircleAvatar(
              radius: outRadius, //43,
              backgroundColor: color,
              //Colors.white.withOpacity(.5),
              child: CircleAvatar(
                backgroundImage: NetworkImage('$imgUrl'),
                radius: innerRadius, //40,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/crown_gold.svg',
                width: stackWidth, //30,
                height: stackHeight, //35,
                color: color,
              ),
              Text(
                '$topNum',
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (level == '')
              ? Container()
              : Container(
                  width: 70,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 0,
                  ),
                  decoration: levelsColor[
                      (int.parse(level ?? '0') / 20).floor() > 15
                          ? 15
                          : (int.parse(level ?? '0') / 20).floor()],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.solidStar,
                        color: Color.fromARGB(255, 255, 230, 0),
                        size: 10,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '$level',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
          Container(
            width: 90,
            child: Center(
              child: Text(
                '$userName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.theme.textTheme.headline6
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (level == '')
                  ? Container(
                      height: 40,
                    )
                  : SvgPicture.asset('assets/images/coin.svg'),
              SizedBox(
                width: 5,
              ),
              (level == '')
                  ? Container()
                  : Text(
                      '$coins',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.theme.textTheme.subtitle2
                          ?.copyWith(color: Colors.white),
                    ),
            ],
          ),
        ],
      )
    ],
  );
}
