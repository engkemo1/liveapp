import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stars_live/global/constants.dart';
import 'package:stars_live/models/gift_model.dart';
import 'package:path/path.dart' as p;

class GiftsProvider extends ChangeNotifier {
  List<Gift> gifts = [];

  String getExt(String fullUrl) => p.extension(fullUrl);

  Future<String> createFullPath(String filename) async {
    var appStorge = await getApplicationDocumentsDirectory();

    String fullPath = '${appStorge.path}/gift/$filename';

    final savedDir = Directory('${appStorge.path}/gift/');
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return fullPath;
  }

  Future<bool> _checkIfFileExist(String filename) async {
    var path = await createFullPath(filename);
    var file = File(path);
    // log(file.path);
    var isExist = await file.exists();
    return isExist;
  }

  /* Future<File?> downloadSingleFilewithDownload() async {
    var rootPath = await getApplicationDocumentsDirectory();

    var filePath = '${rootPath.path}/pics/among.png';
    var url =
        'https://www.pngplay.com/wp-content/uploads/13/Pngpix-PNG-Photos.png';

    try {
      final rsponse = await Dio().download(
        url,
        filePath,
        deleteOnError: true,
      );

      var file = File(filePath);

      log(rsponse.data.toString());

      return file;
    } catch (err, starstack) {
      log('gift providerrrrrrrrrrrrr : err: $err stacktrace : $starstack');
      return null;
    }
  } */

/* 
  Future<File?> downloadSingleFilewithGet() async {
    var rootPath = await getApplicationDocumentsDirectory();
    var filePath = '${rootPath.path}/image/img2.png';
    var url =
        'http://starslive.club/public/storage/gifts/March2022/ed9ezwnAJRqwjccRltCs.png';

    // var isExist = await file.exists();
    final savedDir = Directory('${rootPath.path}/gift/');
    // final savedDir = Directory(filePath);
    var exist = await savedDir.exists();
    if (!exist) {
      await savedDir.create();
    }
    try {
      final rsponse = await Dio().get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      log(rsponse.data.toString());

      File file = File(filePath);
      var raf = file.openSync(mode: FileMode.write);

      raf.writeByteSync(rsponse.data);
      await raf.close();
      return file;
    } catch (err, starstack) {
      log('gift providerrrrrrrrrrrrr : err: $err stacktrace : $starstack');
      return null;
    }
  }

 */

  Future<File?> _downloadSingleFile(String url, String filename) async {
    String urlExt = getExt(url);
    String filePath = await createFullPath(filename + urlExt);
    try {
      await Dio().download(
        url,
        filePath,
        deleteOnError: true,
      );

      File file = File(filePath);

      return file;
    } catch (e, stacktrace) {
      log('gift provider : err: $e stacktrace : $stacktrace');
    }
    return null;
  }

  Future<void> _checkFromApiOrCache(/* List<Gift> gifts */) async {
    if (gifts.length > 0) {
      gifts.forEach((gift) async {
        var filename = '${gift.id}';
        String urlExtPhoto = getExt(gift.image!);
        bool isImgExist = await _checkIfFileExist(filename + urlExtPhoto);
        if (!isImgExist) {
          log('get this image from api, file exist : $isImgExist');
          var cachedImage = await _downloadSingleFile(gift.image!, filename);
          if (cachedImage != null) {
            gift.cachedImgPath = cachedImage.path;
          }
        } else {
          var imgPath = await createFullPath(filename + urlExtPhoto);
          gift.cachedImgPath = imgPath;
          log('get this image from cache, file exist : $isImgExist , image path :${gift.cachedImgPath}');
        }

        if (gift.videoLink != null && gift.videoLink!.trim().isNotEmpty) {
          var videoName = '${gift.id}-video';
          String urlExtVideo = getExt(gift.videoLink!);
          bool isVideoExist = await _checkIfFileExist(videoName + urlExtVideo);
          if (!isVideoExist) {
            log('get this video from api, file exist : $isVideoExist');
            var cachedVideo =
                await _downloadSingleFile(gift.videoLink!, videoName);
            gift.cachedVidPath = cachedVideo?.path;
            log('cached video link ${cachedVideo?.path} ');
          } else {
            var videoPath = await createFullPath(videoName + urlExtVideo);
            gift.cachedVidPath = videoPath;
            log('get this video from cache, file exist : $isVideoExist , video path :${gift.cachedVidPath}');
          }
        }
      });
    } else {
      log('gifts list is empty');
      return;
    }
  }

  Gift getGiftById(int giftId) {
    final existingGiftIndex = gifts.indexWhere((gift) => gift.id == giftId);
    var existingGift = gifts[existingGiftIndex];
    return existingGift;
  }

  Future<List<Gift>?> getAllGifts() async {
    log('request all gifts list from api');
    try {
      final response = await Dio().post(getGiftsURL,
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
            },
          ));

      gifts.clear();
      response.data['data'].forEach((item) {
        if (item != null) {
          Gift gift = Gift.fromJson(item);
          gifts.add(gift);
          //TODO: Check If gift Updated

        }
      });

      await _checkFromApiOrCache(/* gifts */);
      log('all resouces done');

      notifyListeners();
      return gifts;
    } catch (e, stacktrace) {
      log('gift provider err : $e stacktrace: $stacktrace');
    }
    return null;
  }

  bool sendSuccess = false;
  Future<void> sendGift(Gift gift, userID) async {
    // notifyListeners();
    try {
      final dio = Dio();
      dio.options = BaseOptions(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${GetStorage().read('api') ?? ''}',
        },
      );
      //Fluttertoast.showToast(msg: 'loading');
      var response = await dio.post(
        sendGiftURL,
        data: {
          'receiver_id': userID,
          'gift_id': gift.id,
          'gift_number': 1,
        },
      );
      log(response.data.toString());
      // Fluttertoast.showToast(msg: 'done');
      updateSendSuccuess(true);
      notifyListeners();
    } catch (e) {
      //Fluttertoast.showToast(msg: 'wrong');
      updateSendSuccuess(false);
      log(e.toString());
    }
  }

  void updateSendSuccuess(bool val) {
    sendSuccess = val;
    // Fluttertoast.showToast(msg: 'send success upadated');
    notifyListeners();
  }
}
