import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppStylesAndColors {
  static Color blackColor = Colors.black;

  static TextStyle appBarStyle = TextStyle(
    color: blackColor,
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );

  static Widget backButton = InkWell(
    child: Icon(Icons.arrow_back, color: blackColor),
    onTap: () {
      Get.back();
    },
  );
}
