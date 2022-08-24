import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/models/singl_user_model.dart';
import 'package:stars_live/providers/search_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/widgets/custom_widgets.dart';

import '../../global/constants.dart';
import '../../widgets/user_info_bottom_sheet.dart';
import '../../widgets/custom_appBar.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/text_form_field.dart';

class SearchScreen extends StatelessWidget {
  static String id = '/searchScreen';
  TextEditingController _searchContorller = TextEditingController();

  SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (context) => SearchProvider(),
        child: Column(
          children: [
            customAppBar(
              context: context,
              title: "title",
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomContainer(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: textField(
                                  controller: _searchContorller,
                                  hint: "search by id".tr,
                                  textInputAction: TextInputAction.unspecified,
                                  onSubmit: (String) {},
                                  maxCharacters: 100),
                            ),
                            Spacer(),
                            Consumer<SearchProvider>(
                                builder: (context, value, child) {
                              return IconButton(
                                  onPressed: () {
                                    _searchContorller.text = '';
                                    value.user?.data = null;
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.grey[700],
                                  ));
                            }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Consumer<SearchProvider>(
                      builder: (context, value, child) {
                        return InkWell(
                          onTap: () async {
                            String? apiToken = GetStorage().read('api');
                            await value.getUserById(_searchContorller.text,
                                'Bearer ' + (apiToken ?? ''));
                            if (value.user?.data == null ||
                                value.user?.data?.length == 0) {
                              customSnackBar(
                                text: 'invalid id'.tr,
                                context: context,
                              );
                            }
                          },
                          child: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Consumer<SearchProvider>(
              builder: (context, value, child) {
                if (value.user?.data != null &&
                    value.user?.data?.length != 0 &&
                    _searchContorller.text != '')
                  return InkWell(
                    onTap: () {
                      Get.bottomSheet(UserInfoBottomSheet(
                        user: User.fromJson(
                            value.user?.data?.first.toJson() ?? Map()),
                        recieverID: value.user?.data?.first.id.toString() ?? '',
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, right: 8, left: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      width: double.infinity,
                      decoration: DECORATION.copyWith(color: Colors.grey[300]),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(value
                                    .user?.data?.first.image ??
                                'https://www.testingtime.com/app/uploads/2020/12/in-house_research_2.png'),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.user?.data?.first.name ?? 'username'.tr,
                                style: Get.theme.textTheme.headline6,
                              ),
                              Text(
                                'id: '.tr +
                                    (value.user?.data?.first.id.toString() ??
                                        '123'),
                                style: Get.theme.textTheme.caption,
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  );
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
