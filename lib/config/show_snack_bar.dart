import 'package:ceni_fruit/config/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void emptyFunc() {}

void showSnackbar({
  required String title,
  required String message,
  required String type,
  VoidCallback func = emptyFunc,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Color backgroundColor = type == "error" ? hexColorLogout : colorTextSuccess;

    final titleTextStyle = TextStyle(
      fontSize: textfontSizeApp,
      letterSpacing: letterSpacingSmall,
      fontWeight: fontWeightSemiBold,
      color: colorTextApp,
    );
    final messageTextStyle = TextStyle(
      fontSize: textfontSizeNote,
      letterSpacing: letterSpacingSmall,
      fontWeight: fontWeightMedium,
      color: colorTextApp,
    );
    Get.snackbar(
      "",
      "",
      titleText: Text(title, style: titleTextStyle),
      messageText: Text(message, style: messageTextStyle),
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: colorTextApp,
      margin: EdgeInsets.all(spacingSmall),
      borderRadius: 5,
      duration: Duration(seconds: 4),
      isDismissible: true,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Text('Đóng', style: messageTextStyle),
      ),
      onTap: (_) => func(),
    );
  });
}
