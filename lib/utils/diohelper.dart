import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper {
  static Dio dio=Dio(BaseOptions(
    baseUrl: 'http://starslive.club/public/api/',
    receiveDataWhenStatusError: true,
  ),
  );


  static Future<Response> getData(
      {
        required String path,
        Map<String, dynamic>? query,
        String? token,
        String? auth
      }) async {
    dio.options.headers={
      'Accept': 'application/json',
      'Authorization':auth??''
    };
    return await dio.get(path, queryParameters: query??null);
  }

  static Future<Response> setData(
      {
        required String path,
        Map<String, dynamic>? query,
        required data,
        String? auth,
        bool image= false,
      }) async {
    dio.options.headers={
      'Accept':  'application/json',
      'Authorization':auth??'',

    };

    return await dio.post(
      path,
      data:data,
      queryParameters: query??null,
    );
  }

  static Future<Response> putData(
      {
        required String path,
        Map<String, dynamic>? query,
        required data,

      }) async {
    dio.options.headers={
      'Content-Type': 'application/json',
    };

    return await dio.put(
      path,
      data:data,
      queryParameters: query??null,
    );
  }


}