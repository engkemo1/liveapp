import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/list_divider.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/list_item_receiver.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/list_item_sender.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/time_button.dart';
import 'package:stars_live/screens/leader_board_screen/widgets/top_three.dart';
import '../../../global/constants.dart';
import '../../../widgets/user_info_bottom_sheet.dart';
import '../../../models/singl_user_model.dart';
import '../../../providers/top_receiver_provider.dart';
import '../../../providers/user_provider.dart';

Widget receivers(BuildContext context) {
  return Consumer<TopReceiverProvider>(builder: (ctx, value, child) {
    String token = 'Bearer ' + GetStorage().read('api');

    print(token);
    if (value.receiver == null) value.getReceivedGifts(token, "today");
    //print(value.receiver?.data?.length);
    return value.receiver != null
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
                                    await value.getReceivedGifts(
                                        token, "today");
                                  }),
                              timeButton(
                                  title: 'monthly'.tr,
                                  onPress: () async {
                                    await value.getReceivedGifts(
                                        token, "this_month");
                                  }),
                              /*  timeButton(
                                  title: 'yearly'.tr,
                                  onPress: () async {
                                    await value.getReceivedGifts(
                                        token, "this_year");
                                  }), */
                              timeButton(
                                  title: 'totally'.tr,
                                  onPress: () async {
                                    await value.getReceivedGifts(token, "all");
                                  }),
                            ],
                          ),
                        ),
                      ),
                      value.receiver != null
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
                                    value.receiver!.data!.length >= 3
                                        ? InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                  UserInfoBottomSheet(
                                                user: User.fromJson(value
                                                    .receiver!.data!
                                                    .elementAt(2)
                                                    .user!
                                                    .toJson()),
                                                recieverID: value
                                                    .receiver!.data!
                                                    .elementAt(2)
                                                    .user!
                                                    .id
                                                    .toString(),
                                              ));
                                            },
                                            child: topThree(
                                              imgUrl:
                                                  '${value.receiver?.data?.elementAt(2).user?.image}',
                                              coins:
                                                  '${value.receiver?.data?.elementAt(2).value}',
                                              topNum: '3',
                                              userName:
                                                  '${value.receiver?.data?.elementAt(2).user?.name}',
                                              level:
                                                  '${value.receiver?.data?.elementAt(2).user?.levelUser?.level}',
                                              color:
                                                  Colors.white.withOpacity(.5),
                                              height: 132,
                                              outRadius: 43,
                                              innerRadius: 40,
                                              stackHeight: 35,
                                              stackWidth: 30,
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
                                    value.receiver!.data!.length >= 1
                                        ? InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                  UserInfoBottomSheet(
                                                user: User.fromJson(value
                                                    .receiver!.data!
                                                    .elementAt(0)
                                                    .user!
                                                    .toJson()),
                                                recieverID: value
                                                    .receiver!.data!
                                                    .elementAt(0)
                                                    .user!
                                                    .id
                                                    .toString(),
                                              ));
                                            },
                                            child: topThree(
                                              imgUrl:
                                                  '${value.receiver?.data?.elementAt(0).user?.image}',
                                              coins:
                                                  '${value.receiver?.data?.elementAt(0).value}',
                                              topNum: '1',
                                              userName:
                                                  '${value.receiver?.data?.elementAt(0).user?.name}',
                                              level:
                                                  '${value.receiver?.data?.elementAt(0).user?.levelUser?.level}',
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
                                    value.receiver!.data!.length >= 2
                                        ? InkWell(
                                            onTap: () {
                                              Get.bottomSheet(
                                                  UserInfoBottomSheet(
                                                user: User.fromJson(value
                                                    .receiver!.data!
                                                    .elementAt(1)
                                                    .user!
                                                    .toJson()),
                                                recieverID: value
                                                    .receiver!.data!
                                                    .elementAt(1)
                                                    .user!
                                                    .id
                                                    .toString(),
                                              ));
                                            },
                                            child: topThree(
                                              imgUrl:
                                                  '${value.receiver?.data?.elementAt(1).user?.image}',
                                              coins:
                                                  '${value.receiver?.data?.elementAt(1).value}',
                                              topNum: '2',
                                              userName:
                                                  '${value.receiver?.data?.elementAt(1).user?.name}',
                                              level:
                                                  '${value.receiver?.data?.elementAt(1).user?.levelUser?.level}',
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
                                if (value.receiver!.data!.length > 3)
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
                                          ListItemReceiver(
                                        index: 3 + index,
                                      ),
                                      separatorBuilder: (context, index) =>
                                          ListDivider(),
                                      itemCount:
                                          value.receiver!.data!.length - 3,
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
