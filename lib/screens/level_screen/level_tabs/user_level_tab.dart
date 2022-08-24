import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/level_screen/widgets/LevelCard.dart';
import 'package:stars_live/widgets/custom_container.dart';

import '../../../global/constants.dart';
import '../../../models/user_model.dart';

class UserLevel extends StatelessWidget {
  const UserLevel({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Data? user = context.read<UserProvider>().userData?.data?.first ;
    return Scaffold(
      body: LevelCard(
        title: user?.name.toString()??'username'.tr,
        image: user?.image??'',
        endLevel: ((user?.levelUser?.level??0)+1).toString(),
        nextLevel:user?.levelUser?.remaining.toString()??'0',
        startLevel: user?.levelUser?.level.toString()??'0',
        subtitle: user?.id.toString()??'123',
        XP: (user?.levelUser?.current + user?.levelUser?.value ?? 0) .toString(),
      ),
    );
  }
}
