import 'package:flutter/material.dart';
import 'package:stars_live/models/message_model.dart';

import '../../../global/constants.dart';

Widget sendMsg (MessageModel model){
  return Align(
    alignment: AlignmentDirectional.bottomEnd,
    child: Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      //margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: GRADIENT,
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomStart: Radius.circular(10),
        ),
      ),
      child: Text(
        '${model.text}',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}