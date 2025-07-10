import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/pages/login_page.dart';
import 'package:flutter/material.dart';

Widget notLoggedinYet(BuildContext context) {
  return Center(
    child: ElevatedButton(
      style: buttonStyle,
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
      },
      child: const Text(
        "Đăng nhập",
        style: TextStyle(
          color: colorTextApp,
          fontSize: textfontSizeApp,
          letterSpacing: letterSpacingSmall,
          fontWeight: fontWeightNormal,
        ),
      ),
    ),
  );
}
