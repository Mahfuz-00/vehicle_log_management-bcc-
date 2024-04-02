import 'package:flutter/material.dart';

class DriverInfo extends StatelessWidget {
  final String driverName;
  final String driverMobileNumber;
  final String carName;

  const DriverInfo({
    Key? key,
    required this.driverName,
    required this.driverMobileNumber,
    required this.carName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: screenWidth*0.9,
          height: screenHeight*0.14,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Driver: $driverName',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  fontFamily: 'default'
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Mobile Number: $driverMobileNumber',
                style: TextStyle(
                  fontSize: 16.0,
                    fontFamily: 'default'
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Car Name: $carName',
                style: TextStyle(
                  fontSize: 16.0,
                    fontFamily: 'default'
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}