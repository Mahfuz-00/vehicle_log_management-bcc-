import 'package:flutter/material.dart';

/// [CustomBottomNavigation] is a custom widget that creates a bottom navigation bar with a notch effect.
///
/// This class extends [CustomPaint] and is designed to render a bottom navigation area with customizable properties.
///
/// [backgroundColor] is the color of the bottom navigation bar.
/// [children] is a list of [Widget]s that will be displayed as the navigation items.
/// [notchRadius] defines the radius of the notch's corners, defaulting to 20.0.
/// [notchHeight] sets the height of the notch, defaulting to 50.0.
///
/// The constructor initializes the [CustomBottomNavigation] with the provided parameters and sets the painter
/// to an instance of [_CustomBottomNavigationPainter], which handles the drawing of the navigation bar.
class CustomBottomNavigation extends CustomPaint {
  final Color backgroundColor;
  final List<Widget> children;
  final double notchRadius;
  final double notchHeight;

  CustomBottomNavigation({
    required this.backgroundColor,
    required this.children,
    this.notchRadius = 20.0,
    this.notchHeight = 50.0,
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

    final offset = Offset.zero;
    final size = Size(100.0, 50.0);
    final left = offset.dx;
    final top = offset.dy;
    final rect = Rect.fromLTWH(left, top, size.width, size.height);
    canvas.drawRect(rect, paint);

    final notchPath = Path();
    notchPath.moveTo(0.0, size.height);
    notchPath.lineTo(0.0, notchHeight);
    notchPath.quadraticBezierTo(0.0, notchHeight - notchRadius, notchRadius, notchHeight - notchRadius);
    notchPath.lineTo(size.width - notchRadius, notchHeight - notchRadius);
    notchPath.quadraticBezierTo(size.width, notchHeight - notchRadius, size.width, notchHeight);
    notchPath.lineTo(size.width, size.height);
    notchPath.close();
    canvas.drawPath(notchPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(double.infinity, kBottomNavigationBarHeight),
          painter: _CustomBottomNavigationPainter(backgroundColor, children, notchRadius, notchHeight),
        ),
        Material(
          type: MaterialType.transparency,
          child: SafeArea(
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
