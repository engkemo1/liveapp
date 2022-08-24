import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/models/user_model.dart';
import 'package:stars_live/widgets/live_item_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../global/constants.dart';
import '../../../models/follower_model.dart';
import '../../../providers/banner_provider.dart';
import '../../../providers/lives_provider.dart';
import '../../../providers/user_provider.dart';

class FavTab extends StatelessWidget {
  const FavTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final liveUsers = Provider.of<LivesProvider>(context);
    final myFollowings =
        Provider.of<UserProvider>(context).userData?.data?.first.followeds;
    List<Data> myFollowingsLives =
        getMyFollowingsLives(liveUsers.liveUsers.data, myFollowings);
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
            'follow'.tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Consumer<BannerProvider>(
              builder: (context, value, child) {
                if (value.followersBanners == null) {
                  value.getBanners('Bearer ' + (myApiToken ?? ''),
                      {'type': 'banner', 'place': 'followers'});
                }
                return value.banners != null
                    ? Container(
                        decoration: DECORATION,
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
              child: GridView.builder(
                itemCount: myFollowingsLives.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                padding: const EdgeInsets.all(5),
                itemBuilder: (contect, index) {
                  return LiveItemWidget(
                    user: myFollowingsLives[index],
                  );
                  //return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Data> getMyFollowingsLives(
      List<Data>? livesUsers, List<Follower>? myFollowings) {
    List<Data> myFollowingsLives = [];

    if (livesUsers != null && myFollowings != null) {
      Set<int> allLives = getLivesUsersIds(livesUsers);
      // Map<int, Data> allLivesMap= getLivesUsersAsMap(livesUsers);
      for (int i = 0; i < myFollowings.length; i++) {
        if (allLives.contains(myFollowings[i].id))
          myFollowingsLives.add(Data.fromJson(myFollowings[i].toJson()));
      }

      print('my followings lives count is ' +
          myFollowingsLives.length.toString());
    }

    return myFollowingsLives;
  }

  Set<int> getLivesUsersIds(List<Data> livesUsers) {
    Set<int> livesIds = {};
    livesUsers.forEach((element) {
      livesIds.add(element.id ?? -1);
    });

    return livesIds;
  }

  // Map<int, Data> getLivesUsersAsMap(List<Data> livesUsers) {
  //
  //   Map<int,Data> livesMap= {};
  //   livesUsers.forEach((element) {
  //     livesMap[element.id??-1]= element;
  //   });
  //
  //   return livesMap;
  // }
}
