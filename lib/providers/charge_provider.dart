import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/diohelper.dart';
import '../models/charge_model.dart';

class ChargeProvider extends ChangeNotifier {
  ChargeModel? chargeModel;
  Future Charge({required apiToken, required data, required context}) async {
    try {
      var response = await DioHelper.setData(
          path: 'user/send_coins', auth: apiToken, data: data);
      if (response.statusCode == 200) {
        chargeModel = ChargeModel.fromJson(response.data);
        print('from charge provider done');
        log('charge ${response.data}');
        // Fluttertoast.showToast(msg: 'charge done'.tr);
        notifyListeners();
      }
    } catch (e) {
      print('error ' + e.toString());
      notifyListeners();
    }
  }

  Future getAllCharges() async {
    // try{
    //   var response = await DioHelper.getData(path: 'user/my-info',auth: apiToken, );
    //   if (response.statusCode == 200) {
    //     chargeModel = ChargeModel.fromJson(response.data);
    //     print('from charge provider done');
    //     notifyListeners();
    //   }
    // }catch(e)
    // {
    //   print('error '+e.toString());
    //   notifyListeners();
    // }
  }
}
