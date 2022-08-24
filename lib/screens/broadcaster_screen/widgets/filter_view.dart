import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterView extends StatelessWidget {
  BeautyOptions option;
  RtcEngine engine;

  FilterView({required this.option, required this.engine, Key? key})
      : super(key: key);

  _clearFilter() {
    option.lighteningContrastLevel = LighteningContrastLevel.Normal;
    option.lighteningLevel = 0.7;
    option.rednessLevel = 0.1;
    option.smoothnessLevel = 0.5;
  }

  Size? screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return buildUI(context);
  }

  buildUI(BuildContext context) {
    return StatefulBuilder(builder: (ctx, state) {
      return Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        height: screenSize!.height / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Customize your Filter'.tr,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          option = BeautyOptions();
                          _clearFilter();
                          engine.setBeautyEffectOptions(false, option);
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'.tr)),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          engine.setBeautyEffectOptions(true, option);
                          Navigator.of(context).pop();
                        },
                        child: Text('apply'.tr)),
                  ],
                ),
                // option.lighteningContrastLevel = LighteningContrastLevel
              ],
            ),
            const SizedBox(height: 5),
            Text(
              "Lightening Contrast Level".tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: option.lighteningContrastLevel ==
                              LighteningContrastLevel.Normal
                          ? Colors.grey[300]
                          : Colors.transparent),
                  onPressed: () {
                    option.lighteningContrastLevel =
                        LighteningContrastLevel.Normal;
                    state(() {});
                  },
                  child: Text('Noraml'.tr),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: option.lighteningContrastLevel ==
                              LighteningContrastLevel.Low
                          ? Colors.grey[300]
                          : Colors.transparent),
                  onPressed: () {
                    option.lighteningContrastLevel =
                        LighteningContrastLevel.Low;
                    state(() {});
                  },
                  child: Text('Low'.tr),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: option.lighteningContrastLevel ==
                              LighteningContrastLevel.High
                          ? Colors.grey[300]
                          : Colors.transparent),
                  onPressed: () {
                    option.lighteningContrastLevel =
                        LighteningContrastLevel.High;
                    state(() {});
                  },
                  child: Text('High'.tr),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Redness Level".tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Slider(
              value: option.rednessLevel ?? 0,
              min: 0,
              max: 1.0,
              onChanged: (value) {
                state(() {
                  option.rednessLevel = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Lightening Level".tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Slider(
              value: option.lighteningLevel ?? 0,
              min: 0,
              max: 1.0,
              onChanged: (value) {
                state(() {
                  option.lighteningLevel = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Smoothness Level".tr,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Slider(
              value: option.smoothnessLevel ?? 0,
              min: 0,
              max: 1.0,
              onChanged: (value) {
                state(() {
                  option.smoothnessLevel = value;
                });
              },
            ),
          ],
        ),
      );
    });
  }
}
