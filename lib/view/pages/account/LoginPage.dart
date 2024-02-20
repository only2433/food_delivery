import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/controller/AuthDataController.dart';
import 'package:food_delivery/controller/common/LoadingController.dart';
import 'package:food_delivery/enum/ValidateType.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:food_delivery/view/widget/BigText.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../common/Common.dart';
import '../../../common/CommonUtils.dart';
import '../../../utils/Dimensions.dart';
import '../../../utils/Colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final int MAX_TEXT_FIELD_COUNT = 3;
  final _formKey = GlobalKey<FormState>();
  late List<FocusNode> _focusNodeList;
  String mLoginEmail = "";
  String mLoginPassword = "";
  ValidateType _validateType = ValidateType.SUCCESS;


  @override
  void initState() {
    super.initState();
    settingFocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<LoadingController>(builder: (controller) {
          return ModalProgressHUD(
            inAsyncCall: controller.isLoading,
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                padding: EdgeInsets.only(
                    top: Dimensions.getHeight(50)
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: Dimensions.getWidth(300),
                          child: Lottie.asset('asset/lottie/login_animation.json',
                              repeat: true,
                              animate: true,
                              alignment: Alignment.topCenter),
                        ),
                        Text('Food Delivery',
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.getWidth(40),
                              decoration: TextDecoration.none,
                              textStyle: TextStyle(
                                  shadows: [
                                    Shadow(
                                        color: Colors.grey,
                                        blurRadius: Dimensions.getWidth(10.0)
                                    )
                                  ]
                              )
                          ),),
                        SizedBox(
                          height: Dimensions.getHeight(25),
                        ),
                        _inputLoginField()
                      ],
                    ),
                    Positioned(
                        width: Dimensions.getWidth(70),
                        height: Dimensions.getHeight(70),
                        left: MediaQuery
                            .of(context)
                            .size
                            .width / 2 - Dimensions.getWidth(30),
                        top: MediaQuery
                            .of(context)
                            .size
                            .height / 2 + Dimensions.getHeight(180),
                        child: _loginButton(controller)
                    ),
                    Positioned(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        left: 0,
                        top: MediaQuery
                            .of(context)
                            .size
                            .height / 2 + Dimensions.getHeight(260),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Not Yet ',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: ()
                              {
                                Get.toNamed(RouteHelper.getSignUpPage());
                              },
                              child: Text(
                                'Sign up?',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          );
        }
        ));
  }

  Widget _inputLoginField() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width - Dimensions.getWidth(40),
      height: Dimensions.getHeight(180),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.getWidth(15)),
          border: Border.all(
              color: Colors.black54,
              width: Dimensions.getWidth(4)
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: Dimensions.getWidth(6),
                spreadRadius: Dimensions.getWidth(2)
            )
          ]
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(15)),
          child: Column(
            children: [
              SizedBox(
                height: Dimensions.getHeight(15),
              ),
              TextFormField(
                key: const ValueKey(1),
                focusNode: _focusNodeList[0],
                validator: (value) {
                  if (value!.isEmpty ||
                      value.length < 4 ||
                      value.contains('@') == false) {
                    //CommonUtils.getInstance().showErrorMessage('Please enter at least 4 characters');
                    _validateType = ValidateType.ERROR_EMAIL;
                  }
                  else
                  {
                    _validateType = ValidateType.SUCCESS;
                  }
                  return null;
                },
                onSaved: (newValue) {
                  mLoginEmail = newValue!;
                },
                onChanged: (value) {
                  mLoginEmail = value;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.account_circle_outlined,
                      color: _focusNodeList[0].hasFocus ? Colors.blueAccent : Colors.black54, size: Dimensions.getWidth(30),),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.getWidth(15)),
                      borderSide: BorderSide(
                          color: Colors.black54,
                          width: Dimensions.getWidth(2)
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.getWidth(15)),
                        borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: Dimensions.getWidth(2)
                        )
                    ),
                    hintText: 'User Email',
                    hintStyle: GoogleFonts.nunito(
                        fontSize: Dimensions.getWidth(15),
                        color: AppColors.textColor1
                    )
                ),
              ),
              SizedBox(
                height: Dimensions.getHeight(10),
              ),
              TextFormField(
                key: const ValueKey(2),
                focusNode: _focusNodeList[1],
                validator: (value) {

                  if(_validateType != ValidateType.SUCCESS) {
                    return null;
                  }

                  if (value!.isEmpty || value!.length < 6) {
                   // CommonUtils.getInstance().showErrorMessage('Password must be at least 7 characters long.');
                    _validateType = ValidateType.ERROR_PASSWORD;
                  }
                  else {
                    _validateType = ValidateType.SUCCESS;
                  }
                  return null;
                },
                onSaved: (newValue) {
                  mLoginPassword = newValue!;
                },
                onChanged: (value) {
                  mLoginPassword = value;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock_clock_outlined,
                      color: _focusNodeList[1].hasFocus ? Colors.blueAccent : Colors.black54, size: Dimensions.getWidth(30),),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.getWidth(15)),
                      borderSide: BorderSide(
                          color: Colors.black54,
                          width: Dimensions.getWidth(2)
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.getWidth(15)),
                        borderSide: BorderSide(
                            color: Colors.blueAccent,
                            width: Dimensions.getWidth(2)
                        )
                    ),
                    hintText: 'User Password',
                    hintStyle: GoogleFonts.nunito(
                        fontSize: Dimensions.getWidth(15),
                        color: AppColors.textColor1
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginButton(LoadingController controller) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: Dimensions.getWidth(2)),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: Dimensions.getWidth(2),
                spreadRadius: Dimensions.getWidth(2)
            )
          ]
      ),
      child: ClipOval(
        child: Material(
          color: Colors.lightBlue,
          child: GetBuilder<AuthDataController>(builder: (authController) {
            return InkWell(
              splashColor: Colors.blueAccent,
              onTap: () async
              {
                controller.enable();

                String message = getErrorMessage();
                if(message != "")
                {
                  controller.disable();
                  CommonUtils.getInstance().showErrorMessage(message);
                }
                else
                {
                  try {
                    final userData = await authController.login(mLoginEmail, mLoginPassword);
                    controller.disable();
                  }
                  catch (e) {
                    controller.disable();
                    Logger.d("Exception : ${e.toString()}", tag: Common.APP_NAME);
                    CommonUtils.getInstance().showErrorMessage("There is no registerd ID");
                  }
                }
              },
              child: SizedBox(
                width: Dimensions.getWidth(50),
                height: Dimensions.getHeight(50),
                child: Icon(
                  Icons.login,
                  color: Colors.white,
                ),
              ),
            );
          },),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    disposeFocusNode();
  }

  void settingFocusNode() {
    _focusNodeList = List.generate(MAX_TEXT_FIELD_COUNT, (index) => FocusNode());
    for (var focusNode in _focusNodeList) {
      focusNode.addListener(() {
        setState(() {});
      });
    }
  }

  void disposeFocusNode() {
    for (var focusNode in _focusNodeList) {
      focusNode.dispose();
    }
  }

  String getErrorMessage()
  {
    _formKey.currentState?.validate();
    switch(_validateType)
    {
      case ValidateType.ERROR_EMAIL:
        return "Please enter at least 4 characters";
      case ValidateType.ERROR_PASSWORD:
        return "Password must be at least 7 characters long.";
      default:
        return "";
    }
  }
}
