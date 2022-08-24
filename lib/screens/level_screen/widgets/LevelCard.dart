import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global/constants.dart';
import '../../../widgets/custom_container.dart';

class LevelCard extends StatelessWidget {
  final String image;
  final String startLevel;
  final String endLevel;
  final String XP;
  final String nextLevel;
  final String title;
  final String subtitle;

  const LevelCard(
      {Key? key,
      required this.title,
      required this.image,
      required this.endLevel,
      required this.nextLevel,
      required this.startLevel,
      required this.subtitle,
      required this.XP,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        height: Get.height / 2,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: CustomContainer(
                  height: (Get.height / 2) / 1.5,
                  decoration: DECORATION.copyWith(color: Colors.grey[200]),
                  padding: EdgeInsets.only(top: 55),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: Get.theme.textTheme.bodyText2
                            ?.copyWith(fontSize: 20),
                      ),
                      Text(
                        'id: '.tr+subtitle,
                        style:
                            Get.theme.textTheme.caption?.copyWith(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text('Lv.'+startLevel),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Divider(
                                height: 3,
                                thickness: 3.0,
                                color: Colors.black,
                              ),
                            )),
                            Text('Lv.'+endLevel)
                          ],
                        ),
                      ),
                      Text('my xp: '.tr+XP),
                      Text('to next level: '.tr+nextLevel),
                    ],
                  )),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(image),
              backgroundColor: Colors.grey[300],
              radius: 60,
            ),
          ],
        ));
  }
}
