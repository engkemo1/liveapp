import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/receivers.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/senders.dart';

import '../../providers/top_receiver_provider.dart';
import '../../providers/top_sender_provider.dart';


class LeaderBoard extends StatelessWidget {
  static String id = '/leaderboard';

  const LeaderBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TopReceiverProvider()),
        ChangeNotifierProvider(create: (context) => TopSenderProvider()),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(gradient: GRADIENT),
            ),
            titleSpacing: 0.0,
            centerTitle: true,
            title: Text(
              'leaderboard'.tr,
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
                child: Text("top gift senders".tr),
                height: 40,
              ),
              Container(
                child: Text("top gift receivers".tr),
                height: 40,
              ),
            ]),
          ),
          // appBar: new PreferredSize(
          //   child: new Container(
          //     child: Column(
          //       children: [
          //         Row(
          //           crossAxisAlignment: CrossAxisAlignment.end,
          //           //mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             IconButton(
          //               onPressed: () {
          //                 Get.back();
          //               },
          //               icon: const Icon(
          //                 Icons.arrow_back_ios,
          //                 color: Colors.white,
          //               ),
          //             ),
          //             SizedBox(width : Get.width/4),
          //             Container(
          //               child: Text(
          //                 'leaderboard'.tr,
          //                 style: Get.theme.textTheme.headline5
          //                     ?.copyWith(color: Colors.white),
          //               ),
          //             ),
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Container(
          //               height: 100,
          //               width: Get.width,
          //               child: TabBar(indicatorColor: Colors.white, tabs: [
          //                 Text("top gift senders".tr),
          //                 Text("top gift receivers".tr),
          //               ]),
          //             ),
          //           ],
          //         )
          //       ],
          //     ),
          //     decoration: new BoxDecoration(gradient: GRADIENT),
          //   ),
          //   preferredSize: new Size(Get.width, 150),
          // ),
          body: TabBarView(children: [
            senders(context),
            receivers(context),
          ]),

        ),
      ),
    );
  }
}
