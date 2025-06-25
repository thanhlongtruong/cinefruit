import 'package:flutter/material.dart';
import 'package:ceni_fruit/config/styles.dart';

const boxDecoration = BoxDecoration(
  color: colorTextApp,
  borderRadius: borderRadiusButton,
  boxShadow: [
    BoxShadow(offset: Offset(3, 3), blurRadius: 6, color: shadowColorBox),
  ],
);

const double height = 50;

const contentPadding = EdgeInsets.symmetric(vertical: 10);

const hintStyle = TextStyle(color: Colors.grey, fontSize: textfontSizeApp);

final textStyle = TextStyle(
  color: bgColorApp,
  letterSpacing: letterSpacingSmall,
  fontWeight: fontWeightNormal,
  fontSize: textfontSizeApp,
);

final styleTopic = TextStyle(
  color: colorTextApp,
  fontSize: textfontSizeTitleAppBar,
  fontWeight: fontWeightTitleAppBar,
  letterSpacing: letterSpacingMedium,
  shadows: [Shadow(color: Colors.purple, blurRadius: 20, offset: Offset(0, 8))],
);

const buttonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(colorButton),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: borderRadiusButton),
  ),
);

final textStyleElevatedButton = TextStyle(
  fontWeight: fontWeightSemiBold,
  fontSize: textfontSizeApp,
  color: colorTextApp,
  letterSpacing: letterSpacingSmall,
);

textNoteBottomStyle(Color color) {
  return TextStyle(
    fontSize: textfontSizeNote,
    fontWeight: fontWeightNormal,
    color: color,
    letterSpacing: letterSpacingSmall,
  );
}

Widget buildFeld(String title, TextEditingController controller, Icon icon) {
  return Container(
    height: height,
    decoration: boxDecoration,
    child: TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return title;
        }
        return "";
      },
      controller: controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: contentPadding,
        prefixIcon: icon,
        hintText: title,
        hintStyle: hintStyle,
      ),
      style: textStyle,
    ),
  );
}
