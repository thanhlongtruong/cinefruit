import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

Widget circularProgress = Platform.isAndroid
    ? CircularProgressIndicator()
    : CupertinoActivityIndicator();

const urlBgApp = "";
