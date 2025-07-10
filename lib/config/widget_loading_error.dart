import 'package:ceni_fruit/config/style_login_register.dart';
import "package:flutter/material.dart";
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/styles.dart';

Widget buildLoadingScreen() {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          circularProgress,
          const SizedBox(height: spacingMedium),
          const Text(
            'Đang tải...',
            style: TextStyle(
              color: colorTextApp,
              letterSpacing: letterSpacingSmall,
              fontSize: textfontSizeNote,
              fontWeight: fontWeightNormal,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildErrorScreen(Object? error, [Object? stackTrace, Function? func]) {
  print(error);
  return Scaffold(
    backgroundColor: Colors.red.shade600,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(spacingMedium),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $error',
                style: const TextStyle(
                  color: colorTextApp,
                  fontSize: textfontSizeApp,
                  fontWeight: fontWeightMedium,
                ),
              ),
              SizedBox(height: spacingMedium),
              Text(
                'StackTrace: $stackTrace',
                style: const TextStyle(
                  color: colorTextApp,
                  fontSize: textfontSizeApp,
                  fontWeight: fontWeightMedium,
                ),
              ),
              SizedBox(height: spacingMedium),
              if (func != null)
                ElevatedButton(
                  onPressed: () => func(),
                  style: buttonStyle,
                  child: Text("Refresh", style: textStyleElevatedButton),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
