import 'package:flutter/cupertino.dart';
import 'package:stars_live/models/charge_information_model.dart';

import '../utils/diohelper.dart';
import '../models/charge_model.dart';

class ChargeInformationProvider extends ChangeNotifier
{
  ChargeInformationModel? charges;
  Future GetChargesInformation({required apiToken,})async
  {
    print('hello from charge information provider');

    try{
      var response = await DioHelper.getData(path: 'user/my-info',auth: apiToken, );
      if (response.statusCode == 200) {
        print('from charge provider done '+ (response.data['msg']??'time is null'));

        charges= ChargeInformationModel.fromJson(response.data);
        print('from charge provider done '+ (charges?.status??'time is null'));
        //print('from charge provider done '+ (charges?.data?.transactions?.first.time??'time is null'));
        notifyListeners();
      }
    }catch(e)
    {
      print('error '+e.toString());
      notifyListeners();
    }
  }


}