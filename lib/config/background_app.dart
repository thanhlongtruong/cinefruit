import 'dart:ui';

import 'package:ceni_fruit/config/const.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget blurBackground() {
  return Positioned.fill(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: SizedBox.shrink(),
    ),
  );
}

List<Widget> overlayLayers() {
  return [
    Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.15),
              Colors.white.withOpacity(0.35),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ),
    blurBackground(),
    Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3))),
  ];
}

List<Widget> backgroundApp(String urlImage) {
  return [
    Positioned.fill(
      child: CachedNetworkImage(
        imageUrl: urlImage,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: circularProgress),
      ),
    ),
    ...overlayLayers(),
  ];
}
