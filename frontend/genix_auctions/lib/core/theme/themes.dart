import 'package:flutter/material.dart';

class AppTheme {
  static textStyle({
    double size = 13,
    Color color = Colors.black,
    FontWeight fontwt = FontWeight.w400,
  }) =>
      TextStyle(
        color: color,
        fontSize: size,
        fontFamily: 'Outfit',
        fontWeight: fontwt,
      );
}
