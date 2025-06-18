import 'package:flutter/material.dart';

class CurvedScreenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = 118;

    double slope = 40; // Độ nghiêng hai cạnh bên
    double curve = 25; // Độ cong cạnh trên và dưới
    Path path = Path();

    // Bắt đầu từ bên trái phía trên
    // path.moveTo(slope, curve);
    // path.quadraticBezierTo(w / 2, -curve, w - slope, curve); // Cong phía trên

    path.moveTo(slope, 0); // Bắt đầu từ góc trên bên trái
    path.quadraticBezierTo(w / 2, curve * 2, w - slope, 0);

    path.lineTo(w, h - curve);
    path.quadraticBezierTo(w / 2, h + curve, 0, h - curve); // Cong phía dưới

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
