import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/providers/language_provider.dart';

class Languages extends StatelessWidget {
  const Languages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LanguageProvider(),
        child: Consumer<LanguageProvider>(builder: (context, value, child) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('languages'.tr),
                Divider(
                  thickness: 1.5,
                  color: Colors.purple,
                ),
              ],
            ),
            content: SizedBox(
              height: Get.height / 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Center(
                        child: MaterialButton(
                      onPressed: () {
                        value.toEnglish();
                        Get.updateLocale(Locale('en'));
                        Navigator.pop(context);
                      },
                      minWidth: double.infinity,
                      child: Text(
                        'English',
                        style: Get.textTheme.headline6
                            ?.copyWith(color: Colors.white),
                      ),
                    )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: GRADIENT,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Center(
                        child: MaterialButton(
                          onPressed: () {
                            value.toArabic();
                            Get.updateLocale(Locale('ar'));
                            Navigator.pop(context);
                          },
                          minWidth: double.infinity,
                          child: Text(
                            'العربيه',
                            style: Get.textTheme.headline6
                                ?.copyWith(color: Colors.white),
                          ),
                        )),
                    decoration: BoxDecoration(
                      gradient: GRADIENT,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
