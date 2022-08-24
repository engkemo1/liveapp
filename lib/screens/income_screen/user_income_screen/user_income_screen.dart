import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/charge_provider.dart';
import 'package:stars_live/providers/user_provider.dart';

import '../../../global/constants.dart';
import '../../../global/functions.dart';
import '../../../models/user_model.dart';
import '../../../widgets/custom_widgets.dart';

class UserIncomeScreen extends StatelessWidget {
  static String id = '/userIncomeScreen';

  const UserIncomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: GRADIENT),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        title: Text(
          'user income'.tr,
          style: Get.theme.textTheme.headline5?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('total income'.tr),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.solidGem, color: Colors.blue, size: 15),
                SizedBox(
                  width: 20,
                ),
                Text(
                  context
                          .watch<UserProvider>()
                          .userData
                          ?.data
                          ?.first
                          .totalReceivedGifts
                          .toString() ??
                      '0',
                  style: TextStyle(color: Colors.amber, fontSize: 16),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(context
                    .watch<UserProvider>()
                    .userData
                    ?.data
                    ?.first
                    .diamonds
                    .toString() ??
                '0'),
          ),
          SizedBox(
            height: 10,
          ),
          ChangeNotifierProvider(
            create: (context) => ChargeProvider(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Consumer<ChargeProvider>(
                  builder: (context, value, child) {
                    return MaterialButton(
                      minWidth: Get.width,
                      height: 50,
                      onPressed: () async {
                        Data? user =
                            Provider.of<UserProvider>(context, listen: false)
                                .userData
                                ?.data
                                ?.first;
                        String api = (myApiToken ?? '');
                        if (user?.diamonds >= 1000) {
                          await value.Charge(
                              apiToken: 'Bearer ' + (api),
                              data: {'receiver_id': user?.id.toString()},
                              context: context);
                          if (value.chargeModel != null) {
                            if (value.chargeModel?.status != 'error') {
                              customSnackBar(
                                  text: 'Done successfully'.tr,
                                  context: context);
                              Functions.updateUserData(context);
                            } else {
                              customSnackBar(
                                  text: value.chargeModel?.msg ?? '',
                                  context: context);
                            }
                          } else
                            customSnackBar(
                                text: 'something went wrong'.tr,
                                context: context);

                          Get.back();
                        } else
                          Fluttertoast.showToast(
                            msg: 'you have no enough balance'.tr,
                          );
                      },
                      color: Colors.amber[400],
                      child: Text('withdraw'.tr),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
