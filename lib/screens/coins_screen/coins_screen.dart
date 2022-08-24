import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/coins_screen/forward_screen/forward_screen.dart';
import 'package:stars_live/screens/coins_screen/widgets/coins_list_item.dart';

class CoinsScreen extends StatelessWidget {
  static String id = '/diamondsScreen';

  const CoinsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'coins'.tr,
          style: Get.theme.textTheme.headline5
              ?.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/coin.svg',
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  context.read<UserProvider>().userData?.data?.first.balanceInCoins.toString()??'0',
                  style: TextStyle(color: Colors.amber, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: MaterialButton(
                      onPressed: () {
                        Get.to(ForwardScreen());
                      },
                      child: Text(('forward'.tr)),
                      color: Colors.amberAccent,
                    )),
                SizedBox(
                  width: 8,
                ),
                Icon(Icons.arrow_back),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              height: Get.height/1.8,
              child: ListView(
                padding: EdgeInsets.zero,
                children: List.generate(
                  7,
                      (index) => InkWell(onTap:(){Get.to(ForwardScreen());},child: CoinsListItem(index: index)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
