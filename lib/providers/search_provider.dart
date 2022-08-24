import 'package:flutter/cupertino.dart';
import 'package:stars_live/models/search_model.dart';

import '../utils/diohelper.dart';

class SearchProvider extends ChangeNotifier
{
  SearchModel? user;

  Future getUserById(String? id,String? apiToken)async
  {
    try {
      var response = await DioHelper.setData(path: 'user/get_by_id', data: {'user_id':id},auth: apiToken);
      if(response.statusCode==200)
      {
        user = SearchModel.fromJson(response.data);
        print('user id ' + (user?.data?.first.id.toString()??''));
        notifyListeners();
      }

    } catch (error) {
      print(error.toString());
    }
  }


}