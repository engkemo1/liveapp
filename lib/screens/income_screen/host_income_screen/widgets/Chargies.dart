import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/models/charge_information_model.dart';
import 'package:stars_live/widgets/custom_container.dart';

class Charges extends StatelessWidget {
  final List<Transactions>? charges;

  const Charges({Key? key, this.charges}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          'charges'.tr,
          style: Get.textTheme.headline6,
        ),
      ),
      content: SizedBox(
        height: Get.height / 2,
        child: charges == null || charges?.length==0
            ? Column(
                children: [
                  Text('there is no charges now'.tr),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )
            : ListView(
                physics: BouncingScrollPhysics(),
                children: List.generate(
                    charges?.length ?? 5,
                    (index) => Column(
                          children: [
                            Container(
                                //height: 270,
                                width: double.infinity,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.purple)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('username: '.tr +
                                        (charges?[index].to_name ??
                                            'username')),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('id: '.tr +
                                        (charges?[index].to_id ?? '1324')),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('coins'.tr +
                                        ': ' +
                                        (charges?[index].coins ?? 0)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('USD'.tr +
                                        ': ' +
                                        (charges?[index].usd.toString() ??
                                            '0')),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('date'.tr +
                                        (charges![index]
                                            .time!
                                            .split('T')
                                            .first)),
                                    
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('time'.tr +
                                        (charges![index]
                                            .time!
                                            .split('T')
                                            .last
                                            .split('.')
                                            .first)),
                                    SizedBox(
                                      height: 10,
                                    )
                                  ],
                                )),
                            SizedBox(
                              height: 15,
                            )
                          ],
                        )),
              ),
      ),
    );
  }
}
