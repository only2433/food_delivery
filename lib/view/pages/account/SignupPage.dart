import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:food_delivery/controller/AuthDataController.dart';
import 'package:food_delivery/controller/common/LoadingController.dart';
import 'package:food_delivery/data/firebase/UserData.dart';
import 'package:food_delivery/route/RouteHelper.dart';
import 'package:food_delivery/view/widget/BigText.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../common/Common.dart';
import '../../../common/CommonUtils.dart';
import '../../../enum/ValidateType.dart';
import '../../../utils/Colors.dart';
import '../../../utils/Dimensions.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final int MAX_TEXT_FIELD_COUNT = 4;
  final _formKey = GlobalKey<FormState>();
  late List<FocusNode> _focusNodeList;
  late ScrollController _scrollController;
  final TextEditingController _phoneNumberController = TextEditingController();
  ValidateType _validateType = ValidateType.SUCCESS;
  String _userEmail = "";
  String _userPassword = "";
  String _userName = "";
  String _userPhoneNumber = "";

  File? mUserImage = null;
  DateTime? mBirthdayDate = null;
  bool isBirthdayDate = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    settingFocusNode();
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    for (var focus in _focusNodeList) {
      focus.dispose();
    }
  }

  void _onFocusChange(bool hasFocus) {
    if (hasFocus == false) {
      _scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void pickImage() async {
    final imagePicker = ImagePicker();
    final pickImageFile = await imagePicker.pickImage(source: ImageSource.camera, imageQuality: 80, maxHeight: Dimensions.getHeight(150));

    if (pickImageFile != null) {
      setState(() {
        mUserImage = File(pickImageFile.path);
      });
    }
  }

  void settingFocusNode() {
    _focusNodeList = List.generate(MAX_TEXT_FIELD_COUNT, (index) => FocusNode());
    for (var focusNode in _focusNodeList) {
      focusNode.addListener(() {
        _onFocusChange(focusNode.hasFocus);
      });
    }
  }

  void disposeFocusNode() {
    for (var focusNode in _focusNodeList) {
      focusNode.dispose();
    }
  }

  String getErrorMessage() {
    _formKey.currentState?.validate();
    switch (_validateType) {
      case ValidateType.ERROR_EMAIL:
        return "Please enter at least 4 characters";
      case ValidateType.ERROR_PASSWORD:
        return "Password must be at least 7 characters long.";
      case ValidateType.ERROR_NAME:
        return "Nickname must be at least 4 characters long.";
      case ValidateType.ERROR_PHONE:
        return "PhoneNumber is incorrect.";
      case ValidateType.ERROR_BIRTHDAY:
        return "Please select your birthday.";
      case ValidateType.ERROR_USER_IMAGE:
        return "Please take your picture.";
      default:
        return "";
    }
  }

  Future<void> signUp(LoadingController controller) async {
    try {
      final userConfidential = await Get.find<AuthDataController>().signUp(_userEmail, _userPassword);
      if (userConfidential != null) {
        UserData userData = UserData(userName: _userName, userEmail: _userEmail, userAddress: "userAddress", userPhoneNumber: _userPhoneNumber, userBirthday: mBirthdayDate!);
        await Get.find<AuthDataController>().uploadUserData(userConfidential.user!.uid!, mUserImage!, userData);
        controller.disable();

        CommonUtils.getInstance().showSuccessMessage('You have successfully registered.');
        await Future.delayed(Duration(milliseconds: 2000));
        Get.back(closeOverlays: true);
      }
    } catch (e)
    {
      controller.disable();
      CommonUtils.getInstance().showErrorMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: BigText(text: 'Sign up', color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: GetBuilder<LoadingController>(builder: (controller) {
        return ModalProgressHUD(
          inAsyncCall: controller.isLoading,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: Dimensions.getHeight(40),
                      ),
                      _userSelectImage(),
                      SizedBox(
                        height: Dimensions.getWidth(15),
                      ),
                      _inputSignUpField()
                    ],
                  ),
                  Positioned(
                      left: MediaQuery.of(context).size.width / 2 - Dimensions.getWidth(40),
                      top: MediaQuery.of(context).size.height - Dimensions.getHeight(190),
                      child: GestureDetector(
                        onTap: () async
                        {
                          controller.enable();
                          if (mUserImage == null)
                          {
                            _validateType = ValidateType.ERROR_USER_IMAGE;
                          }
                          else if (mBirthdayDate == null)
                          {
                            _validateType = ValidateType.ERROR_BIRTHDAY;
                          }

                          String message = getErrorMessage();
                          if (message != "")
                          {
                            controller.disable();
                            CommonUtils.getInstance().showErrorMessage(message);
                          }
                          else
                          {
                            await signUp(controller);
                          }
                        },
                        child: Container(
                          width: Dimensions.getWidth(80),
                          height: Dimensions.getHeight(80),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              border: Border.all(color: Colors.white, width: Dimensions.getWidth(2)),
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: Dimensions.getWidth(2), blurRadius: Dimensions.getWidth(2))]),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: Dimensions.getWidth(40),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        );
      },),
    );
  }

  Widget _userSelectImage() {
    return Container(
      width: Dimensions.getWidth(500),
      height: Dimensions.getHeight(100),
      child: Stack(
        children: [
          Positioned(
              left: MediaQuery.of(context).size.width / 2 - Dimensions.getWidth(40),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: Dimensions.getWidth(2), blurRadius: Dimensions.getWidth(2)),
                    ],
                    border: Border.all(color: Colors.black54, width: Dimensions.getWidth(2))),
                child: CircleAvatar(
                  radius: Dimensions.getHeight(40),
                  backgroundColor: Colors.grey[200],
                  backgroundImage: mUserImage == null ? null : FileImage(mUserImage!),
                ),
              )),
          Positioned(
              left: MediaQuery.of(context).size.width / 2 + Dimensions.getWidth(20),
              top: Dimensions.getHeight(45),
              child: GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  width: Dimensions.getWidth(50),
                  height: Dimensions.getHeight(50),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _inputSignUpField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: Dimensions.getHeight(390),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(15)),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black54, width: Dimensions.getWidth(4)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: Dimensions.getWidth(5), spreadRadius: Dimensions.getWidth(2))],
          borderRadius: BorderRadius.circular(Dimensions.getWidth(15))),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(10)),
              child: Column(
                children: [
                  SizedBox(
                    height: Dimensions.getHeight(10),
                  ),
                  TextFormField(
                    key: const ValueKey(1),
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _focusNodeList[0],
                    validator: (value) {
                      if (_validateType != ValidateType.SUCCESS) {
                        return null;
                      }
                      if (value!.isEmpty || value.length < 4 || value.contains('@') == false) {
                        _validateType = ValidateType.ERROR_EMAIL;
                      } else {
                        _validateType = ValidateType.SUCCESS;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                    onChanged: (value) {
                      _userEmail = value;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.alternate_email_outlined,
                          color: _focusNodeList[0].hasFocus ? Colors.blueAccent : Colors.black54,
                          size: Dimensions.getWidth(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.getWidth(10)),
                          borderSide: BorderSide(color: Colors.black54, width: Dimensions.getWidth(2)),
                        ),
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.getWidth(15)), borderSide: BorderSide(color: Colors.blueAccent, width: Dimensions.getWidth(2))),
                        hintText: 'User Email',
                        hintStyle: GoogleFonts.nunito(fontSize: Dimensions.getWidth(15), color: AppColors.textColor1)),
                  ),
                  SizedBox(
                    height: Dimensions.getHeight(10),
                  ),
                  TextFormField(
                    key: const ValueKey(2),
                    focusNode: _focusNodeList[1],
                    obscureText: true,
                    validator: (value) {
                      if (_validateType != ValidateType.SUCCESS) {
                        return null;
                      }
                      if (value!.isEmpty || value!.length < 4) {
                        _validateType = ValidateType.ERROR_PASSWORD;
                      } else {
                        _validateType = ValidateType.SUCCESS;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                    onChanged: (value) {
                      _userPassword = value;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.lock_clock_outlined,
                          color: _focusNodeList[1].hasFocus ? Colors.blueAccent : Colors.black54,
                          size: Dimensions.getWidth(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.getWidth(10)),
                          borderSide: BorderSide(color: Colors.black54, width: Dimensions.getWidth(2)),
                        ),
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.getWidth(15)), borderSide: BorderSide(color: Colors.blueAccent, width: Dimensions.getWidth(2))),
                        hintText: 'User Password',
                        hintStyle: GoogleFonts.nunito(fontSize: Dimensions.getWidth(15), color: AppColors.textColor1)),
                  ),
                  SizedBox(
                    height: Dimensions.getHeight(10),
                  ),
                  TextFormField(
                    key: const ValueKey(3),
                    focusNode: _focusNodeList[2],
                    validator: (value) {
                      if (_validateType != ValidateType.SUCCESS) {
                        return null;
                      }
                      if (value!.isEmpty || value!.length < 4) {
                        _validateType = ValidateType.ERROR_NAME;
                      } else {
                        _validateType = ValidateType.SUCCESS;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userName = newValue!;
                    },
                    onChanged: (value) {
                      _userName = value;
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: _focusNodeList[2].hasFocus ? Colors.blueAccent : Colors.black54,
                          size: Dimensions.getWidth(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.getWidth(10)),
                          borderSide: BorderSide(color: Colors.black54, width: Dimensions.getWidth(2)),
                        ),
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.getWidth(15)), borderSide: BorderSide(color: Colors.blueAccent, width: Dimensions.getWidth(2))),
                        hintText: 'User Name',
                        hintStyle: GoogleFonts.nunito(fontSize: Dimensions.getWidth(15), color: AppColors.textColor1)),
                  ),
                  SizedBox(
                    height: Dimensions.getHeight(10),
                  ),
                  TextFormField(
                    key: const ValueKey(4),
                    focusNode: _focusNodeList[3],
                    keyboardType: TextInputType.number,
                    controller: _phoneNumberController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11)
                    ],
                    validator: (value) {
                      if (_validateType != ValidateType.SUCCESS) {
                        return null;
                      }
                      if (value!.isEmpty || value.length < 10) {
                        _validateType = ValidateType.ERROR_PHONE;
                      } else {
                        _validateType = ValidateType.SUCCESS;
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      Logger.d("newValue : ${newValue}");
                      _userPhoneNumber = newValue!;
                    },
                    onChanged: (value) {
                      _userPhoneNumber = value;
                    },
                    onEditingComplete: _formatPhoneNumber,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(
                          Icons.phone_android_outlined,
                          color: _focusNodeList[2].hasFocus ? Colors.blueAccent : Colors.black54,
                          size: Dimensions.getWidth(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimensions.getWidth(10)),
                          borderSide: BorderSide(color: Colors.black54, width: Dimensions.getWidth(2)),
                        ),
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.getWidth(15)), borderSide: BorderSide(color: Colors.blueAccent, width: Dimensions.getWidth(2))),
                        hintText: 'Phone',
                        hintStyle: GoogleFonts.nunito(fontSize: Dimensions.getWidth(15), color: AppColors.textColor1)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Dimensions.getHeight(10),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: Dimensions.getHeight(55),
            margin: EdgeInsets.symmetric(horizontal: Dimensions.getWidth(10)),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black54,
                  width: Dimensions.getWidth(2),
                ),
                borderRadius: BorderRadius.circular(Dimensions.getWidth(10))),
            padding: EdgeInsets.only(left: Dimensions.getWidth(2)),
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
                onPressed: () async {
                  DateTime? tempDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1980),
                      lastDate: DateTime.now());
                  if(tempDate == null)
                  {
                    return;
                  }
                  setState(() {
                    mBirthdayDate = tempDate;
                  });
                },
                icon: Icon(
                  Icons.calendar_month_outlined,
                  size: Dimensions.getWidth(30),
                  color: Colors.black54,
                ),
                label: Text(
                  mBirthdayDate == null ? 'BirthDay' : '${CommonUtils.getInstance().getDateText(mBirthdayDate!)}',
                  style: GoogleFonts.nunito(
                      color: mBirthdayDate == null ? AppColors.textColor1 : Colors.black54),
                )),
          )
        ],
      ),
    );
  }

  void _formatPhoneNumber()
  {

    String data = _userPhoneNumber;
    Logger.d("data : $data", tag: Common.APP_NAME);
    if(_userPhoneNumber.length == 10)
    {
      setState(() {
        _phoneNumberController.text = '${data.substring(0,3)}-${data.substring(3,6)}-${data.substring(6,data.length)}';
      });
    }
    else if(_userPhoneNumber.length == 11)
    {
      setState(() {
        _phoneNumberController.text = '${data.substring(0,3)}-${data.substring(3,7)}-${data.substring(7,data.length)}';
      });
    }
    _focusNodeList[3].unfocus();
    Logger.d("_userPhoneNumber : $_userPhoneNumber", tag: Common.APP_NAME);
  }
}

/*class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Implement your custom formatting logic here
    // In this example, we format phone number like: (123) 456-7890

    String newText = newValue.text;

    if (newText.length == 3 || newText.length == 7)
    {
      newText += '-';
    }
   /* else if (newText.length == 4 || newText.length == 8)
    {
      newText = newText.substring(0, newText.length - 1) +
          '-' +
          newText.substring(newText.length - 1);
    }*/
    else if (newText.length > 13)
    {
      newText = newText.substring(0, 13);
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}*/
