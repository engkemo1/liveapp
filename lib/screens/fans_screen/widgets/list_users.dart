import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/global/functions.dart';
import 'package:stars_live/models/follower_model.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/widgets/custom_container.dart';

import '../../../widgets/user_info_bottom_sheet.dart';
import '../../../models/singl_user_model.dart';

Widget users({
  required int index ,
  required Follower? user,
  required context,
  required bool followings
}){
  return InkWell(
    onTap: (){
      Get.bottomSheet(
          UserInfoBottomSheet(
            user: User.fromJson(user!.toJson()),
            recieverID: user.id.toString()
          ));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${index + 1}',
              style: Get.theme.textTheme.headline6),
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
                user?.image??'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png'),
            radius: 25,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name??'username'.tr,
                    style: Get.theme.textTheme.headline6,
                  ),
                  Text(
                    'ID: '+(user?.id.toString()??'12345'),
                    style: Get.theme.textTheme.caption,
                  ),
                ],
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              onTap: () {
                if(followings) {
                    Provider.of<UserProvider>(context, listen: false)
                        .unFollowUser(user?.id ?? 0);
                  } else
                Provider.of<UserProvider>(context,listen: false).followUser(user?.id??0);
                Functions.updateUserData(context);
              },
              child: CustomContainer(
                alignmentGeometry: Alignment.center,
                decoration: BoxDecoration(color: Color(0xffB83AF3),),

                height: 30,
                child: Icon(
                  myFollowingsIdss.contains(user?.id)?Icons.remove:
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ),
          )
        ],
      ),
    ),
  );
}