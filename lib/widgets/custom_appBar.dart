import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global/constants.dart';

Widget customAppBar({
  required BuildContext context ,
  required String title,
  required double height,
  required Widget child,

}){
  final double statusbarHeight = MediaQuery
      .of(context)
      .padding
      .top;
  return Container(
    padding: EdgeInsets.only(top: statusbarHeight),
    height: statusbarHeight + height,
    decoration: const BoxDecoration(
      gradient: GRADIENT,
    ),
    child: child,
  );
}