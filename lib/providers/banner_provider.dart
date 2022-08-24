import 'package:flutter/cupertino.dart';
import 'package:stars_live/models/banner_model.dart';

import '../utils/diohelper.dart';

class BannerProvider extends ChangeNotifier
{
  BannerModel? banners;
  BannerModel? followersBanners;
  Future getBanners(apiToken,query)async
  {
    try{
      var response = await DioHelper.getData(path: 'banners/get',auth: apiToken,query: query);
      if (response.statusCode == 200) {
        banners = BannerModel.fromJson(response.data) ;
        print('hello from forward provider'+response.data.toString());
        print(banners?.data?.first.name);
        notifyListeners();
      }
    }catch(e)
    {
      print('error '+e.toString());
      notifyListeners();
    }
  }

  Future getFollowersBanners(apiToken,query)async
  {
    try{
      var response = await DioHelper.getData(path: 'banners/get',auth: apiToken,query: query);
      if (response.statusCode == 200) {
        followersBanners = BannerModel.fromJson(response.data) ;
        print('hello from forward provider'+response.data.toString());
        print(followersBanners?.data?.first.name);
        notifyListeners();
      }
    }catch(e)
    {
      print('error '+e.toString());
      notifyListeners();
    }
  }
}