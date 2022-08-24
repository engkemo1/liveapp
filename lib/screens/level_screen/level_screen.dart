import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stars_live/screens/level_screen/level_tabs/host_level_tab.dart';
import 'package:stars_live/screens/level_screen/level_tabs/user_level_tab.dart';
import '../../global/constants.dart';

class LevelScreen extends StatelessWidget {
  static String id = '/levelScreen';

  const LevelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: GRADIENT),
            ),
            titleSpacing: 0.0,
            centerTitle: true,
            title: Text(
              'level'.tr,
              style:
                  Get.theme.textTheme.headline5?.copyWith(color: Colors.white),
            ),
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            bottom: TabBar(indicatorColor: Colors.white, tabs: [
              Container(
                child: Text('user level'.tr),
                height: 40,
              ),
              Container(
                child: Text('host level'.tr),
                height: 40,
              ),
            ]),
          ),
          body: TabBarView(
            children: [
              Center(
                child: UserLevel(),
              ),
              Center(
                child: HostLevel(),
              ),
            ],
          )),
    );
  }
}

// Positioned(
// top: 150,
// left: Get.width * 0.1,
// right: Get.width * 0.1,
// child: Container(
// alignment: Alignment.center,
// padding: const EdgeInsets.only(
// top: 65,
// left: 10,
// right: 10,
// bottom: 10,
// ),
// decoration: BoxDecoration(
// color: Colors.white,
// borderRadius: BorderRadius.circular(25),
// boxShadow: const [
// BoxShadow(
// color: Colors.grey,
// blurRadius: 5,
// offset: Offset(1.0, 4.0),
// )
// ],
// ),
// width: Get.width * 0.8,
// height: Get.height * 0.3,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// 'Mohamed Abdelbasit',
// style: TextStyle(
// fontSize: 20.sp,
// ),
// ),
// Container(
// padding: const EdgeInsets.symmetric(
// horizontal: 8,
// vertical: 0,
// ),
// decoration: BoxDecoration(
// gradient: GRADIENT,
// borderRadius: BorderRadius.circular(25),
// ),
// child: Row(
// children: const [
// Icon(
// FontAwesomeIcons.solidStar,
// color: Color.fromARGB(255, 255, 230, 0),
// size: 10,
// ),
// SizedBox(
// width: 5,
// ),
// Text(
// '12',
// style: TextStyle(
// color: Colors.white,
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// const Text(
// 'ID: 64983274',
// ),
// const SizedBox(
// height: 20,
// ),
// const Divider(),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// InkWell(
// onTap: (){
// Get.toNamed(FansScreen.id,arguments: 'Friends');
// },
// child: Column(
// children: [
// Text(
// 'FRIENDS',
// style: TextStyle(
// color: Colors.grey[400],
// ),
// ),
// Text(
// '200',
// style: TextStyle(
// fontSize: 20.sp,
// ),
// ),
// ],
// ),
// ),
// InkWell(
// onTap: (){
// Get.toNamed(FansScreen.id,arguments: 'Following');
// },
// child: Column(
// children: [
// Text(
// 'FOLLOWING',
// style: TextStyle(
// color: Colors.grey[400],
// ),
// ),
// Text(
// '200',
// style: TextStyle(
// fontSize: 20.sp,
// ),
// ),
// ],
// ),
// ),
// InkWell(
// onTap: (){
// Get.toNamed(FansScreen.id,arguments: 'Fans');
// },
// child: Column(
// children: [
// Text(
// 'FANS',
// style: TextStyle(
// color: Colors.grey[400],
// ),
// ),
// Text(
// '200',
// style: TextStyle(
// fontSize: 20.sp,
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// ),
// Positioned(
// top: 100,
// left: Get.width * 0.34,
// right: Get.width * 0.35,
// child: CircleAvatar(
// backgroundColor: Colors.grey[200],
// radius: 60,
// ),
// ),
