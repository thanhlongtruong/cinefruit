import 'package:flutter/material.dart';

class TicketShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var height = size.height;
    var width = size.width;

    final Path ticketPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(0),
        ),
      );

    final Path leftHole = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(0, size.height / 2), radius: 18),
      );

    final Path rightHole = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, size.height / 2),
          radius: 18,
        ),
      );

    final Path topHole = Path()
      ..addOval(Rect.fromCircle(center: Offset(width / 5, height), radius: 7));

    final Path bottomHole = Path()
      ..addOval(Rect.fromCircle(center: Offset(width / 5, 0), radius: 7));

    final Path uperLeftCornermHole = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, height), radius: 7));

    final Path lowerLeftCornermHole = Path()
      ..addOval(Rect.fromCircle(center: Offset(0, 0), radius: 7));

    final Path uperRightCornermHole = Path()
      ..addOval(Rect.fromCircle(center: Offset(width, height), radius: 7));

    final Path lowerRightCornermHole = Path()
      ..addOval(Rect.fromCircle(center: Offset(width, 0), radius: 7));

    final Path dotted2Hole = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(width / 5, height - 36), radius: 3),
      );
    final Path dotted3Hole = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(width / 5, height - (36 * 2)),
          radius: 3,
        ),
      );
    final Path dotted4Hole = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(width / 5, height - (36 * 3)),
          radius: 3,
        ),
      );
    final Path dotted5Hole = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(width / 5, height - (36 * 4)),
          radius: 3,
        ),
      );

    final Path pathWithoutLeft = Path.combine(
      PathOperation.difference,
      ticketPath,
      leftHole,
    );
    final Path pathWithoutLeftRight = Path.combine(
      PathOperation.difference,
      pathWithoutLeft,
      rightHole,
    );

    final Path combineTopHole = Path.combine(
      PathOperation.difference,
      pathWithoutLeftRight,
      topHole,
    );

    final Path combineBottomHole = Path.combine(
      PathOperation.difference,
      combineTopHole,
      bottomHole,
    );

    final Path combineUperLeftCornermHole = Path.combine(
      PathOperation.difference,
      combineBottomHole,
      uperLeftCornermHole,
    );
    final Path combineLowerLeftCornermHole = Path.combine(
      PathOperation.difference,
      combineUperLeftCornermHole,
      lowerLeftCornermHole,
    );

    final Path combineUperRightCornermHole = Path.combine(
      PathOperation.difference,
      combineLowerLeftCornermHole,
      uperRightCornermHole,
    );
    final Path combineLowerRightCornermHole = Path.combine(
      PathOperation.difference,
      combineUperRightCornermHole,
      lowerRightCornermHole,
    );

    final Path combineDotted2Hole = Path.combine(
      PathOperation.difference,
      combineLowerRightCornermHole,
      dotted2Hole,
    );
    final Path combineDotted3Hole = Path.combine(
      PathOperation.difference,
      combineDotted2Hole,
      dotted3Hole,
    );
    final Path combineDotted4Hole = Path.combine(
      PathOperation.difference,
      combineDotted3Hole,
      dotted4Hole,
    );
    final Path combineDotted5Hole = Path.combine(
      PathOperation.difference,
      combineDotted4Hole,
      dotted5Hole,
    );

    canvas.drawPath(
      combineDotted5Hole,
      // Paint()..color = Color(0xFFFDD9A4),
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
