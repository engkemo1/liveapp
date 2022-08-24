import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stars_live/global/constants.dart' as cons;
import 'package:stars_live/utils/diohelper.dart';

import '../models/game_model.dart';

class GuessGameProvider with ChangeNotifier {
  GameModel? _gameModel;
  Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
      },
    ),
  );

  Future<List<GameData>> getGamesList() async {
    try {
      final respond = await _dio.get(cons.Frames);
      _gameModel = GameModel.fromJson(respond.data);

      if (_gameModel!.status!.contains('ok') && _gameModel?.data != null) {
        var gamesList = _gameModel?.data;
        // print(gamesList?[1].teamOneName);
        gamesList!.sort((a, b) {
          return a.gameDate!.compareTo(b.gameDate!);
        });
        //IMPROVEMENT: sort by time
        _dio.clear();

        return gamesList;
      }
    } catch (err, startTrack) {
      print('game provider err : $err  - stackTrace : $startTrack');
    }
    _dio.clear();

    return <GameData>[];
  }

  Future betOnGame(int gameId, int amount, String team) async {
    try {
      /*    await _dio.post(
        cons.betOnGameUrl,
        data: {
          'game_id': '123',
          'amount': 'as',
          'team': 'teat',
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
          },
        ),
      ); */
      final response = await http.post(Uri.parse(cons.betOnGameUrl), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
      }, body: {
        'game_id': '$gameId',
        'amount': '$amount',
        'team': team,
      });

      // if (response.statusCode != 200) {
      //   print(response.statusCode);
      //   print(response.body);
      // }

      var responded_data = json.decode(response.body);
      String status = responded_data['status'];
      var data = responded_data['data'];
      String msg = responded_data['msg'];

      if (status.contains('ok')) {
        print(data);
      } else {
        //IMPROVEMENT: handle error status
        print(status);
      }
      return msg;
    } catch (err, startTrack) {
      print('game provider err : $err  - stackTrace : $startTrack');
    }

    // notifyListeners();
  }
}
