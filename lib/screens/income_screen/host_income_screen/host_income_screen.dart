
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/models/user_model.dart';
import 'package:stars_live/providers/charge_information_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/income_screen/host_income_screen/widgets/ChargeNow.dart';
import 'package:stars_live/screens/income_screen/host_income_screen/widgets/UserDataCard.dart';
import 'package:stars_live/widgets/custom_container.dart';

import '../../../global/constants.dart';

class HostIncomeScreen extends StatelessWidget {
  static String id = '/hostIncomeScreen';

  const HostIncomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Data? user = Provider.of<UserProvider>(context).userData?.data?.first;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: GRADIENT
          ),
        ),
        titleSpacing: 0.0,
        centerTitle: true,
        title:  Text(
          'host income'.tr,
          style: Get.theme.textTheme.headline5
              ?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: (){Get.back();},
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => ChargeInformationProvider(),
        child: Consumer<ChargeInformationProvider>(
         builder: (context, value, child) {

           if(value.charges==null)
             {
               String api = 'Bearer '+(myApiToken??'');
               value.GetChargesInformation(apiToken:api );
             }
           return SingleChildScrollView(
             child: Column(
               children: [

                 UserDataCard(
                   charges : value.charges?.data?.transactions,
                   image:user?.image??'',
                   name: user?.name??'username'.tr,
                   id: user?.id.toString() ??'123',
                 ),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Icon(
                       FontAwesomeIcons.solidGem,
                       color: Colors.blue[500],
                       size: 15,
                     ),
                     SizedBox(
                       width: 5,
                     ),
                     Text(
                        '${user?.diamonds}',
                      ),
                     SizedBox(width: 20,),
                    ],
                 ),

                 SizedBox(
                   height: 60,
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 20),
                   child: CustomContainer(
                       height: 150,
                       decoration: DECORATION.copyWith(color: Colors.grey[200]),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           CustomContainer(
                               decoration: DECORATION.copyWith(color: Colors.white),
                               child: Row(
                                 children: [
                                   CircleAvatar(
                                     backgroundImage: NetworkImage(user?.image??''),
                                     radius: 20,
                                   ),
                                   SizedBox(width: 10,),
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text('remaining balance'.tr),
                                       Text(((user?.salary.toString()??'0')+' ' + 'USD'.tr),style: Get.theme.textTheme.caption,)
                                     ],
                                   )
                                 ],
                               )
                           ),
                           SizedBox(height: 10,),
                           CustomContainer(
                               decoration: DECORATION.copyWith(color: Colors.white),
                               child: Row(
                                 children: [
                                   CircleAvatar(
                                     backgroundImage: NetworkImage(user?.image??''),
                                     radius: 20,
                                   ),
                                   SizedBox(width: 10,),
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text('Amounts shipped during the month'.tr),
                                       Text(((user?.shiftTransferredUsd.toString()??'0')+' '+'USD'.tr),style: Get.theme.textTheme.caption,)
                                     ],
                                   )
                                 ],
                               )

                           )
                         ],
                       )
                   ),
                 ),
                 SizedBox(
                   height: 10,
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
                   child: ClipRRect(
                     borderRadius: BorderRadius.circular(12),
                     child: MaterialButton(
                       minWidth: Get.width,
                       height: 50,
                       onPressed: () {
                         showDialog(context: context, builder: (context)=>ChargeNow());
                       },
                       color: Colors.amber[400],
                       child: Text('Charge Now'.tr),
                     ),
                   ),
                 )
               ],
             ),
           );
         },
        ),
      ),
    );
  }
}
