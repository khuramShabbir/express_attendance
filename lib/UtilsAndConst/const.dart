import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class AppConst {
  static const String countryCode = '+92';

  static Future startProgress() async {
    await Get.generalDialog(pageBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Center(
        child: CircularProgressIndicator(),
      );
    });
    ;
  }

  static void stopProgress() {
    if (Get.isDialogOpen!) Get.back();
  }

  static Future<void> successSnackBar(String message) async {
    await Get.snackbar("Status : Success", message,
        icon: Icon(
          Icons.check,
          color: Colors.green,
          size: 40,
        ));
  }

  static Future<void> errorSnackBar(String message) async {
    await Get.snackbar("Status : Error", message,
        borderRadius: 15,
        icon: Icon(
          Icons.cancel,
          color: Colors.red,
          size: 40,
        ));
  }

  static Future<void> infoSnackBar(String message) async {
    await Get.snackbar(
      "",
      message,
      icon: Icon(
        Icons.info,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  static String? arrangePhoneNumberFormat(String _phoneNumCtrlTxt) {
    if (_phoneNumCtrlTxt.length < 11 && _phoneNumCtrlTxt.length == 10) {
      return '$countryCode$_phoneNumCtrlTxt';
    } else if (_phoneNumCtrlTxt.length == 11 && _phoneNumCtrlTxt.split('').first == '0') {
      return _phoneNumCtrlTxt.replaceFirst('0', countryCode);
    } else if (_phoneNumCtrlTxt.length == 13 && _phoneNumCtrlTxt.startsWith('+92')) {
      return _phoneNumCtrlTxt;
    } else if (_phoneNumCtrlTxt.length == 14 && _phoneNumCtrlTxt.startsWith('0092')) {
      return _phoneNumCtrlTxt.replaceFirst('0092', countryCode);
    } else {
      return null;
    }
  }
}
