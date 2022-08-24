import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stars_live/utils/diohelper.dart';
import 'package:stars_live/models/user_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:stars_live/widgets/custom_widgets.dart';

class ProfileProvider extends ChangeNotifier
{

  Data? updatedDataUser;
  Future updateProfile(Map<String,String> updateData,String apiToken)async
  {
    try {
      var response = await DioHelper.setData(path: 'profile/update', data: updateData,auth: apiToken);
      if(response.statusCode==200)
      {
        updatedDataUser = Data.fromJson(response.data);
        print('updatedDataUser ' + (updatedDataUser?.id.toString()??''));
        notifyListeners();
      }

    } catch (error) {

      print(error.toString());
    }
  }
  bool uploadedImage = false;
  bool uploading = false;
  Future updateProfileImage(formData,String apiToken)async
  {
    try {
      uploadedImage = false;
      uploading=true;
      notifyListeners();
      var response = await Dio().post('http://starslive.club/public/api/profile/update',data: formData,options: Options(
          headers: {
            'contentType': 'multipart/form-data',
            'accept': 'application/json',
            'Authorization':apiToken
          }
      ));
      if(response.statusCode==200)
      {
        updatedDataUser = Data.fromJson(response.data);
        uploadedImage=true;
        uploading=false;
        print('updatedDataUser ' + (updatedDataUser?.id.toString()??''));
        notifyListeners();
      }

    } catch (error) {
      uploading=false;
      notifyListeners();
      print(error.toString());
    }
  }

  XFile? selectedImage;
  File? imageFile;

  Future<void> pickMessageImage(bool camera,apiToken) async {

    selectedImage =  (await ImagePicker().pickImage(source:camera?ImageSource.camera: ImageSource.gallery,imageQuality: 30))!;
    if (selectedImage != null) {
      {
        print('picked');
        imageFile = File(selectedImage!.path);
        String imageFileName = imageFile!.path.split('/').last;
        FormData formData = new FormData.fromMap({
          "image": await MultipartFile.fromFile(imageFile!.path,
              filename: imageFileName, contentType: new MediaType('image', 'png')),
          "type": "image/png"
        });
        updateProfileImage(formData,apiToken);
      }
    } else {
      print('something went wrong');
    }

  }




}