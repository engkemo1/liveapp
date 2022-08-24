import 'package:flutter/material.dart';
import 'package:stars_live/utils/Cache_Helper.dart';

class LanguageProvider extends ChangeNotifier{


  void _changeLocale(String locale) async {
    await Cache_Helper.setData('lang', locale);
    notifyListeners();
  }

  void toEnglish() => _changeLocale('en');
  void toArabic() => _changeLocale('ar');

}