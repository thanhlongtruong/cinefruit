import 'package:ceni_fruit/Router/navigation_hepler.dart';
import 'package:ceni_fruit/config/style_login_register.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:flutter/material.dart';

Widget notLoggedinYet(BuildContext context, String returnRoute) {
  return Center(
    child: ElevatedButton(
      style: buttonStyle,
      onPressed: () {
        NavigationHelper.goToLogin(returnRoute: returnRoute);
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
