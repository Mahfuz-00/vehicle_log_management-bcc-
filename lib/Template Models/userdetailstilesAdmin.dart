import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Template%20Models/userinfoAdmin.dart';


class UserListTile extends StatelessWidget {
  final User staff;
  final VoidCallback onPressed;

  const UserListTile({
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
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(staff.name),
            subtitle: Text(DateFormat('yyyy-MM-dd HH:mm').format(staff.dateTime)),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: onPressed,
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
