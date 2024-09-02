import 'package:flutter/material.dart';

/// [NotchClipper] is a custom clipper that creates a notch at the top edge of a widget.
///
/// This custom clipper is used when you want to create a unique cutout (or notch) in a widget's design,
/// typically to give a distinctive appearance to a part of the UI, such as a header or a card.
///
/// The clipping path is defined in the [getClip] method, which uses a combination of lines and an arc to form the notch.
/// The path starts from the top-left corner, moves horizontally, creates a notch in the middle, and then continues to the top-right corner,
/// before completing the rectangle down to the bottom-right and bottom-left corners.
///
/// The method [shouldReclip] determines whether the clip needs to be recalculated when the widget is rebuilt.
///
/// [getClip] Method Breakdown:
/// - [moveTo] starts the path at the top-left corner (0, 0).
/// - [lineTo] draws a line from the starting point to just before the notch.
/// - [arcToPoint] creates the notch by drawing an arc from the end of the first line to the beginning of the next line.
/// - [lineTo] completes the top edge of the path after the notch.
/// - The subsequent [lineTo] calls draw the rest of the rectangle's edges down to the bottom-right and bottom-left corners.
/// - [close] closes the path, completing the shape.
///
/// The [shouldReclip] method is set to return [false], meaning the clip path does not change and does not need to be recalculated when the widget is rebuilt.
class NotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
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
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

