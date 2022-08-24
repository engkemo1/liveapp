import 'package:flutter/material.dart';

import '../../../models/message_model.dart';

Widget receiveMsg(MessageModel model) {
  return Align(
    alignment: AlignmentDirectional.bottomStart,
    child: Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      //margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(10),
          topEnd: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: model.text != ''
          ? Text(
              '${model.text}',
        textAlign: TextAlign.center,
      )
          : null,
    ),
  );
}
