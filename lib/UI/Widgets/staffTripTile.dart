import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Data/Models/tripRequestModel.dart';

/// The [StaffTile] class is a stateless widget that represents a
/// tile displaying information about a staff member's trip request.
/// It shows the [staff.name], formatted [staff.date], and
/// [staff.startTime]. The tile is designed with a visually appealing
/// background color and includes a forward arrow icon for navigation.
///
/// The widget takes two parameters:
/// - [staff]: a [TripRequest] object that contains the details
///   of the trip request.
/// - [onPressed]: a callback function that is executed when the
///   tile is tapped, allowing the parent widget to define the
///   action to be taken on tap.
class StaffTile extends StatelessWidget {
  final TripRequest staff;
  final VoidCallback onPressed;

  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  StaffTile({
    Key? key,
    required this.staff,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(staff.date);
    String formattedDate = dateFormat.format(parsedDate);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.1,
          decoration: BoxDecoration(
            color: Color.fromRGBO(25, 192, 122, 1),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              staff.name,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'default',
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  'Date: $formattedDate',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'default',
                  ),
                ),
                SizedBox(width: 5,),
                Text(
                  'Time : ${staff.startTime}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            onTap: onPressed,
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
