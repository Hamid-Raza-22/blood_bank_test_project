import 'package:flutter/material.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;

  static double blockWidth = 0;
  static double blockHeight = 0;

  void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }
}