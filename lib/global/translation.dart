
import 'package:get/get.dart';
import 'package:stars_live/utils/languages/ar.dart';
import 'package:stars_live/utils/languages/en.dart';

class Translation extends Translations
{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en' : en,
    'ar' : ar,
  };

}