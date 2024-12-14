import 'package:flutter/material.dart';


class MultiTouchScreen extends StatefulWidget {
  @override
  _MultiTouchScreenState createState() => _MultiTouchScreenState();
}

class _MultiTouchScreenState extends State<MultiTouchScreen> {
  Map<int, Offset> touchPoints = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (details) {
          setState(() {
            touchPoints[details.pointer] = details.localPosition;
          });
        },
        onPointerMove: (details) {
          setState(() {
            touchPoints[details.pointer] = details.localPosition;
          });
        },
        onPointerUp: (details) {
          setState(() {
            touchPoints.remove(details.pointer);
          });
        },
        onPointerCancel: (details) {
          setState(() {
            touchPoints.remove(details.pointer);
          });
        },
        child: CustomPaint(
          painter: TouchPainter(touchPoints),
          child: Container(),
        ),
      ),
    );
  }
}

class TouchPainter extends CustomPainter {
  final Map<int, Offset> touchPoints;

  TouchPainter(this.touchPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    touchPoints.forEach((_, point) {
      canvas.drawCircle(point, 20, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}