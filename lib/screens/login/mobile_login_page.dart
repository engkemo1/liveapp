import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/auth_provider.dart';
import 'package:stars_live/utils/Cache_Helper.dart';
import 'package:stars_live/providers/login_provider.dart';
import 'package:stars_live/providers/social_login_provider.dart';
import 'package:stars_live/providers/user_provider.dart';
import 'package:stars_live/screens/main_screen/main_screen.dart';

import '../../global/constants.dart';
import '../../widgets/conditional_builder.dart';
import '../../global/functions.dart';
import '../../providers/switch_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/default_expanded_auth.dart';
import '../../widgets/default_textformfeild.dart';

class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({Key? key}) : super(key: key);

  @override
  _MobileLoginPageState createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage>
    with _MixinMobileLoginPage {
  int exitCount = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerEmail.dispose();
    _controllerPw.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final bool _keyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    final Size _mediaQ = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          exitCount++;
          final int exit = exitCount;
          if (exitCount == 2) exitCount = 0;
          return customExitApp(exitCount: exit);
        },
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => LoginProvider()),
            ChangeNotifierProvider(create: (context) => SocialLogin()),
            ChangeNotifierProvider(create: (context) => SwitchState())
          ],
          child: Scaffold(
              body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(gradient: GRADIENT),
            child: LayoutBuilder(
                builder: (context, constraints) => ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.1,
                        ),
                        _buildColumn(
                            keyBoard: _keyBoard,
                            constraints: constraints,
                            mediaQ: _mediaQ),
                        Visibility(
                          visible: _keyBoard ? true : true,
                          child: SizedBox(
                            height: constraints.maxHeight * 0.05,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Consumer<SocialLogin>(
                              builder: (context, socialProvider, child) {
                                //FIXME : goolge button
                                return InkWell(
                                  onTap: (isLoading)
                                      ? null
                                      : () async {
                                          try {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await socialProvider
                                                .userGoogleLogin(context);

                                            await context
                                                .read<UserProvider>()
                                                .getGoogleUserData();

                                            if (context
                                                    .read<UserProvider>()
                                                    .userData
                                                    ?.data
                                                    ?.first !=
                                                null)
                                              Get.offAndToNamed(MainScreen.id);
                                            else {
                                              customSnackBar(
                                                  text:
                                                      'something went wrong'.tr,
                                                  context: context);
                                            }
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                  child: SvgPicture.asset(
                                    '$assetsPath/googleLogo.svg',
                                    color: Colors.white,
                                    height: constraints.maxHeight * 0.05,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
          )),
        ),
      ),
    );
  }
}

mixin _MixinMobileLoginPage<T extends StatefulWidget> on State<T> {
  bool isLoading = false;
  final DateTime _dateTime = DateTime.now();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPw = TextEditingController();

  Column _buildColumn({
    required bool keyBoard,
    required BoxConstraints constraints,
    required Size mediaQ,
  }) {
    return Column(
      children: [
        SizedBox(
          height:
              !keyBoard ? constraints.maxHeight * 0.7 : mediaQ.height * 0.75,
          child: Stack(
            children: [
              Visibility(
                visible: keyBoard ? true : true,
                child: Positioned(
                    bottom: 0,
                    right: constraints.maxWidth * 0.1,
                    child: GestureDetector(
                      onTap: () async {
                        return await Functions.goToSignUpPage();
                      },
                      child: Container(
                        width: constraints.maxWidth * 0.7,
                        height: constraints.maxHeight * 0.1,
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.only(bottom: 10.0),
                        decoration: const BoxDecoration(
                            color: mainWhiteColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0))),
                        child: CustomText(
                          text: 'create'.tr,
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: !keyBoard
                    ? constraints.maxHeight * 0.65
                    : mediaQ.height * 0.7,
                child: Container(
                  width: constraints.maxWidth * 0.9,
                  decoration: BoxDecoration(
                      color: mainWhiteColor,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5.0,
                            spreadRadius: 1.0,
                            color: colorGrey)
                      ]),
                  child: Form(
                    key: _globalKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(10.0),
                            child: CustomText(
                              text: 'sign in'.tr,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Expanded(
                          child: DefaultExpandedAuth(
                              child: DefaultTextFormField(
                            key: Key('email'),
                            controller: _controllerEmail,
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.emailAddress,
                            hint: 'enter your email'.tr,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            validator: (String? v) {
                              return Functions.validatorEmailAndPhone(
                                  v!.trim());
                            },
                          )),
                        ),

                        Expanded(
                          child: DefaultExpandedAuth(
                              child: Builder(
                            builder: (BuildContext context) =>
                                Consumer<SwitchState>(
                              builder: (context, prov, _) =>
                                  DefaultTextFormField(
                                key: Key('password'),
                                controller: _controllerPw,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.visiblePassword,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                hint: 'enter your password'.tr,
                                password: prov.varSwitch,
                                suffixIcon: AnimatedConditionalBuilder(
                                  duration: const Duration(milliseconds: 250),
                                  condition: prov.varSwitch,
                                  builder: (context) => IconButton(
                                    onPressed: () {
                                      prov.funcSwitch();
                                    },
                                    icon: const Icon(Icons.visibility),
                                  ),
                                  fallback: (context) => IconButton(
                                    onPressed: () {
                                      prov.funcSwitch();
                                    },
                                    icon: const Icon(Icons.visibility_off),
                                  ),
                                ),
                                validator: (String? v) {
                                  // return Functions.validatorPw(v);
                                  if (v!.length < 8) {
                                    return 'password must be more than 8 characters';
                                  } else {
                                    return null;
                                  }
                                },
                                onSubmitted: (v) async {
                                  // return await context.read<LoginProvider>().loginButton(
                                  //     globalKey: _globalKey,
                                  //     context: context,
                                  //     email: _controllerEmail.text,
                                  //     password: _controllerPw.text
                                  // );
                                },
                              ),
                            ),
                          )),
                        ),
                        Expanded(
                            child: DefaultExpandedAuth(
                          child: Builder(
                            builder: (BuildContext context) => Container(
                              height: mediaQ.height * 0.09,
                              decoration: BoxDecoration(
                                gradient: GRADIENT,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: CustomTextButton(
                                child: CustomText(
                                  text: 'login'.tr,
                                  color: mainWhiteColor,
                                  fontSize: 18.0,
                                ),
                                onPressed: (isLoading)
                                    ? () {}
                                    : () async {
                                        //FIXME : login button
                                        setState(() {
                                          isLoading = true;
                                        });
                                        // Provider.of<AuthProvider>(context,
                                        //         listen: false)
                                        //     .loginWithAccount(
                                        //   email: 'test3@test.com',
                                        //   pass: '12345678Es%',
                                        // );
                                        if (_globalKey.currentState!
                                            .validate()) {
                                          try {
                                            await context
                                                .read<LoginProvider>()
                                                .loginButton(
                                                    globalKey: _globalKey,
                                                    context: context,
                                                    email: _controllerEmail.text
                                                        .trim(),
                                                    password:
                                                        _controllerPw.text);

                                            await context
                                                .read<UserProvider>()
                                                .getUserData(
                                                    _controllerEmail.text,
                                                    _controllerPw.text);

                                            if (context
                                                    .read<UserProvider>()
                                                    .userData
                                                    ?.data
                                                    ?.first !=
                                                null)
                                              Get.offAndToNamed(MainScreen.id);
                                            else
                                              customSnackBar(
                                                  text:
                                                      'something went wrong'.tr,
                                                  context: context);
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                              ),
                            ),
                          ),
                        )),

                        // Expanded(
                        //   child: Center(
                        //     child: GestureDetector(
                        //       onTap: (){
                        //         FunctionsAuth.goToMainPage();
                        //       },
                        //       child: CustomText(text: 'forget your password?'.tr,
                        //         fontSize: 17.0,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
