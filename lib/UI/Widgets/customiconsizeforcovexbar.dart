import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class CenterTabBuilder extends DelegateBuilder {
  @override
  Widget build(BuildContext context, int index, bool active) {
    // Customize icon size for the center tab
    double iconSize = active ? 48.0 : 24.0; // Default icon size
    if (index == 1) {
      // Double the icon size for the center tab
      iconSize *= 2;
    }

    // You can further customize other properties as needed
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        index == 1 // Check if it's the center tab
            ? Image.asset(
          'Assets/Images/Start Engine.png',
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.2,
        )
            : SizedBox(
          // Empty container to reserve space
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.2,
        ),
        SizedBox(height: 4), // Adjust spacing as needed
        Text(
          'Title',
          style: TextStyle(
            fontSize: 12,
            color: active ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }
}