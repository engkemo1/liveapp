import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/providers/chat_provider.dart';
import 'package:stars_live/widgets/custom_container.dart';
import 'package:stars_live/widgets/text_form_field.dart';

import '../../../models/user_model.dart';
import '../../../widgets/gredient_send_icon.dart';

Widget typeMsg(
  int? id,
  Data? user,
  String receiverName,
  String receiverImage,
) {
  return Consumer<ChatProvider>(
    builder: (context, value, child) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CustomContainer(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(13.0),
                  topStart: Radius.circular(13.0),
                ),
              ),
              child: textField(
                  controller: value.msgController,
                  hint: "type a message .....".tr,
                  textInputAction: TextInputAction.send,
                  onSubmit: (String) {
                    if (value.msgController.text != '') {
                      value.sendMessage(
                        message: value.msgController.text,
                        receiverId: id.toString(),
                        uId: user?.id.toString(),
                        receiverImage: receiverImage,
                        receiverName: receiverName,
                        senderImage: user?.image,
                        senderName: user?.name,
                      );
                      value.msgController.text = '';
                    }
                  },
                  maxCharacters: 1000000),
            ),
          ),
          CustomContainer(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(13.0),
                topEnd: Radius.circular(13.0),
              ),
            ),
            child: InkWell(
              onTap: () {
                if (value.msgController.text != '') {
                  value.sendMessage(
                    message: value.msgController.text,
                    receiverId: id.toString(),
                    uId: user?.id.toString(),
                    receiverImage: receiverImage,
                    receiverName: receiverName,
                    senderImage: user?.image,
                    senderName: user?.name,
                  );
                  value.msgController.text = '';
                }
              },
              child: RadiantGradientMask(
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
