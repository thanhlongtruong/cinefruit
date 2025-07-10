// Custom ElevatedButton background transparant

import 'package:ceni_fruit/config/styles.dart';
import 'package:flutter/material.dart';

Widget customElevatedButtonBgTransparent(
  VoidCallback funcOnPressed,
  Widget child,
) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: borderRadiusButton),
      ),
    ),
    onPressed: () {
      funcOnPressed();
    },
    child: child,
  );
}
