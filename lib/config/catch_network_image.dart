import 'package:cached_network_image/cached_network_image.dart';
import 'package:ceni_fruit/config/const.dart';
import 'package:ceni_fruit/config/styles.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImageConfig(
  String? urlImage,
  double width,
  double height,
  BoxFit boxfit,
  double iconBroken,
) {
  return CachedNetworkImage(
    imageUrl: urlImage ?? "",
    width: width, 
    height: height,
    fit: boxfit,
    fadeInDuration: const Duration(milliseconds: 300),
    placeholderFadeInDuration: const Duration(milliseconds: 300),
    memCacheWidth: 400,
    memCacheHeight: 600,
    useOldImageOnUrlChange: true,
    placeholder: (context, url) => Center(child: circularProgress),
    errorWidget: (context, url, error) => Center(
      child: Icon(Icons.broken_image, size: iconBroken, color: colorTextApp),
    ),
  );
}
