import 'package:ceni_fruit/config/background_app.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:flutter/material.dart';

Widget buttonCallAgain(
  AppBar appar,
  String background,
  VoidCallback funcCallAgain,
) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: appar,
    backgroundColor: Colors.black,
    body: Stack(
      children: [
        if (background.isNotEmpty) ...backgroundApp(background),
        SafeArea(
          child: Center(
            child: ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                funcCallAgain();
              },
              child: Row(
                spacing: spacingMedium,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh,
                    size: iconfontSizeNormal,
                    color: colorTextApp,
                  ),
                  const Text(
                    "Vui lòng thử lại",
                    style: TextStyle(
                      color: colorTextApp,
                      fontSize: textfontSizeApp,
                      letterSpacing: letterSpacingSmall,
                      fontWeight: fontWeightNormal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
