import 'package:flutter/material.dart';

class AppInfo {
  static const NAME = "MomsClub";
}

class AppColor {
  static const PRIMARY = Color(0xffCC749E);
  static const PRIMARY_DARKER = Color(0xffB35B85);
  static const SECONDARY = Color(0xffF8E6F6);
  static const GREY = Color(0xffF5F5F5);
  static const GREY2 = Color(0xffF0F0F0);
  static const GREY3 = Color(0xff606060);
}

EdgeInsets screenBodyPadding =  EdgeInsets.symmetric(vertical: 0, horizontal: 25);
double screenTextMarginBotttom = 15;
double screenTextMarginTop(context) => (MediaQuery.of(context).size.height * (1/7) - 60);
double commonGridSize(context) => (MediaQuery.of(context).size.height * (6/7));