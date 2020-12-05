import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

final Color primaryColor = HexColor('#03a9f4');
final Color primaryColorLight = HexColor('#67daff');
final Color primaryColorDark = HexColor('#007ac1');
final Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
final Color textColor = Colors.black87;
