import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Template%20Models/userinfodriver.dart';


class UserListTileRecent extends StatelessWidget {
  final User staff;
  final VoidCallback onPressed;

  const UserListTileRecent({
    Key? key,
    required this.staff,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: screenWidth*0.9,
          height: screenHeight*0.1,
          decoration: BoxDecoration(
            color: Color.fromRGBO(25, 192, 122, 1),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(staff.name, style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'default',
            ),),
            subtitle: Text('Duration: ${staff.duration} Hours',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'default',
              ),),
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
            onTap: onPressed,
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
