import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../forward_screen/forward_screen.dart';

class CoinsListItem extends StatelessWidget {
  final int index;

  CoinsListItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final Map<String, String> amountAndPrices = {
    '286': '1',
    '2860': '10',
    '7150': '25',
    '14300': '50',
    '28600': '100',
    '57200': '200',
    '143000': '500',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: Get.width,
      height: 50,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/coin.svg',
            height: 20,
            width: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              amountAndPrices.entries.elementAt(index).key,
              style: TextStyle(fontSize: 16),
            ),
          ),



          InkWell(
        onTap:(){Get.to(ForwardScreen());},
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              height: 25,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Text(
                amountAndPrices.values.elementAt(index) + '\$',
                style: Get.theme.textTheme.bodyText2
                    ?.copyWith(color: Colors.black),
              )),
            ),
          )
        ],
      ),
    );
  }
}
