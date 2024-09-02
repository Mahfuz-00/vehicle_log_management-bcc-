import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

/// [CenterTabBuilder] is a custom delegate that builds the widget structure for a tab in a [ConvexBottomBar].
///
/// This builder customizes the appearance of a tab based on its [index] and whether it is [active].
/// The central tab (index 1) is designed to be more prominent, doubling the icon size and using a custom image.
///
/// [build] Method Breakdown:
/// - The method [build] returns a [Widget] that represents the content of a tab.
/// - [iconSize] is calculated based on whether the tab is [active]. Active tabs have a larger icon size.
/// - If the [index] is 1 (the center tab), the [iconSize] is further doubled to make it more prominent.
/// - The method then returns a [Column] widget containing the icon and text.
///   - If [index] equals 1, an image is loaded from the assets using [Image.asset]. The image is resized to fit within 20% of the screen width.
///   - If [index] is not 1, an empty [SizedBox] of the same size is returned to maintain consistent layout spacing.
/// - A [SizedBox] with a height of 4 is added for spacing between the icon and the text.
/// - Finally, a [Text] widget is used to display the title of the tab, with its color dependent on whether the tab is [active].
///
/// This custom tab builder allows for flexible and dynamic tab designs, making it easy to emphasize the center tab while keeping the other tabs uniform.
class CenterTabBuilder extends DelegateBuilder {
  @override
  Widget build(BuildContext context, int index, bool active) {
    double iconSize = active ? 48.0 : 24.0;
    if (index == 1) {
      iconSize *= 2;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        index == 1
            ? Image.asset(
          'Assets/Images/Start Engine.png',
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.2,
        )
            : SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.width * 0.2,
        ),
        SizedBox(height: 4),
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