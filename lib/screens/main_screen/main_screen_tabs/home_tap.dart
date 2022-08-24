import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/providers/banner_provider.dart';
import 'package:stars_live/screens/leader_board_screen/leader_board_screen.dart';
import 'package:stars_live/screens/search_screen/search_screen.dart';
import 'package:stars_live/widgets/live_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../../providers/lives_provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveUsers = context.watch<LivesProvider>();

    return ChangeNotifierProvider(
      create: (context) => BannerProvider(),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: GRADIENT,
            ),
          ),
          centerTitle: true,
          title: Text(
            'home'.tr,
            style: Get.theme.textTheme.headline6?.copyWith(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Get.toNamed(LeaderBoard.id);
            },
            icon: const Icon(
              FontAwesomeIcons.crown,
              color: Colors.amber,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.toNamed(SearchScreen.id);
              },
              icon: const Icon(
                FontAwesomeIcons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Consumer<BannerProvider>(
              builder: (context, value, child) {
                if (value.banners == null) {
                  value.getBanners('Bearer ' + GetStorage().read('api'),
                      {'type': 'banner', 'place': 'trend'});
                }
                return value.banners != null
                    ? Container(
                        height: 100,
                        width: double.maxFinite,
                        padding: EdgeInsets.all(0),
                        child: CarouselSlider(
                            items: List.generate(
                                value.banners?.data?.length ?? 0,
                                (index) => Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          value.banners?.data
                                                  ?.elementAt(index)
                                                  .image ??
                                              '',
                                        ),
                                      )),
                                    )),
                            options: CarouselOptions(
                              aspectRatio: 16 / 9,
                              viewportFraction: 1.0,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            )),
                      )
                    : SizedBox();
              },
            ),
            Expanded(
              child: RefreshIndicator(
                color: Colors.black,
                onRefresh: () async {
                  await liveUsers.getLiveUsers();
                 //Fluttertoast.showToast(msg: 'refresh');
                },
                child: GridView.builder(

                  itemCount: liveUsers.liveUsers.data == null
                      ? 0
                      : liveUsers.liveUsers.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  padding: const EdgeInsets.all(5),
                  itemBuilder: (contect, index) {
                    return LiveItemWidget(
                      user: liveUsers.liveUsers.data![index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
