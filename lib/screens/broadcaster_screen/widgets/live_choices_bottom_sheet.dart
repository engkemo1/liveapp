import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/screens/broadcaster_screen/widgets/filter_view.dart';

import '../../../providers/lives_provider.dart';

class LiveChoicesBottomSheet extends StatefulWidget {
  final client, ref;
  RtcEngine engine;
  LiveChoicesBottomSheet(
      {Key? key, this.client, this.ref, required this.engine})
      : super(key: key);

  @override
  State<LiveChoicesBottomSheet> createState() => _LiveChoicesBottomSheetState();
}

class _LiveChoicesBottomSheetState extends State<LiveChoicesBottomSheet> {
  BeautyOptions option = BeautyOptions();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _muteMicButton(),
          // _disconnectCallButton(),
          _disableVideoButton(context),
          _switchCameraButton(),
          _BeautyMode(),
        ],
      ),
    );
  }

  Widget _muteMicButton() {
    return RawMaterialButton(
      onPressed: () {
        widget.client.sessionController.toggleMute();
        setState(() {});
      },
      child: Icon(
        widget.client.sessionController.value.isLocalUserMuted
            ? Icons.mic_off
            : Icons.mic,
        color: widget.client.sessionController.value.isLocalUserMuted
            ? Colors.white
            : Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: widget.client.sessionController.value.isLocalUserMuted
          ? Colors.blueAccent
          : Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  Widget _disconnectCallButton() {
    return RawMaterialButton(
      onPressed: () {
        resetData();
      },
      child: Icon(Icons.call_end, color: Colors.white, size: 35),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.redAccent,
      padding: const EdgeInsets.all(15.0),
    );
  }

  Widget _switchCameraButton() {
    return RawMaterialButton(
      onPressed: () {
        widget.client.sessionController.switchCamera();
        setState(() {});
      },
      child: Icon(
        Icons.switch_camera,
        color: Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  Widget _BeautyMode() {
    return RawMaterialButton(
      onPressed: () {
        Get.bottomSheet(FilterView(option: option, engine: widget.engine));
        setState(() {});
      },
      child: Icon(
        Icons.filter_none,
        color: Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  Widget _disableVideoButton(context) {
    return RawMaterialButton(
      onPressed: () {
        widget.client.sessionController.toggleCamera();

        setState(() {});
      },
      child: Icon(
        widget.client.sessionController.value.isLocalVideoDisabled
            ? Icons.videocam_off
            : Icons.videocam,
        color: widget.client.sessionController.value.isLocalVideoDisabled
            ? Colors.white
            : Colors.blueAccent,
        size: 20.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: widget.client.sessionController.value.isLocalVideoDisabled
          ? Colors.blueAccent
          : Colors.white,
      padding: const EdgeInsets.all(12.0),
    );
  }

  /// Default functionality of disconnect button is such that it pops the view and navigates the user to the previous screen.
  resetData() async {
    Provider.of<LivesProvider>(context, listen: false).setUserUnLive();
    await widget.ref.remove();
    await widget.client.sessionController.endCall();
    widget.client.sessionController.dispose();
    Get.back();
    Get.back();
  }
}
