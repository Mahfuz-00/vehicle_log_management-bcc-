import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../Data/Models/tripRequestModelApprovedStaff.dart';

/// A widget that displays the details of an approved trip for staff.
///
/// This widget takes a [ApprovedStaffTripRequest] object as input and
/// presents various details related to the trip, such as the staff's
/// name, designation, department, mobile number, trip type, date,
/// start time, end time, distance, trip mode, destination details,
/// driver information, and car details. It also includes a back button
/// to return to the previous screen.
///
/// Actions:
/// - Navigate back to the previous screen when the back button is pressed.
class ApprovedStaffTrip extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApprovedStaffTripRequest staff;

  ApprovedStaffTrip({Key? key, required this.staff}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InternetConnectionChecker(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
          titleSpacing: 5,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
              )),
          title: const Text(
            'Approved Trip',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'default',
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: const Center(
                    child: Text(
                      'Trip Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                    ),
                  ),
                ),
                Divider(),
                SizedBox(height: 20),
                _buildRow('Name', staff.name),
                _buildRow('Designation', staff.designation),
                _buildRow('Department', staff.department),
                _buildRow('Mobile Number', staff.phone),
                _buildRow('Trip Category', staff.category),
                if(staff.category != 'Pick Drop')...[
                  _buildRow('Trip Type', staff.type!),
                  _buildRowTime('Date', staff.date!),
                  _buildRow('Start Time', staff.startTime!),
                  _buildRow('End Time', staff.endTime!),
                  _buildRow('Destination From', staff.destinationFrom!),
                  _buildRow('Destination To', staff.destinationTo!),
                  _buildRow('Distance', '${staff.distance} KM'),
                ], if(staff.category == 'Pick Drop') ...[
                  _buildRow('Route', staff.route!),
                  _buildRow('Stoppage', staff.stoppage!),
                  _buildRowTime('Start Month', staff.startMonth!),
                  _buildRowTime('End Month', staff.endMonth!),
                ],
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height * 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRowTime(String label, String value) {
    String formattedDate = 'Invalid date';

    try {
      if (value == 'N/A') {
        // Handle the "N/A" case explicitly
        formattedDate = 'N/A';
      } else if (staff.category == 'Pick Drop') {
        // Parse the date using the appropriate format for 'Pick Drop'
        DateTime dateTime = DateFormat('yyyy-MM-dd').parse(value);
        // Format the parsed date into "MMMM yyyy" (e.g., "January 2024")
        formattedDate = DateFormat.yMMMM('en_US').format(dateTime);
      } else {
        DateTime dateTime;

        // Identify if the input contains date only, time only, or both
        if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
          // Input contains only a date (e.g., "2024-01-01")
          dateTime = DateFormat('yyyy-MM-dd').parse(value);
          formattedDate = DateFormat.yMMMMd('en_US')
              .format(dateTime); // e.g., "January 1, 2024"
        } else if (RegExp(r'^\d{1,2}:\d{2}([ ]?[APap][Mm])?$').hasMatch(value)) {
          // Input contains only a time (e.g., "10:30" or "10:30:00")
          dateTime = DateFormat('HH:mm').parse(value, true);
          formattedDate = DateFormat.jm().format(dateTime); // e.g., "10:30 AM"
        } else if (RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}(:\d{2})?$')
            .hasMatch(value)) {
          // Input contains both date and time (e.g., "2024-01-01 10:30:00")
          dateTime = DateFormat('yyyy-MM-dd HH:mm').parse(value);
          String formattedDatePart =
          DateFormat.yMMMMd('en_US').format(dateTime);
          String formattedTimePart = DateFormat.jm().format(dateTime);
          formattedDate =
          '$formattedDatePart, $formattedTimePart'; // Combine date and time
        } else {
          throw FormatException('Unsupported date/time format: $value');
        }
      }
    } catch (e) {
      print('Error parsing date: $e');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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
          child: Text(
            formattedDate, // Display the formatted date
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              height: 1.6,
              letterSpacing: 1.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value == 'None' ? 'N/A' : value,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
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
    );
  }
}
