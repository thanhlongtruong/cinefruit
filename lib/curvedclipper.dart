import 'package:flutter/material.dart';

class CurvedShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Vẽ đường cong đơn giản (Bezier)
    path.moveTo(0, h * 0.8);
    path.quadraticBezierTo(w / 2, 0, w, h * 0.8);

    // Vẽ bóng đổ
    canvas.drawShadow(path, Colors.amberAccent.withOpacity(0.4), 6, false);

    // Vẽ stroke vàng
    final paint = Paint()
      ..color = const Color(0xFFFFC107)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
