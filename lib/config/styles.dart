import 'package:flutter/material.dart';

const Color bgColorApp = Colors.black;
const Color navBarColor = Colors.transparent;
const Color colorTextApp = Colors.white;
const double opacityColorApp = 0.4;

const double textfontSizeTitleAppBar = 22;
const double textfontSizeSmall = 15;
const double textfontSizeNote = 17;
const double textfontSizeApp = 19;

const double iconfontSizeCardBig = 90;
const double iconfontSizeCardMedium = 60;
const double iconfontSizeNormal = 24;
const double iconfontSizeTiny = 10;

const Color colorIcon = Colors.amberAccent;

const Color shadowColorBox = Color.fromARGB(255, 100, 181, 246);
const Color colorButton = Color(0xFFFF7042);
const Color hexColorLogout = Color(0xFFFF5252);
const Color hexColorInformationSpecial = Color(0xFF24C4FF);
const Color hexColorPlaceHolder = Colors.grey;
const Color hexColorTextBlack = Color(0xFF08100C);
const Color colorTextSuccess = Color(0xFF4CAF50);
const Color colorTextWarning = Colors.amber;

const BorderRadius borderRadiusCardBig = BorderRadius.all(Radius.circular(30));
const BorderRadius borderRadiusCardSmall = BorderRadius.all(
  Radius.circular(16),
);

const BorderRadius borderRadiusButton = BorderRadius.all(Radius.circular(10));
const BorderRadius borderRadiusButtonSmall = BorderRadius.all(
  Radius.circular(5),
);

const double spacingTiny = 6;
const double spacingSmall = 8;
const double spacingMedium = 15;
const double spacingBig = 30;
const double spacingLarge = 50;

const double paddingInTextSmall = 8;
const double paddingInTextMedium = 15;

const double letterSpacingMedium = 10;
const double letterSpacingSmall = 1.5;

const fontWeightLight = FontWeight.w300;
const fontWeightNormal = FontWeight.normal;
const fontWeightMedium = FontWeight.w500;
const fontWeightSemiBold = FontWeight.w600;
const fontWeightTitleAppBar = FontWeight.bold;
const fontWeightExtraBold = FontWeight.w800;
const fontWeightHeavy = FontWeight.w900;

const tilteStyleApp = TextStyle(
  color: colorTextApp,
  fontSize: textfontSizeTitleAppBar,
  letterSpacing: letterSpacingSmall,
  fontWeight: fontWeightTitleAppBar,
  shadows: [
    Shadow(color: Color(0xFF9C27B0), blurRadius: 20, offset: Offset(0, 3)),
  ],
);

const styleTextSpecial = TextStyle(
  fontSize: textfontSizeApp,
  fontWeight: fontWeightMedium,
  color: hexColorInformationSpecial,
  letterSpacing: letterSpacingSmall,
);
