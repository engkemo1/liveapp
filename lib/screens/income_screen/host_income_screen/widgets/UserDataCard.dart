import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stars_live/models/charge_information_model.dart';
import 'package:stars_live/screens/income_screen/host_income_screen/widgets/Chargies.dart';

import '../../../../global/constants.dart';
import '../../../../widgets/custom_container.dart';

class UserDataCard extends StatelessWidget {
  final String name;
  final String id;
  final String image;
  final List<Transactions>? charges;

  const UserDataCard({Key? key,required this.image,required this.name,required this.id,this.charges}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(image),
            radius: 25,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Get.theme.textTheme.subtitle1,
              ),
              Text(
                'id: '.tr+id,
                style: Get.theme.textTheme.caption,
              ),
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
                showDialog(context: context, builder: (context)=>Charges(charges: charges,));
            },
            child: CustomContainer(
              height: 30,
              decoration: DECORATION,
              child: Text('charges'.tr),
            ),
          )
        ],
      ),
    );
  }
}
