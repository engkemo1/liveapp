import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/models/follower_model.dart';
import 'package:stars_live/models/user_model.dart';
import 'package:stars_live/screens/fans_screen/widgets/list_users.dart';
import 'package:stars_live/widgets/custom_appBar.dart';
import 'package:stars_live/widgets/custom_container.dart';

import '../../global/constants.dart';
import '../../providers/user_provider.dart';

class FansScreen extends StatelessWidget {
  static String id = '/fansscreen';

  FansScreen({Key? key}) : super(key: key);
  String title = Get.arguments[0] as String;
  bool following = Get.arguments[1] as bool;
  List<Follower> myList=[];
  @override
  Widget build(BuildContext context) {

    Data? user = Provider.of<UserProvider>(context).userData?.data?.first;
    if(myList.length==0) {
      if (following) {
        myList = user?.followeds?.reversed.toList()??[];
      } else {
        myList = user?.followers?.reversed.toList()??[];
      }
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: GRADIENT
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        title:  Text(
          title,
          style: Get.theme.textTheme.headline5
              ?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: (){Get.back();},
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 15,),
            CustomContainer(
              height: Get.height *.8,
              alignmentGeometry: Alignment.topCenter,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(
                  myList.length,
                      (index) => users(
                          index: index,
                          followings:following?true:false ,
                          context: context,
                          user:myList[index],
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
