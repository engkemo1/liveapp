import 'package:flutter/material.dart';

import '../utils/diohelper.dart';
import '../models/top_gifts_model.dart';

class TopReceiverProvider extends ChangeNotifier{
  GiftModel? receiver;
  bool pressed = false;

  Future getReceivedGifts (String apiToken , String time) async
  {
    try{
      var response = await DioHelper.setData(path:'top/giftreceivers',auth: apiToken , data: {
        'time': time
      });
      if (response.statusCode == 200) {
        receiver = GiftModel.fromJson(response.data);
        print('hello from gift provider'+response.data.toString());
        print(receiver?.data?.first.user?.name);
        pressed = true;
        notifyListeners();
      }
    }catch(e)
    {
      print('error '+e.toString());
      notifyListeners();
    }
  }
}