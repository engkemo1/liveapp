import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/utils/Cache_Helper.dart';
import 'package:stars_live/global/functions.dart';
import 'package:stars_live/providers/forward_provider.dart';
import 'package:stars_live/providers/profile_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/widgets/custom_widgets.dart';

import '../../../../../global/constants.dart';



class ChangePasswordScreen extends StatefulWidget {
  static String id = '/changePasswordScreen';



  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmNewPassword = TextEditingController();
   GlobalKey<FormState> formKey = GlobalKey<FormState>();
   bool _oldPasswordVis = true;
   bool _newPasswordVis = true;
   bool _confirmNewPasswordVis = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ProfileProvider(),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  height: Get.height * 0.13,
                  decoration: const BoxDecoration(
                    gradient: GRADIENT,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Consumer<ProfileProvider>(
                          builder: (context,provider, child) {
                            return InkWell(
                                onTap: () {
                                  print(provider
                                      .updatedDataUser
                                      .toString());
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ));
                          },
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'change password'.tr,
                              style: Get.theme.textTheme.headline5
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,

                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: DECORATION.copyWith(color: Colors.grey[300]),
                        margin: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        //height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            obscureText: _oldPasswordVis,
                            controller: _oldPassword,
                            validator: (value){
                              return Functions.validatorPw(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'old password'.tr,
                              border: InputBorder.none,
                              suffixIcon: InkWell(
                                onTap: (){
                                  setState(() {
                                    _oldPasswordVis = !_oldPasswordVis;
                                  });
                                },
                                child: Icon(!_oldPasswordVis?Icons.visibility:Icons.visibility_off,color: Colors.grey,),
                              ),
                            ),
                          )
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: DECORATION.copyWith(color: Colors.grey[300]),
                        margin: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        //height: 50,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              obscureText: _newPasswordVis,
                              controller: _newPassword,
                              validator: (value){

                                return Functions.validatorPw(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'new password'.tr,
                                border: InputBorder.none,
                                suffixIcon: InkWell(
                                  onTap: (){
                                    setState(() {
                                      _newPasswordVis = !_newPasswordVis;
                                    });
                                  },
                                  child: Icon(!_newPasswordVis?Icons.visibility:Icons.visibility_off,color: Colors.grey,),
                                ),
                              ),
                            )
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: DECORATION.copyWith(color: Colors.grey[300]),
                        margin: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        //height: 50,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              obscureText: _confirmNewPasswordVis,
                              controller: _confirmNewPassword,
                              validator: (value){
                                return Functions.validatorPw(value);
                              },
                              decoration: InputDecoration(
                                hintText: 'confirm new password'.tr,
                                border: InputBorder.none,
                                suffixIcon: InkWell(
                                    onTap: (){
                                      setState(() {
                                        _confirmNewPasswordVis = !_confirmNewPasswordVis;
                                      });
                                    },
                                    child: Icon(!_confirmNewPasswordVis?Icons.visibility:Icons.visibility_off,color: Colors.grey,),
                                ),
                              ),
                            )
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: DECORATION.copyWith(color: Colors.amber[300]),
                        margin: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        height: 50,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Consumer<ProfileProvider>(
                              builder: (context, profileUpdate, child) {
                                return InkWell(
                                  onTap: (){
                                    String apiToken =  GetStorage().read('api');
                                    var password = Cache_Helper.getData('password');
                                    if(formKey.currentState!.validate()){
                                      if (password != null) {
                                        if (password == _oldPassword.text && _newPassword.text == _confirmNewPassword.text) {
                                          profileUpdate.updateProfile({'password':_newPassword.text}, 'Bearer '+apiToken);
                                          if(profileUpdate.updatedDataUser!=null)
                                            {
                                              Cache_Helper.setData('password', _newPassword.text);
                                              customSnackBar(text: 'changed', context: context);
                                            }else
                                            customSnackBar(text: 'something went wrong'.tr, context: context);

                                        } else
                                          customSnackBar(text: 'check password please'.tr, context: context);
                                      } else {
                                        customSnackBar(text: 'you logged in with google'.tr, context: context);
                                      }
                                    }
                                  },
                                  child: Center(child: Text('save'.tr,style: Get.theme.textTheme.headline6,),),
                                );
                              },
                            ),

                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
