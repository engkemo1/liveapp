import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:stars_live/providers/register_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global/constants.dart';
import '../../widgets/conditional_builder.dart';
import '../../global/functions.dart';
import '../../providers/switch_provider.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/default_expanded_auth.dart';
import '../../widgets/default_textformfeild.dart';

class MobileSignUpPage extends StatefulWidget {
  const MobileSignUpPage({Key? key}) : super(key: key);

  @override
  _MobileSignUpPageState createState() => _MobileSignUpPageState();
}

class _MobileSignUpPageState extends State<MobileSignUpPage>
    with _MixinMobileSignUpPage {
  @override
  void dispose() {
    super.dispose();
    _controllerEmail.dispose();
    _controllerName.dispose();
    _controllerPhone.dispose();
    _controllerPw.dispose();
  }

  bool _value = false;
  var acceptTerms = '';

  @override
  Widget build(BuildContext context) {
    final bool _keyBoard = MediaQuery.of(context).viewInsets.bottom != 0;
    final Size _mediaQ = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => RegisterProvider()),
          ChangeNotifierProvider(create: (context) => SwitchState())
        ],
        child: Scaffold(
            body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(gradient: GRADIENT),
            child: LayoutBuilder(
                builder: (context, constraints) => Center(
                      child: ListView(
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.1,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: !_keyBoard
                                    ? constraints.maxHeight * 0.85
                                    : _mediaQ.height * 0.9,
                                child: Container(
                                  width: constraints.maxWidth * 0.9,
                                  decoration: BoxDecoration(
                                      color: mainWhiteColor,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: const [
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
                                              text: 'sign up'.tr,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: DefaultExpandedAuth(
                                              child: DefaultTextFormField(
                                            controller: _controllerName,
                                            inputAction: TextInputAction.next,
                                            inputType: TextInputType.text,
                                            label: 'enter your name'.tr,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            validator: (String? value) {},
                                          )),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: DefaultExpandedAuth(
                                              child: DefaultTextFormField(
                                            controller: _controllerEmail,
                                            inputAction: TextInputAction.next,
                                            inputType:
                                                TextInputType.emailAddress,
                                            label: 'enter your email'.tr,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            validator: (String? v) {
                                              return Functions.validatorEmail(
                                                  v);
                                            },
                                          )),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: DefaultExpandedAuth(
                                              child: DefaultTextFormField(
                                            controller: _controllerPhone,
                                            inputAction: TextInputAction.next,
                                            inputType: TextInputType.phone,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            label: 'enter your phone'.tr,
                                            validator: (String? v) {
                                              return Functions.validatorPhone(
                                                  v);
                                            },
                                          )),
                                        ),
                                        SizedBox(height: 10),
                                        Expanded(
                                          child: DefaultExpandedAuth(
                                              child: Consumer<SwitchState>(
                                            builder: (context, prov, _) =>
                                                DefaultTextFormField(
                                              controller: _controllerPw,
                                              inputAction: TextInputAction.done,
                                              inputType:
                                                  TextInputType.visiblePassword,
                                              password: prov.varSwitch,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              label: 'enter your password'.tr,
                                              suffixIcon:
                                                  AnimatedConditionalBuilder(
                                                duration: const Duration(
                                                    milliseconds: 250),
                                                condition: prov.varSwitch,
                                                builder: (context) =>
                                                    IconButton(
                                                  onPressed: () {
                                                    prov.funcSwitch();
                                                  },
                                                  icon: const Icon(
                                                      Icons.visibility),
                                                ),
                                                fallback: (context) =>
                                                    IconButton(
                                                  onPressed: () {
                                                    prov.funcSwitch();
                                                  },
                                                  icon: const Icon(
                                                      Icons.visibility_off),
                                                ),
                                              ),
                                              validator: (String? v) {
                                                // return Functions.validatorPw(v);
                                              },
                                            ),
                                          )),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: 'continue'.tr + '\n',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                  children: [
                                                    TextSpan(
                                                      text: 'Terms & Conditions'
                                                          .tr,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              _launchURL(
                                                                  'http://starslive.club/public/terms-conditions');
                                                            },
                                                    ),
                                                    TextSpan(text: 'and'.tr),
                                                    TextSpan(
                                                      text:
                                                          'Privacy Policy'.tr +
                                                              '\n',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              _launchURL(
                                                                  'https://pages.flycricket.io/stars-live/privacy.html');
                                                            },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Checkbox(
                                              value: _value,
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          acceptTerms,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        Expanded(
                                            child: DefaultExpandedAuth(
                                          child: Container(
                                            height: _mediaQ.height * 0.09,
                                            decoration: BoxDecoration(
                                              gradient: GRADIENT,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: CustomTextButton(
                                              child: CustomText(
                                                text: 'sign up'.tr,
                                                color: mainWhiteColor,
                                                fontSize: 18.0,
                                              ),
                                              onPressed: () async {
                                                if (_value == false) {
                                                  setState(() {
                                                    acceptTerms =
                                                        'please agree to terms';
                                                  });
                                                } else {
                                                  setState(() {
                                                    acceptTerms = '';
                                                  });
                                                  return await context
                                                      .read<RegisterProvider>()
                                                      .registerButton(
                                                        globalKey: _globalKey,
                                                        context: context,
                                                        name: _controllerName
                                                            .text,
                                                        email: _controllerEmail
                                                            .text,
                                                        phone: _controllerPhone
                                                            .text,
                                                        password:
                                                            _controllerPw.text,
                                                      );
                                                }
                                              },
                                            ),
                                          ),
                                        )),
                                        Expanded(
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                Functions.goToMainPage();
                                              },
                                              child: CustomText(
                                                text: 'have an account'.tr,
                                                fontSize: 17.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
          ),
        )),
      ),
    );
  }

  _launchURL(String Url) async {
    var url = Url;
    try {
      await launch(url);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: new Text('Could not launch $url')));
    }
  }
}

mixin _MixinMobileSignUpPage {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPw = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
}
