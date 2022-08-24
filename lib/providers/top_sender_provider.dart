import 'package:flutter/material.dart';
import 'package:stars_live/models/top_gifts_model.dart';

import '../utils/diohelper.dart';

class TopSenderProvider extends ChangeNotifier{

  GiftModel? sender;

  Future getSendGifts (String apiToken , String time) async
  {
    try{
      var response = await DioHelper.setData(path:'top/giftsenders',auth: apiToken , data: {
        'time': time
      });
      if (response.statusCode == 200) {
        sender = GiftModel.fromJson(response.data);
        print('hello from gift provider'+response.data.toString());
        print(sender?.data?.first.user?.name);
        notifyListeners();
      }
    }catch(e)
    {
      print('error '+e.toString());
      notifyListeners();
    }
  }
}