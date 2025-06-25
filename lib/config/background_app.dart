import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
    Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: SizedBox.shrink(),
      ),
    ),
    Positioned.fill(child: Container(color: Colors.black.withOpacity(0.25))),
  ];
}

List<Widget> backgroundApp(String urlImage) {
  return [
    Positioned.fill(
      child: CachedNetworkImage(imageUrl: urlImage, fit: BoxFit.cover),
    ),
    ...overlayLayers(),
  ];
}
