import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/models/user_model.dart';
import 'package:stars_live/providers/charge_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/widgets/custom_container.dart';
import 'package:stars_live/widgets/custom_form_field.dart';
import 'package:stars_live/widgets/custom_widgets.dart';

import '../../../../global/constants.dart';
import '../../../../global/functions.dart';

class ChargeNow extends StatelessWidget {
  TextEditingController idController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  ChargeNow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChargeProvider(),
      child: Consumer<ChargeProvider>(
        builder: (context, value, child) {
          return AlertDialog(
            content: SizedBox(
              height: Get.height / 2.5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Charge ID'.tr),
                    CustomFormField(
                      controller: idController,
                      label: 'id'.tr,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Charge amount'.tr),
                    CustomFormField(
                      controller: amountController,
                      label: 'Amount in USD'.tr,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (amountController.text != '' &&
                            idController.text != '') {
                          await value.Charge(
                              apiToken: 'Bearer ' + (myApiToken ?? ''),
                              data: {
                                'usd': amountController.text,
                                'receiver_id': idController.text
                              },
                              context: context);
                          if (value.chargeModel != null) {
                            if (value.chargeModel?.status != 'error') {
                              Functions.updateUserData(context);
                              customSnackBar(
                                  text: 'Done successfully'.tr,
                                  context: context);
                            } else {
                              customSnackBar(
                                  text: value.chargeModel?.msg!.tr ?? '',
                                  context: context);
                            }
                          } else
                            customSnackBar(
                                text: 'something went wrong'.tr,
                                context: context);

                          Get.back();
                        }
                      },
                      child: CustomContainer(
                          decoration: DECORATION, child: Text('charge'.tr)),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
