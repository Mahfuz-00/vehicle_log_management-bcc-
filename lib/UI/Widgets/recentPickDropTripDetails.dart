import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../Data/Models/driverstaffModel.dart';
import '../../Data/Models/tripRequestModelRecent.dart';

/// [RecentPickDropTripDetails] is a StatelessWidget that displays detailed information about a recent trip.
///
/// It receives a [RecentTrip] object as a parameter, which contains all the relevant details about the trip.
/// The widget includes an app bar for navigation, displays various trip details, and provides a back button
/// for returning to the previous screen.
///
/// Parameters:
/// - [staff]: A required [RecentTrip] object containing the trip details.
///
/// Actions:
/// - The widget builds the UI by utilizing the [build] method, which constructs a scrollable layout with
///   information displayed in rows.
/// - The [convertDuration] method is used to convert the trip duration from minutes to a formatted string
///   displaying hours and minutes.
/// - The [onPressed] action for the back button navigates the user back to the previous screen when tapped.
///
/// Private Methods:
/// - [_buildRow]: A helper method that creates a row displaying a label and a corresponding value.
/// - [_buildRowTime]: A helper method that formats and displays a date and time label along with the formatted date.
class RecentPickDropTripDetails extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DriveTripRoute staff;

  RecentPickDropTripDetails({Key? key, required this.staff}) : super(key: key);

  String convertDuration(int duration) {
    int hours = duration ~/ 60;
    int minutes = duration % 60;

    String result = hours > 0 ? "${hours} hr ${minutes} min" : "${minutes} min";
    return result;
  }

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
            'Recent Trip',
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
                SizedBox(height: 40,),
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
                _buildRow('Route', staff.name),
                _buildRowTime('Date', staff.date!),
                _buildRowTime(
                    'Start Time', staff.startTime),
                _buildRowTime('End Time', staff.endTime!),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Stoppage Name',
                              style: TextStyle(
                                color: Color.fromRGBO(25, 192, 122, 1),
                                fontSize: 19,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0),
                      child: Text(
                        "::",
                        style: TextStyle(
                          color: Color.fromRGBO(25, 192, 122, 1),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Staff(s)',
                              style: TextStyle(
                                color: Color.fromRGBO(25, 192, 122, 1),
                                fontSize: 19,
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
                _buildStoppages(staff.stoppages),
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

  Widget _buildStoppages(Map<String, dynamic> stoppages) {
    List<Widget> stoppageWidgets = [];
    stoppages.forEach((stoppage, description) {
      stoppageWidgets.add(
        _buildRow(
          stoppage,
          description.isEmpty
              ? 'N/A'
              : description, // Display N/A if description is empty
        ),
      );
    });

    return Column(
      children: stoppageWidgets,
    );
  }

  Widget _buildRowTime(String label, String value) {
    String formattedDate = 'Invalid date';

    try {
      if (value == 'N/A' || value == 'None') {
        // Handle the "N/A" case explicitly
        formattedDate = 'N/A';
      }
      /*else if (staff.category == 'Pick Drop') {
        // Parse the date using the appropriate format for 'Pick Drop'
        DateTime dateTime = DateFormat('yyyy-MM-dd').parse(value);
        // Format the parsed date into "MMMM yyyy" (e.g., "January 2024")
        formattedDate = DateFormat.yMMMM('en_US').format(dateTime);
      }*/
      else {
        DateTime dateTime;

        // Identify if the input contains date only, time only, or both
        if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
          // Input contains only a date (e.g., "2024-01-01")
          dateTime = DateFormat('yyyy-MM-dd').parse(value);
          formattedDate = DateFormat.yMMMMd('en_US')
              .format(dateTime); // e.g., "January 1, 2024"
        } else if (RegExp(r'^\d{1,2}:\d{2}([ ]?[APap][Mm])?$')
            .hasMatch(value)) {
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
