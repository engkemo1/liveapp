import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget timeButton({
  required String title,
  required  onPress
}){
  return  MaterialButton(
    onPressed: onPress,
    child: Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          borderRadius: BorderRadius.circular(25)),
      child: Text(
        title,
        style: Get.theme.textTheme.subtitle1
            ?.copyWith(color: Colors.white),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: 5),
    ),
  );
}