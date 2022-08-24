import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stars_live/providers/chat_provider.dart';

class ShowCommentsProvider extends ChangeNotifier
{
  bool showComments = true;

  void toggleComments ()
  {
    showComments=!showComments;
    notifyListeners();
  }
}