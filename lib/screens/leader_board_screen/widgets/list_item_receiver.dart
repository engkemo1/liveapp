import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../global/constants.dart';
import '../../../widgets/user_info_bottom_sheet.dart';
import '../../../models/singl_user_model.dart';
import '../../../providers/top_receiver_provider.dart';


class ListItemReceiver extends StatelessWidget {
  const ListItemReceiver({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<TopReceiverProvider>(builder: (ctx, value, child) {
      return InkWell(
        onTap: () {
          Get.bottomSheet(
            UserInfoBottomSheet(
              user: User.fromJson(
                  value.receiver!.data!.elementAt(index).user!.toJson()),
              recieverID:
              value.receiver?.data?.elementAt(index).user?.id.toString() ??
                  '',
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${index + 1}', style: Get.theme.textTheme.headline6),
              SizedBox(
                width: 8,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(
                    '${value.receiver?.data?.elementAt(index).user?.image}'),
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
                        '${value.receiver?.data?.elementAt(index).user?.name}',
                        style: Get.theme.textTheme.headline6,
                      ),
                      Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                        decoration: levelsColor[(value.receiver?.data?.elementAt(index).user?.levelUser?.level/20).floor()>15?15:(value.receiver?.data?.elementAt(index).user?.levelUser?.level/20).floor()],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Icon(
                              FontAwesomeIcons.solidStar,
                              color: Color.fromARGB(255, 255, 230, 0),
                              size: 10,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${value.receiver?.data?.elementAt(index).user?.levelUser?.level}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Row(
                children: [
                  SvgPicture.asset('assets/images/coin.svg'),
                  Text(
                      '${value.receiver?.data?.elementAt(index).value}',
                      style: Get.theme.textTheme.subtitle2
                          ?.copyWith(color: Colors.red)),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
