import "package:flutter/material.dart";
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/styles.dart';

Widget buildLoadingScreen() {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          circularProgress,
          const SizedBox(height: spacingMedium),
          const Text('Đang tải...', style: TextStyle(color: colorTextApp)),
        ],
      ),
    ),
  );
}

Widget buildErrorScreen(Object? error) {
  return Scaffold(
    backgroundColor: Colors.red.shade600,
    body: Center(
      child: Text('Lỗi: $error', style: const TextStyle(color: colorTextApp)),
    ),
  );
}
