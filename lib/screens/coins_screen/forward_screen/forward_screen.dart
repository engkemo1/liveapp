import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/coins_screen/forward_screen/widgets/forward_list_item.dart';
import '../../../providers/forward_provider.dart';

class ForwardScreen extends StatelessWidget {
  static String id = '/diamondsScreen';

  const ForwardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ForwardProvider(),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: GRADIENT
            ),
          ),
          titleSpacing: 0.0,
          centerTitle: true,
          title:  Text(
            'forward'.tr,
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(height: 15,),
            Consumer<ForwardProvider>(
              builder: (context, value, child) {
                String token = 'Bearer '+ GetStorage().read('api');;
                print(token);
                if(value.forwards==null)
                value.getAllForwards(token);
                return value.forwards!=null ? Container(
                  height: Get.height / 1.5,
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) => ForwardListItem(
                        name: value.forwards?.data?.elementAt(index).name??'username',
                        index: (index + 1).toString(),
                        whats: value.forwards?.data?.elementAt(index).whats??'0123456789',
                        image: value.forwards?.data?.elementAt(index).avatar??'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png',
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 10,
                      ),
                      itemCount: value.forwards?.data?.length??0),
                ): Center(
                  child: CircularProgressIndicator(
                    color: basicColor,
                  ),
                );
              },

            )
          ],
        ),
      ),
    );
  }
}
