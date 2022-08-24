import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Widget that is displayed when local/remote video is disabled.
class CameraOff extends StatefulWidget {
  const CameraOff({Key? key}) : super(key: key);

  @override
  _CameraOffState createState() => _CameraOffState();
}

class _CameraOffState extends State<CameraOff> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      /* child: Center(
        child: Text('stars live'.tr,style: TextStyle(fontSize: 40,color:Colors.white),),
        // Image.network(
        //   'https://i.ibb.co/q5RysSV/image.png',
        // ),
      ), */
    );
  }
}
