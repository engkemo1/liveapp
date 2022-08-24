import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/user_provider.dart';

import '../../global/constants.dart';
import '../custom_container.dart';

class BlockedUserItem extends StatelessWidget {
  final int userId;
  final String profileImageUrl;
  final String username;

  const BlockedUserItem({
    required this.userId,
    required this.username,
    required this.profileImageUrl,
    Key? key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, right: 8, left: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      decoration: DECORATION.copyWith(color: Colors.grey[300]),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              username,
              style: Get.theme.textTheme.headline6?.copyWith(color: Colors.red),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: () => Provider.of<UserProvider>(context, listen: false)
                  .unBlockUser(userId),
              child: CustomContainer(
                alignmentGeometry: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffB83AF3),
                ),
                height: 30,
                child: Text(
                  'un block'.tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
