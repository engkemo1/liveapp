import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stars_live/widgets/custom_container.dart';

import '../../../../global/constants.dart';

class ChargeConfirmation extends StatelessWidget {
  final String name ;
   const ChargeConfirmation({Key? key,required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: Get.height/2.5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Do you want to charge for '.tr +name),
            InkWell(
              onTap: (){},
              child: CustomContainer(
                  decoration: DECORATION,
                  child: Text('charge'.tr)
              ),
            )
          ],
        ),
      ),
    );
  }
}
