import 'package:flutter/material.dart';

/// Creates a widget that displays a message indicating there are no requests,
/// using a Material widget for a more prominent alert-like appearance.
///
/// This function takes the following parameters:
/// - [screenWidth]: The width of the screen, used to set the width of the widget.
/// - [message]: The message to display in the widget, typically indicating that there are no requests.
class LoadingContainer extends StatelessWidget {
  final double screenWidth;

  LoadingContainer({required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 200, // Adjust height as needed
        width: screenWidth, // Adjust width as needed
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
