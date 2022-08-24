import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stars_live/providers/profile_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/screens/main_screen/main_screen_tabs/profile_tab.dart';

import '../../global/constants.dart';
import '../../utils/Cache_Helper.dart';
import '../../global/functions.dart';

class EditScreen extends StatelessWidget {
  EditScreen({Key? key}) : super(key: key);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String? name;
  String? country;
  String? gender;
  String? age;
  String? bio;

  var password = Cache_Helper.getData('password');
  var email = Cache_Helper.getData('email');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileProvider(),
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50),
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: GRADIENT,
                ),
                child: SingleChildScrollView(
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                        height: Get.size.height * 0.8,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer<UserProvider>(
                                builder: (context, value, child) {
                                  name = value.userData?.data?.first.name;
                                  return Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: DECORATION.copyWith(
                                        color: Colors.grey[300]),
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: double.infinity,
                                    //height: 50,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                            hintText: value.userData?.data
                                                    ?.first.name ??
                                                'username'.tr,
                                            border: InputBorder.none,
                                          ),
                                        )),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Consumer<UserProvider>(
                                builder: (context, value, child) {
                                  bio = value.userData?.data?.first.bio;

                                  return Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: DECORATION.copyWith(
                                        color: Colors.grey[300]),
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: double.infinity,
                                    //height: 50,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          controller: _bioController,
                                          decoration: InputDecoration(
                                            hintText: (value.userData?.data
                                                        ?.first.bio ==
                                                    '')
                                                ? 'bio'.tr
                                                : value
                                                    .userData?.data?.first.bio,
                                            border: InputBorder.none,
                                          ),
                                        )),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Consumer<UserProvider>(
                                builder: (context, value, child) {
                                  country = value.userData?.data?.first.country;
                                  return Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: DECORATION.copyWith(
                                        color: Colors.grey[300]),
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: double.infinity,
                                    //height: 50,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          controller: _countryController,
                                          decoration: InputDecoration(
                                            hintText: (value.userData?.data
                                                        ?.first.country ==
                                                    '')
                                                ? 'country'.tr
                                                : value.userData?.data?.first
                                                    .country,
                                            border: InputBorder.none,
                                          ),
                                        )),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Consumer<UserProvider>(
                                builder: (context, value, child) {
                                  gender = value.userData?.data?.first.gender;
                                  return Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: DECORATION.copyWith(
                                        color: Colors.grey[300]),
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: double.infinity,
                                    //height: 50,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          controller: _genderController,
                                          decoration: InputDecoration(
                                            hintText: (value.userData?.data
                                                        ?.first.gender ==
                                                    '')
                                                ? 'gender'.tr
                                                : value.userData?.data?.first
                                                    .gender,
                                            border: InputBorder.none,
                                          ),
                                        )),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Consumer<UserProvider>(
                                builder: (context, value, child) {
                                  var age = value.userData?.data?.first.age
                                      .toString();
                                  log(age!);
                                  return Container(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: DECORATION.copyWith(
                                        color: Colors.grey[300]),
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: double.infinity,
                                    //height: 50,
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          controller: _ageController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: (value.userData?.data
                                                        ?.first.age ==
                                                    0)
                                                ? 'age'.tr
                                                : value
                                                    .userData?.data?.first.age
                                                    .toString(),
                                            border: InputBorder.none,
                                          ),
                                        )),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xff6950FB),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Consumer<ProfileProvider>(
                                  builder: (context, value, child) {
                                    String? apiToken = GetStorage().read('api');
                                    return MaterialButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          await value.updateProfile({
                                            'name': _nameController.text,
                                            'country': (_countryController
                                                    .text.isEmpty)
                                                ? country!
                                                : _countryController.text,
                                            'gender':
                                                (_genderController.text.isEmpty)
                                                    ? gender!
                                                    : _genderController.text,
                                            'age': (_ageController.text.isEmpty)
                                                ? age!
                                                : _ageController.text,
                                            'bio': (_bioController.text.isEmpty)
                                                ? bio!
                                                : _bioController.text,
                                          }, 'Bearer ' + (apiToken ?? ''));

                                          if (value.updatedDataUser != null) {
                                            if (password != null) {
                                              context
                                                  .read<UserProvider>()
                                                  .getMyData();
                                            } else
                                              context
                                                  .read<UserProvider>()
                                                  .getMyData();

                                            Fluttertoast.showToast(
                                                msg: 'updated'.tr);
                                            Get.back();
                                          }
                                        }
                                      },
                                      child: Text(
                                        "save".tr,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Consumer<UserProvider>(
                        builder: (context, value, child) {
                          if (Provider.of<ProfileProvider>(context)
                              .uploadedImage) {
                            Provider.of<ProfileProvider>(context)
                                .uploadedImage = false;
                            value.getMyData();
                          }
                          String apiToken =
                              'Bearer ' + GetStorage().read('api');
                          ;
                          return Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 58,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      value.userData?.data?.first.image ?? ''),
                                  backgroundColor: Colors.grey,
                                  radius: 51,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showBottomSheet(
                                      context: context,
                                      builder: (context) => BottomSheetBuilder(
                                          context, apiToken));
                                },
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 18,
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Colors.grey,
                                        radius: 15,
                                      ),
                                    ),
                                    if (Provider.of<ProfileProvider>(context)
                                        .uploading)
                                      CircularProgressIndicator(
                                        color: basicColor,
                                      )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget BottomSheetBuilder(context, apiToken) {
    return Container(
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Provider.of<ProfileProvider>(context, listen: false)
                    .pickMessageImage(true, apiToken);

                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 10.0),
                    Text('camera'.tr)
                  ],
                ),
              ),
            ),
          ),
          Divider(
            height: 2.0,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Provider.of<ProfileProvider>(context, listen: false)
                    .pickMessageImage(false, apiToken);
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('gallery'.tr)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
