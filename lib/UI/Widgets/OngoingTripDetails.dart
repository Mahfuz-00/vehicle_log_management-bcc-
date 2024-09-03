import 'package:flutter/material.dart';
import '../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../Data/Models/tripRequestModelOngingTrip.dart';

/// [OngoingTrip] is a StatelessWidget that displays the details of an ongoing trip.
///
/// It takes a [OngoingTripRequest] object as a parameter, which contains information about the trip.
///
/// This widget builds a user interface that includes:
/// - A [Scaffold] with an [AppBar] that has a back button and a title.
/// - A [SingleChildScrollView] that allows for scrolling if the content exceeds the screen height.
/// - A column of trip details displayed using [_buildRow] method to format each piece of information.
///
/// The [staff] variable is used to access the trip details, which are displayed in a structured format.
///
/// The layout adapts to the screen size using [MediaQuery] to ensure proper spacing and sizing of elements.
///
/// Actions:
/// - The back button navigates to the previous screen when pressed.
/// - The back button at the bottom allows the user to return to the previous screen as well.
///
/// Variables:
/// - [_scaffoldKey]: A GlobalKey for the Scaffold widget to manage the widget tree state.
/// - [staff]: An instance of [OngoingTripRequest] that contains details about the ongoing trip.
class OngoingTrip extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final OngoingTripRequest staff;

  OngoingTrip({Key? key, required this.staff}) : super(key: key);

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
            'Ongoing Trip',
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
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
                _buildRow('Name', staff.name),
                _buildRow('Designation', staff.designation),
                _buildRow('Department', staff.department),
                _buildRow('Mobile Number', staff.phone),
                _buildRow('Trip Type', staff.type),
                _buildRow('Date', staff.date),
                _buildRow('Start Time', staff.startTime),
                _buildRow('End Time', staff.endTime),
                _buildRow('Distance', '${staff.distance} KM'),
                _buildRow('Trip Type', staff.category),
                _buildRow('Trip Mode', staff.type),
                _buildRow('Destination From', staff.destinationFrom),
                _buildRow('Destination To', staff.destinationTo),
                _buildRow('Driver', staff.driver),
                _buildRow('Car', staff.Car),
                _buildRow('Trip Started', staff.startTrip),
                _buildRow('Destination To', staff.destinationTo),
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
                  text: value,
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
