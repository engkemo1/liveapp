import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../models/blockedUser_model.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../global/constants.dart';
import '../../../widgets/blocked_screen/blocked_user_item.dart';

class BlockedScreen extends StatelessWidget {
  static String id = '/blockedScreen';

  const BlockedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 30),
            height: Get.height * 0.13,
            decoration: const BoxDecoration(
              gradient: GRADIENT,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                  Expanded(
                    child: Center(
                      child: Text(
                        'blocked'.tr,
                        style: Get.theme.textTheme.headline5
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            // height: Get.height / 1.5,
            height: Get.height * 0.8,
            child: FutureBuilder<List<Data>>(
              future: userProvider.getBlockedUserList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var blockedListRespond = snapshot.data;
                  if (blockedListRespond != null &&
                      blockedListRespond.length > 0) {
                    return ListView.builder(
                      itemCount: blockedListRespond.length,
                      itemBuilder: (ctx, index) => BlockedUserItem(
                        userId: blockedListRespond[index].id!,
                        profileImageUrl: blockedListRespond[index].image!,
                        username: blockedListRespond[index].name!,
                      ),
                    );
                  } else {
                    return Center(
                        child: Text(
                      'You don\'t have any blocked user.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.purple),
                    ));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
