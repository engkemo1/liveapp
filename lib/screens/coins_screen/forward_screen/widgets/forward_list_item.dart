import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/widgets/custom_container.dart';
import 'package:url_launcher/url_launcher.dart';

class ForwardListItem extends StatelessWidget {
  final String name;
  final String whats;
  final String image;
  final String index;
  const ForwardListItem({Key? key,required this.name, required this.whats,required this.image,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        openWhatsApp(context, whats);
      },
      child: CustomContainer(

        height: 70,
        decoration: DECORATION.copyWith(color: Colors.grey[200]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(index),
            SizedBox(width: 8,),
            CircleAvatar(
              backgroundImage: NetworkImage(image),
            ),
            SizedBox(width: 8,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,style: Get.theme.textTheme.subtitle2,maxLines: 1,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: 10),
                  Text('whats : '+whats,style: Get.theme.textTheme.caption,),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  openWhatsApp(context,String number) async{
    print(number);
    var whatsapp =number.split('00').last;
    var whatsappURl_android = "whatsapp://send?phone=$whatsapp";
    var whatappURL_ios = "https://wa.me/$whatsapp";
    if (Platform.isIOS) {
      // for iOS phone only
      try{
        await launch(whatappURL_ios, forceSafariVC: false);
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(e.toString())));
      }
    } else {
      // android , web
      try{
        await launch(whatsappURl_android);
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text(e.toString())));
      }
    }
  }
}
