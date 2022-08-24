import 'package:flutter/cupertino.dart';
import 'package:stars_live/utils/diohelper.dart';
import 'package:stars_live/models/forward_model.dart';

class ForwardProvider extends ChangeNotifier
{
  ForwardModel? forwards;
  Future getAllForwards (String apiToken) async
  {
    try{
      var response = await DioHelper.setData(path: 'chargers/all',auth: apiToken, data: null);
      if (response.statusCode == 200) {
        forwards = ForwardModel.fromJson(response.data);
        print('hello from forward provider'+response.data.toString());
        print(forwards?.data?.first.name);
        notifyListeners();
      }
    }catch(e)
    {
      print('error '+e.toString());
      notifyListeners();
    }
  }
}