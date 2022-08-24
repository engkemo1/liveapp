import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/audiance_screen/audiance.dart';
import '../global/constants.dart';
import '../models/user_model.dart';

class LiveItemWidget extends StatelessWidget {
  final Data user;

  LiveItemWidget({required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Audiance.id,
          arguments: {
            'channel': user.id.toString(),
            'name': user.name.toString(),
            'image': user.image.toString(),
            'id': user.id.toString(),
            'level': user.levelUser!.level.toString(),
            'hostLevel': user.levelHost!.level,
            'gifts': user.totalReceivedGifts ?? 0,
            'user': user.toJson(),
            'diamonds': user.diamonds,
            'sender': Provider.of<UserProvider>(context, listen: false)
                .userData
                ?.data
                ?.first,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1,
            )
          ],
          image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(
              user.image!,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              width: Get.width * 0.21,
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(2),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color.fromARGB(255, 163, 163, 163),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      user.name.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(25)),
                      child: Row(
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
                            user.levelHost!.level.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
