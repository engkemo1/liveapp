import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomText extends StatelessWidget {
  final  String text;
  final int? maxLine;
  final TextStyle? style;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextDecoration? decoration;

  const CustomText({Key? key,this.decoration,required this.text, this.maxLine, this.style, this.overflow, this.fontSize, this.fontWeight, this.color,}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Text(
        text ,
        //textDirection: TextDirection.ltr,
        style: style ??  TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize ?? 15.0,
            fontWeight: fontWeight ,
            color: color,
            decoration: decoration ?? TextDecoration.none
        ),
        textScaleFactor: 1.0 ,
        maxLines: maxLine ?? 1 ,
        overflow: overflow ?? TextOverflow.ellipsis
    );
  }
}


ScaffoldMessengerState customSnackBar({
  required String text,
  required BuildContext context ,
  final BorderRadius? borderRadius ,
  final EdgeInsets? padding ,
  final Duration? duration ,
  final SnackBarAction? snackBarAction
}) {
  return ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
      SnackBar(
          content: CustomText(text: text),
          shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(0.0)),
          padding: padding ,
          duration: duration ?? const Duration(seconds: 1) ,
          action: snackBarAction
      ));
}


ScaffoldMessengerState customMaterialBanner({
  required BuildContext context ,
  required String text ,
  required List<Widget> actions ,
  Widget? leading
}) {
  return ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(MaterialBanner(
        leading: leading ,
        content: Text(text) ,
        actions: actions
    ));
}


Future<bool> customExitApp({required int exitCount}) async {


  if(exitCount<2){
    await Fluttertoast.showToast(
        msg: 'Press back again to exit',
        fontSize: 17.0 ,
      backgroundColor: Colors.red
    );
    return false;
  }else{
    await Fluttertoast.cancel();
    return true;
  }
}