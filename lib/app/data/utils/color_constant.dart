import 'package:flutter/material.dart';

class ColorConstant {
  static Color black = fromHex('#000000');
  static Color gray5001 = fromHex('#fafafa');
  // static Color primaryPink = fromHex('#FFF28BA0');
  // static Color primaryPink = Color(0xFFEB6F87);
  static Color primaryPink1 = fromHex('#f7951c');
  static Color primaryPink = fromHex('#000000');
  static Color green = fromHex('#43FF00');
  static Color greenButton = fromHex('#38640A');
  static Color red = fromHex('#FF1A1A');
  static Color bg = fromHex('#121212');
  static Color containerBg = fromHex('#363636');
  static Color blue = fromHex('#007AFF');
  static Color white60 = Colors.white.withOpacity(.6);
  static Color white = fromHex('#ffffff');
  static Color unselectedIcon = fromHex('#CDCDCD');
  static Color grayBorder = fromHex('#707070');
  static Color greenActive = fromHex('#6DD400');
  static Color textGrey = fromHex('#909191');
  static Color grayBackground = fromHex('#f0f0f0');
  static Color gray50 = fromHex('#fbfbfd');
  static Color gray300 = fromHex('#e6e6e6');
  static const Color textFieldUnderlineColor = Color(0xffEAE9E9);
  static Color yellow = fromHex('#FEA846');
  static Color opacBlackColor = fromHex('#1E2329');

  //todo change
  static Color black9004c = fromHex('#4c000000');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
