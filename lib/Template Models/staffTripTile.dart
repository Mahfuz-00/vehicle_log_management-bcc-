import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_log_management/API%20Model%20and%20Service%20(Dashboard)/tripRequestModel.dart';

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
    // Assuming staff.date is a string in 'yyyy-MM-dd' format
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
                  'Time : ${staff.time}',
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