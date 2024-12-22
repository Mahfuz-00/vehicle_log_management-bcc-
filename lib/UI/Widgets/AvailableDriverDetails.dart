import 'package:flutter/material.dart';

/// [DriverInfoCard] is a stateless widget that displays detailed information about a driver and their vehicle.
/// This widget is designed to be used within a broader UI context where information cards are presented.
///
/// The card includes:
/// - The [Name] of the driver.
/// - The [MobileNo] of the driver.
/// - The [CarName], [CarModel], and [CarRegNo] of the vehicle.
///
/// The layout of the card features an icon representing a vehicle, followed by text displaying the car's name and model.
/// Below that, a series of key-value pairs are shown in rows, where each key (e.g., "Name", "Mobile No") is followed by its corresponding value.
///
/// The card is styled with padding, rounded corners, and a slight elevation to create a visually appealing material design.
///
/// The constructor requires all fields to be passed in, ensuring that the card always has complete information to display.
class DriverInfoCard extends StatelessWidget {
  final String Name;
  final String MobileNo;
  final String CarName;
  final String CarRegNo;
  final String CarModel;

  const DriverInfoCard({
    Key? key,
    required this.Name,
    required this.MobileNo,
    required this.CarName,
    required this.CarRegNo,
    required this.CarModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: screenWidth * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.drive_eta_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    '$CarName $CarModel',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      height: 1.6,
                      letterSpacing: 1.3,
                    ),
                    maxLines: 1, // Restrict to a single line
                    overflow: TextOverflow.ellipsis, // Add ellipsis if the text overflows
                  )
                ],
              ),
              Divider(),
              Container(
                width: screenWidth * 0.9,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow('Name', Name),
                      _buildRow('Mobile No', MobileNo),
                      _buildRow('Car Brand', CarName),
                      _buildRow('Car Model', CarModel),
                      _buildRow('Car No', CarRegNo),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildRow(String label, String value) {
  return Container(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            ":",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value == 'None' ? 'N/A' : value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.6,
                    letterSpacing: 1.3,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
