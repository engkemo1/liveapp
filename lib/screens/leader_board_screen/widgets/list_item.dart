import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stars_live/global/constants.dart';

import '../../../widgets/custom_container.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({Key? key,required this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${index + 1}',style: Get.theme.textTheme.headline6),
          SizedBox(
            width: 8,
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png'),
            radius: 25,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('username'.tr,style: Get.theme.textTheme.headline6,),
              Row(
                children: [
                  SvgPicture.asset(
                      'assets/images/coin.svg'),
                  Text('165465',
                      style: Get.theme.textTheme.subtitle2?.copyWith(color: Colors.red)),
                ],
              )
            ],
          )),
          Row(
            children: [

              InkWell(onTap: (){}, child: SvgPicture.asset(assetsPath+'/chat.svg',)),
              SizedBox(width: 10,),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: InkWell(
                    onTap: () {},
                    child: CustomContainer(

                      decoration: BoxDecoration(color: Color(0xffB83AF3),),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      height: 30,
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    )
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
