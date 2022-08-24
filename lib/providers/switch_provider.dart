import 'package:flutter/material.dart';


class SwitchState extends ChangeNotifier{
  bool varSwitch = true;

  bool funcSwitch(){
    notifyListeners();
    return varSwitch = !varSwitch;
  }

  bool trueSwitch(){
    notifyListeners();
    return varSwitch = true;
  }

  bool falseSwitch(){
    notifyListeners();
    return varSwitch = false;
  }
}