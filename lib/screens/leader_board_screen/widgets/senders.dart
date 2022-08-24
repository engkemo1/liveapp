import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/models/singl_user_model.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/list_divider.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/list_item_sender.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/time_button.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/top_three.dart';
import '../../../global/constants.dart';
import '../../../widgets/user_info_bottom_sheet.dart';
import '../../../providers/top_sender_provider.dart';
import '../../../providers/user_provider.dart';

Widget senders(BuildContext context) {
  return Consumer<TopSenderProvider>(builder: (ctx, value, child) {
    String token = 'Bearer ' + GetStorage().read('api');

    print(token);
    if (value.sender == null) value.getSendGifts(token, "today");
    //print(value.sender?.data?.length);
    return value.sender != null
        ? Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: GRADIENT,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 55,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              timeButton(
                                  title: 'daily'.tr,
                                  onPress: () async {
                                    await value.getSendGifts(token, 'today');
                                  }),
                              timeButton(
                                  title: 'monthly'.tr,
                                  onPress: () async {
                                    await value.getSendGifts(
                                        token, 'this_month');
                                  }),
                              /*  timeButton(title: 'yearly'.tr, onPress: () async{
                                await value.getSendGifts(token, 'this_year');

                              }), */
                              timeButton(
                                  title: 'totally'.tr,
                                  onPress: () async {
                                    await value.getSendGifts(token, 'all');
                                  }),
                            ],
                          ),
                        ),
                      ),
                      value.sender != null
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    value.sender!.data!.length >= 3
                                        ? InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                  UserInfoBottomSheet(
                                                user: User.fromJson(value
                                                    .sender!.data!
                                                    .elementAt(2)
                                                    .user!
                                                    .toJson()),
                                                recieverID: value.sender!.data!
                                                    .elementAt(2)
                                                    .user!
                                                    .id
                                                    .toString(),
                                              ));
                                            },
                                            child: topThree(
                                              imgUrl:
                                                  '${value.sender?.data?.elementAt(2).user?.image}',
                                              coins:
                                                  '${value.sender?.data?.elementAt(2).value}',
                                              topNum: '3',
                                              userName:
                                                  '${value.sender?.data?.elementAt(2).user?.name}',
                                              level:
                                                  '${value.sender?.data?.elementAt(2).user?.levelUser?.level}',
                                              color:
                                                  Colors.white.withOpacity(.5),
                                              height: 132,
                                              outRadius: 43,
                                              innerRadius: 40,
                                              stackHeight: 35,
                                              stackWidth: 30,
                                              //user: value.sender?.data?.first.user??User(),
                                            ),
                                          )
                                        : topThree(
                                            imgUrl:
                                                'http://starslive.club/public/storage/users/default.png',
                                            coins: '0',
                                            topNum: '3',
                                            userName: '',
                                            level: '',
                                            color: Colors.white.withOpacity(.5),
                                            height: 132,
                                            outRadius: 43,
                                            innerRadius: 40,
                                            stackHeight: 35,
                                            stackWidth: 30,
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    value.sender!.data!.length >= 1
                                        ? InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                  UserInfoBottomSheet(
                                                user: User.fromJson(value
                                                    .sender!.data!
                                                    .elementAt(0)
                                                    .user!
                                                    .toJson()),
                                                recieverID: value.sender!.data!
                                                    .elementAt(0)
                                                    .user!
                                                    .id
                                                    .toString(),
                                              ));
                                            },
                                            child: topThree(
                                              imgUrl:
                                                  '${value.sender?.data?.elementAt(0).user?.image}',
                                              coins:
                                                  '${value.sender?.data?.elementAt(0).value}',
                                              topNum: '1',
                                              userName:
                                                  '${value.sender?.data?.elementAt(0).user?.name}',
                                              level:
                                                  '${value.sender?.data?.elementAt(0).user?.levelUser?.level}',
                                              color: Colors.amber,
                                              height: 155,
                                              outRadius: 53,
                                              innerRadius: 50,
                                              stackHeight: 35,
                                              stackWidth: 35,
                                            ),
                                          )
                                        : topThree(
                                            imgUrl:
                                                'http://starslive.club/public/storage/users/default.png',
                                            coins: '0',
                                            topNum: '1',
                                            userName: '',
                                            level: '',
                                            color: Colors.amber,
                                            height: 155,
                                            outRadius: 53,
                                            innerRadius: 50,
                                            stackHeight: 35,
                                            stackWidth: 35,
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    value.sender!.data!.length >= 2
                                        ? InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                  UserInfoBottomSheet(
                                                user: User.fromJson(value
                                                    .sender!.data!
                                                    .elementAt(1)
                                                    .user!
                                                    .toJson()),
                                                recieverID: value.sender!.data!
                                                    .elementAt(1)
                                                    .user!
                                                    .id
                                                    .toString(),
                                              ));
                                            },
                                            child: topThree(
                                              imgUrl:
                                                  '${value.sender?.data?.elementAt(1).user?.image}',
                                              coins:
                                                  '${value.sender?.data?.elementAt(1).value}',
                                              topNum: '2',
                                              userName:
                                                  '${value.sender?.data?.elementAt(1).user?.name}',
                                              level:
                                                  '${value.sender?.data?.elementAt(1).user?.levelUser?.level}',
                                              color: Colors.orange,
                                              height: 128,
                                              outRadius: 43,
                                              innerRadius: 40,
                                              stackHeight: 35,
                                              stackWidth: 35,
                                            ),
                                          )
                                        : topThree(
                                            imgUrl:
                                                'http://starslive.club/public/storage/users/default.png',
                                            coins: '0',
                                            topNum: '2',
                                            userName: '',
                                            level: '',
                                            color: Colors.orange,
                                            height: 128,
                                            outRadius: 43,
                                            innerRadius: 40,
                                            stackHeight: 35,
                                            stackWidth: 35,
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                if (value.sender!.data!.length > 3)
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    height: Get.size.height / 1.5,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView.separated(
                                      itemBuilder: (context, index) =>
                                          ListItemSender(
                                        index: 3 + index,
                                      ),
                                      separatorBuilder: (context, index) =>
                                          ListDivider(),
                                      itemCount: min(
                                          value.sender!.data!.length - 3, 47),
                                    ),
                                  ),
                              ],
                            )
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  });
}
