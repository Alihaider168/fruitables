import 'package:flutter/material.dart';

class ColorConstant {
  static Color black = fromHex('#000000');
  static Color gray5001 = fromHex('#fafafa');
  // static Color primaryPink = fromHex('#FFF28BA0');
  static Color primaryPink = Color(0xFFEB6F87);
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
  static Color textGrey = fromHex('#A3A8AD');

  static Color blueA400 = fromHex('#1877f2');


  static Color blackColor = fromHex('#000000');


  static Color grayBackground = fromHex('#f0f0f0');

  static Color gray20002 = fromHex('#ededed');

  static Color blueGray900 = fromHex('#2a2f35');

  static Color gray600 = fromHex('#797979');

  static Color orangeA200 = fromHex('#fea846');

  static Color blueGray100 = fromHex('#d9d9d9');

  static Color black9004d = fromHex('#4d000000');

  static Color blue700 = fromHex('#3b88c4');

  static Color redA200 = fromHex('#fd6262');

  static Color blueGray4003f = fromHex('#3f898989');

  static Color gray200 = fromHex('#eae9e9');

  static Color gray10002 = fromHex('#f2f2f2');

  static Color black90099 = fromHex('#99000000');

  static Color gray10001 = fromHex('#f7f7f7');

  static Color blue300 = fromHex('#55acee');

  static Color black90019 = fromHex('#19000000');

  static Color blueGray40001 = fromHex('#888888');

  static Color gray70001 = fromHex('#6a6a6a');

  static Color cyanA400 = fromHex('#01f2ff');

  static Color lightBlueA70014 = fromHex('#14007aff');

  static Color blueGray10001 = fromHex('#ceced4');

  static Color blueGray10002 = fromHex('#d7d7d7');

  static Color orangeA20033 = fromHex('#33fea846');

  static Color gray50 = fromHex('#fbfbfd');

  static Color black9001e = fromHex('#1e000000');

  static Color blueGray504c = fromHex('#4cf1f1f1');

  static Color black90066 = fromHex('#66000000');


  static Color gray50001 = fromHex('#979797');

  static Color gray50003 = fromHex('#999999');

  static Color gray50002 = fromHex('#a7a7a7');

  static Color gray90080 = fromHex('#801a1818');

  static Color gray90002 = fromHex('#1a1d24');

  static Color gray700 = fromHex('#676666');

  static Color gray90003 = fromHex('#222227');

  static Color blueGray200 = fromHex('#bbbfcc');

  static Color gray60002 = fromHex('#707581');

  static Color gray500 = fromHex('#aaaaaa');

  static Color gray60001 = fromHex('#757575');

  static Color black900E5 = fromHex('#e5000000');

  static Color blueGray400 = fromHex('#848589');

  static Color black900E2 = fromHex('#e2000000');

  static Color gray900 = fromHex('#232323');

  static Color gray90001 = fromHex('#1e2329');

  static Color gray300 = fromHex('#e6e6e6');

  static Color gray30002 = fromHex('#e1e2ec');


  static Color gray30001 = fromHex('#dcdee6');

  static Color gray100 = fromHex('#f6f7f9');

  static Color black90075 = fromHex('#75000000');

  static Color black900Cc = fromHex('#cc000000');

  static Color orangeA20019 = fromHex('#19fea846');

  static Color blueGray1004c = fromHex('#4ccdcdcd');

  static Color cyan900 = fromHex('#1c5e6a');
  static Color filterBg = fromHex('#FBF3EB');

  //
  static const Color secondaryColor = Color(0xFFC6000F);

  static const Color primaryColor = Color(0xFF000000);

  static const Color textFieldUnderlineColor = Color(0xffEAE9E9);

  static const Color eyeIconColor = Color(0xffD9D9D9);

  static const Color textFieldHintColor = Color(0xff7C7C7E);

  static const Color errorColor = Colors.red;

  static Color successColor = yellow;

  static const Color reviewStarColor = Color(0xffFFBB22);

  static const Color textDarkGrey = Color(0xFF292929);

  static const Color textColorGrey = Color(0xFFB1B1B1);

  static const Color accentColor = Color(0xFFB1B1B1);

  static const Color whiteColor = Color(0xFFffffff);

  static Color colorInviteFriend = fromHex('#52292C');

  static Color yellow = fromHex('#FEA846');

  static Color bodyBackground = fromHex('#F7F7F7');
  static Color answerColor = fromHex('#676666');
  static Color hintTextColor = fromHex('#89889B');
  static Color red80071 = fromHex('#71c32126');
  static Color checkboxColor = fromHex('#ABAEB7');
  static Color grayF8Color = fromHex('#F8F8F8');
  static Color redColor = fromHex('#FF5A4E');
  static Color redNewColor = fromHex('#E62E2E');
  static Color redOpacColor = fromHex('#26FF5A4E');
  static Color dividerColor = fromHex('#646464');
  static Color opacBlackColor = fromHex('#1E2329');
  static Color unreadNotificationColor = fromHex('#12FEA846');
  static Color lightGreenColor = fromHex('#EAFFEF');
  static Color darkGreenColor = fromHex('#069952');
  static Color disabledColor = fromHex('#50FFFFFF');

  //todo change
  static Color black9004c = fromHex('#4c000000');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
