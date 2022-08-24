import 'package:flutter/material.dart';

Widget CustomContainer({
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10),
  AlignmentGeometry alignmentGeometry = Alignment.center,
  double height = 48,
  Decoration decoration = const BoxDecoration() ,
  Widget ? child,
  double ? width ,
}){
  return Container(
    padding: padding,
    width: width,
    alignment: alignmentGeometry,
    height: height,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: decoration,

    child: child,

  );
}