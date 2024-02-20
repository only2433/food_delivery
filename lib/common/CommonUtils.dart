import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../data/result/CartItem.dart';
import '../enum/ViewPage.dart';


class CommonUtils {
  static CommonUtils? _instance;

  static CommonUtils getInstance() {
    if (_instance == null) {
      _instance = CommonUtils();
    }
    return _instance!;
  }

  T enumFromString<T>(List<T> values, String value, {required T defaultValue}) {
    return values.firstWhere(
          (e) => e.toString().split('.')[1] == value,
      orElse: () => defaultValue,
    );
  }

  ViewPage getViewPage(String value) {
    return ViewPage.values.firstWhere(
            (element) => element.getStringValue == value,
        orElse: () => ViewPage.HOME);
  }

  String getCheckoutDate(String date) {
    DateTime time = DateTime.parse(date);
    String result = DateFormat('MM/dd/yyyy HH:mm:ss a').format(time);
    return result;
  }

  Map<String, int> getPerOrderForCartItems(List<CartItem> list) {
    Map<String, int> result = Map();
    for (int i = 0; i < list.length; i++) {
      if (result.containsKey(list[i].time)) {
        result.update(list[i].time!, (value) => ++value);
      }
      else {
        result.putIfAbsent(list[i].time!, () {
          return 1;
        });
      }
    }
    return result;
  }

  Map<int, CartItem> getCartItemForPerTimes(List<CartItem> list, String targetTimes)
  {
    Map<int, CartItem> result = {};

    for(int i = 0; i < list.length; i++)
    {
        if(list[i].time == targetTimes)
        {
          result.putIfAbsent(list[i].id!, (){
            return list[i];
          });
        }
    }

    return result;
  }

  void showErrorMessage(String errorMessage) {
    Get.snackbar('Error', errorMessage,
        colorText: Colors.white,
        backgroundColor: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED,
        duration: Duration(milliseconds: 1500),
        animationDuration: Duration(milliseconds: 300));
  }

  void showSuccessMessage(String successMessage) {
    Get.snackbar('Success', successMessage,
        colorText: Colors.green,
        backgroundColor: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED,
        duration: Duration(milliseconds: 1500),
        animationDuration: Duration(milliseconds: 300));
  }

  String getDateText(DateTime time) {
    return '${time.year}-${time.month}-${time.day}';
  }

}