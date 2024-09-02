import 'package:flutter/material.dart';

/// [NotchPainter] is a custom painter that creates a unique notch shape on a canvas.
///
/// This class extends [CustomPainter] and is responsible for painting a notch at the top of a widget.
///
/// [paint] Method Breakdown:
/// - The [paint] method is called to render the notch shape on the provided [Canvas] with a specified [Size].
/// - A [Paint] object is created to define the color and style of the notch:
///   - The color is set to a custom RGBA value (25, 192, 122, 1) for a greenish appearance.
///   - The style is set to [PaintingStyle.fill] to fill the notch with color.
/// - A [Path] object is created to define the shape of the notch:
///   - The path starts at the top-left corner (0, 0).
///   - It moves to a point that is offset from the center by 55 pixels to the left, and 22 pixels up for the notch.
///   - An arc is drawn from the left point to the right point, creating a rounded notch.
///   - The path continues to the top-right corner, down to the bottom-right corner, across to the bottom-left corner, and back to the start, effectively closing the shape.
/// - The completed path is drawn on the canvas using the defined [paint].
///
/// The [shouldRepaint] method returns false, indicating that the painter does not need to repaint if the delegate has not changed.
///
/// This custom painter can be used to enhance the visual design of the app, providing a distinctive notch at the top of a widget.
class NotchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(25, 192, 122, 1)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2 - 55, -22)
      ..arcToPoint(
        Offset(size.width / 2 + 55, -22),
        radius: Radius.circular(10),
        clockwise: false,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
