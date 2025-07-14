import 'dart:io';

import 'package:ceni_fruit/config/styles.dart';
import 'package:ceni_fruit/service/auth_interceptor.dart';
import 'package:ceni_fruit/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final logger = Logger();

Widget circularProgress = Platform.isAndroid
    ? const CircularProgressIndicator(
        color: Colors.white,
        backgroundColor: Colors.transparent,
      )
    : const CupertinoActivityIndicator(color: Colors.white);

Widget circularProgressBlack = Platform.isAndroid
    ? const CircularProgressIndicator(color: hexColorTextBlack)
    : const CupertinoActivityIndicator(color: hexColorTextBlack);

const urlBgApp = "";

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = Platform.isAndroid
      ? 'http://10.0.2.2:2020'
      : Platform.isIOS
      ? 'http://127.0.0.1:2020'
      : 'http://localhost:2020';

  const backupUrl = 'https://wh54v89v-2020.asse.devtunnels.ms';

  final dio = Dio(
    BaseOptions(
      baseUrl: backupUrl,
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    ),
  );

  final excludedPaths = [
    '/user/login',
    '/user/register',
    "/movie/get/hot",
    "/movie/get/all",
    "/cinema/get/all",
    "/cinema/get",
    "/food_drink/get/all",
    "movie_room/get/movie",
    "/payment_method/get/all",
    "/user/verificarion-email",
    "/user/update/verification",
  ];

  final userService = UserService(dio);
  dio.interceptors.add(
    AuthInerceptor(dio, excludedPaths: excludedPaths, userService: userService),
  );

  return dio;
});
