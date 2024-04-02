import 'package:flutter/material.dart';

class CustomBottomNavigation extends CustomPaint {
  final Color backgroundColor;
  final List<Widget> children;
  final double notchRadius;
  final double notchHeight;

  CustomBottomNavigation({
    required this.backgroundColor,
    required this.children,
    this.notchRadius = 20.0, // Adjust notch radius as needed
    this.notchHeight = 50.0, // Adjust notch height as needed
  }) : super(
    painter: _CustomBottomNavigationPainter(backgroundColor, children, notchRadius, notchHeight),
  );
}

class _CustomBottomNavigationPainter extends CustomPainter {
  final Color backgroundColor;
  final List<Widget> children;
  final double notchRadius;
  final double notchHeight;

  _CustomBottomNavigationPainter(this.backgroundColor, this.children, this.notchRadius, this.notchHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = backgroundColor;

    // Draw the background rectangle
    final offset = Offset.zero;
    final size = Size(100.0, 50.0); // Adjust width and height as needed
    final left = offset.dx; // Extract x-coordinate from Offset
    final top = offset.dy; // Extract y-coordinate from Offset
    final rect = Rect.fromLTWH(left, top, size.width, size.height);
    canvas.drawRect(rect, paint);

    // Create and draw the notch path
    final notchPath = Path();
    notchPath.moveTo(0.0, size.height);
    notchPath.lineTo(0.0, notchHeight);
    notchPath.quadraticBezierTo(0.0, notchHeight - notchRadius, notchRadius, notchHeight - notchRadius);
    notchPath.lineTo(size.width - notchRadius, notchHeight - notchRadius);
    notchPath.quadraticBezierTo(size.width, notchHeight - notchRadius, size.width, notchHeight);
    notchPath.lineTo(size.width, size.height);
    notchPath.close();
    canvas.drawPath(notchPath, paint);

    // Layout and paint child widgets here (optional)
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(double.infinity, kBottomNavigationBarHeight), // Use the full width and a fixed height
          painter: _CustomBottomNavigationPainter(backgroundColor, children, notchRadius, notchHeight),
        ),
        Material( // Add a Material widget for ink splash
          type: MaterialType.transparency, // Make it transparent
          child: SafeArea( // Use SafeArea to respect the 'notch'
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
